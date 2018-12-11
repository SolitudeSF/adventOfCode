import strscans

const file = "input/day15"

type Ingredient = object
    capacity, durability, flavor, texture, calories: int

const str = "$w: capacity $i, durability $i, flavor $i, texture $i, calories $i"

var ingr = newSeq[Ingredient]()
for line in file.lines:
  var
    cap, dur, flv, tex, cal: int
    name: string
  if line.scanf(str, name, cap, dur, flv, tex, cal):
    ingr &= Ingredient(capacity: cap, durability: dur,
                       flavor: flv, texture: tex, calories: cal)

func score(stats: seq[Ingredient], n: seq[int], exactCal: bool): int =
  var cap, dur, flv, tex, cal: int
  for i in 0..stats.high:
    cap += stats[i].capacity * n[i]
    dur += stats[i].durability * n[i]
    flv += stats[i].flavor * n[i]
    tex += stats[i].texture * n[i]
    cal += stats[i].calories * n[i]
  if cap < 0 or dur < 0 or flv < 0 or tex < 0 or (exactCal and cal != 500):
    0
  else:
    cap * dur * flv * tex

func bestScore(stats: seq[Ingredient], i: int, v: seq[int], n: int, exactCal: bool): int =
  if i == stats.len:
    result = score(stats, v & @[n], exactCal)
  else:
    for x in 1..n - stats.len + i:
      let s = bestScore(stats, i + 1, v & @[x], n - x, exactCal)
      if s > result: result = s

func bestScore(stats: seq[Ingredient], n: int, exactCal = false): int =
  for x in 1..n - stats.high:
    let s = bestScore(stats, 2, @[x], n - x, exactCal)
    if s > result: result = s

echo bestScore(ingr, 100)
echo bestScore(ingr, 100, true)
