#!/bin/bash
set -euo pipefail

readonly source=$1
readonly output=$2

grep "^#ifdef CC_BUILD_FAILURE_" "$source" | while read -r line; do
    define=${line:7}
    if "${@:3}" "-D$define" 2>/dev/null; then
        printf "\e[31mERROR:\e[0m Build failures are expected but are not found for %s\n" "$define" | tee "$output"
        exit 1
    fi
done

printf "build failure" >"$output"
