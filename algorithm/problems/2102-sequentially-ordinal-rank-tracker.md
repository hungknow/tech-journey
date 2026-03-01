# 2102 Sequentially Ordinal Rank Tracker

## Problem Description

Design a system that tracks the rank of scores in a game where scores are added sequentially.

Implement the `SORTracker` class:

- `SORTracker()` Initializes the object with an empty scores list.
- `void addScore(int score)` Adds the score to the system.
- `int getRank(int score)` Returns the rank of the given score, where rank 1 is the highest score.

### Example 1:
```
Input
["SORTracker","addScore","addScore","addScore","addScore","getRank","getRank","getRank"]
[[],[10],[36],[5],[5],[7],[5],[36],[5]]
Output
[null,null,null,null,null,null,1,2,2]

Explanation
SORTracker sORTracker = new SORTracker();
sORTracker.addScore(10); // The system now has [10].
sORTracker.addScore(36); // The system now has [10, 36].
sORTracker.addScore(5);  // The system now has [36, 10, 5].
sORTracker.addScore(5);  // The system now has [36, 10, 5, 5].
sORTracker.addScore(7);  // The system now has [36, 10, 7, 5, 5].
sORTracker.getRank(5);  // The score 5 is the 2nd highest, so return 2.
sORTracker.getRank(36); // The score 36 is the highest, so return 1.
```

## The Twist

Implementing a score tracking system that maintains scores in sorted order and efficiently retrieves the rank of any given score.

## Algorithm

### TreeSet Approach:
1. Use a TreeSet (or balanced BST) to maintain scores in sorted order
2. For SORTracker():
   - Initialize an empty TreeSet
3. For addScore(score):
   - Add the score to the TreeSet
4. For getRank(score):
   - Find the position of the score in the sorted list
   - Return rank = size - position

The key insight is using a TreeSet to maintain scores in sorted order for efficient rank queries.

## Complexity

- **Time**: 
  - SORTracker constructor: O(1)
  - addScore: O(logn) where n is the number of scores
  - getRank: O(logn) where n is the number of scores
- **Space**: O(n) where n is the number of scores

## Solution Code

```go
package main

import "sort"

type SORTracker struct {
	scores []int
}

func Constructor() SORTracker {
	return SORTracker{
		scores: make([]int, 0),
	}
}

func (this *SORTracker) AddScore(score int)  {
	// Insert score in sorted order
	index := sort.SearchInts(this.scores, score)
	if index == len(this.scores) {
		this.scores = append(this.scores, score)
	} else {
		// Insert at the correct position
		this.scores = append(this.scores[:index], append([]int{score}, this.scores[index:]...)...)
	}
}

func (this *SORTracker) GetRank(score int) int {
	// Find the position of the score
	index := sort.SearchInts(this.scores, score)
	if index == len(this.scores) {
		return -1
	}
	
	// Rank is position from the end
	return len(this.scores) - index
}

/**
 * Your SORTracker object will be instantiated and called as such:
 * obj := Constructor();
 * obj.AddScore(score);
 * param_2 := obj.GetRank(score);
 */
```

## Link

[LeetCode 2102 Sequentially Ordinal Rank Tracker](https://leetcode.com/problems/sequentially-ordinal-rank-tracker/)