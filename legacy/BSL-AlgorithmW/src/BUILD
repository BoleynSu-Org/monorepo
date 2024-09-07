load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")

cc_library(
    name = "hdrs",
    hdrs = glob(["**/*.h"]),
)

cc_binary(
    name = "main",
    srcs = ["main.cpp"],
    visibility = ["//visibility:public"],
    deps = [":hdrs"],
)
