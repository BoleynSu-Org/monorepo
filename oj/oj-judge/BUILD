load("@io_bazel_rules_docker//java:image.bzl", "java_image")
load("@rules_java//java:defs.bzl", "java_proto_library")
load("@rules_proto//proto:defs.bzl", "proto_library")
load("@io_grpc_grpc_java//:java_grpc_library.bzl", "java_grpc_library")

package(
    default_visibility = ["//visibility:public"],
)

proto_library(
    name = "task_proto",
    srcs = ["src/main/proto/su/boleyn/oj/judge/task.proto"],
)

java_proto_library(
    name = "task_java_proto",
    deps = [":task_proto"],
)

proto_library(
    name = "result_proto",
    srcs = ["src/main/proto/su/boleyn/oj/judge/result.proto"],
)

java_proto_library(
    name = "result_java_proto",
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
    deps = [":runner_proto"],
)

java_grpc_library(
    name = "runner_java_grpc",
    srcs = [":runner_proto"],
    deps = [":runner_java_proto"],
)

java_image(
    name = "oj-judge",
    srcs = ["src/main/java/su/boleyn/oj/judge/Main.java"],
    main_class = "su.boleyn.oj.judge.Main",
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
