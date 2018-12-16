import strutils, strscans, tables, sets

const file = "input/day16"

type
  Cpu = array[4, int]
  Operation = enum
    Addr, Addi, Mulr, Muli, Banr, Bani, Borr, Bori,
    Setr, Seti, Gtir, Gtri, Gtrr, Eqir, Eqri, Eqrr
  Instruction = object
    op: Operation
    a, b, c: int

func getFirstValue[T: Ordinal](s: HashSet[T]): T =
  for t in T.low..T.high:
    if t in s:
      return t

func execute(c: var Cpu, i: Instruction) =
  c[i.c] = case i.op
           of Addr: c[i.a] + c[i.b]
           of Addi: c[i.a] + i.b
           of Mulr: c[i.a] * c[i.b]
           of Muli: c[i.a] * i.b
           of Banr: c[i.a] and c[i.b]
           of Bani: c[i.a] and i.b
           of Borr: c[i.a] or c[i.b]
           of Bori: c[i.a] or i.b
           of Setr: c[i.a]
           of Seti: i.a
           of Gtir: (if i.a > c[i.b]: 1 else: 0)
           of Gtri: (if c[i.a] > i.b: 1 else: 0)
           of Gtrr: (if c[i.a] > c[i.b]: 1 else: 0)
           of Eqir: (if i.a == c[i.b]: 1 else: 0)
           of Eqri: (if c[i.a] == i.b: 1 else: 0)
           of Eqrr: (if c[i.a] == c[i.b]: 1 else: 0)

let input = file.readFile.splitLines

const
  registerBeforeScan = "Before: [$i, $i, $i, $i]"
  registerAfterScan = "After:  [$i, $i, $i, $i]"
  instructionScan = "$i $i $i $i"

var
  i, sum = 0
  candidates = initTable[int, HashSet[Operation]](16)
  opcodes = initTable[int, Operation](16)

while input[i].len != 0:
  var
    i1, i2, i3, i4, alike: int
    cpuBefore, cpuAfter, cpuTemp: Cpu
    instruction: Instruction

  if input[i].scanf(registerBeforeScan, i1, i2, i3, i4):
    cpuBefore = [i1, i2, i3, i4]
  if input[i + 2].scanf(registerAfterScan, i1, i2, i3, i4):
    cpuAfter = [i1, i2, i3, i4]
  if input[i + 1].scanf(instructionScan, i1, i2, i3, i4):
    instruction = Instruction(a: i2, b: i3, c: i4)

  for i in Operation.low..Operation.high:
    instruction.op = i
    cpuTemp = cpuBefore
    cpuTemp.execute instruction
    if cpuTemp == cpuAfter:
      inc alike
      if i1 notin candidates:
        candidates[i1] = initSet[Operation]()
      candidates[i1].incl i

  if alike > 2: inc sum
  i += 4

echo sum

while candidates.len > 0:
  for key, val in candidates:
    if val.card == 1:
      let found = val.getFirstValue
      opcodes[key] = found
      candidates.del key
      for value in candidates.mvalues:
        value.excl found

var cpu: Cpu
i += 2

while i < input.len:
  var i1, i2, i3, i4: int
  if input[i].scanf(instructionScan, i1, i2, i3, i4):
    cpu.execute(Instruction(op: opcodes[i1], a: i2, b: i3, c: i4))
  inc i

echo cpu[0]
