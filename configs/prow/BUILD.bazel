load("@bazel_deps//:deps.bzl", "DEPS")
load("//tools/build/rules:expand_template.bzl", "expand_template")

(CI_RUNNER_IMAGE,) = [dep for dep in DEPS["container_deps"] if dep["name"] == "io_quay_boleynsu_ci_runner"]

[
    expand_template(
        name = "{}.yaml".format(job),
        substitutions = {
            "quay.io/boleynsu/ci-runner": CI_RUNNER_IMAGE["registry"] + "/" + CI_RUNNER_IMAGE["repository"] + "@" + CI_RUNNER_IMAGE["digest"],
        },
        template = "{}.tpl.yaml".format(job),
        visibility = ["//visibility:public"],
    )
    for job in [
        "presubmit",
        "postsubmit",
    ]
]
