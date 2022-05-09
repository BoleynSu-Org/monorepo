#!/bin/bash
set -euo pipefail

cd "$BUILD_WORKSPACE_DIRECTORY"
# https://docs.bazel.build/versions/main/user-manual.html#run
unset BUILD_WORKSPACE_DIRECTORY
unset BUILD_WORKING_DIRECTORY

REPIN=1 bazel run //tools/deps_bzl:regenerate -- configs/deps/deps.bzl configs/deps/deps.bzl
REPIN=1 bazel run @unpinned_maven//:pin
REPIN=1 bazel run @unpinned_pip//:pin
REPIN=1 bazel run @unpinned_gazelle_go_deps//:pin
