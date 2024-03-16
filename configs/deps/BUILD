load("@bazel_deps//:deps.bzl", "DEPS")
load("//tools/build/rules:genfile.bzl", "genfile")
load("//tools/build/rules:run.bzl", "run")

INCLUDES = DEPS["metadata"]["include"]

alias(
    name = "alias_to_avoid_duplicated_label",
    actual = "deps.yaml",
)

run(
    name = "updated_deps_yaml",
    arguments = [
        "$(execpath :alias_to_avoid_duplicated_label)",
        "$(execpath updated_deps.yaml)",
    ] + ["--include=$(execpath {})".format(include) for include in INCLUDES],
    executable = "//deps_yaml:regenerate",
    inputs = [":alias_to_avoid_duplicated_label"] + INCLUDES,
    outputs = ["updated_deps.yaml"],
    tools = ["//deps_yaml:regenerate"],
)

genfile(
    name = "deps_yaml",
    src = ":updated_deps_yaml",
    out = "deps.yaml",
    headers = [],
)

exports_files(
    ["deps.yaml"],
    visibility = ["//visibility:public"],
)
