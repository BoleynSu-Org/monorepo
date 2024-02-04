load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")
load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load("@bazel_deps//:container_deps.bzl", "CONTAINER_IMAGES")

exports_files(glob(["**"]))

filegroup(
    name = "oj",
    srcs = glob(["**"]),
)

copy_file(
    name = "oj-server",
    src = "//oj/oj-server:image.image.tar",
    out = "oj-server.tar",
    allow_symlink = True,
)

copy_file(
    name = "oj-judge",
    src = "//oj/oj-judge:image.image.tar",
    out = "oj-judge.tar",
    allow_symlink = True,
)

copy_file(
    name = "oj-c99runner",
    src = "//oj/oj-c99runner:image.image.tar",
    out = "oj-c99runner.tar",
    allow_symlink = True,
)

k8s_object(
    name = "staging",
    cluster = "k3s-cuhk",
    image_chroot = "ghcr.io/boleynsu-org",
    images = {
        "images_boleynsu_org_oj_oj-server": ":oj-server",
        "images_boleynsu_org_oj_oj-judge": ":oj-judge",
        "images_boleynsu_org_oj_oj-c99runner": ":oj-c99runner",
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
