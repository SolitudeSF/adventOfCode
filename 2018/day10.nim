import strscans

const file = "input/day10"

type
  Point = object
    x, y, xv, yv: int

var points: seq[Point]

for line in file.lines:
  var x, y, xv, yv: int
  if line.scanf("position=<$s$i,$s$i> velocity=<$s$i,$s$i>", x, y, xv, yv):
    points &= Point(x: x, y: y, xv: xv, yv: yv)

var
  maxx, maxy, minx, miny: int
  minDistY = int.high
  minDistX = int.high
  i = 0
while true:
  maxx = int.low
  maxy = int.low
  minx = int.high
  miny = int.high
  for point in points.mitems:
    point.x += point.xv
    point.y += point.yv
    if point.x < minx: minx = point.x
    if point.y < miny: miny = point.y
    if point.x > maxx: maxx = point.x
    if point.y > maxy: maxy = point.y

  if maxy - miny <= minDistY:
    minDistY = maxy - miny
    minDistX = maxx - minx
    inc i
  else:
    break

for point in points.mitems:
  point.x -= point.xv
  point.y -= point.yv
  if point.x < minx: minx = point.x
  if point.y < miny: miny = point.y
  if point.x > maxx: maxx = point.x
  if point.y > maxy: maxy = point.y

let
  width = maxx - minx + 1
  height = maxy - miny + 1

var grid = newSeq[seq[char]](height)
for i in 0..grid.high:
  grid[i] = newSeq[char](width)
  for c in grid[i].mitems:
    c = ' '

for point in points:
  grid[point.y - miny][point.x - minx] = '*'

for line in grid:
  for c in line:
    stdout.write c
  echo ""

echo i
