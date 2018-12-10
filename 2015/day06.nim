import strutils, sequtils, nre

const file = "input/day06"

var
  grid1 = newSeqWith(1000, newSeqWith(1000, false))
  grid2 = newSeqWith(1000, newSeqWith(1000, 0))
  lit, bright = 0

for line in file.lines:
  let
    tokens = line.find(re"(\w+(\s\w+)?)\s(\d+),(\d+)\s\w+\s(\d+),(\d+)").get.captures
    act = tokens[0]
    x1 = tokens[2].parseInt
    y1 = tokens[3].parseInt
    x2 = tokens[4].parseInt
    y2 = tokens[5].parseInt

  case act:
    of "turn off":
      for x in x1..x2:
        for y in y1..y2:
          grid1[x][y] = false
          dec grid2[x][y]
          if grid2[x][y] < 0: grid2[x][y] = 0
    of "turn on":
      for x in x1..x2:
        for y in y1..y2:
          grid1[x][y] = true
          inc grid2[x][y]
    of "toggle":
      for x in x1..x2:
        for y in y1..y2:
          grid1[x][y] = not grid1[x][y]
          grid2[x][y] += 2

for x in 0..999:
  for y in 0..999:
    if grid1[x][y]: inc lit
    bright += grid2[x][y]

echo lit
echo bright
