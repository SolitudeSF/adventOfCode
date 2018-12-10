#!/usr/bin/env elvish

@input = (cat "input/day03")

@fabric = (for i [(range 1000)] { put [(repeat 1000 0)] })
@rects = (for i [(range (count $input))] { put [] })

for line $input {
  @parts = (splits ' ' $line)
  id = $parts[0][1:]
  x y = (splits ',' $parts[2][:-1])
  w h = (splits 'x' $parts[3])
  rects[(- $id 1)] = [$x $y $w $h]
  for i [(range (- $x 1) (- (+ $x $w) 1))] {
    for j [(range $y (+ $y $h))] {
      fabric[$i][$j] = (+ $fabric[$i][$j] 1)
    }
  }
}

overlapped = 0
for i [(range (count $fabric))] {
  for j [(range (count $fabric))] {
    if (> $fabric[$i][$j] 1) {
      overlapped = (+ $overlapped 1)
    }
  }
}
put $overlapped

for x [(range (count $rects))] {
  rect = $rects[$x]
  intact = $true
  for i [(range $rect[0] (+ $rect[0] $rect[2]))] {
    for j [(range $rect[1] (+ $rect[1] $rect[3]))] {
      if (> $fabric[(- $i 1)][$j] 1) {
        intact = $false
	break
      }
    }
    if (not $intact) { break }
  }
  if $intact {
    + $x 1
    break
  }
}
