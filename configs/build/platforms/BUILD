platform(
    name = "rbe-fedora-clang_container",
    constraint_values = [
        "@io_bazel_rules_docker//platforms:run_in_container",  # See https://github.com/bazelbuild/rules_docker/blob/v0.24.0/platforms/BUILD
    ],
    parents = ["@rbe-fedora-clang//config:platform"],
    visibility = ["//visibility:public"],
)

platform(
    name = "linux_x86_64",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    visibility = ["//visibility:public"],
)

platform(
    name = "windows_x86_64",
    constraint_values = [
        "@platforms//os:windows",
        "@platforms//cpu:x86_64",
        "@io_bazel_rules_go//go/toolchain:cgo_off",
    ],
    visibility = ["//visibility:public"],
)
