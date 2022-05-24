#!/bin/bash
set -euo pipefail
src=$1
out=$2
hdrs=("${@:3}")

if [[ -v BUILD_WORKSPACE_DIRECTORY ]]; then
    out=$BUILD_WORKSPACE_DIRECTORY/$out
fi

rm -f "$out"
for hdr in "${hdrs[@]}"; do
  printf "%s\n" "$hdr" >>"$out"
done
cat "$src" >>"$out"
