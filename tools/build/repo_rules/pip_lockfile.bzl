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
    Please run `{}` to regenerate them.
""".format(repository_ctx.attr.pin_cmd))

    repository_ctx.file("WORKSPACE", content = "")
    repository_ctx.file("BUILD", content = "")
    repository_ctx.symlink(repository_ctx.attr.requirements_txt, "requirements.txt")

def _unpinned_pip_impl(repository_ctx):
    repository_ctx.file("WORKSPACE", content = "")
    repository_ctx.file("BUILD", content = """
sh_binary(
    name = "pin",
    srcs = ["pin.sh"],
    data = ["requirements.txt"],
    deps = ["@bazel_tools//tools/bash/runfiles"],
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

    result = repository_ctx.execute([repository_ctx.attr.python_interpreter_target, "-m", "venv", "venv"])
    if result.return_code:
        fail("failed to run python -m venv: " + result.stderr)
    result = repository_ctx.execute(["./venv/bin/pip", "install", "pip_tools"])
    if result.return_code:
        fail("failed to run pip: " + result.stderr)

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

requirements_txt=$(rlocation "{repo_name}/requirements.txt")

cp "$requirements_txt" "$BUILD_WORKSPACE_DIRECTORY/{requirements_txt}"
"""
        .replace("{repo_name}", repository_ctx.name)
        .replace("{requirements_txt}", _get_path(repository_ctx.attr.requirements_txt)))

    repository_ctx.file("requirements.txt")
    result = repository_ctx.execute(
        ["./venv/bin/pip-compile", "--no-header", "--generate-hashes", "--output-file", "requirements.txt", "requirements.in"] + repository_ctx.attr.extra_args,
        timeout = 86400,  # use a very large timeout, i.e. one day, to avoid timeout errors
    )
    if result.return_code:
        fail("failed to run pip-compile: " + result.stderr)

    requirements_txt = repository_ctx.read("requirements.txt")
    repository_ctx.file("requirements.txt", content = _updater_header(repository_ctx, requirements_txt))

pinned_pip = repository_rule(
    implementation = _pinned_pip_impl,
    attrs = {
        "packages": attr.string_dict(),
        "requirements_txt": attr.label(allow_single_file = True, mandatory = True),
        "pin_cmd": attr.string(),
    },
)

unpinned_pip = repository_rule(
    implementation = _unpinned_pip_impl,
    attrs = {
        "packages": attr.string_dict(),
        "requirements_txt": attr.label(allow_single_file = True, mandatory = True),
        "python_interpreter_target": attr.label(allow_single_file = True, mandatory = True),
        "extra_args": attr.string_list(),
    },
)
