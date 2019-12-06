import tables

const file = "input/day06"

type
  Id = array[3, char]
  Body = object
    children: seq[Id]
    orbits: int
    parent: Id

func toId(s: string): Id =
  copyMem addr result[0], unsafeAddr s[0], sizeof Id

func propagateOrbits(orbits: var Table[Id, Body], id: Id) =
  for child in orbits[id].children:
    orbits[child].orbits = orbits[id].orbits + 1
    orbits.propagateOrbits child

func countOrbits(orbits: Table[Id, Body]): int =
  for _, body in orbits:
    result += body.orbits

func parents(orbits: Table[Id, Body], id: Id): seq[Id] =
  let parent = orbits[id].parent
  result.add parent
  if parent != ['C', 'O', 'M']:
    result.add orbits.parents parent

func findPath(orbits: Table[Id, Body], a, b: Id): int =
  let
    parentsA = orbits.parents a
    parentsB = orbits.parents b
  var pathA: int
  for pA in parentsA:
    var pathB: int
    for pB in parentsB:
      if pA == pB:
        return pathA + pathB
      inc pathB
    inc pathA

var orbits = initTable[Id, Body](2048)

for line in file.lines:
  let
    parent = line[0..2].toId
    child = line[4..6].toId
  if parent notin orbits:
    orbits.add parent, Body(children: @[child])
  else:
    orbits[parent].children.add child
  if child notin orbits:
    orbits.add child, Body(parent: parent)
  else:
    orbits[child].parent = parent

orbits.propagateOrbits "COM".toId

echo orbits.countOrbits

echo orbits.findPath("YOU".toId, "SAN".toId)
