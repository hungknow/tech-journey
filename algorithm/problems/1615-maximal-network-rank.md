# 1615 Maximal Network Rank

## Problem Description

You are given `n` cities and a list of `roads` where `roads[i] = [ai, bi]` represents a bidirectional road between city `ai` and city `bi`.

The network rank of a city is the total number of roads that are directly connected to the city.

Return the maximal network rank of the city with the maximal network rank.

### Example 1:
```
Input: n = 4, roads = [[0,1],[0,3],[1,2],[1,3]]
Output: 4
```

### Example 2:
```
Input: n = 5, roads = [[0,1],[0,2],[2,3],[2,4]]
Output: 5
```

## Approach

This problem can be solved using counting:

1. **Degree Counting**:
   - Count the number of roads connected to each city
   - Track the maximum degree

2. **Maximum Network Rank**:
   - Find the city with the maximum degree
   - Return its degree as the network rank

3. **Efficient Implementation**:
   - Use an array to store degrees
   - Single pass through all roads to count connections

## Solution Code

```go
func maximalNetworkRank(n int, roads [][]int) int {
    if n == 0 {
        return 0
    }
    
    // Count degrees for each city
    degrees := make([]int, n)
    
    for _, road := range roads {
        a, b := road[0], road[1]
        degrees[a]++
        degrees[b]++
    }
    
    // Find the maximum degree
    maxRank := 0
    for _, degree := range degrees {
        if degree > maxRank {
            maxRank = degree
        }
    }
    
    return maxRank
}
```

## Complexity Analysis

- **Time**: O(n + m) where n is the number of cities and m is the number of roads
  - Counting degrees: O(m)
  - Finding maximum: O(n)
- **Space**: O(n) for the degrees array

## Link

[LeetCode 1615 Maximal Network Rank](https://leetcode.com/problems/maximal-network-rank/)