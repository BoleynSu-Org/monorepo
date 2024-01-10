load("@rules_python//python:defs.bzl", "py_binary", "py_library")

py_library(
    name = "include",
    srcs = ["include.py"],
    visibility = ["//visibility:public"],
    deps = [
        "@pip_ruamel_yaml//:pkg",
    ],
)

py_binary(
    name = "regenerate",
    srcs = ["regenerate.py"],
    visibility = ["//visibility:public"],
    deps = [
        ":include",
        "@pip_ruamel_yaml//:pkg",
    ],
)
