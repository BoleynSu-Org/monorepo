load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")
load("@bazel_deps//:container_deps.bzl", "CONTAINER_IMAGES")

exports_files(glob(["**"]))

filegroup(
    name = "oj",
    srcs = glob(["**"]),
)

k8s_object(
    name = "staging",
    cluster = "k3s-cuhk",
    image_chroot = "ghcr.io/boleynsu-org",
    images = {
        "images_boleynsu_org_oj_oj-server": "@boleynsu_org//oj/oj-server",
        "images_boleynsu_org_oj_oj-judge": "@boleynsu_org//oj/oj-judge",
        "images_boleynsu_org_oj_oj-c99runner": "@boleynsu_org//oj/oj-c99runner",
    },
    namespace = "staging",
    substitutions = {
        image["registry"] + "/" + image["repository"]: image["registry"] + "/" + image["repository"] + "@" + image["digest"]
        for image in CONTAINER_IMAGES.values()
        if image["registry"] + "/" + image["repository"] in [
            "docker.io/library/mariadb",
            "docker.io/library/adminer",
            "docker.io/filebrowser/filebrowser",
        ]
    },
    template = "k3s-cuhk/common/deployment.yaml",
)
