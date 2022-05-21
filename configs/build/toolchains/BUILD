# See https://github.com/bazelbuild/rules_docker/blob/v0.24.0/toolchains/BUILD
toolchain(
    name = "rbe-ubuntu18-04_cc_toolchain",
    exec_compatible_with = [
        "@io_bazel_rules_docker//platforms:run_in_container",
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
        "@bazel_tools//tools/cpp:clang",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    toolchain = "@boleynsu_org//third_party/rbe-ubuntu18-04/cc:cc-compiler-k8",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)
