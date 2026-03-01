# 0710 Random Pick with Blacklist

## Problem Description

You are given an integer `n` and an integer array `blacklist` where `blacklist` contains distinct integers in the range `[0, n - 1]` that are blacklisted.

Implement the `Solution` class:

- `Solution(int n, int[] blacklist)` Initializes the object with the integer `n` and the blacklisted integers `blacklist`.
- `int pick()` Returns a random integer in the range `[0, n - 1]` and not in `blacklist`.

### Example 1:
```
Input
["Solution", "pick", "pick", "pick", "pick", "pick"]
[[7, [2, 3, 5]], [], [], [], [], []]
Output
[null, 0, 4, 1, 6, 1]

Explanation
Solution solution = new Solution(7, [2, 3, 5]);
solution.pick(); // return 0, any integer from [0,1,4,6] should be ok. Note that for every call of pick,
                 // 0, 1, 4, and 6 must be equally likely to be returned (i.e., with probability 1/4).
solution.pick(); // return 4
```

## The Twist

Implementing **random selection** with blacklist efficiently. The key insight is to remap blacklisted numbers in the whitelist range.

## Algorithm

### Mapping Approach:
1. Calculate whitelist size: `m = n - len(blacklist)`
2. Create a mapping from blacklisted numbers in [0, m) to whitelisted numbers in [m, n)
3. For picking:
   - Generate a random number in [0, m)
   - If it's in the mapping, return the mapped value
   - Otherwise, return the random number itself

## Complexity

- **Time**: 
  - Constructor: O(b) where b is blacklist size
  - Pick: O(1) average
- **Space**: O(b) - mapping storage

## Solution Code

```go
package main

import (
	"math/rand"
	"time"
)

type Solution struct {
	m        int
	blackmap map[int]int
	rnd      *rand.Rand
}

func Constructor(n int, blacklist []int) Solution {
	m := n - len(blacklist)
	blackmap := make(map[int]int)
	blacklisted := make(map[int]bool)
	
	for _, num := range blacklist {
		blacklisted[num] = true
	}
	
	// Map blacklisted numbers in [0, m) to whitelisted numbers in [m, n)
	w := m
	for _, num := range blacklist {
		if num < m {
			// Find next whitelisted number
			for blacklisted[w] {
				w++
			}
			blackmap[num] = w
			w++
		}
	}
	
	return Solution{
		m:        m,
		blackmap: blackmap,
		rnd:      rand.New(rand.NewSource(time.Now().UnixNano())),
	}
}

func (s *Solution) Pick() int {
	r := s.rnd.Intn(s.m)
	if mapped, exists := s.blackmap[r]; exists {
		return mapped
	}
	return r
}
```

## Link

[LeetCode 0710 Random Pick with Blacklist](https://leetcode.com/problems/random-pick-with-blacklist/)
