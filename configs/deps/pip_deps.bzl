load("@local_config_platform//:constraints.bzl", "HOST_CONSTRAINTS")
load("@rules_python//python:versions.bzl", "PLATFORMS")
load("@rules_python//python:pip.bzl", "pip_parse")
load("@boleynsu_deps_bzl//:deps.bzl", "DEPS")

PIP_PACKAGES = {dep["name"]: dep["version"] for dep in DEPS["pip_deps"]}

def _updater_header(repository_ctx, requirements_txt):
    header = """# DO NOT EDIT! This file is auto-generated.
# hash = """
    if requirements_txt.startswith(header):
        requirements_txt = requirements_txt[requirements_txt.find("\n", len(header)) + 1:]
    data = {
        "packages": repository_ctx.attr.packages,
        "requirements_txt": requirements_txt,
    }
    return "{}{}\n{}".format(header, hash(json.encode(data)), requirements_txt)

def _get_path(label):
    package_path = label.package
    file_name = label.name
    if package_path == "":
        return file_name
    else:
        return "/".join([package_path, file_name])

def _pinned_pip_impl(repository_ctx):
    requirements_txt = repository_ctx.read(repository_ctx.attr.requirements_txt)
    if "REPIN" not in repository_ctx.os.environ and requirements_txt != _updater_header(repository_ctx, requirements_txt):
        fail("""requirements.txt contains an invalid input signature and must be regenerated.
    Please run `REPIN=1 bazel run @{}//:pin` to regenerate them.
""".format("un" + repository_ctx.name))

    repository_ctx.file("WORKSPACE", content = "")
    repository_ctx.file("BUILD", content = "")
    repository_ctx.symlink(repository_ctx.attr.requirements_txt, "requirements.txt")

def _unpinned_pip_impl(repository_ctx):
    repository_ctx.file("WORKSPACE", content = "")
    repository_ctx.file("BUILD", content = """
load("@bazel_skylib//rules:diff_test.bzl", "diff_test")

sh_binary(
    name = "pin",
    srcs = ["pin.sh"],
    args = ["$(rootpath requirements.txt)"],
    data = ["requirements.txt"],
)

diff_test(
    "pin_test",
    "imported_requirements.txt",
    "requirements.txt",
)
""")

    repository_ctx.file(
        "requirements.in",
        content = "".join(["{package} == {version}\n".format(
            package = package,
            version = version,
        ) for (package, version) in repository_ctx.attr.packages.items()]),
    )

    repository_ctx.symlink(repository_ctx.attr.requirements_txt, "imported_requirements.txt")

    repository_ctx.file("pin.sh", content = """
#!/bin/bash
set -euo pipefail

requirements_txt="$1"

cat "$requirements_txt" >"$BUILD_WORKSPACE_DIRECTORY/{requirements_txt}"
""".format(
        requirements_txt = _get_path(repository_ctx.attr.requirements_txt),
    ))

    pip_compile = repository_ctx.which("pip-compile")
    if not pip_compile:
        fail("""Please make sure pip-compile is installed.
    You can run `pip install --user pip_tools` to install it.
""")

    repository_ctx.file("requirements.txt")
    result = repository_ctx.execute(
        [pip_compile, "--no-header", "--generate-hashes", "--output-file", "requirements.txt", "requirements.in"] + repository_ctx.attr.extra_args,
        timeout = 86400,  # use a very large timeout, i.e. one day, to avoid timeout errors
    )
    if result.return_code:
        fail("failed to go mod download all: " + result.stderr)

    requirements_txt = repository_ctx.read("requirements.txt")
    repository_ctx.file("requirements.txt", content = _updater_header(repository_ctx, requirements_txt))

_pinned_pip = repository_rule(
    implementation = _pinned_pip_impl,
    attrs = {
        "packages": attr.string_dict(),
        "requirements_txt": attr.label(allow_single_file = True, mandatory = True),
    },
)

_unpinned_pip = repository_rule(
    implementation = _unpinned_pip_impl,
    attrs = {
        "packages": attr.string_dict(),
        "requirements_txt": attr.label(allow_single_file = True, mandatory = True),
        "extra_args": attr.string_list(),
    },
)

def pip_deps(
        *,
        name = "pip",
        packages = PIP_PACKAGES,
        requirements_lock_file = Label("@//:requirements.txt"),
        python_sdk = "python_sdk",
        python_interpreter_target = None,
        extra_args = ["--allow-unsafe"],
        **kwargs):
    _pinned_pip(
        name = "pinned_" + name,
        packages = packages,
        requirements_txt = requirements_lock_file,
        **kwargs
    )
    _unpinned_pip(
        name = "unpinned_" + name,
        packages = packages,
        requirements_txt = requirements_lock_file,
        extra_args = extra_args,
        **kwargs
    )
    if not python_interpreter_target:
        for platform, info in PLATFORMS.items():
            if sorted(info.compatible_with) == sorted(HOST_CONSTRAINTS):
                path = "python.exe" if "@platforms//os:windows" in info.compatible_with else "bin/python3"
                python_interpreter_target = "@{}_{}//:{}".format(python_sdk, platform, path)
    pip_parse(
        name = name,
        requirements_lock = "@pinned_{}//:requirements.txt".format(name),
        python_interpreter_target = python_interpreter_target,
        **kwargs
    )
