import strutils, sequtils

const file = "input/day05"

type
  Instruction = enum
    Add = 1, Multiply, Input, Output,
    JumpIfTrue, JumpIfFalse, LessThan, Equals, Terminate = 99
  ParameterMode = enum
    Positional, Immediate
  ParameterModes = array[3, ParameterMode]

func parseOpCode(x: int): tuple[i: Instruction, m: ParameterModes] =
  result.i = Instruction(x mod 100)
  var params = x div 100
  var i = 0
  while true:
    result.m[i] = ParameterMode(params mod 10)
    if params < 10: break
    inc i
    params = params div 10

func len(x: Instruction): int =
  case x
  of Add, Multiply, LessThan, Equals: 4
  of JumpIfTrue, JumpIfFalse: 3
  of Input, Output: 2
  of Terminate: 1

func `[]`(mem: seq[int], pos: int, mode: ParameterModes, arg: int): int =
  case mode[arg - 1]
  of Positional: mem[mem[pos + arg]]
  of Immediate: mem[pos + arg]

func `[]=`(mem: var seq[int], pos: int, mode: ParameterModes, arg, val: int) =
  case mode[arg - 1]
  of Positional: mem[mem[pos + arg]] = val
  of Immediate: mem[pos + arg] = val

func execute(mem: var seq[int], input: int): int =
  var p = 0
  while true:
    let (i, m) = mem[p].parseOpCode
    case i
    of Add: mem[p, m, 3] = mem[p, m, 1] + mem[p, m, 2]
    of Multiply: mem[p, m, 3] = mem[p, m, 1] * mem[p, m, 2]
    of Output: result = mem[p, m, 1]
    of Input: mem[p, m, 1] = input
    of JumpIfTrue:
      if mem[p, m, 1] != 0:
        p = mem[p, m, 2]
        continue
    of JumpIfFalse:
      if mem[p, m, 1] == 0:
        p = mem[p, m, 2]
        continue
    of LessThan: mem[p, m, 3] = if mem[p, m, 1] < mem[p, m, 2]: 1 else: 0
    of Equals: mem[p, m, 3] = if mem[p, m, 1] == mem[p, m, 2]: 1 else: 0
    of Terminate: break
    p += i.len

let mem = file.readFile.strip.split(',').mapIt it.parseInt

block:
  var mem = mem
  echo execute(mem, 1)

block:
  var mem = mem
  echo execute(mem, 5)
