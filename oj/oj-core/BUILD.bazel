load("@rules_java//java:defs.bzl", "java_library")

java_library(
    name = "lib",
    srcs = [
        "src/main/java/su/boleyn/oj/core/Config.java",
        "src/main/java/su/boleyn/oj/core/FileUtils.java",
        "src/main/java/su/boleyn/oj/core/HtmlUtils.java",
        "src/main/java/su/boleyn/oj/core/SQL.java",
    ],
    visibility = ["//visibility:public"],
    runtime_deps = [
        "@maven//:org_mariadb_jdbc_mariadb_java_client",
    ],
    deps = [
        "@maven//:com_googlecode_owasp_java_html_sanitizer_owasp_java_html_sanitizer",
        "@maven//:org_apache_commons_commons_text",
    ],
)
