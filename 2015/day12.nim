import strutils

const file = "input/day12"

let input = file.readFile

block part1:
  var
    num = ""
    sum = 0
  for c in input:
    if c in {'0'..'9', '-'}:
      num &= c
    elif num.len != 0:
      sum += num.parseInt
      num = ""

  echo sum

block part2:
  var
    isObj = newSeq[bool]()
    sum = newSeq[int]()
    num = ""
    i = 0

  while i < input.high:
    case input[i]
      of '0'..'9', '-':
        num &= input[i]
      of '[':
        isObj &= false
        sum &= 0
      of '{':
        isObj &= true
        sum &= 0
      of ']', '}':
        if num.len != 0:
          sum[^1] += num.parseInt
          num = ""
        sum[^2] += sum[^1]
        isObj.setLen isObj.high
        sum.setLen sum.high
      of 'r':
        if isObj[^1] and input[i + 1] == 'e' and input[i + 2] == 'd':
          isObj.setLen isObj.high
          sum.setLen sum.high
          var closer = 1
          while closer != 0:
            if input[i] == '{': inc closer
            elif input[i] == '}': dec closer
            inc i
          continue
      else:
        if num.len != 0:
          sum[^1] += num.parseInt
          num = ""
    inc i

  echo sum[0]
