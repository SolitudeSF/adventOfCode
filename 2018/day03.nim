import strscans

const file = "input/day03"

type
  Rect = object
    x, y, w, h: int

var
  fabric: array[1000, array[1000, int8]]
  rects = newSeq[Rect](1280)

for line in file.lines:
  var id, x, y, w, h: int
  if scanf(line, "#$i @ $i,$i: $ix$i", id, x, y, w, h):
    rects[id - 1] = Rect(x: x, y: y, w: w, h: h)
    for i in x..<x+w:
      for j in y..<y+h:
        inc fabric[i-1][j]

block part1:
  var overlapped = 0
  for i in 0..fabric.high:
    for j in 0..fabric[0].high:
      if (fabric[i][j] > 1):
        inc overlapped

  echo overlapped

block part2:
  for i, rect in rects:
    var intact = true
    for i in rect.x..<rect.x+rect.w:
      for j in rect.y..<rect.y+rect.h:
        if fabric[i-1][j] > 1:
          intact = false
          break
      if not intact: break
    if intact:
      echo i + 1
      break part2
