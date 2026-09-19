#!/bin/bash
set -euo pipefail

if [[ -v BUILD_WORKSPACE_DIRECTORY ]]; then
  cd "$BUILD_WORKSPACE_DIRECTORY"
  # https://docs.bazel.build/versions/main/user-manual.html#run
  unset BUILD_WORKSPACE_DIRECTORY
  unset BUILD_WORKING_DIRECTORY
fi

bazel run --lockfile_mode=off //:bazelversion.genfile
bazel run --lockfile_mode=off @unpinned_maven//:pin
bazel run --lockfile_mode=off @unpinned_pip//:pin

bazel mod graph --lockfile_mode=update

bazel run //.prow:presubmit.genfile
bazel run //.prow:postsubmit.genfile
bazel run //oj/oj-server:versions.genfile
