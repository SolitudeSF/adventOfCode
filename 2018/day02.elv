#!/usr/bin/env elvish

@input = (cat "input/day02")

two = 0
three = 0

fn countMap [a]{
  result = [&]
  for l $a {
    if (has-key $result $l) {
      result[$l] = (+ $result[$l] 1)
    } else {
      result[$l] = 1
    }
  }
  put $result
}

for line $input {
  letters = (countMap $line)
  need2 = $true
  need3 = $true
  for k [(keys $letters)] {
    if (and $need2 (eq $letters[$k] 2)) {
      two = (+ $two 1)
      need2 = $false
    } elif (and $need3 (eq $letters[$k] 3)) {
      three = (+ $three 1)
      need3 = $false
    }
  }
}

* $two $three

# Part 2

fn dist [a b]{
  result = 0
  for i [(range (count $a))] {
    if (not-eq $a[$i] $b[$i]) {
      result = (+ $result 1)
    }
  }
  put $result
}

fn same [a b]{
  result = ""
  for i [(range (count $a))] {
    if (eq $a[$i] $b[$i]) {
      result = $result$a[$i]
    }
  }
  put $result
}

for i [(range (- (count $input) 1))] {
  for j [(range (+ $i 1) (count $input))] {
    if (eq (dist $input[$i] $input[$j]) 1) {
      same $input[$i] $input[$j]
      exit 0
    }
  }
}
