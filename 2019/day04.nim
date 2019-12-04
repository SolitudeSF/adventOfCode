const file = "input/day04"

type Number = array[6, int]

func parseNumber(s: string): Number =
  for i in Number.low..Number.high:
    result[i] = s[i].ord - '0'.ord

func hasDouble(n: Number): bool =
  for i in 0..Number.len - 2:
    if n[i] == n[i + 1]:
      return true

func hasDoubleStrict(n: Number): bool =
  const high = Number.len - 2
  for i in 0..high:
    if n[i] == n[i + 1] and (i == high or n[i] != n[i + 2]) and (i == 0 or n[i] != n[i - 1]):
      return true

func isIncreasing(n: Number): bool =
  for i in 0..Number.len - 2:
    if n[i] > n[i + 1]:
      return false
  true

func normalize(n: var Number) =
  for i in countdown(Number.high, Number.low + 1):
    if n[i] > 9:
      n[i] -= 10
      n[i - 1] += 1

func inc(n: var Number) =
  inc n[^1]
  normalize n

iterator range(a, b: Number): Number =
  var r = a
  while r != b:
    inc r
    yield r

let
  input = file.readFile
  a = input[0..5].parseNumber
  b = input[7..12].parseNumber

var res1, res2: int
for number in range(a, b):
  if number.isIncreasing:
    if number.hasDouble: inc res1
    if number.hasDoubleStrict: inc res2

echo res1
echo res2
