#!/bin/bash
set -euo pipefail

(
  printf "%s\n" "${@:3}"
  cat "$1"
) > "$2"
