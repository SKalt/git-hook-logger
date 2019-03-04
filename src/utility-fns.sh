#! /usr/bin/env bash
local input="$1"; if [ -z "$input" ]; then input="$(cat -)"; fi

function escape-quotes() {
  local input="$1"; if [ -z "$input" ]; then input="$(cat -)"; fi
  echo "\"$(echo $input | sed 's/"/\\"/g')\""
}
