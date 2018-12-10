import strutils, math

const file = "input/day06"

type
  State = enum
    Empty, Contested, Taken, Checking, Neutral

var xs, ys: seq[int]

for line in file.lines:
  let splits = line.split(", ", 1)
  xs &= splits[0].parseInt
  ys &= splits[1].parseInt

var
  maxx = int.low
  maxy = int.low
  minx = int.high
  miny = int.high

for i in 0..xs.high:
  if minx > xs[i]:
    minx = xs[i]
  elif maxx < xs[i]:
    maxx = xs[i]
  if miny > ys[i]:
    miny = ys[i]
  elif maxy < ys[i]:
    maxy = ys[i]

let
  width = maxx - minx + 1
  height = maxy - miny + 1
var
  grid = newSeq[seq[int8]](height)
  state = newSeq[seq[State]](height)
for i in 0..grid.high:
  grid[i] = newSeq[int8](width)
  state[i] = newSeq[State](width)

for i in 0..xs.high:
  xs[i] -= minx
  ys[i] -= miny
  grid[ys[i]][xs[i]] = i.int8 + 1
  state[ys[i]][xs[i]] = Checking

template checkFor(y, x: int, i: int8): untyped =
  case state[y][x]
  of Empty:
    state[y][x] = Contested
    grid[y][x] = i
  of Contested:
    if i != grid[y][x]:
      state[y][x] = Neutral
      grid[y][x] = 0
  else: discard

let maxDim = if width > height: width else: height

for i in 0..<maxDim:
  for x in 0..<width:
    for y in 0..<height:
      let tag = grid[y][x]
      if state[y][x] == Checking:
        state[y][x] = Taken
        if x > 0:
          checkFor(y, x - 1, tag)
        if x < width - 1:
          checkFor(y, x + 1, tag)
        if y > 0:
          checkFor(y - 1, x, tag)
        if y < height - 1:
          checkFor(y + 1, x, tag)

  for x in 0..<width:
    for y in 0..<height:
      if state[y][x] == Contested:
        state[y][x] = Checking

var
  count = newSeq[int](xs.len)
  safe = 0
for x in 0..<width:
  for y in 0..<height:
    var sum = 0
    for i in 0..xs.high:
      sum += abs(y - ys[i]) + abs(x - xs[i])
    if sum < 10_000:
      inc safe

    let tag = grid[y][x] - 1
    if tag != -1:
      if x == 0 or y == 0 or x == width - 1 or y == height - 1:
        count[tag] = -1
      elif count[tag] != -1:
        inc count[tag]

var max = 0
for i in count:
  if i > max:
    max = i

echo max
echo safe
