#! /usr/bin/env bash
# source "./utility-fns.sh"
#------------------------- state introspection utils -------------------------#
# function __format-ls-head() {
#   cat - | awk '{print $2 " = " "\"" $1 "\""}'
# }

function ls-heads() {
  git show-ref --heads --abbrev=7 \
    | awk '{print $2 " = " "\"" $1 "\""}' \
    | sed 's#refs/heads/##'
}

function ls-tags() {
  # send "tag = $tag_value" to stdout
  git show-ref --tags --abbrev=7 \
    | awk '{print $2 " = " "\"" $1 "\""}' \
    | sed 's#refs/tags/##'
}

function ls-remotes() {
  # send "remote.$push_or_pull = $url" to stdout
  git remote -v | awk '
    {
      gsub("\(|\)", "", $3);
      print $1 "." $3 " = " "\"" $2 "\""
    }'
}

function ls-toplevel() {
  # view the state of nontrivial files in the root of .git
  # sends "$filename = $contents"
  for file in $(
    find .git -maxdepth 1 -type f \
      ! -name 'config' \
      ! -name 'description' \
      ! -name 'packed-refs' \
      ! -name 'index'
    ); do
    file_contents=$(cat)
      # ! -name 'HEAD'
    | sed 's#.git/##' # needs to cat file-contents

}

function ls-exported-vars() {
  declare -x \
    | grep -i 'git' \
    | sed 's/=/ = /'
}
