# 1244 Design A Leaderboard

## Problem Description

Design a Leaderboard class, which has 3 functions:

1. `addScore(playerId, score)`: Update the leaderboard by adding score to the given player's score. If there is no player with such id in the leaderboard, add it to the leaderboard with the given score.
2. `top(K)`: Return the score sum of the top K players.
3. `reset(playerId)`: Reset the score of the player with the given id to 0 (in other words erase it from the leaderboard). It is guaranteed that the player was added to the leaderboard before calling this function.

Initially, the leaderboard is empty.

### Example 1:
```
Input: 
["Leaderboard", "addScore", "addScore", "top", "reset", "addScore", "top"]
[[], [1, 73], [2, 56], [1], [2], [2, 51], [2]]
Output: 
[null, null, null, 129, null, null, 156]

Explanation: 
Leaderboard leaderboard = new Leaderboard ();
leaderboard.addScore(1, 73);   // leaderboard = [[1,73]];
leaderboard.addScore(2, 56);   // leaderboard = [[1,73],[2,56]];
leaderboard.top(1);             // return 73;
leaderboard.reset(1);           // leaderboard = [[2,56]];
leaderboard.addScore(2, 51);   // leaderboard = [[2,107]];
leaderboard.top(2);             // return 156;
```

## The Twist

Implementing a leaderboard that efficiently supports adding scores, retrieving top K scores, and resetting player scores.

## Algorithm

### HashMap + Sorting Approach:
1. Use a HashMap to store player scores
2. For addScore(playerId, score):
   - Add score to the player's current score in the HashMap
   - If player doesn't exist, initialize with 0 first
3. For top(K):
   - Extract all scores from the HashMap
   - Sort the scores in descending order
   - Sum the top K scores
   - Return the sum
4. For reset(playerId):
   - Set the player's score to 0 in the HashMap
   - Or remove the player from the HashMap

The key insight is using a HashMap for O(1) score updates and sorting when needed to find the top K scores.

## Complexity

- **Time**: 
  - Leaderboard constructor: O(1)
  - addScore: O(1)
  - top: O(nlogn) where n is the number of players
  - reset: O(1)
- **Space**: O(n) where n is the number of players

## Solution Code

```go
package main

import "sort"

type Leaderboard struct {
	scores map[int]int
}

func Constructor() Leaderboard {
	return Leaderboard{
		scores: make(map[int]int),
	}
}

func (this *Leaderboard) AddScore(playerId int, score int)  {
	this.scores[playerId] += score
}

func (this *Leaderboard) Top(K int) int {
	// Extract all scores
	allScores := make([]int, 0, len(this.scores))
	for _, score := range this.scores {
		allScores = append(allScores, score)
	}
	
	// Sort in descending order
	sort.Sort(sort.Reverse(sort.IntSlice(allScores)))
	
	// Sum the top K scores
	sum := 0
	for i := 0; i < K && i < len(allScores); i++ {
		sum += allScores[i]
	}
	
	return sum
}

func (this *Leaderboard) Reset(playerId int)  {
	this.scores[playerId] = 0
}

/**
 * Your Leaderboard object will be instantiated and called as such:
 * obj := Constructor();
 * obj.AddScore(playerId,score);
 * param_2 := obj.Top(K);
 * obj.Reset(playerId);
 */
```

## Link

[LeetCode 1244 Design A Leaderboard](https://leetcode.com/problems/design-a-leaderboard/)