import strutils, sequtils

const file = "input/day07"

type
  Instruction = enum
    Add = 1, Multiply, Input, Output,
    JumpIfTrue, JumpIfFalse, LessThan, Equals, Terminate = 99
  ParameterMode = enum
    Positional, Immediate
  ParameterModes = array[3, ParameterMode]
  Cpu = object
    mem: seq[int]
    p: int
    input: seq[int]
    inp: int

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

func execute(cpu: var Cpu): int =
  while true:
    let (i, m) = cpu.mem[cpu.p].parseOpCode
    case i
    of Add: cpu.mem[cpu.p, m, 3] = cpu.mem[cpu.p, m, 1] + cpu.mem[cpu.p, m, 2]
    of Multiply: cpu.mem[cpu.p, m, 3] = cpu.mem[cpu.p, m, 1] * cpu.mem[cpu.p, m, 2]
    of Output:
      result = cpu.mem[cpu.p, m, 1]
      cpu.p += i.len
      return
    of Input:
      cpu.mem[cpu.p, m, 1] = cpu.input[cpu.inp]
      inc cpu.inp
    of JumpIfTrue:
      if cpu.mem[cpu.p, m, 1] != 0:
        cpu.p = cpu.mem[cpu.p, m, 2]
        continue
    of JumpIfFalse:
      if cpu.mem[cpu.p, m, 1] == 0:
        cpu.p = cpu.mem[cpu.p, m, 2]
        continue
    of LessThan: cpu.mem[cpu.p, m, 3] = if cpu.mem[cpu.p, m, 1] < cpu.mem[cpu.p, m, 2]: 1 else: 0
    of Equals: cpu.mem[cpu.p, m, 3] = if cpu.mem[cpu.p, m, 1] == cpu.mem[cpu.p, m, 2]: 1 else: 0
    of Terminate:
      cpu.p = -1
      break
    cpu.p += i.len

iterator permutations[N, T](a: array[N, T]): array[N, T] =
  var
    c: array[N, int]
    a = a
    i = 0

  yield a

  while i < a.len:
    if c[i] < i:
      if i mod 2 == 0:
        swap a[0], a[i]
      else:
        swap a[c[i]], a[i]
      yield a
      inc c[i]
      i = 0
    else:
      c[i] = 0
      inc i

let mem = file.readFile.strip.split(',').mapIt it.parseInt

block:
  var maxres = 0
  for p in [0, 1, 2, 3, 4].permutations:
    var cpus = [
      Cpu(mem: mem, input: @[p[0], 0]),
      Cpu(mem: mem, input: @[p[1]]),
      Cpu(mem: mem, input: @[p[2]]),
      Cpu(mem: mem, input: @[p[3]]),
      Cpu(mem: mem, input: @[p[4]])]
    var res = cpus[0].execute
    for i in 1..cpus.high:
      cpus[i].input.add res
      res = cpus[i].execute
    if res > maxres: maxres = res

  echo maxres

block:
  var maxres = 0
  for p in [5, 6, 7, 8, 9].permutations:
    var cpus = [
      Cpu(mem: mem, input: @[p[0], 0]),
      Cpu(mem: mem, input: @[p[1]]),
      Cpu(mem: mem, input: @[p[2]]),
      Cpu(mem: mem, input: @[p[3]]),
      Cpu(mem: mem, input: @[p[4]])]
    while cpus[^1].p != -1:
      for i in cpus.low..cpus.high:
        cpus[if i == cpus.high: 0 else: i + 1].input.add cpus[i].execute
    if cpus[0].input[^2] > maxres:
      maxres = cpus[0].input[^2]

  echo maxres
