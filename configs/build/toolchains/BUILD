load("@rules_cc//cc:defs.bzl", "cc_toolchain", "cc_toolchain_suite")
load("@io_bazel_rules_k8s//toolchains/kubectl:kubectl_toolchain.bzl", "kubectl_toolchain")
load(":defs.bzl", "fake_cc_toolchain_config")

cc_toolchain_suite(
    name = "fake_crosstool_top",
    toolchains = {
        "k8|clang": ":fake_cc",
        "aarch64|clang": ":fake_cc",
        "darwin|clang": ":fake_cc",
        "k8": ":fake_cc",
        "aarch64": ":fake_cc",
        "darwin": ":fake_cc",
    },
)

filegroup(
    name = "empty",
    srcs = [],
)

fake_cc_toolchain_config(
    name = "fake_cc_toolchain_config",
)

cc_toolchain(
    name = "fake_cc",
    all_files = ":empty",
    ar_files = ":empty",
    as_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
    toolchain_config = ":fake_cc_toolchain_config",
)

kubectl_toolchain(
    name = "kubectl",
    tool_target = "@io_k8s_kubernetes//:kubectl",
)

toolchain(
    name = "kubectl_toolchain",
    toolchain = ":kubectl",
    toolchain_type = "@io_bazel_rules_k8s//toolchains/kubectl:toolchain_type",
)
