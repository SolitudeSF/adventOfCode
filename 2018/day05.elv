#!/usr/bin/env elvish
use str

input = (cat "input/day05")

alpha = [a b c d e f g h i j k l m n o p q r s t u v w x y z]
to-replace = [(for i [(range (count $alpha))] {
      upper = (str:to-upper $alpha[$i])
      put $alpha[$i]$upper $upper$alpha[$i]
})]

fn reacted [s]{
  res = $s
  last = ""
  while (not-eq $res $last) {
    last = $res
    for a $to-replace {
      res = (replaces $a '' $res)
    }
  }
  put $res
}

count (reacted $input)

fn without [s c]{
  replaces $c '' (replaces (str:to-upper $c) '' $s)
}

min = (count $input)
for a $alpha {
  l = (count (reacted (without $input $a)))
  if (< $l $min) { min = $l }
}
put $min
