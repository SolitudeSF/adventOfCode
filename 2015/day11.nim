const file = "input/day11"

var pass = file.readFile

proc inc(s: var string, n = s.high) =
  case s[n]
  of 'z':
    s[n] = 'a'
    if n > 0:
      inc s, n - 1
  of 'h', 'k', 'n':
    inc s[n], 2
  else:
    inc s[n]

func hasInc(s: string): bool =
  for i in 0..s.high - 2:
    if s[i].ord + 1 == s[i + 1].ord and
       s[i].ord + 2 == s[i + 2].ord:
      return true

func hasDoubles(s: string): bool =
  var
    doubles = 0
    doubleChar = '\0'
  for i in 0..<s.high:
    if s[i] == s[i + 1] and s[i] != doubleChar:
      inc doubles
      doubleChar = s[i]
      if doubles == 2:
        return true

while not (pass.hasDoubles and pass.hasInc):
  inc pass
echo pass

inc pass
while not (pass.hasDoubles and pass.hasInc):
  inc pass
echo pass
