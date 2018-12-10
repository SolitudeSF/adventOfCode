import strscans

const file = "input/day02"

var sum1, sum2 = 0

for line in file.lines:
  var l, w, h: int
  if line.scanf("$ix$ix$i", l, w, h):
    let
      a = l * w
      b = w * h
      c = l * h
      d = min(a, min(b, c))
      p1 = 2 * (l + w)
      p2 = 2 * (l + h)
      p3 = 2 * (h + w)
      p = min(p1, min(p2, p3))
    sum1 += d + 2 * (a + b + c)
    sum2 += p + a * h

echo sum1
echo sum2
