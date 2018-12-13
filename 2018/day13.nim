import algorithm

const file = "input/day13"

type
  Direction = enum
    North, West, South, East
  Turn = enum
    Left, Straight, Right
  Track = enum
    Empty, Vertical, Horizontal, Intersection, DownRight, UpLeft
  Cart = object
    x, y: int
    dir: Direction
    turn: Turn

var
  carts = newSeq[Cart]()
  tracks = newSeq[seq[Track]]()

proc cornerTurn(dir: var Direction, turn: Turn) =
  case turn
  of Left:
    if dir == North:
      dir = East
    else:
      dec dir
  of Right:
    if dir == East:
      dir = North
    else:
      inc dir
  of Straight:
    discard

proc intersectionTurn(dir: var Direction, turn: var Turn) =
  case turn
  of Left:
    turn = Straight
    if dir == North:
      dir = East
    else:
      dec dir
  of Right:
    turn = Left
    if dir == East:
      dir = North
    else:
      inc dir
  of Straight:
    turn = Right

proc advance(c: var Cart) =
  case c.dir
  of North: dec c.y
  of West:  inc c.x
  of South: inc c.y
  of East:  dec c.x

proc move(c: var Cart, t: seq[seq[Track]]) =
  case t[c.y][c.x]
  of Intersection: c.dir.intersectionTurn c.turn
  of DownRight:
    case c.dir
    of North, South: c.dir.cornerTurn Right
    of West, East:   c.dir.cornerTurn Left
  of UpLeft:
    case c.dir
    of North, South: c.dir.cornerTurn Left
    of West, East:   c.dir.cornerTurn Right
  else: discard
  advance c


func cmp(a, b: Cart): int =
  if   a.y > b.y: result =  1
  elif a.y < b.y: result = -1
  elif a.x > b.x: result =  1
  elif a.x < b.x: result = -1

proc sort(c: var seq[Cart]) = c.sort cmp

func hasCollisions(carts: seq[Cart], i: int): bool =
  for j in 0..carts.high:
    if j != i and carts[i].x == carts[j].x and carts[i].y == carts[j].y:
        return true

proc removeCollisions(carts: var seq[Cart], i: int): bool =
  let
    x = carts[i].x
    y = carts[i].y
  var n = 0
  while n < carts.len:
    if n != i and x == carts[n].x and y == carts[n].y:
      result = n < i
      break
    else:
      inc n
  if result:
    carts.delete i
    carts.delete n
  else:
    carts.delete n
    carts.delete i

for line in file.lines:
  tracks &= newSeq[Track]()
  for tile in line:
    case tile
    of '-':
      tracks[^1] &= Horizontal
    of '|':
      tracks[^1] &= Vertical
    of '+':
      tracks[^1] &= Intersection
    of '/':
      tracks[^1] &= DownRight
    of '\\':
      tracks[^1] &= UpLeft
    of '^':
      tracks[^1] &= Vertical
      carts &= Cart(dir: North, x: tracks[^1].high, y: tracks.high)
    of '>':
      tracks[^1] &= Horizontal
      carts &= Cart(dir: West, x: tracks[^1].high, y: tracks.high)
    of 'v':
      tracks[^1] &= Vertical
      carts &= Cart(dir: South, x: tracks[^1].high, y: tracks.high)
    of '<':
      tracks[^1] &= Horizontal
      carts &= Cart(dir: East, x: tracks[^1].high, y: tracks.high)
    else:
      tracks[^1] &= Empty

block part1:
  var carts = carts
  while true:
    carts.sort
    for i in 0..carts.high:
      carts[i].move tracks
      if carts.hasCollisions(i):
        echo carts[i].x, ",", carts[i].y
        break part1

block part2:
  while carts.len > 1:
    var i = 0
    carts.sort
    while i < carts.len:
      carts[i].move tracks
      if carts.hasCollisions(i):
        if carts.removeCollisions i:
          dec i
      else:
        inc i
  echo carts[0].x, ",", carts[0].y
