import tables, strscans

const file = "input/day09"

var distances = initTable[string, Table[string, int]](8)

for line in file.lines:
  var
    a, b: string
    d: int
  if line.scanf("$w to $w = $i", a, b, d):
    if a notin distances: distances[a] = initTable[string, int](8)
    if b notin distances: distances[b] = initTable[string, int](8)
    distances[a][b] = d
    distances[b][a] = d

var
  min = int.high
  max = int.low

for c0, distances1 in distances:
  for c1, d1 in distances[c0]:
    for c2, d2 in distances[c1]:
      if c2 == c0: continue
      for c3, d3 in distances[c2]:
        if c3 == c1 or c3 == c0: continue
        for c4, d4 in distances[c3]:
          if c4 == c2 or c4 == c1 or c4 == c0: continue
          for c5, d5 in distances[c4]:
            if c5 == c3 or c5 == c2 or c5 == c1 or c5 == c0: continue
            for c6, d6 in distances[c5]:
              if c6 == c4 or c6 == c3 or c6 == c2 or c6 == c1 or c6 == c0: continue
              for c7, d7 in distances[c6]:
                if c7 == c5 or c7 == c4 or c7 == c3 or c7 == c2 or c7 == c1 or c7 == c0: continue
                let d = d1 + d2 + d3 + d4 + d5 + d6 + d7
                if min > d: min = d
                if max < d: max = d

echo min
echo max
