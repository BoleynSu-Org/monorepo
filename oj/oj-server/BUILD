load("//tools/build/rules:genfile.bzl", "genfile")
load("@io_bazel_rules_docker//java:image.bzl", "java_image")

genfile(
    name = "favicon",
    src = "//storage/public/assets:favicon",
    out = "src/main/webapp/favicon.ico",
    headers = [],
)

java_image(
    name = "oj-server",
    srcs = [
        "src/main/java/su/boleyn/oj/server/Main.java",
        "src/main/java/su/boleyn/oj/server/User.java",
    ],
    main_class = "su.boleyn.oj.server.Main",
    resources = [
        # pages
        "src/main/webapp/chat.jsp",
        "src/main/webapp/contests.jsp",
        "src/main/webapp/index.jsp",
        "src/main/webapp/login.jsp",
        "src/main/webapp/problem.jsp",
        "src/main/webapp/problemset.jsp",
        "src/main/webapp/redirect.jsp",
        "src/main/webapp/register.jsp",
        "src/main/webapp/standings.jsp",
        "src/main/webapp/status.jsp",
        "src/main/webapp/submit.jsp",
        "src/main/webapp/submission.jsp",
        "src/main/webapp/custom_test.jsp",
        # favicon
        "src/main/webapp/favicon.ico",
        # js
        "src/main/webapp/static/my.js",
        # config
        "src/main/webapp/WEB-INF/web.xml",
    ] + glob([
        # editarea
        "src/main/webapp/static/editarea/**",
    ]),
    visibility = ["//visibility:public"],
    runtime_deps = [
        "@io_grpc_grpc_java//netty",
        "@maven//:org_webjars_bootstrap",
        "@maven//:org_webjars_jquery",
    ],
    deps = [
        "//oj/oj-core:lib",
        "//oj/oj-judge:java_grpc",
        "//oj/oj-judge:java_proto",
        "@io_grpc_grpc_java//api",
        "@maven//:commons_io_commons_io",
        "@maven//:org_apache_tomcat_embed_tomcat_embed_core",
        "@maven//:org_apache_tomcat_embed_tomcat_embed_jasper",
    ],
)
