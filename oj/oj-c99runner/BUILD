load("@rules_java//java:defs.bzl", "java_binary", "java_library")
load("@rules_oci//oci:defs.bzl", "oci_image")
load("@rules_pkg//pkg:tar.bzl", "pkg_tar")

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

java_binary(
    name = "oj-c99runner",
    jvm_flags = [
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
    ],
    main_class = "su.boleyn.oj.c99runner.Main",
    visibility = ["//visibility:public"],
    runtime_deps = [":lib"],
)

pkg_tar(
    name = "oj-c99runner.tar",
    srcs = [":oj-c99runner"],
    empty_dirs = ["oj-c99runner.runfiles/_main"],
    include_runfiles = True,
    package_dir = "/usr/local/bin",
)

oci_image(
    name = "image",
    base = "//base_images:oj-c99runner",
    entrypoint = ["/usr/local/bin/oj-c99runner"],
    tars = [":oj-c99runner.tar"],
    visibility = ["//visibility:public"],
)
