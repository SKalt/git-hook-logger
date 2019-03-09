#!/usr/bin/env bash
# pwd should already include ./
# global experiment_name
. 'state-introspection-utils.sh'
. 'toml-utils.sh'
function experiment-table () {
  echo "$(toml-table "$experiment_name" "$@")"
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
  escaped=$(toml-escape "$@")
  echo "args = [ ${escaped[*]} ]" | toml-indent;
}

function log-hookname() {
  local toml_indent="  $toml_indent"
  echo "hook = \"$hookname\"" | toml-indent
}
