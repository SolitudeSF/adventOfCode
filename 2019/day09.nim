import strutils, sequtils

const file = "input/day09"

type
  Instruction = enum
    Add = 1, Multiply, Input, Output,
    JumpIfTrue, JumpIfFalse, LessThan, Equals, Base, Terminate = 99
  ParameterMode = enum
    Positional, Immediate, Relative
  ParameterModes = array[3, ParameterMode]
  Cpu = object
    mem, input: seq[int]
    p, base, inp: int

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
  of Input, Output, Base: 2
  of Terminate: 1

func `[]`(cpu: var Cpu, mode: ParameterModes, arg: int): int =
  let adr = case mode[arg - 1]
    of Positional: cpu.mem[cpu.p + arg]
    of Immediate: cpu.p + arg
    of Relative: cpu.mem[cpu.p + arg] + cpu.base
  if adr > cpu.mem.high:
    cpu.mem.setLen(adr + 1)
  cpu.mem[adr]

func `[]=`(cpu: var Cpu, mode: ParameterModes, arg, val: int) =
  let adr = case mode[arg - 1]
    of Positional: cpu.mem[cpu.p + arg]
    of Immediate: cpu.p + arg
    of Relative: cpu.mem[cpu.p + arg] + cpu.base
  if adr > cpu.mem.high:
    cpu.mem.setLen(adr + 1)
  cpu.mem[adr] = val

func execute(cpu: var Cpu): int =
  while true:
    let (i, m) = cpu.mem[cpu.p].parseOpCode
    case i
    of Add: cpu[m, 3] = cpu[m, 1] + cpu[m, 2]
    of Multiply: cpu[m, 3] = cpu[m, 1] * cpu[m, 2]
    of Output:
      result = cpu[m, 1]
      cpu.p += i.len
      return
    of Input:
      cpu[m, 1] = cpu.input[cpu.inp]
      inc cpu.inp
    of JumpIfTrue:
      if cpu[m, 1] != 0:
        cpu.p = cpu[m, 2]
        continue
    of JumpIfFalse:
      if cpu[m, 1] == 0:
        cpu.p = cpu[m, 2]
        continue
    of LessThan: cpu[m, 3] = if cpu[m, 1] < cpu[m, 2]: 1 else: 0
    of Equals: cpu[m, 3] = if cpu[m, 1] == cpu[m, 2]: 1 else: 0
    of Base: cpu.base += cpu[m, 1]
    of Terminate:
      cpu.p = -1
      break
    cpu.p += i.len

let mem = file.readFile.strip.split(',').mapIt it.parseInt

block:
  var cpu = Cpu(mem: mem, input: @[1])
  echo execute cpu

block:
  var cpu = Cpu(mem: mem, input: @[2])
  echo execute cpu
