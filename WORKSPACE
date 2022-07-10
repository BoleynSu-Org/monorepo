workspace(name = "boleynsu_org")

new_local_repository(
    name = "boleynsu_deps_bzl",
    build_file_content = "",
    path = "configs/deps",
)

local_repository(
    name = "boleynsu",
    path = "../..",
)

load("@boleynsu_org//tools/build/repo_rules/workspace:bazel_deps.bzl", "bazel_deps")

bazel_deps()

load("@bazel_deps//:indirect_deps.bzl", "indirect_deps")

indirect_deps()

load("@bazel_deps//:nonbazel_deps.bzl", "nonbazel_deps")

nonbazel_deps(
    maven_deps_config = dict(
        strict_visibility = False,  # FIXME(https://github.com/grpc/grpc-java/issues/9288): remove strict_visibility=False after the upstream issue is fixed.
    ),
)

load("@bazel_deps//:install_nonbazel_deps.bzl", "install_nonbazel_deps")

install_nonbazel_deps()
