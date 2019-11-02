#! /usr/bin/env bash
#------------------------- state introspection utils -------------------------#
# function __format-ls-head() {
#   cat - | awk '{print $2 " = " "\"" $1 "\""}'
# }

function heads() {
  git show-ref --heads --abbrev=7 \
    | awk '{print $2 " = " "\"" $1 "\""}' \
    | sed 's#refs/heads/##'
}

function tags() {
  # send "tag = $tag_value" to stdout
  git show-ref --tags --abbrev=7 \
    | awk '{print $2 " = " "\"" $1 "\""}' \
    | sed 's#refs/tags/##'
}

function remotes() {
  # send "remote.$push_or_pull = '$url'" to stdout
  git remote -v | awk '
    {
      gsub("\(|\)", "", $3);
      print $1 "." $3 " = " "\"" $2 "\""
    }'
}

function ls-file () {
  local name contents
  name="${1//.git/}"
  contents="$(cat "$1")"
  echo "$name" " = " '"""' "$contents" '"""'
}

function toplevel() {
  # view the state of nontrivial files in the root of .git
  # sends "$filename = $contents"
  find .git -maxdepth 1 -type f \
      ! -name 'config' \
      ! -name 'description' \
      ! -name 'packed-refs' \
      ! -name 'index' \
      | while read -r name; do
          ls-file "$name"
        done
}

function exported-vars() {
  declare -x \
    | grep -i 'git' \
    | grep -v 'PWD' \
    | grep -v 'PATH' \
    | sed 's/EMAIL = "([^"]*)"/EMAIL = "###@###.###"/i' \
    | sed 's/^declare -x //' \
    | sed 's/=/ = /'
}
