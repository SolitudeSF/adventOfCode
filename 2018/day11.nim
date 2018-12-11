import strutils

const file = "input/day11"

let serial = file.readFile.parseInt

var grid: array[1..300, array[1..300, int]]

for y in 1..300:
  for x in 1..300:
    grid[y][x] = ((((x + 10) * y) + serial) * (x + 10)) mod 1000 div 100 - 5

block part1:
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

block part2:
  var
    sums: array[1..300, array[1..300, int]]
    max, maxX, maxY, maxSize = 0
  for n in 0..299:
    for y in 1..300 - n:
      for x in 1..300 - n:
        sums[y][x] += grid[y + n][x + n]
        if n > 1:
          for i in 0..<n:
            sums[y][x] += grid[y + n][x + i] + grid[y + i][x + n]
        if sums[y][x] > max:
          max = sums[y][x]
          maxSize = n + 1
          maxX = x
          maxY = y

  echo maxX, ",", maxY, ",", maxSize
