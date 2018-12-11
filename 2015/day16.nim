import strscans, tables

const file = "input/day16"

const known = [("children", 3), ("cats", 7), ("samoyeds", 2), ("pomeranians", 3),
               ("akitas", 0), ("vizslas", 0), ("goldfish", 5), ("trees", 3),
               ("cars", 2), ("perfumes", 1)].toTable
var aunts: array[1..500, Table[string, int]]
for line in file.lines:
  var
    i, n1, n2, n3: int
    t1, t2, t3: string
  if line.scanf("Sue $i: $w: $i, $w: $i, $w: $i", i, t1, n1, t2, n2, t3, n3):
    aunts[i] = initTable[string, int]()
    aunts[i][t1] = n1
    aunts[i][t2] = n2
    aunts[i][t3] = n3

for n, a in aunts:
  var i = 0
  for key in a.keys:
    if a[key] == known[key]:
      inc i
  if i == 3:
    echo n
    break

for n, a in aunts:
  var i = 0
  for key in a.keys:
    case key
    of "cats", "trees":
      if a[key] > known[key]:
        inc i
    of "pomeranians", "goldfish":
      if a[key] < known[key]:
        inc i
    else:
      if a[key] == known[key]:
        inc i
  if i == 3:
    echo n
    break
