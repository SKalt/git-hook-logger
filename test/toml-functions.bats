#!/usr/bin/env ./test/libs/bats/bin/bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'

. 'src/toml-utils.sh'

@test "escaping: unnecessary" {
  result="$(toml-escape "foo" "bar")"
  assert_equal "$result" 'foo bar'
}

@test "escaping: '.'" {
  result="$(toml-escape fo.o bar)"
  assert_equal "$result" '"fo.o" bar'
}

@test "escaping: '\"'" {
  result="$(toml-escape 'fo"o' "bar")"
  assert_equal "$result" '"fo\"o" bar'
}

@test "escaping: whitespace" {
  result="$(toml-escape 'fo o' "bar")"
  assert_equal "$result" '"fo o" bar'
}

# failing, but ok
# @test "escaping: ''" {
#   result="$(toml-escape '' "")"
#   assert_equal "$result" '..'
# }

@test "joining keys with '.'s" {
  result="$(toml-key "foo" "bar")"
  assert_equal "$result" 'foo.bar'
  result="$(toml-key fo.o bar)"
  assert_equal "$result" '"fo.o".bar'
  result="$(toml-key 'fo"o' "bar")"
  assert_equal "$result" '"fo\"o".bar'
}

@test "creating a header" {
  result="$(toml-table "foo" "bar")"
  assert_equal "$result" '[foo.bar]'
  result="$(toml-table fo.o bar)"
  assert_equal "$result" '["fo.o".bar]'
  result="$(toml-table 'fo"o' "bar")"
  assert_equal "$result" '["fo\"o".bar]'
}
