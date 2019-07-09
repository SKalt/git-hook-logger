#! /usr/bin/env bash
root=$(git rev-parse --show-toplevel)
git_dir="$(git rev-parse --git-dir)"
hooks_dir="$root/$git_dir/hooks"
experiment_name="$1"

hooks=(
  "applypatch-msg" "pre-applypatch" "post-applypatch" "pre-commit"
  "prepare-commit-msg" "commit-msg" "post-commit" "pre-rebase" "post-checkout"
  "post-merge" "pre-push" "pre-receive" "update" "post-receive" "post-update"
  "push-to-checkout" "pre-auto-gc" "post-rewrite" "sendemail-validate"
  "fsmonitor-watchman" "p4-pre-submit"
)

header='#! /usr/bin/env bash
PATH=$PATH:$(pwd)/src
. probes.sh
'
body="
log_file=$root/git-hooks.log
experiment_name=\"$experiment_name\""
footer='{
  echo "[$(experiment-table)]"
  log-hookname;
  probe-args;
  make-probe heads
  make-probe tags
  make-probe remotes;
  make-probe toplevel
  make-probe exported-vars
} >> $log_file
'

function make-logger() {
  local hook=$1
  local hook_file="$hooks_dir/$hook"
  {
    echo "$header";
    echo "$body";
    echo "hookname='$hook'";
    echo "$footer"
  } > $hook_file
  chmod +x $hook_file
  echo $hook
}

function main() {
  rm $hooks_dir/*
  for hook in "${hooks[@]}"; do
    make-logger $hook;
  done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then main; fi
