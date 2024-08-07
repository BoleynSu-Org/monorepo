load("@bazel_deps//:deps.bzl", "DEPS")
load("//tools/build/rules:genfile.bzl", "genfile")
load("//tools/build/rules:run.bzl", "run")

INCLUDES = DEPS["metadata"]["include"]

[
    run(
        name = "updated_deps_yaml",
        arguments = [
            "$(execpath deps.yaml)",
            "$(execpath updated_deps.yaml)",
        ] + ["--include=$(execpath {})".format(include) for include in INCLUDES],
        executable = "//deps_yaml:regenerate",
        inputs = ["deps.yaml"] + INCLUDES,
        mnemonic = "DepsYaml",
        outputs = ["updated_deps.yaml"],
        tools = ["//deps_yaml:regenerate"],
    ),
    genfile(
        name = "deps_yaml",
        src = ":updated_deps_yaml",
        out = "deps.yaml",
        headers = [],
    ),
] if DEPS["metadata"]["name"] == "boleynsu_org" else []

exports_files(
    ["deps.yaml"],
    visibility = ["//visibility:public"],
)
