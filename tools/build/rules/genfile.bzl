load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@bazel_skylib//rules:diff_test.bzl", "diff_test")

def genfile(*, name, src, out, comment = "# ", headers = None, test = True, failure_message = None, **kwargs):
    if headers == None:
        headers = ["DO NOT EDIT! This file is auto-generated.", "Run `bazel run //{}:{}` to regenerate.".format(native.package_name(), name)]

    if comment:
        for i, hdr_i in enumerate(headers):
            headers[i] = comment + hdr_i

    hdr = "{}.genfile.header".format(name)
    write_file(
        name = hdr,
        out = "{}.genfile.header.out".format(name),
        content = headers + [""],
    )

    write_file(
        name = "{}.genfile.update".format(name),
        out = "{}.genfile.update.sh".format(name),
        content = ["""
#!/bin/bash
set -euo pipefail
hdr=$1
src=$2
out=$3

if [[ -v BUILD_WORKSPACE_DIRECTORY ]]; then
    out=$BUILD_WORKSPACE_DIRECTORY/$out
fi

cat "$hdr" >"$out"
cat "$src" >>"$out"
"""],
        **kwargs
    )

    gen = "{}.genfile".format(name)
    native.genrule(
        name = gen,
        srcs = [src, hdr],
        outs = ["{}.genfile.out".format(name)],
        cmd = """
cat "$(execpath {hdr})" >"$@"
cat "$(execpath {src})" >>"$@"
""".format(src = src, hdr = hdr),
    )

    native.sh_binary(
        name = name,
        srcs = [":{}.genfile.update".format(name)],
        args = ["$(rootpath {})".format(hdr), "$(rootpath {})".format(src), "$(rootpath {})".format(out)],
        data = [src, out, hdr],
        **kwargs
    )

    if test:
        diff_test(
            "{}.genfile.test".format(name),
            gen,
            out,
            failure_message = failure_message,
            **kwargs
        )
