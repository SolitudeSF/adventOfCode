const file = "input/day08"

func parseLine(s: string): int =
  result = 2
  var i = 1
  while i < s.high:
    if s[i] == '\\':
      case s[i+1]
      of '\\', '"':
        inc i
        inc result
      of 'x':
        inc result, 3
        inc i, 3
      else: discard
    inc i

func encode(s: string): int =
  result = 2
  for c in s:
    if c == '\\' or c == '"':
      inc result
  debugecho result, s

var decrease, increase = 0
for line in file.lines:
  decrease += line.parseLine
  increase += line.encode

echo decrease
echo increase
