load("@io_bazel_rules_k8s//toolchains/kubectl:kubectl_toolchain.bzl", "kubectl_toolchain")

kubectl_toolchain(
    name = "kubectl",
    tool_target = "@kubectl_linux_amd64//file",
)

toolchain(
    name = "kubectl_toolchain",
    toolchain = ":kubectl",
    toolchain_type = "@io_bazel_rules_k8s//toolchains/kubectl:toolchain_type",
)
