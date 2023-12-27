load(":toolchain_deps.bzl", "GOLANG_VERSION")
load("//:deps.bzl", "DEPS")

GO_PACKAGES = {dep["name"]: dep["version"] for dep in DEPS["go_deps"]}

GO_PACKAGE_PATCH_CMDS = {dep["name"]: dep["patch_cmds"] for dep in DEPS["go_deps"] if "patch_cmds" in dep}

GO_PACKAGE_PATCHES = {dep["name"]: dep["patches"] for dep in DEPS["go_deps"] if "patches" in dep}

def _header_with_hash(repository_ctx, go_sum):
    data = {
        "module": repository_ctx.attr.module,
        "go_version": repository_ctx.attr.go_version,
        "packages": repository_ctx.attr.packages,
        "go_sum": go_sum,
    }
    tpl = """// DO NOT EDIT! This file is auto-generated.
// hash = {}
"""
    return tpl.format(hash(json.encode(data)))

def _generate_go_mod(repository_ctx):
    return "".join(
        ["module {}\n".format(repository_ctx.attr.module)] +
        (["\ngo {}\n".format(".".join(repository_ctx.attr.go_version.split(".")[:2]))] if repository_ctx.attr.go_version else []) +
        ["\nrequire (\n"] +
        ["\t{name} {version}\n".format(name = name, version = version) for (name, version) in repository_ctx.attr.packages.items()] +
        [")\n"],
    )

def _get_path(label):
    package_path = label.package
    file_name = label.name
    if package_path == "":
        return file_name
    else:
        return "/".join([package_path, file_name])

def _gazelle_go_deps_impl(repository_ctx):
    go_mod = repository_ctx.read(repository_ctx.attr.go_mod)
    go_sum = repository_ctx.read(repository_ctx.attr.go_sum)
    header = _header_with_hash(repository_ctx, go_sum)
    if "REPIN" not in repository_ctx.os.environ and go_mod != header + _generate_go_mod(repository_ctx):
        fail("""go.sum or go.mod contains an invalid input signature and must be regenerated.
    Please run `REPIN=1 bazel run @{}//:pin` to regenerate them.
""".format("unpinned_" + repository_ctx.name))

    repository_ctx.file("WORKSPACE", content = "workspace(name=\"{}\")".format(repository_ctx.name))
    repository_ctx.file("BUILD")

    dependency_template = """
    go_repository(
        name = {name},
        importpath = {importpath},
        sum = {sum},
        version = {version},
        build_external = "external",
        build_file_proto_mode = "disable",
        build_config = Label("//:build_config"),
        patches = {patches},
        patch_cmds = {patch_cmds},
    )
"""
    dependencies = ""
    build_config = ""
    for line in repository_ctx.read(repository_ctx.attr.go_sum).split("\n"):
        if line:
            importpath, version, sum = line.split(" ")
            path = importpath.split("/")
            name = "_".join(reversed(path[0].split(".")) + path[1:]).replace(".", "_").replace("-", "_").replace("/", "_").lower()
            if not version.endswith("/go.mod"):
                dependencies += dependency_template.format(
                    name = repr(name),
                    importpath = repr(importpath),
                    sum = repr(sum),
                    version = repr(version),
                    patches = repr(repository_ctx.attr.package_patches.get(importpath)),
                    patch_cmds = repr(repository_ctx.attr.package_patch_cmds.get(importpath)),
                )
                build_config += "# gazelle:repository go_repository name={name} importpath={importpath}\n".format(
                    name = name,
                    importpath = importpath,
                )

    repository_ctx.file("gazelle_go_deps.bzl", content = """
load("@bazel_gazelle//:deps.bzl", "go_repository")

def go_dependencies():
{dependencies}
""".format(dependencies = dependencies if dependencies else "    pass"))
    repository_ctx.file("build_config", content = build_config)

def _unpinned_gazelle_go_deps_impl(repository_ctx):
    repository_ctx.file("WORKSPACE", content = "workspace(name=\"{}\")".format(repository_ctx.name))

    repository_ctx.file("BUILD", content = """
load("@bazel_skylib//rules:diff_test.bzl", "diff_test")

sh_binary(
    name = "pin",
    srcs = ["pin.sh"],
    data = ["go.mod", "go.sum"],
    deps = ["@bazel_tools//tools/bash/runfiles"],
)

diff_test(
    "go.mod.test",
    "imported_go.mod",
    "go.mod",
)

diff_test(
    "go.sum.test",
    "imported_go.sum",
    "go.sum",
)

test_suite(
    name = "pin_test",
    tests = [
        ":go.mod.test",
        ":go.sum.test",
    ],
)
""")

    repository_ctx.symlink(repository_ctx.attr.go_mod, "imported_go.mod")

    repository_ctx.symlink(repository_ctx.attr.go_sum, "imported_go.sum")

    repository_ctx.file(
        "go.mod",
        content = _generate_go_mod(repository_ctx),
    )

    repository_ctx.file("pin.sh", content = """\
#!/bin/bash
set -euo pipefail

# --- begin runfiles.bash initialization v3 ---
# Copy-pasted from the Bazel Bash runfiles library v3.
set -uo pipefail; set +e; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
source "$0.runfiles/$f" 2>/dev/null || \
source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
{ echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v3 ---

go_mod=$(rlocation "{repo_name}/go.mod")
go_sum=$(rlocation "{repo_name}/go.sum")

cp "$go_mod" "$BUILD_WORKSPACE_DIRECTORY/{go_mod}"
cp "$go_sum" "$BUILD_WORKSPACE_DIRECTORY/{go_sum}"
""".replace(
        "{repo_name}",
        repository_ctx.name,
    ).replace(
        "{go_mod}",
        _get_path(repository_ctx.attr.go_mod),
    ).replace(
        "{go_sum}",
        _get_path(repository_ctx.attr.go_sum),
    ))

    repository_ctx.file("go.sum")
    env = {}
    for line in repository_ctx.read(repository_ctx.attr.go_env).split("\n"):
        if not line.startswith("#") and "=" in line:
            k, v = line.split("=", 1)
            env[k] = v.strip("'")
    result = repository_ctx.execute(
        [env["GOROOT"] + "/bin/go", "mod", "download", "all"],
        environment = env,
        timeout = 86400,  # use a very large timeout, i.e. one day, to avoid timeout errors
    )
    if result.return_code:
        fail("failed to go mod download all: " + result.stderr)

    header = _header_with_hash(repository_ctx, repository_ctx.read("go.sum"))
    repository_ctx.file("go.mod", content = header + _generate_go_mod(repository_ctx))

_gazelle_go_deps = repository_rule(
    implementation = _gazelle_go_deps_impl,
    attrs = {
        "module": attr.string(mandatory = True),
        "go_version": attr.string(),
        "packages": attr.string_dict(default = {}),
        "package_patch_cmds": attr.string_list_dict(default = {}),
        "package_patches": attr.string_list_dict(default = {}),
        "go_mod": attr.label(allow_single_file = True, mandatory = True),
        "go_sum": attr.label(allow_single_file = True, mandatory = True),
    },
    environ = ["REPIN"],
)

_unpinned_gazelle_go_deps = repository_rule(
    implementation = _unpinned_gazelle_go_deps_impl,
    attrs = {
        "module": attr.string(mandatory = True),
        "go_version": attr.string(),
        "packages": attr.string_dict(default = {}),
        "go_mod": attr.label(allow_single_file = True, mandatory = True),
        "go_sum": attr.label(allow_single_file = True, mandatory = True),
        "go_env": attr.label(allow_single_file = True, mandatory = True),
    },
)

def go_deps(
        *,
        name = "gazelle_go_deps",
        module = "golang.boleyn.su",
        go_version = GOLANG_VERSION,
        packages = GO_PACKAGES,
        package_patches = GO_PACKAGE_PATCHES,
        package_patch_cmds = GO_PACKAGE_PATCH_CMDS,
        go_mod = Label("@//:go.mod"),
        go_sum = Label("@//:go.sum"),
        go_env = Label("@bazel_gazelle_go_repository_cache//:go.env"),
        **kwargs):
    _gazelle_go_deps(
        name = name,
        module = module,
        go_version = go_version,
        packages = packages,
        package_patches = package_patches,
        package_patch_cmds = package_patch_cmds,
        go_mod = go_mod,
        go_sum = go_sum,
        **kwargs
    )
    _unpinned_gazelle_go_deps(
        name = "unpinned_" + name,
        module = module,
        go_version = go_version,
        packages = packages,
        go_mod = go_mod,
        go_sum = go_sum,
        go_env = go_env,
        **kwargs
    )
