import sets, tables, math, strutils, algorithm

const file = "input/day10"

const eps = 0.000000000000001

type
  Vector = tuple[x, y: float]

func len(v: Vector): float =
  sqrt(v.x * v.x + v.y * v.y)

func normalized(v: Vector): Vector =
  let len = v.len
  (v.x / len, v.y / len)

func `-`(a, b: Vector): Vector =
  (a.x - b.x, a.y - b.y)

func `~=`(a, b: Vector): bool =
  abs(a.x - b.x) < eps and abs(a.y - b.y) < eps

func normalize(s: var HashSet[Vector]) =
  for a in s:
    for b in s:
      if a != b:
        if a ~= b:
          s.excl b

func parseMap(s: string): seq[Vector] =
  var x, y: float
  for c in s:
    case c
    of '#':
      result.add (x, y)
      x += 1
    of '\n':
      x = 0
      y += 1
    else:
      x += 1

func addApprox(dirs: var Table[Vector, seq[Vector]], dir, asteroid: Vector) =
  for d in dirs.keys:
    if dir ~= d:
      dirs[d].add asteroid
      return
  dirs.add dir, @[asteroid]

func quadrant(v: Vector): int =
  if v.x >= 0 and v.y < 0: 1
  elif v.x > 0 and v.y >= 0: 2
  elif v.x <= 0 and v.y >= 0: 3
  else: 4

func cmpClockwise(a, b: Vector): int =
  let quadA = quadrant a
  let quadB = quadrant b
  if quadA < quadB: -1
  elif quadA > quadB: 1
  else:
    let tgA = a.x / -a.y
    let tgB = b.x / -b.y
    if tgA < tgB: -1
    elif tgA > tgB: 1
    else: 0

var
  asteroids = file.readFile.strip.parseMap
  maxSeen = 0
  laser: Vector

for a in asteroids:
  var dirs = initHashSet[Vector]()
  for b in asteroids:
    if b != a:
      let dir = normalized(b - a)
      if dir notin dirs:
        dirs.incl dir

  normalize dirs

  if dirs.card > maxSeen:
    maxSeen = dirs.card
    laser = a

echo maxSeen

var targets: Table[Vector, seq[Vector]]
for a in asteroids:
  if a != laser:
    let dir = normalized(a - laser)
    targets.addApprox dir, a

proc cmpDist(a, b: Vector): int =
  if len(a - laser) < len(b - laser): -1 else: 1

var dirs: seq[Vector]
for dir in targets.keys:
  dirs.add dir
  sort targets[dir], cmpDist

sort dirs, cmpClockwise

var count = 0
while targets.len > 0:
  for dir in dirs:
    if dir in targets:
      if count == 199:
        let res = targets[dir][0]
        echo res.x.int * 100 + res.y.int
        quit 0
      else:
        inc count
        targets[dir].delete 0
        if targets[dir].len == 0:
          targets.del dir
