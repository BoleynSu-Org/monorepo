# bazel deps
load("//configs/deps:bazel_deps.bzl", "bazel_deps")

def workspace(*, enable_bazel_deps = True):
    # bazel deps
    if enable_bazel_deps:
        bazel_deps()
