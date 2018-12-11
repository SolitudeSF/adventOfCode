import strutils

const file = "input/day11"

let serial = file.readFile.parseInt

var grid: array[1..300, array[1..300, int]]

for y in 1..300:
  for x in 1..300:
    grid[y][x] = ((((x + 10) * y) + serial) * (x + 10)) mod 1000 div 100 - 5

var max, maxX, maxY = 0
for y in 1..298:
  for x in 1..298:
    var sum = 0
    for i in y..y+2:
      for j in x..x+2:
        sum += grid[i][j]
    if sum > max:
      max = sum
      maxX = x
      maxY = y

echo maxX, ",", maxY

max = 0
var maxSize = 0
for n in 1..300:
  for y in 1..301 - n:
    for x in 1..301 - n:
      var sum = 0
      for i in y..<y + n:
        for j in x..<x + n:
          sum += grid[i][j]
      if sum > max:
        max = sum
        maxSize = n
        maxX = x
        maxY = y

echo maxX, ",", maxY, ",", maxSize
