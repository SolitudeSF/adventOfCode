import sets

const file = "input/day03"

let input = file.readFile

type Point = tuple[x, y: int]

block part1:
  var
    x, y = 0
    visited = initSet[Point]()

  for d in input:
    case d:
      of '>': inc x
      of '<': dec x
      of '^': inc y
      of 'v': dec y
      else: discard
    visited.incl (x, y)
  echo visited.len

block part2:
  var
    x1, x2, y1, y2 = 0
    turn = true
    visited = initSet[Point]()

  for d in input:
    if turn:
      case d:
        of '>': inc x1
        of '<': dec x1
        of '^': inc y1
        of 'v': dec y1
        else: discard
      visited.incl (x1,y1)
    else:
      case d:
        of '>': inc x2
        of '<': dec x2
        of '^': inc y2
        of 'v': dec y2
        else: discard
      visited.incl (x2,y2)
    turn = not turn
  echo visited.len
