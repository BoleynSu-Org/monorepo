#!/bin/bash
set -euo pipefail

if [[ -v BUILD_WORKSPACE_DIRECTORY ]]; then
  cd "$BUILD_WORKSPACE_DIRECTORY"
  # https://docs.bazel.build/versions/main/user-manual.html#run
  unset BUILD_WORKSPACE_DIRECTORY
  unset BUILD_WORKING_DIRECTORY
fi

export REPIN=1

bazel run --lockfile_mode=update //configs/deps:deps_yaml.genfile
bazel run --lockfile_mode=update @unpinned_maven//:pin
bazel run --lockfile_mode=update @unpinned_pip//:pin
bazel run --lockfile_mode=update //third_party/io_grpc_grpc_java:module_bazel.genfile
bazel run --lockfile_mode=update //.prow:presubmit.genfile
bazel run --lockfile_mode=update //.prow:postsubmit.genfile
bazel run --lockfile_mode=update //oj/oj-server:versions.genfile
bazel build --lockfile_mode=update //... --nobuild
