load("@bazel_deps//:deps.bzl", "DEPS")
load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("//tools/build/rules:expand_template.bzl", "expand_template")

(C_VERSION,) = [dep["version"] for dep in DEPS["toolchain_deps"] if dep["name"] == "c"]

(CPP_VERSION,) = [dep["version"] for dep in DEPS["toolchain_deps"] if dep["name"] == "cpp"]

(JAVA_VERSION,) = [dep["version"] for dep in DEPS["toolchain_deps"] if dep["name"] == "java"]

(BAZEL_VERSION,) = [dep["version"] for dep in DEPS["bazel_deps"] if dep["name"] == "bazel_linux_x86_64"]

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
    content = ["{}\n".format(BAZEL_VERSION)],
    visibility = ["//visibility:public"],
)
