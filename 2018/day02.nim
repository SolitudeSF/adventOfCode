import tables, strutils

const file = "input/day02"
let lines = file.readFile.strip.splitLines

block part1:
  var
    two = 0
    three = 0
  for line in lines:
    let count = line.toCountTable
    var
      need2 = true
      need3 = true
    for k in count.keys:
      if need3 and count[k] == 3:
        need3 = false
        inc three
      elif need2 and count[k] == 2:
        need2 = false
        inc two

  echo two * three

block part2:

  func dist(a, b: string): int =
    for i in 0..a.high:
      if a[i] != b[i]:
        inc result

  func same(a, b: string): string =
    for i in 0..a.high:
      if a[i] == b[i]:
        result &= a[i]

  for i in 0..<lines.high:
    for j in i+1..lines.high:
      if dist(lines[i], lines[j]) == 1:
        echo same(lines[i], lines[j])
        break part2
