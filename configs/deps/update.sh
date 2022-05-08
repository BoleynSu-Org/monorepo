#!/bin/bash
set -euo pipefail

if [[ -v BUILD_WORKSPACE_DIRECTORY ]]; then
    cd "$BUILD_WORKSPACE_DIRECTORY"
    # https://docs.bazel.build/versions/main/user-manual.html#run
    unset BUILD_WORKSPACE_DIRECTORY
    unset BUILD_WORKING_DIRECTORY
fi

REPIN=1 bazel run @unpinned_maven//:pin
REPIN=1 bazel run @unpinned_pip//:pin
REPIN=1 bazel run @unpinned_gazelle_go_deps//:pin
