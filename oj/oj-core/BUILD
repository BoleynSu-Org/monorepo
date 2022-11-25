load("@rules_java//java:defs.bzl", "java_library")

java_library(
    name = "lib",
    srcs = [
        "src/main/java/su/boleyn/oj/core/Config.java",
        "src/main/java/su/boleyn/oj/core/FileUtils.java",
        "src/main/java/su/boleyn/oj/core/SQL.java",
    ],
    visibility = ["//visibility:public"],
    deps = ["@maven//:com_mysql_mysql_connector_j"],
)
