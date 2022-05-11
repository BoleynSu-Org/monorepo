#!/bin/bash
set -euo pipefail
src=$1
out=$2
hdr=("${@:3}")

if [[ -v BUILD_WORKSPACE_DIRECTORY ]]; then
    out=$BUILD_WORKSPACE_DIRECTORY/$out
fi

printf "%s\n" "${hdr[@]}" >"$out"
cat "$src" >>"$out"
