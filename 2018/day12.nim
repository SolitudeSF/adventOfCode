import strutils

const file = "input/day12"

# It goes absolutely downhill from here

type BiSeq[T] = object
    positive, negative: seq[T]

func isPlant(c: char): bool =
  if c == '#': true else: false
func inv(i: int): int {.inline.} = -i - 1
func `[]`[T](b: BiSeq[T], i: int): T {.inline.} =
  if i >= 0: b.positive[i] else: b.negative[i.inv]
proc `[]=`[T](b: var BiSeq[T], i: int, t: T) {.inline.} =
  if i >= 0: b.positive[i] = t else: b.negative[i.inv] = t
func high(b: BiSeq): int {.inline.} = b.positive.high
func low(b: BiSeq): int {.inline.} = b.negative.high.inv
proc append[T](b: var BiSeq[T], t: T) = b.positive.add t
proc prepend[T](b: var BiSeq[T], t: T) = b.negative.add t
func countScore(b: BiSeq[bool]): int =
  for i in b.low..b.high:
    if b[i]: result += i

let input = file.readFile.splitLines

var
  pots: BiSeq[bool]
  condEmpty, condPlant = newSeq[array[4, bool]]()

for c in input[0][15..^1]:
  pots.append c.isPlant
pots.prepend false

for line in input[2..^1]:
  var a: array[4, bool]
  if line[2] != line[^1]:
    a[0] = line[0].isPlant
    a[1] = line[1].isPlant
    a[2] = line[3].isPlant
    a[3] = line[4].isPlant
    if line[2] == '#':
      condPlant &= a
    else:
      condEmpty &= a

func nextGeneration(b: BiSeq[bool], c1, c2: seq[array[4, bool]]): BiSeq[bool] =
  var a = b
  if a[a.low + 2]:
    a.prepend false
    a.prepend false
  if a[a.high - 2]:
    a.append false
    a.append false
  result = a
  for i in a.low+2..result.high-2:
    for cond in (if a[i]: c1 else: c2):
      if a[i - 2] == cond[0] and
         a[i - 1] == cond[1] and
         a[i + 1] == cond[2] and
         a[i + 2] == cond[3]:
        result[i] = not a[i]

for i in 1..20:
  pots = pots.nextGeneration(condPlant, condEmpty)
echo pots.countScore

for i in 21..50000000000:
  let new = pots.nextGeneration(condPlant, condEmpty)
  var stable = true
  if new.positive.len > pots.positive.len:
    for i, v in pots.positive:
      if new.positive[i + 1] != v:
        stable = false
        break
    if stable:
      var n = 0
      for i in pots.positive:
        if i: inc n
      echo new.countScore + (n * (50000000000 - i))
      break
  pots = new
