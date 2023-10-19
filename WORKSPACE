workspace(name = "boleynsu_org")

local_repository(
    name = "boleynsu",
    path = "../..",
)

load("//configs/deps:deps.bzl", "DEPS")
load("//tools/build/repo_rules/workspace:bazel_deps.bzl", "bazel_deps")

bazel_deps(
    name = "bazel_deps",
    deps = DEPS,
)

load("@bazel_deps//:install_bazel_deps.bzl", "install_bazel_deps")

install_bazel_deps()

load("@bazel_deps//:nonbazel_deps.bzl", "nonbazel_deps")

nonbazel_deps()

load("@bazel_deps//:install_nonbazel_deps.bzl", "install_nonbazel_deps")

install_nonbazel_deps()
