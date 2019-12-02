import strutils, sequtils

const file = "input/day02"

let mem = file.readFile.strip.split(',').mapIt it.parseInt

func execute(mem: var seq[int]): int =
  for i in countup(0, mem.high, 4):
    var val: int
    case mem[i]
    of 1:
      val = mem[mem[i + 1]] + mem[mem[i + 2]]
    of 2:
      val = mem[mem[i + 1]] * mem[mem[i + 2]]
    else:
      return mem[0]
    mem[mem[i + 3]] = val

block:
  var mem = mem

  mem[1] = 12
  mem[2] = 2

  echo execute mem

block:
  for noun in 0..99:
    for verb in 0..99:
      var mem = mem

      mem[1] = noun
      mem[2] = verb

      if execute(mem) == 19690720:
        echo 100 * noun + verb
