load("@bazel_deps//:deps.bzl", "DEPS")

(RBE_FEDORA_IMAGE,) = [dep for dep in DEPS["container_deps"] if dep["name"] == "io_quay_boleynsu_rbe_fedora"]

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
    name = "linux_x86_64",
    constraint_values = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
    visibility = ["//visibility:public"],
)

platform(
    name = "windows_x86_64",
    constraint_values = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows",
    ],
    visibility = ["//visibility:public"],
)
