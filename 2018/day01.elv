#!/usr/bin/env elvish

@input = (cat "input/day01")

+ $@input

sum = 0
sums = [&0]

while $true {
  for n $input {
    sum = (+ $sum $n)
    if (has-key $sums $sum) {
      put $sum
      exit 0
    } else {
      sums[$sum] = $true
    }
  }
}
