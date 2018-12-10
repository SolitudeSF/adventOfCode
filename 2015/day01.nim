const file = "input/day01"

let input = file.readFile

var floor, basement = 0

for i, c in input:
  if c == '(': inc floor
  else: dec floor
  if basement == 0 and floor == -1: basement = i+1

echo floor
echo basement
