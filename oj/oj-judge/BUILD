load("@io_bazel_rules_docker//java:image.bzl", "java_image")
load("@rules_java//java:defs.bzl", "java_proto_library")
load("@rules_proto//proto:defs.bzl", "proto_library")
load("@io_grpc_grpc_java//:java_grpc_library.bzl", "java_grpc_library")

proto_library(
    name = "proto",
    srcs = ["src/main/proto/su/boleyn/oj/judge/runner.proto"],
    visibility = ["//visibility:public"],
)

java_proto_library(
    name = "java_proto",
    visibility = ["//visibility:public"],
    deps = [":proto"],
)

java_grpc_library(
    name = "java_grpc",
    srcs = ["proto"],
    visibility = ["//visibility:public"],
    deps = ["java_proto"],
)

java_image(
    name = "oj-judge",
    srcs = ["src/main/java/su/boleyn/oj/judge/Main.java"],
    main_class = "su.boleyn.oj.judge.Main",
    visibility = ["//visibility:public"],
    runtime_deps = [
        "@io_grpc_grpc_java//netty",
    ],
    deps = [
        ":java_grpc",
        ":java_proto",
        "//oj/oj-core:lib",
        "@io_grpc_grpc_java//api",
    ],
)
