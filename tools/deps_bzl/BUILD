load("@rules_python//python:defs.bzl", "py_binary", "py_library")

py_library(
    name = "parser",
    srcs = ["parser.py"],
    visibility = ["//visibility:public"],
    deps = [
        "@pip_ruamel_yaml//:pkg",
    ],
)

py_binary(
    name = "regenerate",
    srcs = ["regenerate.py"],
    deps = [":parser"],
)
