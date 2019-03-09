#! /usr/bin/env bash
DIR="${BASH_SOURCE[0]%/*}"
source "$DIR/../init.sh" "simple-commit"
main
# steps to reproduce your desired state
touch "$DIR/sandbox/foo.txt"
git add "$DIR/sandbox/foo.txt"
git commit -m 'test commit please ignore'
rm $DIR/../.git/hooks/*
git rm "$DIR/sandbox/foo.txt"
git commit -m "also to be ignored"
