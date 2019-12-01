import strutils

const file = "input/day01"

block:
  var fuel = 0
  for line in file.lines:
    fuel += line.parseInt div 3 - 2
  echo fuel

block:
  var fuel = 0
  for line in file.lines:
    var t = line.parseInt div 3 - 2
    while t > 0:
      fuel += t
      t = t div 3 - 2
  echo fuel
