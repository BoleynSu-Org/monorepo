load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("//tools/build/rules:expand_template.bzl", "expand_template")
load("//configs/deps:toolchain_deps.bzl", "BAZEL_VERSION", "CPP_VERSION", "C_VERSION", "JAVA_VERSION")

expand_template(
    name = "bazelrc",
    substitutions = {
        "{c_version}": C_VERSION,
        "{cpp_version}": CPP_VERSION,
        "{java_version}": JAVA_VERSION,
    },
    visibility = ["//visibility:public"],
)

write_file(
    name = "bazelversion",
    out = ".bazelversion",
    content = [BAZEL_VERSION + "\n"],
    visibility = ["//visibility:public"],
)
