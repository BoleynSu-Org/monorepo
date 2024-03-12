#!/bin/bash
set -euo pipefail

if [[ -v BUILD_WORKSPACE_DIRECTORY ]]; then
  cd "$BUILD_WORKSPACE_DIRECTORY"
  # https://docs.bazel.build/versions/main/user-manual.html#run
  unset BUILD_WORKSPACE_DIRECTORY
  unset BUILD_WORKING_DIRECTORY
fi

REPIN=1 bazel run --config=disable_bzlmod //configs/bazel:deps_bzl.genfile
REPIN=1 bazel run --config=disable_bzlmod //configs/deps:deps_yaml.genfile
REPIN=1 bazel run --config=disable_bzlmod //configs/bazel:deps_bzl.genfile
REPIN=1 bazel run --config=disable_bzlmod @unpinned_maven//:pin
REPIN=1 bazel run --config=disable_bzlmod @unpinned_pip//:pin
REPIN=1 bazel run --config=disable_bzlmod @unpinned_gazelle_go_deps//:pin
REPIN=1 bazel run --config=disable_bzlmod //third_party/io_grpc_grpc_java:module_bazel.genfile
REPIN=1 bazel run --config=disable_bzlmod //.prow:presubmit.genfile
REPIN=1 bazel run --config=disable_bzlmod //.prow:postsubmit.genfile
REPIN=1 bazel run --config=disable_bzlmod //oj/oj-server:versions.genfile
