load("@bazel_skylib//rules:diff_test.bzl", "diff_test")

def genfile(*, name, src, out, comment = "# ", headers = None, test = True, failure_message = None, visibility = None, **kwargs):
    if headers == None:
        headers = ["DO NOT EDIT! This file is auto-generated.", "Run `bazel run //{}:{}.genfile` to regenerate.".format(native.package_name(), name)]
    if failure_message == None:
        failure_message = "The file is outdated. bazel run //{}:{}.genfile to regenerate.".format(native.package_name(), name)

    if comment:
        for i, hdr_i in enumerate(headers):
            headers[i] = comment + hdr_i

    for hdr in headers:
        if "'" in hdr:
            fail("' is not allowed in headers!")
    if out.startswith("@"):
        fail("out should points to a file in the current repo.")

    native.genrule(
        name = name,
        srcs = [src],
        outs = ["{}.genfile.out".format(name)],
        cmd = " && ".join(["printf '%s\n' '{}' >>'$@'".format(hdr) for hdr in headers] + ['cat "$(execpath {})" >>"$@"'.format(src)]),
        visibility = visibility,
        **kwargs
    )

    native.sh_binary(
        name = "{}.genfile".format(name),
        srcs = [Label("//tools/build/rules:genfile_sh")],
        args = ["$(rootpath {})".format(name), "$(rootpath {})".format(out)],
        data = [name, out],
        visibility = ["//visibility:private"],
        **kwargs
    )

    if test:
        diff_test(
            "{}.genfile.test".format(name),
            name,
            out,
            failure_message = failure_message,
            visibility = ["//visibility:private"],
            **kwargs
        )
