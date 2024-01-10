load("@rules_python//python:defs.bzl", "py_binary")

py_binary(
    name = "generate",
    srcs = ["generate.py"],
    visibility = ["//visibility:public"],
    deps = [
        "@pip_ruamel_yaml//:pkg",
    ],
)
