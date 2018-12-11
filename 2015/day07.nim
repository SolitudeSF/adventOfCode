import strutils, tables

const file = "input/day07"

type
  Wires = TableRef[uint16, uint16]
  Action = enum
    Assign, Not, And, Or, Rshift, Lshift
  Value = object
    isWire: bool
    value: uint16
  Condition = object
    case action: Action
    of Assign:
      assignWire: Value
    of Not:
      notWire: Value
    of And:
      andWire1, andWire2: Value
    of Or:
      orWire1, orWire2: Value
    of Rshift:
      rshift, rshiftWire: Value
    of Lshift:
      lshift, lshiftWire: Value

func isNumber(s: string): bool = s[^1] in Digits

func toUint(s: string): uint16 =
  if s.len == 2:
    cast[uint16]([s[0], s[1]])
  else:
    cast[uint16]([s[0], '\0'])

func newValue(s: string): Value =
  if s.isNumber:
    Value(isWire: false, value: s.parseUint.uint16)
  else:
    Value(isWire: true, value: s.toUint)

func isKnown(v: Value, w: Wires): bool =
  case v.isWire
  of true:
    v.value in w
  of false:
    true

func canResolve(c: Condition, w: Wires): bool =
  case c.action
  of Assign:
    isKnown c.assignWire, w
  of Not:
    isKnown c.notWire, w
  of And:
    isKnown(c.andWire1, w) and isKnown(c.andWire2, w)
  of Or:
    isKnown(c.orWire1, w) and isKnown(c.orWire2, w)
  of Rshift:
    isKnown(c.rshiftWire, w) and isKnown(c.rshift, w)
  of Lshift:
    isKnown(c.lshiftWire, w) and isKnown(c.lshift, w)

func resolve(v: Value, w: Wires): uint16 =
  if v.isWire:
    w[v.value]
  else:
    v.value

func resolve(c: Condition, w: Wires): uint16 =
  case c.action
  of Assign:
    c.assignWire.resolve(w)
  of Not:
    not c.notWire.resolve(w)
  of And:
    c.andWire1.resolve(w) and c.andWire2.resolve(w)
  of Or:
    c.orWire1.resolve(w) or c.orWire2.resolve(w)
  of Rshift:
    c.rshiftWire.resolve(w) shr c.rshift.resolve(w)
  of Lshift:
    c.lshiftWire.resolve(w) shl c.lshift.resolve(w)

var conditions = newTable[uint16, Condition]()

for line in file.lines:
  let
    input = line.splitWhitespace
    name = input[^1].toUint

  case input.len
  of 3: conditions.add name, Condition(action: Assign,
                                       assignWire: newValue input[0])
  of 4: conditions.add name, Condition(action: Not,
                                       notWire: newValue input[1])
  of 5:
    let
      arg1 = newValue input[0]
      arg2 = newValue input[2]

    case input[1]
    of "AND":
      conditions.add name, Condition(action: And,
                                     andWire1: arg1,
                                     andWire2: arg2)
    of "OR":
      conditions.add name, Condition(action: Or,
                                     orWire1: arg1,
                                     orWire2: arg2)
    of "RSHIFT":
      conditions.add name, Condition(action: Rshift,
                                     rshiftWire: arg1,
                                     rshift: arg2)
    of "LSHIFT":
      conditions.add name, Condition(action: Lshift,
                                     lshiftWire: arg1,
                                     lshift: arg2)
    else: quit 1
  else: quit 1

func solve(c: TableRef[uint16, Condition]): Wires =
  var conditions = c.deepCopy
  result = newTable[uint16, uint16]()
  while conditions.len != 0:
    for name, value in conditions:
      if value.canResolve result:
        result[name] = value.resolve(result)
        conditions.del name

var a: uint16
block part1:
  a = conditions.solve["a".toUint]
  echo a

block part2:
  conditions["b".toUint] = Condition(action: Assign, assignWire: Value(isWire: false, value: a))
  echo conditions.solve["a".toUint]
