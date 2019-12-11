import strutils, sequtils, tables

const file = "input/day11"

type
  Instruction = enum
    Add = 1, Multiply, Input, Output,
    JumpIfTrue, JumpIfFalse, LessThan, Equals, Base, Terminate = 99
  ParameterMode = enum
    Positional, Immediate, Relative
  ParameterModes = array[3, ParameterMode]
  Cpu = object
    mem: seq[int]
    p, base, input: int

  Direction = enum
    Up, Right, Down, Left
  Vector = tuple[x, y: int]
  Robot = object
    pos: Vector
    dir: Direction

func left(dir: var Direction) =
  dir = case dir
  of Up: Left
  of Right: Up
  of Down: Right
  of Left: Down

func right(dir: var Direction) =
  dir = case dir
  of Up: Right
  of Right: Down
  of Down: Left
  of Left: Up

func move(pos: var Vector, dir: Direction) =
  case dir
  of Up: pos.y += 1
  of Right: pos.x += 1
  of Down: pos.y -= 1
  of Left: pos.x -= 1

func getColor(x: Table[Vector, int], v: Vector): int =
  if v in x: x[v] else: 0

func getColor2(x: Table[Vector, int], v: Vector): int =
  if v in x: x[v] else:
    if v == (0, 0): 1 else: 0

func getRect(x: Table[Vector, int]): tuple[x, y, w, h: int] =
  var maxX, maxY = int.low
  result.x = int.high
  result.y = int.high
  for key in x.keys:
    if key.x > maxX:
      maxX = key.x
    if key.x < result.x:
      result.x = key.x
    if key.y > maxY:
      maxY = key.y
    if key.y < result.y:
      result.y = key.y
  result.w = maxX - result.x + 1
  result.h = maxY - result.y + 1

func `$`(x: seq[seq[int]]): string =
  for row in countdown(x.high, x.low):
    for panel in x[row]:
      result.add if panel == 1: '#' else: '.'
    result.add "\n"

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
      cpu[m, 1] = cpu.input
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
  var
    painted = initTable[Vector, int]()
    robot = Robot()
    cpu = Cpu(mem: mem)

  while true:
    let color = execute cpu
    if cpu.p == -1: break
    let turn = execute cpu

    let scanColor = painted.getColor(robot.pos)
    if scanColor != color:
      painted[robot.pos] = color
    if turn == 0: robot.dir.left else: robot.dir.right
    robot.pos.move robot.dir
    cpu.input = painted.getColor(robot.pos)

  echo painted.len

block:
  var
    painted = initTable[Vector, int]()
    robot = Robot()
    cpu = Cpu(mem: mem, input: 1)

  while true:
    let color = execute cpu
    if cpu.p == -1: break
    let turn = execute cpu

    let scanColor = painted.getColor2(robot.pos)
    if scanColor != color:
      painted[robot.pos] = color
    if turn == 0: robot.dir.left else: robot.dir.right
    robot.pos.move robot.dir
    cpu.input = painted.getColor2(robot.pos)

  let rect = painted.getRect
  echo rect
  var grid = newSeq[seq[int]](rect.h)
  for i in 0..grid.high:
    grid[i] = newSeq[int](rect.w)

  for key, val in painted:
    grid[key.y - rect.y][key.x - rect.x] = val

  echo grid
