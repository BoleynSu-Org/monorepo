load("@bazel_skylib//rules:diff_test.bzl", "diff_test")

def genfile(*, name, src, out, comment = "# ", headers = None, test = True, failure_message = None, **kwargs):
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

    native.genrule(
        name = name,
        srcs = [src],
        outs = ["{}.genfile.out".format(name)],
        cmd = " && ".join(["printf '%s\n' '{}' >>'$@'".format(hdr) for hdr in headers] + ['cat "$(execpath {})" >>"$@"'.format(src)]),
    )

    native.sh_binary(
        name = "{}.genfile".format(name),
        srcs = [Label("//tools/build/rules:genfile.sh")],
        args = ["$(rootpath {})".format(src), "$(rootpath {})".format(out)] + [repr(hdr) for hdr in headers],
        data = [src, out],
        **kwargs
    )

    if test:
        diff_test(
            "{}.genfile.test".format(name),
            name,
            out,
            failure_message = failure_message,
            **kwargs
        )
