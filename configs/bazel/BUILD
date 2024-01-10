load("@bazel_deps//:toolchain_deps.bzl", "CPP_VERSION", "C_VERSION", "JAVA_VERSION")
load("//tools/build/rules:expand_template.bzl", "expand_template")
load("//tools/build/rules:run.bzl", "run")
load("//tools/build/rules:genfile.bzl", "genfile")

expand_template(
    name = "bazelrc",
    substitutions = {
        "{c_version}": C_VERSION,
        "{cpp_version}": CPP_VERSION,
        "{java_version}": JAVA_VERSION,
    },
    template = "common.bazelrc",
    visibility = ["//visibility:public"],
)

run(
    name = "gen_deps_bzl",
    arguments = [
        "$(execpath //configs/deps:deps.yaml)",
        "$(execpath gen_deps.bzl)",
    ],
    executable = "//deps_bzl:generate",
    inputs = ["//configs/deps:deps.yaml"],
    outputs = ["gen_deps.bzl"],
    tools = ["//deps_bzl:generate"],
)

genfile(
    name = "deps_bzl",
    src = ":gen_deps_bzl",
    out = "deps.bzl",
    visibility = ["//visibility:public"],
)
