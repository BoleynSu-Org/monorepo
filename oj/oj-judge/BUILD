load("@com_google_protobuf//bazel:java_proto_library.bzl", "java_proto_library")
load("@com_google_protobuf//bazel:proto_library.bzl", "proto_library")
load("@io_grpc_grpc_java//:java_grpc_library.bzl", "java_grpc_library")
load("@rules_java//java:defs.bzl", "java_binary")
load("@rules_oci//oci:defs.bzl", "oci_image")
load("@rules_pkg//pkg:tar.bzl", "pkg_tar")

proto_library(
    name = "task_proto",
    srcs = ["src/main/proto/su/boleyn/oj/judge/task.proto"],
)

java_proto_library(
    name = "task_java_proto",
    visibility = ["//visibility:public"],
    deps = [":task_proto"],
)

proto_library(
    name = "result_proto",
    srcs = ["src/main/proto/su/boleyn/oj/judge/result.proto"],
)

java_proto_library(
    name = "result_java_proto",
    visibility = ["//visibility:public"],
    deps = [":result_proto"],
)

proto_library(
    name = "runner_proto",
    srcs = ["src/main/proto/su/boleyn/oj/judge/runner.proto"],
    deps = [
        ":result_proto",
        ":task_proto",
    ],
)

java_proto_library(
    name = "runner_java_proto",
    visibility = ["//visibility:public"],
    deps = [":runner_proto"],
)

java_grpc_library(
    name = "runner_java_grpc",
    srcs = [":runner_proto"],
    visibility = ["//visibility:public"],
    deps = [":runner_java_proto"],
)

java_binary(
    name = "oj-judge",
    srcs = ["src/main/java/su/boleyn/oj/judge/Main.java"],
    main_class = "su.boleyn.oj.judge.Main",
    visibility = ["//visibility:public"],
    runtime_deps = [
        "@io_grpc_grpc_java//netty",
    ],
    deps = [
        ":result_java_proto",
        ":runner_java_grpc",
        ":runner_java_proto",
        ":task_java_proto",
        "//oj/oj-core:lib",
        "@io_grpc_grpc_java//api",
    ],
)

pkg_tar(
    name = "oj-judge.tar",
    srcs = [":oj-judge"],
    empty_dirs = ["oj-judge.runfiles/_main"],
    include_runfiles = True,
    package_dir = "/usr/local/bin",
)

oci_image(
    name = "image",
    base = "//base_images:base",
    entrypoint = ["/usr/local/bin/oj-judge"],
    tars = [":oj-judge.tar"],
    visibility = ["//visibility:public"],
)
