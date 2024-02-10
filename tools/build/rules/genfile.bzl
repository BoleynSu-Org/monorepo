load("@bazel_skylib//rules:diff_test.bzl", "diff_test")
load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load(":run.bzl", "run")
load(":expand_template.bzl", "expand_template")

def genfile(*, name, src, out, comment = "# ", headers = None, test = True, failure_message = None, **kwargs):
    if headers == None:
        headers = ["DO NOT EDIT! This file is auto-generated.", "Run `bazel run //{}:{}.genfile` to regenerate.".format(native.package_name(), name)]
    if failure_message == None:
        failure_message = "The file is outdated. bazel run //{}:{}.genfile to regenerate.".format(native.package_name(), name)

    if comment:
        for i, hdr_i in enumerate(headers):
            headers[i] = comment + hdr_i

    if out.startswith("@"):
        fail("out should points to a file in the current repo.")

    if headers:
        run(
            name = name,
            executable = Label("//tools/build/rules:genfile"),
            tools = [Label("//tools/build/rules:genfile")],
            inputs = [src],
            outputs = ["{}.genfile.out".format(name)],
            arguments = ["$(execpath {})".format(src), "$(execpath {})".format("{}.genfile.out".format(name))] + headers,
            **kwargs
        )
    else:
        copy_file(
            name = name,
            src = src,
            out = "{}.genfile.out".format(name),
            allow_symlink = True,
            **kwargs
        )

    expand_template(
        name = "{}.genfile.sh".format(name),
        template = Label("//tools/build/rules:genfile_tpl_sh"),
        substitutions = {
            "{src}": "$(rlocationpath {})".format(name),
            "{out}": "$(rootpath {})".format(out),
        },
        expand_location_for = [name, out],
        **kwargs
    )

    native.sh_binary(
        name = "{}.genfile".format(name),
        srcs = [":{}.genfile.sh".format(name)],
        data = [name],
        deps = [Label("@bazel_tools//tools/bash/runfiles")],
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
