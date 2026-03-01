# 1688 Count of Matches in Tournament

## Problem Description

You are given an integer `n`, the number of teams in a tournament. In each match, the loser is eliminated, and the winner advances to the next round.

The tournament continues until only one team remains. Return the number of matches played in the tournament.

### Example 1:
```
Input: n = 7
Output: 6
Explanation: 
- Round 1: 7 teams, 3 matches, 4 teams advance
- Round 2: 4 teams, 2 matches, 2 teams advance
- Round 3: 2 teams, 1 match, 1 team wins
Total matches: 3 + 2 + 1 = 6
```

### Example 2:
```
Input: n = 14
Output: 13
Explanation: 
- Round 1: 14 teams, 7 matches, 7 teams advance
- Round 2: 7 teams, 3 matches, 4 teams advance
- Round 3: 4 teams, 2 matches, 2 teams advance
- Round 4: 2 teams, 1 match, 1 team wins
Total matches: 7 + 3 + 2 + 1 = 13
```

## Solution Approach

In a tournament, each match eliminates exactly one team. To determine a winner from n teams, we need to eliminate n-1 teams, which means we need exactly n-1 matches.

## Algorithm

1. Return n - 1

## Why This Works

This is a mathematical observation. In any single-elimination tournament, each match eliminates one team. To go from n teams to 1 champion, we need to eliminate n-1 teams, requiring exactly n-1 matches.

## Complexity

- **Time**: O(1) - constant time
- **Space**: O(1) - constant extra space

## Link

[LeetCode 1688 Count of Matches in Tournament](https://leetcode.com/problems/count-of-matches-in-tournament/)