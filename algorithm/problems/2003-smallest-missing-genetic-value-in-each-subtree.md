# Smallest Missing Genetic Value in Each Subtree

## Problem Description

There is a family tree rooted at node 0 consisting of `n` nodes numbered from `0` to `n - 1`. You are given a 0-indexed integer array `parents`, where `parents[i]` is the parent of node `i`. Since node 0 is the root, `parents[0] == -1`.

You are also given a 0-indexed integer array `nums`, where `nums[i]` is the genetic value of node `i`.

Return an array `ans` of length `n`, where `ans[i]` is the smallest missing genetic value in the subtree rooted at node `i`.

**Example 1:**
```
Input: parents = [-1,0,1,0,3,3], nums = [5,4,6,2,1,3]
Output: [7,1,1,4,2,1]
Explanation:
- Subtree rooted at node 0 contains nodes [0,1,2,3,4,5] with values [5,4,6,2,1,3]. The smallest missing positive integer is 7.
- Subtree rooted at node 1 contains nodes [1,2] with values [4,6]. The smallest missing positive integer is 1.
- Subtree rooted at node 2 contains only node 2 with value 6. The smallest missing positive integer is 1.
- Subtree rooted at node 3 contains nodes [3,4,5] with values [2,1,3]. The smallest missing positive integer is 4.
- Subtree rooted at node 4 contains only node 4 with value 1. The smallest missing positive integer is 2.
- Subtree rooted at node 5 contains only node 5 with value 3. The smallest missing positive integer is 1.
```

**Example 2:**
```
Input: parents = [-1,0,0,2], nums = [1,2,3,4]
Output: [5,1,1,1]
```

**Constraints:**
- n == parents.length == nums.length
- 2 <= n <= 10^5
- 0 <= parents[i] <= n - 1 for i != 0
- parents[0] == -1
- 1 <= nums[i] <= 10^5
- The values of nums are distinct.

## The Twist

This is a tree problem where we need to find the smallest missing positive integer in each subtree. The key insight is that the answer for most nodes will be 1, except for nodes on the path from the root to the node with value 1. We only need to process this path efficiently.

## Algorithm

### Approach: DFS with Hash Set

1. Build the tree adjacency list from the parents array
2. Find the node with value 1
3. Identify all nodes on the path from the root to the node with value 1
4. For nodes not on this path, the answer is 1 (since 1 is not in their subtree)
5. For nodes on this path, use DFS with a hash set to find the smallest missing positive integer

```go
func smallestMissingValueSubtree(parents []int, nums []int) []int {
    n := len(parents)
    ans := make([]int, n)
    
    // Build adjacency list
    adj := make([][]int, n)
    for i := 1; i < n; i++ {
        adj[parents[i]] = append(adj[parents[i]], i)
    }
    
    // Find node with value 1
    oneNode := -1
    for i, num := range nums {
        if num == 1 {
            oneNode = i
            break
        }
    }
    
    // If no node has value 1, all answers are 1
    if oneNode == -1 {
        for i := range ans {
            ans[i] = 1
        }
        return ans
    }
    
    // Find path from root to oneNode
    path := make([]int, 0)
    node := oneNode
    for node != -1 {
        path = append(path, node)
        node = parents[node]
    }
    
    // For nodes not on the path, answer is 1
    for i := range ans {
        ans[i] = 1
    }
    
    // Process nodes on the path
    visited := make(map[int]bool)
    missing := 1
    
    for _, node := range path {
        dfs(node, adj, nums, visited)
        for visited[missing] {
            missing++
        }
        ans[node] = missing
    }
    
    return ans
}

func dfs(node int, adj [][]int, nums []int, visited map[int]bool) {
    if visited[nums[node]] {
        return
    }
    visited[nums[node]] = true
    
    for _, child := range adj[node] {
        dfs(child, adj, nums, visited)
    }
}
```

## Complexity

- **Time Complexity:** O(n) - We visit each node at most once during DFS
- **Space Complexity:** O(n) - For the adjacency list, path, and visited set

## Link

[LeetCode 2003 - Smallest Missing Genetic Value in Each Subtree](https://leetcode.com/problems/smallest-missing-genetic-value-in-each-subtree/)
