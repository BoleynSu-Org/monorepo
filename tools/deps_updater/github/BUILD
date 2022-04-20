load("@rules_python//python:defs.bzl", "py_library")
load("@pip//:requirements.bzl", "requirement")

py_library(
    name = "lib",
    srcs = [
        "version.py",
    ],
    visibility = ["//visibility:public"],
    deps = [
        requirement("requests"),
    ],
)
