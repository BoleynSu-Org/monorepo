#!/bin/bash
set -euo pipefail

if [[ -v BUILD_WORKSPACE_DIRECTORY ]]; then
  cd "$BUILD_WORKSPACE_DIRECTORY"
  # https://docs.bazel.build/versions/main/user-manual.html#run
  unset BUILD_WORKSPACE_DIRECTORY
  unset BUILD_WORKING_DIRECTORY
fi

export REPIN=1

bazel run --lockfile_mode=off //configs/deps:deps_yaml.genfile
bazel run --lockfile_mode=off //:bazelversion.genfile
bazel run --lockfile_mode=off @unpinned_maven//:pin
bazel run --lockfile_mode=off @unpinned_pip//:pin
bazel run --lockfile_mode=off //third_party/io_grpc_grpc_java:module_bazel.genfile
bazel run --lockfile_mode=off //.prow:presubmit.genfile
bazel run --lockfile_mode=off //.prow:postsubmit.genfile
bazel run --lockfile_mode=off //oj/oj-server:versions.genfile

bazel mod graph --lockfile_mode=update
