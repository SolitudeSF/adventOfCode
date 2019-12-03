import strutils

const file = "input/day03"

type
  Orientation = enum
    Vertical, Horizontal
  Vector = tuple[x, y: int]
  Segment = tuple[a, b: Vector]
  Wire = seq[Segment]

func dist(a, b: Vector): int = abs(a.x - b.x) + abs(a.y - b.y)

func length(v: Segment): int = dist(v.a, v.b)

func orientation(s: Segment): Orientation =
  if s.a.x == s.b.x: Vertical else: Horizontal

func isBetween(x, a, b: int): bool =
  (x <= a and x >= b) or (x >= a and x <= b)

func isIntersecting(a, b: Segment): bool =
  a.orientation != b.orientation and (
    case a.orientation
    of Vertical:
      a.a.x.isBetween(b.a.x, b.b.x) and b.a.y.isBetween(a.a.y, a.b.y)
    of Horizontal:
      b.a.x.isBetween(a.a.x, a.b.x) and a.a.y.isBetween(b.a.y, b.b.y)
  )

func intersection(a, b: Segment): Vector =
  case a.orientation
  of Vertical:
    (a.a.x, b.a.y)
  of Horizontal:
    (b.a.x, a.a.y)

func parseWire(s: string): Wire =
  var a, b: Vector
  for seg in s.split(','):
    let
      dir = seg[0]
      length = seg[1..^1].parseInt
    b = case dir
      of 'U': (a.x, a.y + length)
      of 'D': (a.x, a.y - length)
      of 'R': (a.x + length, a.y)
      of 'L': (a.x - length, a.y)
      else: raise newException(CatchableError, "Cringe")
    result.add (a, b)
    a = b

var wires = newSeqOfCap[Wire](2)

for line in file.lines:
  wires.add line.parseWire

# Here comes bit of bullshit for little optimization
var
  offset = if wires[0][0].orientation == wires[1][0].orientation: 1 else: 0
  mindist = int.high
  minsumdist = int.high
  w1dist = 0

for w1 in wires[0]:
  var w2prev = (0, 0)
  var w2dist = 0
  for i in countup(offset, wires[1].high, 2):
    let w2 = wires[1][i]
    if (w1 != wires[0][0] or w2 != wires[1][0]) and w1.isIntersecting w2:
      let
        inter = intersection(w1, w2)
        dist = inter.dist (0, 0)
        sumdist = w1dist + dist(w1.a, inter) + w2dist + dist(w2prev, inter)
      if dist < mindist:
        mindist = dist
      if sumdist < minsumdist:
        minsumdist = sumdist

    w2dist += dist(w2prev, w2.b)
    w2prev = w2.b

  w1dist += w1.length
  offset = if offset == 1: 0 else: 1

echo mindist
echo minsumdist
