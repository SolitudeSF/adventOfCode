import strutils

const file = "input/day08"

const
  width = 25
  height = 6
  layerSize = width * height

type Layer = array[layerSize, char]

func `$`(l: Layer): string =
  result = newStringOfCap(layerSize + height)
  for row in 0..<height:
    for pixel in 0..<width:
      case l[row * width + pixel]
      of '0': result.add '#'
      of '1': result.add '.'
      else: result.add ' '
    result.add '\n'

func newLayer: Layer =
  for i in 0..<layerSize:
    result[i] = '2'

func count(l: Layer, c: char): int =
  for ch in l:
    if ch == c:
      inc result

let
  input = file.readFile.strip
  layerCount = input.len div layerSize

var
  minZeros = int.high
  minLayer: int
  layers = newSeq[Layer](layerCount)

for i in 0..<layerCount:
  copyMem addr layers[i][0], unsafeAddr input[i * layerSize], layerSize
  let z = layers[i].count('0')
  if z < minZeros:
    minZeros = z
    minLayer = i

echo layers[minLayer].count('1') * layers[minLayer].count('2')

var layer = newLayer()

for i in 0..<layerSize:
  for j in 0..layers.high:
    if layers[j][i] != '2':
      layer[i] = layers[j][i]
      break

echo layer
