load("//tools/build/rules:run.bzl", "run")
load("//tools/build/rules:genfile.bzl", "genfile")
load(":deps.bzl", "DEPS")

INCLUDES = DEPS["metadata"]["include"]

run(
    name = "updated_deps_bzl",
    arguments = [
        "$(execpath //configs/deps:deps.bzl)",
        "$(execpath updated/deps.bzl)",
    ] + ["--include=$(execpath {})".format(include) for include in INCLUDES],
    executable = "//deps_bzl:regenerate",
    inputs = ["deps.bzl"] + INCLUDES,
    outputs = ["updated/deps.bzl"],
    tools = ["//deps_bzl:regenerate"],
)

genfile(
    name = "deps_bzl",
    src = ":updated_deps_bzl",
    out = "deps.bzl",
    headers = [],
    visibility = ["//visibility:public"],
)
