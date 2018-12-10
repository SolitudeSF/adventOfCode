import strutils, sequtils

const file = "input/day05"

let input = file.readFile.splitLines

func hasDouble(s: string): bool =
  for i in 1..s.high:
    if s[i] == s[i - 1]: return true

func hasVowels(s: string): bool =
  var count = 0
  for c in s:
    if c in "aeiou": inc count
    if count == 3: return true

func isCompliant(s: string): bool =
  not (s.contains("ab") or s.contains("cd") or s.contains("pq") or s.contains("xy"))

func hasPair(s: string): bool =
  var pairs = newSeq[string]()
  for i in 1..s.high:
    pairs.add s[i - 1] & s[i]
  for i in 0..pairs.high:
    for j in i + 2..pairs.high:
      if pairs[i] == pairs[j]: return true

func hasRepeat(s: string): bool =
  for i in 2..s.high:
    if s[i] == s[i - 2]: return true

echo input.foldl(a + (if b.hasDouble and b.hasVowels and b.isCompliant: 1 else: 0), 0)
echo input.foldl(a + (if b.hasPair and b.hasRepeat: 1 else: 0), 0)
