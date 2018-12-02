import intsets, strutils

const file = "input/day1"

block part1:
  var sum = 0

  for line in file.lines:
    sum += line.parseInt

  echo sum

block part2:
  var
    sum = 0
    sums = initIntSet()
    input: seq[int]

  for line in file.lines:
    input &= line.parseInt

  sums.incl 0
  while true:
    for num in input:
      sum += num
      if sum in sums:
        echo sum
        break part2
      else: sums.incl sum
