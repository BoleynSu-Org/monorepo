load("@rules_pkg//pkg:mappings.bzl", "pkg_attributes", "pkg_files")
load("@rules_pkg//pkg:tar.bzl", "pkg_tar")
load("@io_bazel_rules_docker//container:container.bzl", "container_image")
load("@io_bazel_rules_docker//java:image.bzl", "java_image")
load("@rules_java//java:defs.bzl", "java_library")

pkg_files(
    name = "java_wrapper_files",
    srcs = [
        "java_wrapper.sh",
    ],
    attributes = pkg_attributes(mode = "0755"),
    renames = {"java_wrapper.sh": "/usr/bin/java"},
)

pkg_tar(
    name = "java_wrapper",
    srcs = [":java_wrapper_files"],
)

container_image(
    name = "base_image",
    tars = [
        "@rpm_deps//:oj-c99runner",
        ":java_wrapper",
    ],
)

java_library(
    name = "lib",
    srcs = ["src/main/java/su/boleyn/oj/c99runner/Main.java"],
    deps = [
        "//oj/oj-judge:result_java_proto",
        "//oj/oj-judge:runner_java_grpc",
        "//oj/oj-judge:runner_java_proto",
        "//oj/oj-judge:task_java_proto",
        "@io_grpc_grpc_java//api",
        "@io_grpc_grpc_java//netty",
        "@io_grpc_grpc_java//stub",
    ],
)

java_image(
    name = "oj-c99runner",
    base = ":base_image",
    main_class = "su.boleyn.oj.c99runner.Main",
    visibility = ["//visibility:public"],
    runtime_deps = [":lib"],
)
