# Number of Nodes in the Sub-Tree With the Same Label

## Problem Description

You are given a tree (i.e. a connected, undirected graph that has no cycles) rooted at node `0` consisting of `n` nodes numbered from `0` to `n - 1`. The tree is represented by a 0-indexed array `parent` of size `n`, where `parent[i]` is the parent of node `i`. Since node `0` is the root, `parent[0] == -1`.

You are also given a string `s` of length `n`, where `s[i]` is the label assigned to node `i`.

Return an array of size `n` where `ans[i]` is the number of nodes in the subtree of the `i`th node which have the same label as node `i`.

**Example 1:**
```
Input: n = 7, edges = [[0,1],[0,2],[1,4],[1,5],[2,3],[2,6]], s = "abaedcd"
Output: [2,1,1,1,1,1,1]
```

**Example 2:**
```
Input: n = 4, edges = [[0,1],[1,2],[0,3]], s = "bbbb"
Output: [4,2,1,1]
```

**Example 3:**
```
Input: n = 5, edges = [[0,1],[0,2],[1,3],[1,4]], s = "aabab"
Output: [3,2,1,1,1]
```

**Constraints:**
- 1 <= n <= 10^5
- edges.length == n - 1
- edges[i].length == 2
- 0 <= ai, bi < n
- 0 <= i < n
- parent[0] == -1
- parent[i] == edges[i][0] for 0 < i < n
- s consists of only lowercase English letters.

## The Twist

This is a tree DFS problem where we need to count the number of nodes with the same label in each subtree. The key insight is to use post-order DFS to aggregate the count of each label from children to parent.

## Algorithm

### Approach: DFS with Post-Order Traversal

1. Build the tree adjacency list from the edges
2. Perform a post-order DFS starting from the root (node 0)
3. For each node, maintain a count array of size 26 (for each letter)
4. When visiting a node:
   - Initialize its count array with its own label
   - For each child, add the child's count array to the node's count array
   - The answer for the node is the count of its own label in its count array

```go
func countSubTrees(n int, edges [][]int, labels string) []int {
    // Build adjacency list
    adj := make([][]int, n)
    for _, edge := range edges {
        adj[edge[0]] = append(adj[edge[0]], edge[1])
        adj[edge[1]] = append(adj[edge[1]], edge[0])
    }
    
    ans := make([]int, n)
    dfs(0, -1, adj, labels, ans)
    return ans
}

func dfs(node, parent int, adj [][]int, labels string, ans []int) [26]int {
    count := [26]int{}
    count[labels[node]-'a'] = 1
    
    for _, child := range adj[node] {
        if child == parent {
            continue
        }
        childCount := dfs(child, node, adj, labels, ans)
        for i := 0; i < 26; i++ {
            count[i] += childCount[i]
        }
    }
    
    ans[node] = count[labels[node]-'a']
    return count
}
```

## Complexity

- **Time Complexity:** O(n * 26) = O(n) - We visit each node once and process 26 letters per node
- **Space Complexity:** O(n) - For the adjacency list and the recursion stack

## Link

[LeetCode 1519 - Number of Nodes in the Sub-Tree With the Same Label](https://leetcode.com/problems/number-of-nodes-in-the-sub-tree-with-the-same-label/)
