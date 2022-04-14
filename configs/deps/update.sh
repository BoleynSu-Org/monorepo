#!/bin/bash
set -euo pipefail

deps_updater=$1
deps_bzl=$2
gen_requirements_in=$3
requirements_in=$4
requirements_update=$5
requirements_txt=$6
requirements_update_label=$7
maven_pin=$8
jq=$9
unsorted_deps_json=${10}

"$deps_updater" "$deps_bzl"
(
    if [[ -v BUILD_WORKSPACE_DIRECTORY ]]; then
        requirements_in=$BUILD_WORKSPACE_DIRECTORY/$requirements_in
    fi
    cp "$gen_requirements_in" "$requirements_in"
)
"$requirements_update" "$requirements_in" "$requirements_txt" "$requirements_update_label" --allow-unsafe
"$maven_pin" "$jq" "$unsorted_deps_json"
