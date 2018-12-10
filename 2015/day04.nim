import md5, strutils

const file = "input/day04"

let input = file.readFile

block part1:
  var counter = 1
  while not (input & $counter).toMD5.`$`.startsWith("00000"):
    inc counter
  echo counter

block part2:
  var counter = 1
  while not (input & $counter).toMD5.`$`.startsWith("000000"):
    inc counter
  echo counter
