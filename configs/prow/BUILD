load("//tools/build/rules:expand_template.bzl", "expand_template")
load("//configs/deps:container_deps.bzl", "CONTAINER_IMAGES")

CI_RUNNER_IMAGE = CONTAINER_IMAGES["io_quay_boleynsu_ci_runner"]

expand_template(
    name = "presubmit.yaml",
    substitutions = {
        "{ci_runner_image}": CI_RUNNER_IMAGE["registry"] + "/" + CI_RUNNER_IMAGE["repository"] + "@" + CI_RUNNER_IMAGE["digest"],
    },
    visibility = ["//visibility:public"],
)

expand_template(
    name = "postsubmit.yaml",
    substitutions = {
        "{ci_runner_image}": CI_RUNNER_IMAGE["registry"] + "/" + CI_RUNNER_IMAGE["repository"] + "@" + CI_RUNNER_IMAGE["digest"],
    },
    visibility = ["//visibility:public"],
)
