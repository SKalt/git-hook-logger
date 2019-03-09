#!/usr/bin/env bash

#--------------------------------- toml utils ---------------------------------#
export toml_indent=""

function toml-indent() {
  # indent each line of STDIN
  cat - | sed "s/^/$toml_indent/"
}

function toml-escape() {
  # quote each arg if neccessary
  local IFS="."
  local re="[.\"' ]"
  declare -a result
  while [[ -n "$1" ]]; do
    if [[ "$1" =~ $re ]]; then # shellcheck  disable=SC2076
      result+=("\"${1/\"/\\\"}\"")
    else
      result+=("$1")
    fi
    shift
  done
  echo "${result[@]}"
}

function toml-key() {
  # create a string toml key with the necessary bits quoted.
  declare -a key
  key=($(toml-escape "$@"))
  local IFS="."
  echo "${key[*]}" # assumes all keys are quoted/space-safe
}

function toml-table() {
  echo "[$(toml-key "$@")]"
}

function toml-key-value-pair(){
  local toml_indent="  $toml_indent"
  local key value
  key="$(toml-key "$1")"
  value="$(toml-escape "$2")"
  echo "$key = $value" | indent-lines
}
