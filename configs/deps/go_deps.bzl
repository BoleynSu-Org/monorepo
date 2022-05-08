load(":deps.bzl", "DEPS")

GO_PACKAGES = {dep["name"]: dep["version"] for dep in DEPS["go_deps"]}

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
        (["go {}\n".format(repository_ctx.attr.go_version)] if repository_ctx.attr.go_version else []) +
        ["require (\n"] +
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
        name = "{name}",
        importpath = "{importpath}",
        sum = "{sum}",
        version = "{version}",
    )
"""
    dependencies = ""
    for line in repository_ctx.read(repository_ctx.attr.go_sum).split("\n"):
        if line:
            importpath, version, sum = line.split(" ")
            path = importpath.split("/")
            name = "_".join(reversed(path[0].split(".")) + path[1:]).replace(".", "_").replace("-", "_").replace("/", "_")
            if not version.endswith("/go.mod"):
                dependencies += dependency_template.format(
                    name = name,
                    importpath = importpath,
                    sum = sum,
                    version = version,
                )

    repository_ctx.file("gazelle_go_deps.bzl", content = """
load("@bazel_gazelle//:deps.bzl", "go_repository")

def go_dependencies():
{dependencies}
""".format(dependencies = dependencies if dependencies else "    pass"))

def _unpinned_gazelle_go_deps_impl(repository_ctx):
    repository_ctx.file("WORKSPACE", content = "workspace(name=\"{}\")".format(repository_ctx.name))

    repository_ctx.file("BUILD", content = """
load("@bazel_skylib//rules:diff_test.bzl", "diff_test")

sh_binary(
    name = "pin",
    srcs = ["pin.sh"],
    args = ["$(rootpath go.mod)", "$(rootpath go.sum)"],
    data = ["go.mod", "go.sum"],
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

    repository_ctx.file("pin.sh", content = """
#!/bin/bash
set -euo pipefail

go_mod="$1"
go_sum="$2"

cat "$go_mod" >"$BUILD_WORKSPACE_DIRECTORY/{go_mod}"
cat "$go_sum" >"$BUILD_WORKSPACE_DIRECTORY/{go_sum}"
""".format(
        go_mod = _get_path(repository_ctx.attr.go_mod),
        go_sum = _get_path(repository_ctx.attr.go_sum),
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
        "go_mod": attr.label(allow_single_file = True, mandatory = True),
        "go_sum": attr.label(allow_single_file = True, mandatory = True),
    },
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
        go_version = None,
        packages = GO_PACKAGES,
        go_mod = Label("//:go.mod"),
        go_sum = Label("//:go.sum"),
        go_env = Label("@bazel_gazelle_go_repository_cache//:go.env"),
        **kwargs):
    _gazelle_go_deps(
        name = name,
        module = module,
        go_version = go_version,
        packages = packages,
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
