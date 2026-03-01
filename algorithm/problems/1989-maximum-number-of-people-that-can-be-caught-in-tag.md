# 1989 Maximum Number of People That Can Be Caught in Tag

## Problem Description

You are playing a game of tag with your friends. You are "it" and you want to tag as many people as possible.

You are given a 2D integer array `team` where `team[i] = [position_i, direction_i]` represents the position and direction of the i-th person on your team.

You are also given a 2D integer array `opponent` where `opponent[j] = [position_j, direction_j]` represents the position and direction of the j-th person on the opposing team.

The direction is either 1 (moving right) or -1 (moving left).

You can tag a person from the opposing team if:
- You are at the same position as them.
- You are moving in the same direction as them.
- You are to the left of them (if both are moving right) or to the right of them (if both are moving left).

Return the maximum number of people from the opposing team that you can tag.

### Example 1:
```
Input: team = [[1,1],[0,1]], opponent = [[3,1],[1,-1]]
Output: 1
Explanation: You can tag the opponent at position 1.
```

### Example 2:
```
Input: team = [[0,1],[2,1]], opponent = [[1,1],[3,-1]]
Output: 0
Explanation: You cannot tag any opponent.
```

## Approach

This problem can be solved using a two-pointer approach:

1. Sort both teams by position.
2. Use two pointers to traverse both teams simultaneously.
3. For each person on your team, check if they can tag any person on the opposing team based on the rules.
4. Count the number of successful tags.

## Solution Code

```go
func catchMaximumAmountofPeople(team [][]int, opponent [][]int) int {
    // Sort both teams by position
    sort.Slice(team, func(i, j int) bool {
        return team[i][0] < team[j][0]
    })
    
    sort.Slice(opponent, func(i, j int) bool {
        return opponent[i][0] < opponent[j][0]
    })
    
    i, j := 0, 0
    count := 0
    n, m := len(team), len(opponent)
    
    for i < n && j < m {
        teamPos, teamDir := team[i][0], team[i][1]
        oppPos, oppDir := opponent[j][0], opponent[j][1]
        
        // Check if the current team member can tag the current opponent
        if teamPos == oppPos && teamDir == oppDir {
            count++
            i++
            j++
        } else if teamPos < oppPos {
            // Team member is to the left of opponent
            if teamDir == 1 && oppDir == 1 {
                // Both moving right, team member can tag opponent
                count++
                i++
                j++
            } else {
                i++
            }
        } else {
            // Team member is to the right of opponent
            if teamDir == -1 && oppDir == -1 {
                // Both moving left, team member can tag opponent
                count++
                i++
                j++
            } else {
                j++
            }
        }
    }
    
    return count
}
```

## Complexity Analysis

- **Time**: O(n log n + m log m) - Sorting dominates the time complexity
- **Space**: O(1) - We only use a few pointers regardless of the input size

## Link

[LeetCode 1989 Maximum Number of People That Can Be Caught in Tag](https://leetcode.com/problems/maximum-number-of-people-that-can-be-caught-in-tag/)