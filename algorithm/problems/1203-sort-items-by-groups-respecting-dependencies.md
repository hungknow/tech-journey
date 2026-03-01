# 1203 Sort Items by Groups Respecting Dependencies

## Problem Description

You are given `n` items labeled from `0` to `n-1`, a 2D array `groupItems` where `groupItems[i] = [item, group]` means item `item` belongs to group `group`, and a 2D array `beforeItems` where `beforeItems[i] = [item, before]` means item `item` must come before item `before`.

Return a sorted list of the items respecting the group and before dependencies.

### Example 1:
```
Input: n = 8, groupItems = [[5,2],[3,0],[2,1],[4,1],[6,1],[7,0],[8,0]], beforeItems = [[5,3],[3,0],[2,6],[8,4],[6,7],[4,5],[7,2]]
Output: [5,3,2,4,6,7,8,0,1]
```

## Approach

This problem can be solved using topological sorting with custom comparison:

1. **Graph Construction**: Build a directed graph from beforeItems.

2. **Custom Topological Sort**: 
   - Use Kahn's algorithm with a custom comparison function
   - Items in the same group should be ordered together
   - Respect the before dependencies

3. **Group Handling**: 
   - Track which group each item belongs to
   - When comparing items from different groups, maintain their relative order

## Solution Code

```go
func sortItems(n int, groupItems [][]int, beforeItems [][]int) []int {
    // Build graph and in-degree array
    graph := make([][]int, n)
    inDegree := make([]int, n)
    group := make([]int, n)
    
    for _, item := range groupItems {
        itemID, groupID := item[0], item[1]
        group[itemID] = groupID
    }
    
    for _, before := range beforeItems {
        from, to := before[0], before[1]
        graph[from] = append(graph[from], to)
        inDegree[to]++
    }
    
    // Initialize queue with nodes having in-degree 0
    queue := []int{}
    for i := 0; i < n; i++ {
        if inDegree[i] == 0 {
            queue = append(queue, i)
        }
    }
    
    // Custom comparison function
    less := func(i, j int) bool {
        // If in same group, maintain relative order
        if group[i] == group[j] {
            return i < j
        }
        
        // If in different groups, maintain original order
        return i < j
    }
    
    // Process nodes in topological order
    result := []int{}
    for len(queue) > 0 {
        // Find the smallest element according to our custom comparison
        minIndex := 0
        for i := 1; i < len(queue); i++ {
            if less(queue[i], queue[minIndex]) {
                minIndex = i
            }
        }
        
        node := queue[minIndex]
        queue = append(queue[:minIndex], queue[minIndex+1:]...)
        result = append(result, node)
        
        // Reduce in-degree for all neighbors
        for _, neighbor := range graph[node] {
            inDegree[neighbor]--
            if inDegree[neighbor] == 0 {
                queue = append(queue, neighbor)
            }
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n² + n log n) where n is the number of items
  - Building graph: O(n)
  - Topological sort with custom comparison: O(n²) in worst case
- **Space**: O(n) for the graph, in-degree array, and result

## Link

[LeetCode 1203 Sort Items by Groups Respecting Dependencies](https://leetcode.com/problems/sort-items-by-groups-respecting-dependencies/)