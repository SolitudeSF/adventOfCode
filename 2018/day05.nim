import strutils

const file = "input/day05"

let input = file.readFile.strip

func isReplacement(a, b: char): bool =
  (a == toLowerAscii(b) and isUpperAscii(b) and isLowerAscii(a)) or
    (a == toUpperAscii(b) and isLowerAscii(b) and isUpperAscii(a))

func reacted(s: string): string =
  result = s
  var l = s.len
  for i in countdown(s.high, 1):
    if isReplacement(result[i], result[i-1]):
      for x in i + 1..<l:
        result[x - 2] = result[x]
      dec l, 2
  result.setLen l

echo input.reacted.len

func withoutUnit(s: string, c: char): string =
  result = newString(s.len)
  var i = 0
  for a in s:
    if a != c and a != c.toUpperAscii:
      result[i] = a
      inc i
  result.setLen i

var min = input.len
for a in 'a'..'z':
  let l = input.withoutUnit(a).reacted.len
  if l < min:
    min = l

echo min
