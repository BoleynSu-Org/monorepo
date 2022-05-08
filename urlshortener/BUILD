load("@io_bazel_rules_docker//java:image.bzl", "java_image")

java_image(
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
    deps = [
        "@maven//:commons_codec_commons_codec",
        "@maven//:commons_validator_commons_validator",
        "@maven//:io_undertow_undertow_core",
        "@maven//:org_wildfly_common_wildfly_common",
    ],
)
