#!/bin/bash
set -euo pipefail
readonly src=$1
readonly out=$2

cp "$src" $BUILD_WORKSPACE_DIRECTORY/"$out"
