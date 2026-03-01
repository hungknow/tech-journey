# 0911 Online Election

## Problem Description

You are given two integer arrays `persons` and `times`. In an election, the `ith` person voted at `times[i]`.

The election is **open** between time `t1` and `t2`, meaning that anyone who voted in this time range could win.

Implement the `TopVotedCandidate` class:

- `TopVotedCandidate(String person, int time)` Initializes the candidate with the given name and time.
- `int q(int t)` Returns the number of votes for the candidate leading up to and including time `t`.
- `void add(int time, int person, int votes)` Adds `votes` to the candidate's total at the given time.

### Example 1:
```
Input:
persons = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
times = [20,59,68,95,39,28,55,71,63]
topVotedCandidate.q(59) // returns 4
```

### Example 2:
```
Input:
persons = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
times = [42,99,64,24,69,38,57,24]
topVotedCandidate.q(99) // returns 2
```

## The Twist

Implementing an **online voting system** with efficient queries. The key insight is to maintain a running total and use binary search to find the time of the kth vote.

## Algorithm

### Binary Search for Vote Time:
1. Preprocess vote data:
   - Create arrays of (time, person) pairs and sort by time
   - Create a prefix sum array for cumulative votes
2. For each query `t`:
   - Use binary search to find the smallest time where cumulative votes ≥ k
   - Track the candidate with maximum votes at that time
3. Return the candidate with most votes at the query time

## Complexity

- **Time**: 
  - Constructor: O(n log n) for sorting
  - Query: O(log n) - binary search
- **Space**: O(n) - storing vote data

## Solution Code

```go
package main

import (
	"sort"
)

type TopVotedCandidate struct {
	person string
	votes  int
	times  []int
}

func Constructor(persons []string, times []int) TopVotedCandidate {
	n := len(persons)
	votes := make([]int, n)
	
	// Create (time, person) pairs and sort by time
	pairs := make([][2]int, n)
	for i := 0; i < n; i++ {
		pairs[i] = [2]int{times[i], i}
	}
	
	sort.Slice(pairs, func(i, j int) bool {
		return pairs[i][0] < pairs[j][0]
	})
	
	// Initialize votes
	for _, pair := range pairs {
		votes[pair[1]]++
	}
	
	// Create prefix sum array
	prefix := make([]int, n+1)
	for i := 1; i <= n; i++ {
		prefix[i] = prefix[i-1] + votes[i-1]
	}
	
	return TopVotedCandidate{
		person:  "",
		votes:  votes,
		times: times,
	}
}

func (t *TopVotedCandidate) q(t int) int {
	// Binary search for the smallest time with at least t votes
	left, right := 0, len(t.times)
	
	for left < right {
		mid := left + (right-left)/2
		
		if t.times[mid] >= t {
			right = mid
		} else {
			left = mid + 1
		}
	}
	
	// Find the candidate with most votes at time left
	maxVotes := 0
	candidate := ""
	
	for i := 0; i < len(t.times); i++ {
		if t.times[i] == left {
			if t.votes[i] > maxVotes {
				maxVotes = t.votes[i]
				candidate = t.person
			}
		}
	}
	
	t.person = candidate
	return maxVotes
}
```

## Link

[LeetCode 0911 Online Election](https://leetcode.com/problems/online-election/)
