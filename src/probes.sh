#!/usr/bin/env bash

# shellcheck source=src/state-introspection-utils.sh
. './state-introspection-utils.sh'
# shellcheck source=src/toml-utils.sh
. './toml-utils.sh'

function experiment-table () {
  # global experiment_name
  toml-table "$experiment_name" "$@"
}

function make-probe() {
  local toml_indent="  $toml_indent"
  callback=$1; shift;
  {
    experiment-table "$callback"; # gets the function name of the callback
    $callback "$@" | toml-indent
  } | toml-indent;
}

function probe-args() { # scipt args are passed in
  local toml_indent="  $toml_indent"
  local IFS=', '
  declare -a escaped
  escaped=toml-escape "$@"
  echo "args = [ ${escaped[*]} ]" | toml-indent;
}

function log-hookname() {
  local toml_indent="  $toml_indent"
  echo "hook = \"$hookname\"" | toml-indent
}
