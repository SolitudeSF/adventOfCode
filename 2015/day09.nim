import tables, sets, strscans

const file = "input/day09"

var distances = newTable[string, TableRef[string, int]](8)

for line in file.lines:
  var
    a, b: string
    d: int
  if line.scanf("$w to $w = $i", a, b, d):
    if a notin distances: distances[a] = newTable[string, int](8)
    if b notin distances: distances[b] = newTable[string, int](8)
    distances[a][b] = d
    distances[b][a] = d

func extrDistance(map: TableRef[string, TableRef[string, int]],
                  to: HashSet, a: string, at: int): (int, int) =
  if to.len == 0:
    (at, at)
  else:
    var
      max = int.low
      min = int.high
    for c in to:
      let d = map.extrDistance(to - toSet([c]), c, map[a][c])
      if d[0] < min: min = d[0]
      if d[1] > max: max = d[1]
    (at + min, at + max)

func extrDistance(map: TableRef[string, TableRef[string, int]]): (int, int) =
  result = (int.high, int.low)
  var cities = initSet[string]()
  for c in map.keys: cities.incl c
  for c in cities:
    let d = map.extrDistance(cities - toSet([c]), c, 0)
    if d[0] < result[0]: result[0] = d[0]
    if d[1] > result[1]: result[1] = d[1]

var (min, max) = extrDistance(distances)

echo min
echo max
