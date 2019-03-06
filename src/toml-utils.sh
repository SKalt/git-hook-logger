#!/usr/bin/env bash

filename="${BASH_SOURCE[0]}"
echo $filename
#--------------------------------- toml utils ---------------------------------#
toml_indent=""
toml_key=$EXPERIMENT_NAME # in branch? $(git rev-parse --abbrev-ref)
# function join_by { local IFS="$1"; shift; echo "$*"; }

function toml-indent() {
  # indent each line of STDIN
  cat - | sed "s/^/$toml_indent/"
}

function toml-escape() {
  # quote each arg, join them with '.'
  local IFS="."
  local re="[.\"']"
  declare -a result
  while [[ -n "$1" ]]; do
    if [[ "$1" =~ $re ]]; then # shellcheck  disable=SC2076
      result+=("\"$(echo "$1" | sed 's/"/\\\"/g')\"")
    else
      result+=("$1")
    fi
    shift
  done
  echo "${result[@]}"
}

function toml-key() {
  declare -a key
  key=(`toml-escape "$@"`)
  local IFS="."
  echo "${key[*]}" # assumes all keys are quoted/space-safe
}

function toml-table() {
  echo "[$(toml-key "$@")]"
}

function toml-key-value-pair(){
  local toml_indent key value
  toml_indent="  $toml_indent"
  key="$(toml-key "$1")"
  value="$(toml-escape $2)"
  echo "$key = $value" | indent-lines
}
