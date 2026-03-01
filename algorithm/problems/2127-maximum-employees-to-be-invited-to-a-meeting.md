# 2127 Maximum Employees to Be Invited to a Meeting

## Problem Description

You are given a list of `favorite` lists where `favorite[i]` is the favorite person of employee `i`.

An employee will attend a meeting if:
- Their favorite person is also attending, OR
- They are the favorite of someone attending

Return the maximum number of employees that can be invited to a meeting.

### Example 1:
```
Input: favorite = [2,2,1,2]
Output: 3
```

### Example 2:
```
Input: favorite = [1,2,0]
Output: 3
```

## Approach

This problem can be solved by analyzing the favorite graph structure:

1. **Graph Analysis**:
   - The favorite relationships form a directed graph
   - Each component can be a cycle or a chain leading to a cycle

2. **Cycle Detection**:
   - Find all cycles in the graph
   - For 2-person cycles, count chains extending from both ends
   - For longer cycles, count the cycle length

3. **Maximum Calculation**:
   - For 2-person cycles, sum the lengths of chains from both sides
   - For longer cycles, use the cycle length directly
   - Take the maximum of all possibilities

4. **DFS Traversal**:
   - Use DFS to explore each component
   - Track visited nodes to avoid cycles
   - Calculate maximum chain lengths

## Solution Code

```go
func maximumInvitations(favorite []int) int {
    n := len(favorite)
    if n == 0 {
        return 0
    }
    
    visited := make([]bool, n)
    maxCycle := 0
    twoCycleSum := 0
    
    for i := 0; i < n; i++ {
        if !visited[i] {
            cycle := []int{}
            current := i
            
            // Find cycle starting from current
            for !visited[current] {
                visited[current] = true
                cycle = append(cycle, current)
                current = favorite[current]
            }
            
            // Check if current is in the current cycle
            cycleStart := -1
            for j, node := range cycle {
                if node == current {
                    cycleStart = j
                    break
                }
            }
            
            if cycleStart != -1 {
                // Found a cycle
                cycleLength := len(cycle) - cycleStart
                
                if cycleLength == 2 {
                    // 2-person cycle, count chains
                    node1, node2 := cycle[cycleStart], cycle[cycleStart+1]
                    
                    // Count chain from node1 side
                    chain1 := 0
                    for j := 0; j < n; j++ {
                        if favorite[j] == node1 && j != node2 {
                            chain1 = max(chain1, countChain(j, node1, favorite))
                        }
                    }
                    
                    // Count chain from node2 side
                    chain2 := 0
                    for j := 0; j < n; j++ {
                        if favorite[j] == node2 && j != node1 {
                            chain2 = max(chain2, countChain(j, node2, favorite))
                        }
                    }
                    
                    twoCycleSum += 2 + chain1 + chain2
                } else {
                    // Longer cycle
                    maxCycle = max(maxCycle, cycleLength)
                }
            }
        }
    }
    
    return max(maxCycle, twoCycleSum)
}

func countChain(start, end int, favorite []int) int {
    length := 0
    current := start
    
    for current != end {
        length++
        next := favorite[current]
        if next == end {
            break
        }
        current = next
    }
    
    return length
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(N) where N is the number of employees
  - Each node is visited at most once
  - Chain counting is O(N) in total
- **Space**: O(N) for the visited array and cycle tracking

## Link

[LeetCode 2127 Maximum Employees to Be Invited to a Meeting](https://leetcode.com/problems/maximum-employees-to-be-invited-to-a-meeting/)