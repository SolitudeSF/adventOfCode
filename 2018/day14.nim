import strutils

const file = "input/day14"

proc move(i: var int, s: seq[int8]) =
  i = (i + s[i] + 1) mod s.len

proc combine(s: var seq[int8], a, b: int) =
  let sum = s[a] + s[b]
  if sum < 10:
    s &= sum
  else:
    s &= 1
    s &= sum - 10

let num = file.readFile

block part1:
  let num = num.parseInt
  var
    scores = @[3'i8, 7]
    e1 = 0
    e2 = 1

  while scores.len <= num + 10:
    scores.combine e1, e2
    e1.move scores
    e2.move scores

  for c in scores[num..num + 9]:
    stdout.write $c
  echo ""

block part2:
  var
    s: seq[int8]
    scores = @[3'i8, 7]
    e1 = 0
    e2 = 1

  for c in num:
    s &= c.`$`.parseInt.int8

  while true:
    let l = scores.len
    scores.combine e1, e2
    let k = 1 - (scores.len - l) mod 2
    if scores.len > s.len and scores[^(s.len + k)..^(1 + k)] == s:
      echo scores.len - s.len - k
      break
    e1.move scores
    e2.move scores
