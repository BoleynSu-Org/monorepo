load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@bazel_deps//:bazel_deps.bzl", "BAZEL_DEPS")
load("@bazel_deps//:toolchain_deps.bzl", "CPP_VERSION", "C_VERSION", "JAVA_VERSION")
load("//tools/build/rules:expand_template.bzl", "expand_template")

expand_template(
    name = "bazelrc",
    substitutions = {
        "{c_version}": C_VERSION,
        "{cpp_version}": CPP_VERSION,
        "{java_version}": JAVA_VERSION,
    },
    template = "common.bazelrc",
    visibility = ["//visibility:public"],
)

write_file(
    name = "bazelversion",
    out = ".bazelversion",
    content = [BAZEL_DEPS["io_bazel"]["version"] + "\n"],
    visibility = ["//visibility:public"],
)
