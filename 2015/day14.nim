import strscans

const file = "input/day14"

type
  Deer = object
    speed, travel, rest: int
    points, distance, time: int
    moving: bool

var deer = newSeq[Deer]()
const str = "$w can fly $i km/s for $i seconds, but then must rest for $i seconds."

for line in file.lines:
  var
    s, t, r: int
    name: string
  if line.scanf(str, name, s, t, r):
    deer &= Deer(speed: s, travel: t, rest: r, moving: true, time: t)

for i in 1..2503:
  var maxDist = 0
  for d in deer.mitems:
    if d.moving:
      d.distance += d.speed
    if d.distance > maxDist:
      maxDist = d.distance
    dec d.time
    if d.time == 0:
      d.moving = not d.moving
      if d.moving:
        d.time = d.travel
      else:
        d.time = d.rest
  for d in deer.mitems:
    if d.distance == maxDist:
        inc d.points

var maxPoint, maxDist = 0
for d in deer:
  if d.distance > maxDist:
    maxDist = d.distance
  if d.points > maxPoint:
    maxPoint = d.points

echo maxDist
echo maxPoint
