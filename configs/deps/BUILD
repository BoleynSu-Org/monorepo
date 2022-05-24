load("//tools/build/rules:genfile.bzl", "genfile")

INCLUDES = ["@boleynsu_org//third_party/io_grpc_grpc_java_deps_bzl:deps.bzl"]

genrule(
    name = "updated_deps_bzl",
    srcs = ["deps.bzl"],
    outs = ["updated/deps.bzl"],
    cmd = """"$(execpath //tools/deps_bzl:regenerate)" "$(execpath //configs/deps:deps.bzl)" "$@" {}""".format(" ".join(['--include="$(execpath {})"'.format(include) for include in INCLUDES])),
    tools = ["//tools/deps_bzl:regenerate"] + INCLUDES,
)

genfile(
    name = "deps_bzl",
    src = ":updated_deps_bzl",
    out = "deps.bzl",
    headers = [],
)
