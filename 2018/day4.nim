import algorithm, strutils, tables

func newArray[N: static int, T]: array[N, T] = result

const file = "input/day4"
let events = file.readFile.strip.splitLines.sorted cmp

var
  sleep = newTable[int, array[60, int8]](32)
  id = 0
  start = 0
  asleep = false

for event in events:
  if event[25] == '#':
    id = event[26..<(event.find(' ', 25))].parseInt
    if id notin sleep:
      sleep[id] = newArray[60, int8]()
  else:
    let minute = event[15..16].parseInt
    if asleep:
      for i in start..<minute:
        inc sleep[id][i]
    else:
      start = minute
    asleep = not asleep

block part1:
  var sleepSum = newTable[int, int](32)

  for k, v in sleep:
    sleepSum[k] = 0
    for n in v:
      inc sleepSum[k], n

  var maxSleepTotal, maxId: int
  for i, v in sleepSum:
    if v > maxSleepTotal:
      maxSleepTotal = v
      maxId = i

  var maxMinute, maxMinuteSleep: int
  for i, v in sleep[maxId]:
    if v > maxMinuteSleep:
      maxMinuteSleep = v
      maxMinute = i

  echo maxMinute * maxId

block part2:
  var maxMinute, maxMinuteSleep, maxId: int

  for k, v in sleep:
    var maxSleep, maxSleepId: int

    for i, v in v:
      if v > maxSleep:
        maxSleep = v
        maxSleepId = i

    if maxSleep > maxMinuteSleep:
      maxMinuteSleep = maxSleep
      maxMinute = maxSleepId
      maxId = k

  echo maxMinute * maxId
