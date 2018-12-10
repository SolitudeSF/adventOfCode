import tables

const file = "input/day07"

type
  Worker = tuple[c: char, t: int]
  Stack[T: static int] = array[T, Worker]

iterator working(s: var Stack): var Worker =
  for w in s.mitems:
    if w.c != '\0':
      yield w

iterator available(s: var Stack): var Worker =
  for w in s.mitems:
    if w.c == '\0':
      yield w

proc iterate(s: var Stack, t: var int): set[char] =
  var min = int.high
  for w in s.working:
    if w.t < min:
      min = w.t
  t += min
  for w in s.working:
    w.t -= min
    if w.t == 0:
      result.incl w.c
      w.c = '\0'

var
  reqs = initTable[char, set[char]](32)
  all, required, q: set[char]

for line in file.lines:
  let
    k = line[36]
    v = line[5]
  required.incl k
  all.incl v
  if k in reqs:
    reqs[k].incl v
  else:
    reqs[k] = {v}


block part1:
  var
    res = ""
    reqs = reqs
  q = all - required

  while reqs.len > 0:
    for key in reqs.keys:
      if reqs[key].card == 0:
        q.incl key
        reqs.del key

    var min = 'Z'
    for c in q:
      if c.ord < min.ord:
        min = c

    res &= min
    q.excl min

    for key in reqs.keys:
      reqs[key].excl min

  echo res


block part2:
  var
    time = 0
    reqs = reqs
    workers: Stack[5]
  q = all - required

  while reqs.len > 0:
    for key in reqs.keys:
      if reqs[key].card == 0:
        q.incl key
        reqs.del key

    for w in workers.available:
      if q.card > 0:
        var min = 'Z'
        for c in q:
          if c.ord < min.ord:
            min = c
        q.excl min
        w.c = min
        w.t = min.ord - 4
      else: break

    let done = workers.iterate time
    for key in reqs.keys:
      reqs[key] = reqs[key] - done

  echo time
