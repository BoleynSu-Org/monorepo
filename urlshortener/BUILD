load("@rules_java//java:defs.bzl", "java_binary")
load("@rules_pkg//pkg:tar.bzl", "pkg_tar")
load("@rules_oci//oci:defs.bzl", "oci_image")

java_binary(
    name = "urlshortener",
    srcs = [
        "src/main/java/su/boleyn/urlshortener/BasicAuthHandler.java",
        "src/main/java/su/boleyn/urlshortener/LockHandler.java",
        "src/main/java/su/boleyn/urlshortener/PasswordIdentityManager.java",
        "src/main/java/su/boleyn/urlshortener/URLInfo.java",
        "src/main/java/su/boleyn/urlshortener/URLShortener.java",
        "src/main/java/su/boleyn/urlshortener/URLShortenerServer.java",
    ],
    main_class = "su.boleyn.urlshortener.URLShortenerServer",
    visibility = ["//visibility:public"],
    runtime_deps = ["@maven//:org_wildfly_common_wildfly_common"],
    deps = [
        "@maven//:commons_codec_commons_codec",
        "@maven//:commons_validator_commons_validator",
        "@maven//:io_undertow_undertow_core",
    ],
)

pkg_tar(
    name = "urlshortener.tar",
    srcs = [":urlshortener"],
    empty_dirs = ["/usr/local/bin/urlshortener.runfiles"],
    include_runfiles = True,
    package_dir = "/usr/local/bin",
    symlinks = {"_main": "urlshortener.runfiles"},
)

oci_image(
    name = "image",
    base = "//base_images:base",
    entrypoint = ["/usr/local/bin/urlshortener"],
    env = {"JAVA_RUNFILES": "/usr/local/bin"},
    tars = [":urlshortener.tar"],
    visibility = ["//visibility:public"],
)
