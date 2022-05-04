#!/bin/bash
set -euo pipefail

if [[ -v BUILD_WORKSPACE_DIRECTORY ]]; then
    cd "$BUILD_WORKSPACE_DIRECTORY"
    # https://docs.bazel.build/versions/main/user-manual.html#run
    unset BUILD_WORKSPACE_DIRECTORY
    unset BUILD_WORKING_DIRECTORY
fi

REPIN=1 bazel run "${@:1}" @unpinned_maven//:pin
bazel run "${@:1}" @unpinned_pip//:pin.update
bazel run "${@:1}" @unpinned_gazelle_go_deps//:pin

