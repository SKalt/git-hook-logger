#--------------------------------- toml utils ---------------------------------#
toml_indent=""
toml_key=$EXPERIMENT_NAME # in branch? $(git rev-parse --abbrev-ref)
# function join_by { local IFS="$1"; shift; echo "$*"; }

function toml-indent() {
  # indent each line of STDIN
  cat - | sed "s/^/$toml_indent/"
}

# function stdin-or-arg() {
#   local input="$1"; if [ -z "$input" ]; then input="$(cat -)"; fi
#   echo "$input"
# }
# stdin-or-arg "foo"
# echo "bar" | stdin-or-arg
function toml-key() {
  local IFS="."
  shift
  echo "$toml_indent[$*]" # assumes all keys are quoted/space-safe
}


function toml-key-value-pair(){
  local toml_indent="  $toml_indent"
  local key="$(escape-quotes $1)"
  local value="$(escape-quotes $2)"
  echo "$key = $value" | indent-lines
}
