import strscans, tables, sets

const file = "input/day13"

var relations = newTable[string, TableRef[string, int]]()

for line in file.lines:
  var
    a, b, c: string
    n: int
  if line.scanf("$w would $w $i happiness units by sitting next to $w.", a, c, n, b):
    if a notin relations:
      relations[a] = newTable[string, int]()
    if c == "gain":
      relations[a][b] = n
    else:
      relations[a][b] = -n

func maxHappiness(map: TableRef[string, TableRef[string, int]],
                  guests: HashSet, first, last: string, deltaA, deltaB: int): int =
    if guests.len == 0:
      deltaA + deltaB + map[last][first] + map[first][last]
    else:
      var max = int.low
      for g in guests:
        let d = map.maxHappiness(guests - toSet([g]), first, g, map[last][g], map[g][last])
        if d > max: max = d
      deltaA + deltaB + max

func maxHappiness(map: TableRef[string, TableRef[string, int]]): int =
  result = int.low
  var guests = initSet[string]()
  for g in map.keys: guests.incl g
  for g in guests:
    let d = map.maxHappiness(guests - toSet([g]), g, g, 0, 0)
    if d > result: result = d

echo relations.maxHappiness

relations["0"] = newTable[string, int]()
for name in relations.keys:
  relations[name]["0"] = 0
  relations["0"][name] = 0

echo relations.maxHappiness
