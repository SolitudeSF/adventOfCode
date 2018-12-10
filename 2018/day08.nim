import strutils, sequtils

const file = "input/day08"
let input = file.readFile.splitWhitespace.mapIt it.parseInt.int8

func sumMetadata(s: seq[SomeNumber], pos = 0): (int, int) =
  let
    children = s[pos]
    meta = s[pos + 1]
  result[1] = pos + 2
  for _ in 1..children:
    let res = sumMetadata(s, result[1])
    result[0] += res[0]
    result[1] = res[1]
  for i in result[1]..<result[1] + meta:
    result[0] += s[i]
  result[1] += meta

func sumMetadataComplex(s: seq[SomeNumber], pos = 0): (int, int) =
  var children = newSeq[int](s[pos])
  let meta = s[pos + 1]
  result[1] = pos + 2
  for i in 0..children.high:
    let res = sumMetadataComplex(s, result[1])
    result[1] = res[1]
    children[i] = res[0]
  if children.len == 0:
    for i in result[1]..<result[1] + meta:
      result[0] += s[i]
  else:
    for i in result[1]..<result[1] + meta:
      if s[i] <= children.len:
        result[0] += children[s[i] - 1]
  result[1] += meta

echo input.sumMetadata[0]
echo input.sumMetadataComplex[0]
