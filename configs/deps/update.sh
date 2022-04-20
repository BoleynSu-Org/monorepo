#!/bin/bash
set -euo pipefail

if [[ -v BUILD_WORKSPACE_DIRECTORY ]]; then
    cd "$BUILD_WORKSPACE_DIRECTORY"
fi

bazel run "${@:1}" //tools/deps_updater -- configs/deps/deps.bzl configs/deps/deps.bzl
bazel run "${@:1}" //configs/deps:requirements_in.update
bazel run "${@:1}" //configs/deps:requirements.update
bazel run "${@:1}" @unpinned_maven//:pin
