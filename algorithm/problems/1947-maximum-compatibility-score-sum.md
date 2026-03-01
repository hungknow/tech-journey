# 1947 Maximum Compatibility Score Sum

## Problem Description

You are given two matrices `students` and `mentors` where:
- `students[i][j]` represents the answer of student `i` to question `j`
- `mentors[i][j]` represents the answer of mentor `i` to question `j`

The compatibility score of a student-mentor pair is the number of answers that are the same.

Each student can be assigned to exactly one mentor, and each mentor can be assigned to exactly one student.

Return the maximum compatibility score sum possible.

### Example 1:
```
Input: students = [[1,1,0],[1,0,1],[0,0,1]], mentors = [[1,0,0],[0,0,1],[1,1,0]]
Output: 8
```

### Example 2:
```
Input: students = [[0,0],[0,0],[0,0]], mentors = [[1,1],[1,1],[1,1]]
Output: 0
```

## Approach

This problem can be solved using maximum bipartite matching with DP:

1. **Compatibility Calculation**:
   - Calculate compatibility score for each student-mentor pair
   - Score is the number of matching answers

2. **Maximum Matching**:
   - Use DP with bitmask to find maximum total score
   - Each student must be matched to exactly one mentor

3. **State Compression**:
   - Use bitmask to represent which mentors are used
   - DP[i][mask] = maximum score for first i students

4. **Greedy Assignment**:
   - For each student, try all available mentors
   - Choose the assignment that maximizes total score

## Solution Code

```go
func maxCompatibilitySum(students [][]int, mentors [][]int) int {
    m := len(students)
    n := len(students[0])
    if m == 0 {
        return 0
    }
    
    // Precompute compatibility scores
    scores := make([][]int, m)
    for i := 0; i < m; i++ {
        scores[i] = make([]int, m)
        for j := 0; j < m; j++ {
            score := 0
            for k := 0; k < n; k++ {
                if students[i][k] == mentors[j][k] {
                    score++
                }
            }
            scores[i][j] = score
        }
    }
    
    // DP with bitmask
    dp := make([][]int, m+1)
    for i := 0; i <= m; i++ {
        dp[i] = make([]int, 1<<m)
    }
    
    for i := 1; i <= m; i++ {
        for mask := 0; mask < 1<<m; mask++ {
            // Count how many mentors are used in this mask
            mentorCount := 0
            for j := 0; j < m; j++ {
                if mask&(1<<j) != 0 {
                    mentorCount++
                }
            }
            
            if mentorCount != i-1 {
                continue
            }
            
            // Try to assign student i-1 to each available mentor
            for j := 0; j < m; j++ {
                if mask&(1<<j) == 0 { // If mentor j is not used
                    newMask := mask | (1 << j)
                    dp[i][newMask] = max(dp[i][newMask], dp[i-1][mask]+scores[i-1][j])
                }
            }
        }
    }
    
    return dp[m][(1<<m)-1]
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(m^2 * n + m * 2^m) where m is the number of students/mentors and n is the number of questions
  - Precomputing scores: O(m^2 * n)
  - DP computation: O(m * 2^m)
- **Space**: O(m * 2^m) for the DP array

## Link

[LeetCode 1947 Maximum Compatibility Score Sum](https://leetcode.com/problems/maximum-compatibility-score-sum/)