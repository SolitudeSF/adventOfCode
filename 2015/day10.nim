const file = "input/day10"

var input = file.readFile

func countRun(s: string): string =
  var
    c = s[0]
    n = 1
  for i in 1..s.high:
    if s[i] != c:
      result &= $n & $c
      c = s[i]
      n = 1
    else:
      inc n
  result &= $n & $c

for _ in 1..40:
  input = input.countRun

echo input.len

for _ in 1..10:
  input = input.countRun

echo input.len
