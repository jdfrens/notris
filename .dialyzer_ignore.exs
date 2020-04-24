# to get the proper short format:
#
# $ MIX_ENV=test mix dialyzer --format short
#
[
  # dialyzer doesn't seem to trust the type of the keys of a map with Enum.reduce/3
  {"lib/notris/bottom.ex", :call, 60}
]
