#! /usr/bin/env bash
root=$(git rev-parse --show-toplevel)
git_dir="$(git rev-parse --git-dir)"
hooks_dir="$git_dir/hooks"

hooks=(
  "applypatch-msg" "pre-applypatch" "post-applypatch" "pre-commit"
  "prepare-commit-msg" "commit-msg" "post-commit" "pre-rebase" "post-checkout"
  "post-merge" "pre-push" "pre-receive" "update" "post-receive" "post-update"
  "push-to-checkout" "pre-auto-gc" "post-rewrite" "sendemail-validate"
  "fsmonitor-watchman" "p4-pre-submit"
)

function make-logger() {
  local hook=$1
  local hook_file="$hooks_dir/$hook"
  cat $root/src/utility-fns.sh          >> $hook_file
  cat $root/src/toml-utils.sh           >> $hook_file
  cat $root/src/state-introspection.sh  >> $hook_file
  chmod +x $hook_file
  echo $hook_file
}

function main() {
  rm $hooks_dir/*
  for hook in "${hooks[@]}"; do
    make-logger $hook;
  done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then main; fi
