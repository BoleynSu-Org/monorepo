# bazel deps
load("//configs/deps:bazel_deps.bzl", "bazel_deps")

def workspace():
    # bazel deps
    bazel_deps()
