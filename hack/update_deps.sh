#!/bin/bash
set -euo pipefail

REPIN=1 bazel run //configs/deps:deps_bzl.genfile
REPIN=1 bazel run @unpinned_maven//:pin
REPIN=1 bazel run @unpinned_pip//:pin
REPIN=1 bazel run @unpinned_gazelle_go_deps//:pin
