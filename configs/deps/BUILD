load("@rules_python//python:pip.bzl", "compile_pip_requirements")
load(":pip_deps.bzl", "requirements_in")

requirements_in(
    name = "requirements_in",
    out = "requirements.in",
)

compile_pip_requirements(
    name = "requirements",
    requirements_in = "requirements.in",
    requirements_txt = "//:requirements_txt",
)

# bazel run //configs/deps:update
sh_binary(
    name = "update",
    srcs = ["update.sh"],
)
