# 0826 Most Profit Assigning Work

## Problem Description

You have `n` jobs and `m` workers. Each job has a difficulty and a profit. Each worker has a maximum ability they can handle. A worker can be assigned at most one job, and a job can be assigned to at most one worker.

For each worker, we want to assign them a job such that:
- The worker's ability is greater than or equal to the job's difficulty
- The profit is as high as possible

Return the maximum total profit we can achieve after assigning jobs to workers.

### Example 1:
```
Input: difficulty = [2,4,6,8,10], profit = [10,20,30,40,50], worker = [4,5,6,7]
Output: 100
Explanation: Workers are assigned jobs of difficulty [4,4,6,6] and they get a profit of [20,20,30,30] separately.
```

### Example 2:
```
Input: difficulty = [85,47,57], profit = [24,66,99], worker = [40,25,25]
Output: 0
```

## Approach

This problem can be solved using a two-pointer approach combined with sorting:

1. Create pairs of (difficulty, profit) and sort them by difficulty.
2. Create a prefix maximum array to store the maximum profit achievable up to each difficulty level.
3. Sort the workers array.
4. For each worker, find the maximum difficulty they can handle using binary search or two-pointer technique, and get the corresponding maximum profit.

## Solution Code

```go
func maxProfitAssignment(difficulty []int, profit []int, worker []int) int {
    n := len(difficulty)
    jobs := make([][2]int, n)
    
    // Create jobs array with (difficulty, profit) pairs
    for i := 0; i < n; i++ {
        jobs[i] = [2]int{difficulty[i], profit[i]}
    }
    
    // Sort jobs by difficulty
    sort.Slice(jobs, func(i, j int) bool {
        return jobs[i][0] < jobs[j][0]
    })
    
    // Create prefix maximum array
    maxProfitUpTo := make([]int, n)
    maxProfitUpTo[0] = jobs[0][1]
    for i := 1; i < n; i++ {
        maxProfitUpTo[i] = max(maxProfitUpTo[i-1], jobs[i][1])
    }
    
    // Sort workers
    sort.Ints(worker)
    
    totalProfit := 0
    jobIndex := 0
    
    // For each worker, find the maximum profit they can get
    for _, ability := range worker {
        // Move jobIndex to the rightmost job with difficulty <= ability
        for jobIndex < n && jobs[jobIndex][0] <= ability {
            jobIndex++
        }
        
        if jobIndex > 0 {
            totalProfit += maxProfitUpTo[jobIndex-1]
        }
    }
    
    return totalProfit
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(n log n + m log m) - Sorting dominates the time complexity
- **Space**: O(n) - We create additional arrays to store job pairs and prefix maximums

## Link

[LeetCode 0826 Most Profit Assigning Work](https://leetcode.com/problems/most-profit-assigning-work/)