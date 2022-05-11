load("//tools/build/rules:genfile.bzl", "genfile")

genfile(
    name = "bazelrc",
    src = "@boleynsu_org//configs/bazel:bazelrc",
    out = ".bazelrc",
)

genfile(
    name = "bazelversion",
    src = "@boleynsu_org//configs/bazel:bazelversion",
    out = ".bazelversion",
    headers = [],
)

genfile(
    name = "prow.yaml",
    src = "@boleynsu_org//configs/prow:prow.yaml",
    out = ".prow.yaml",
)
