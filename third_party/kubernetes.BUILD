load("@io_bazel_rules_go//go:def.bzl", "go_binary")

go_binary(
    name = "kubectl",
    srcs = ["cmd/kubectl/kubectl.go"],
    visibility = ["//visibility:public"],
    deps = [
        "@io_k8s_client_go//plugin/pkg/client/auth:go_default_library",
        "@io_k8s_component_base//cli:go_default_library",
        "@io_k8s_kubectl//pkg/cmd:go_default_library",
        "@io_k8s_kubectl//pkg/cmd/util:go_default_library",
    ],
)
