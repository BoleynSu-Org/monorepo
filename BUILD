load("//tools/build/rules:genfile.bzl", "genfile")

genfile(
    name = "bazelrc",
    src = "//configs/bazel:bazelrc",
    out = ".bazelrc",
)

genfile(
    name = "bazelversion",
    src = "//configs/bazel:bazelversion",
    out = ".bazelversion",
    headers = [],
)

genfile(
    name = "prow.yaml",
    src = "//configs/prow:prow.yaml",
    out = ".prow.yaml",
)
