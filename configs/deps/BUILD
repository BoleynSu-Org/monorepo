load("//tools/build/rules:genfile.bzl", "genfile")
load("//tools/build/rules:run.bzl", "run")

run(
    name = "updated_deps_yaml",
    arguments = [
        "$(execpath :deps.yaml)",
        "$(execpath updated_deps.yaml)",
        "--include=$(execpath //third_party/io_grpc_grpc_java:deps_yaml)",
    ],
    executable = "//deps_yaml:regenerate",
    inputs = [
        ":deps.yaml",
        "//third_party/io_grpc_grpc_java:deps_yaml",
    ],
    mnemonic = "DepsYaml",
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
