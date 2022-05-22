# bazel deps
load("//configs/deps:bazel_deps.bzl", "bazel_deps")

def workspace(*, enable_bazel_deps = True):
    native.local_config_platform(name = "local_config_platform")

    # bazel deps
    if enable_bazel_deps:
        bazel_deps()
