#!/usr/bin/env elvish

@input = (sort <"input/day4")

sleep = [&]

{
  id = 0
  start = 0
  asleep = $false

  for line $input {
    if (eq $line[25] '#') {
      id = [(splits ' ' $line)][3][1:]
      if (not (has-key $sleep $id)) {
        sleep[$id] = [(repeat 60 0)]
      }
    } else {
      minute = $line[15:17]
      if $asleep {
        for i [(range $start $minute)] {
          sleep[$id][$i] = (+ $sleep[$id][$i] 1)
	}
      } else {
        start = $minute
      }
      asleep = (not $asleep)
    }
  }
}

{
  sleepSum = [&]

  for k [(keys $sleep)] {
    v = $sleep[$k]
    sleepSum[$k] = 0
    for n $v {
      sleepSum[$k] = (+ $sleepSum[$k] $n)
    }
  }

  maxSleepTotal = 0
  maxId = 0
  for k [(keys $sleepSum)] {
    v = $sleepSum[$k]
    if (> $v $maxSleepTotal) {
      maxSleepTotal = $v
      maxId = $k
    }
  }

  maxMinute = 0
  maxMinuteSleep = 0
  for i [(range (count $sleep[$maxId]))] {
    v = $sleep[$maxId][$i]
    if (> $v $maxMinuteSleep) {
      maxMinuteSleep = $v
      maxMinute = $i
    }
  }

  * $maxMinute $maxId
}

{
  maxMinute = 0
  maxMinuteSleep = 0
  maxId = 0

  for k [(keys $sleep)] {
    v = $sleep[$k]
    maxSleep = 0
    maxSleepId = 0

    for i [(range (count $v))] {
      n = $v[$i]
      if (> $n $maxSleep) {
        maxSleep = $n
	maxSleepId = $i
      }
    }

    if (> $maxSleep $maxMinuteSleep) {
      maxMinuteSleep = $maxSleep
      maxMinute = $maxSleepId
      maxId = $k
    }
  }

  * $maxMinute $maxId
}
