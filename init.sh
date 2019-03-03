#! /usr/bin/env bash
git_dir="$(git rev-parse --git-dir)"
hooks_dir="$git_dir/hooks"
hooks=(
  "applypatch-msg" "pre-applypatch" "post-applypatch" "pre-commit"
  "prepare-commit-msg" "commit-msg" "post-commit" "pre-rebase" "post-checkout"
  "post-merge" "pre-push" "pre-receive" "update" "post-receive" "post-update"
  "push-to-checkout" "pre-auto-gc" "post-rewrite" "sendemail-validate"
  "fsmonitor-watchman" "p4-pre-submit"
)

make-logger() {
  local hook=$1
  local hook_file="$hooks_dir/$hook"
  cat << EOF | sed 's/^    //' > $hook_file
    #! /usr/bin/env bash
    echo "$hook"
    # ls-heads::in-dir
    # ls-refs/**/*
    # ls-vars
    declare | grep -i 'git'
EOF
  chmod +x $hook_file
  echo $hook_file
}

main() {
  rm $hooks_dir/*
  for hook in "${hooks[@]}"; do
    make-logger $hook;
  done
}
main
