import lists, strutils

const file = "input/day09"

proc simulate(playersN, marblesN: int): int =
  var
    ring = initDoublyLinkedRing[int]()
    players = newSeq[int](playersN)
    player = 0

  ring.append 0

  var cursor = ring.head

  for n in 1..marblesN:
    if n mod 23 == 0:
      for _ in 1..7:
        cursor = cursor.prev
      players[player] += n + cursor.value
      ring.remove cursor
      cursor = cursor.next
    else:
      var node = newDoublyLinkedNode(n)
      cursor = cursor.next
      node.prev = cursor
      node.next = cursor.next
      cursor.next.prev = node
      cursor.next = node
      cursor = node
    if player == players.high:
      player = 0
    else:
      inc player

  for i in players:
    if i > result:
      result = i

let
  input = file.readFile.splitWhitespace
  playersN = input[0].parseInt
  marblesN = input[6].parseInt

echo simulate(playersN, marblesN)
echo simulate(playersN, marblesN * 100)
