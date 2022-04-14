load("@rules_python//python:pip.bzl", "compile_pip_requirements")
load(":pip_deps.bzl", "requirements_in")

compile_pip_requirements(
    name = "requirements",
    extra_args = ["--allow-unsafe"],
    requirements_in = "requirements.in",
    requirements_txt = "//:requirements.txt",
)

# bazel run //configs/deps:update
sh_binary(
    name = "update",
    srcs = ["update.sh"],
    args = [
        # bazel run //tools/deps_updater -- configs/deps/deps.bzl
        "$(location //tools/deps_updater)",
        "$(location deps.bzl)",
        # bazel run //configs/deps:requirements.update
        "$(location :requirements_in)",
        "$(location requirements.in)",
        "$(location :requirements.update)",
        "$(location //:requirements.txt)",
        "//{}:requirements.update".format(package_name()),
        # bazel run @unpinned_maven//:pin
        "$(location @unpinned_maven//:pin)",
        "$(location @unpinned_maven//:jq-binary)",
        "$(location @unpinned_maven//:unsorted_deps.json)",
    ],
    data = [
        "deps.bzl",
        "requirements.in",
        ":requirements.update",
        ":requirements_in",
        "//:requirements.txt",
        "//tools/deps_updater",
        "@unpinned_maven//:jq-binary",
        "@unpinned_maven//:pin",
        "@unpinned_maven//:unsorted_deps.json",
    ],
)

requirements_in(
    name = "requirements_in",
)
