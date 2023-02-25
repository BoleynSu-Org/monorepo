load("@bazel_deps//:container_deps.bzl", "CONTAINER_IMAGES")

RBE_FEDORA_IMAGE = CONTAINER_IMAGES["io_quay_boleynsu_rbe_fedora"]

platform(
    name = "rbe-fedora",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    exec_properties = {
        "container-image": "docker://" + RBE_FEDORA_IMAGE["registry"] + "/" + RBE_FEDORA_IMAGE["repository"] + "@" + RBE_FEDORA_IMAGE["digest"],
        "OSFamily": "Linux",
    },
)

platform(
    name = "rbe-fedora_container",
    constraint_values = [
        "@io_bazel_rules_docker//platforms:run_in_container",  # See https://github.com/bazelbuild/rules_docker/blob/v0.24.0/platforms/BUILD
    ],
    parents = [":rbe-fedora"],
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
