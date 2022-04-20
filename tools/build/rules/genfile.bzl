load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@bazel_skylib//rules:diff_test.bzl", "diff_test")

def genfile(*, name, src, out, test = True, **kwargs):
    write_file(
        name = "{}.update_sh".format(name),
        out = "{}.update.sh".format(name),
        content = ["""
#!/bin/bash
set -euo pipefail
src=$1
out=$2

if [[ -v BUILD_WORKSPACE_DIRECTORY ]]; then
    out=$BUILD_WORKSPACE_DIRECTORY/$out
fi
cp "$src" "$out"
"""],
        **kwargs
    )

    native.sh_binary(
        name = name,
        srcs = [":{}.update_sh".format(name)],
        args = [
            "$(location {})".format(src),
            "$(location {})".format(out),
        ],
        data = [
            "{}".format(src),
            out,
        ],
        **kwargs
    )

    if test:
        diff_test(
            "{}.test".format(name),
            src,
            out,
            **kwargs
        )
