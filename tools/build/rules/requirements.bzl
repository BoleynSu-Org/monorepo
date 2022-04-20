load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("//tools/build/rules:genfile.bzl", "genfile")

def requirements_txt(*, name, out, packages, versions, **kwargs):
    write_file(
        name = name,
        out = "{}.requirements.in".format(name),
        content = ["{package} == {version}".format(package = package, version = versions[package]) for package in packages] + [""],
        **kwargs
    )

    genfile(
        name = "{}.update".format(name),
        src = ":{}".format(name),
        out = out,
        **kwargs
    )
