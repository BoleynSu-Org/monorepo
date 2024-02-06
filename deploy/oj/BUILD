load("@rules_oci//oci:defs.bzl", "oci_push")
load("@bazel_deps//:container_deps.bzl", "CONTAINER_IMAGES")
load("//tools/build/rules:expand_template.bzl", "expand_template")

exports_files(glob(["**"]))

filegroup(
    name = "oj",
    srcs = glob(["**"]),
)

COMPONENTS = [
    "oj-server",
    "oj-judge",
    "oj-c99runner",
]

DATA = [
    tpl.format(name)
    for tpl in [
        ":{}",
        "//oj/{}:image",
    ]
    for name in COMPONENTS
] + [
    "@kubectl_linux_amd64//file",
    "@jq_toolchains//:resolved_toolchain",
]

[
    oci_push(
        name = name,
        image = "//oj/{}:image".format(name),
        repository = "ghcr.io/boleynsu-org/images_boleynsu_org_oj_{}".format(name),
    )
    for name in COMPONENTS
]

expand_template(
    name = "deploy",
    expand_location_for = DATA,
    is_executable = True,
    substitutions = {
        "$PUSH_ALL_IMAGES": "\n".join([
            '"$(rlocation "$(rlocationpath :{})")" --tag=latest'.format(name)
            for name in [
                "oj-server",
                "oj-judge",
                "oj-c99runner",
            ]
        ]),
        "$SED_COMMANDS": " ".join([
            "-e 's#{registry}/{repository}#{registry}/{repository}@{digest}#'".format(
                digest = image["digest"],
                registry = image["registry"],
                repository = image["repository"],
            )
            for image in CONTAINER_IMAGES.values()
            if image["registry"] + "/" + image["repository"] in [
                "docker.io/library/mariadb",
                "docker.io/library/adminer",
                "docker.io/filebrowser/filebrowser",
            ]
        ] + [
            '-e "s#images_boleynsu_org_oj_{name}#ghcr.io/boleynsu-org/images_boleynsu_org_oj_{name}@$("$(rlocation "$(rlocationpath @jq_toolchains//:resolved_toolchain)")" -r ".manifests[0].digest" "$(rlocation "$(rlocationpath //oj/{name}:image)/index.json")")#g" '.format(name = name)
            for name in COMPONENTS
        ]),
        "$KUBECTL": '"$(rlocation "$(rlocationpath @kubectl_linux_amd64//file)")"',
    },
    template = "deploy.tpl.sh",
)

sh_binary(
    name = "staging.apply",
    srcs = [":deploy"],
    args = [
        "$(rootpath k3s-cuhk/common/deployment.yaml)",
        "--cluster",
        "k3s-cuhk",
        "--namespace",
        "staging",
    ],
    data = DATA + [
        "k3s-cuhk/common/deployment.yaml",
        "@bazel_tools//tools/bash/runfiles",
    ],
)
