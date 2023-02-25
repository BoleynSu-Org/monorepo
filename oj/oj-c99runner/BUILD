load("@io_bazel_rules_docker//java:image.bzl", "java_image")
load("@rules_java//java:defs.bzl", "java_library")

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
    base = "@io_quay_boleynsu_oj_c99runner//image",
    main_class = "su.boleyn.oj.c99runner.Main",
    visibility = ["//visibility:public"],
    runtime_deps = [":lib"],
)
