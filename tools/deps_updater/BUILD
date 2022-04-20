load("@rules_python//python:defs.bzl", "py_binary", "py_library")
load("@pip//:requirements.bzl", "requirement")

py_library(
    name = "lib",
    srcs = [
        "bazel_updater.py",
        "deps_updater.py",
        "maven_updater.py",
        "pip_updater.py",
        "version.py",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "//tools/deps_updater/github:lib",
        requirement("ruamel.yaml"),
        requirement("requests"),
    ],
)

py_binary(
    name = "deps_updater",
    srcs = ["deps_updater.py"],
    main = "deps_updater.py",
    visibility = ["//visibility:public"],
    deps = [":lib"],
)
