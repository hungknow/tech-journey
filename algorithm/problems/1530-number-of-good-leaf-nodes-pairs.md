# Number of Good Leaf Nodes Pairs

## Problem Description

You are given the `root` of a binary tree and an integer `distance`. A pair of different leaf nodes of a binary tree is said to be good if the length of the shortest path between them is less than or equal to `distance`.

Return the number of good leaf node pairs in the tree.

**Example 1:**
```
Input: root = [1,2,3,null,4], distance = 3
Output: 1
Explanation: The leaf nodes are nodes 3 and 4 and the length of the shortest path between them is 3. This is the only good pair.
```

**Example 2:**
```
Input: root = [1,2,3,4,5,6,7], distance = 3
Output: 2
Explanation: The good pairs are [4,5] and [6,7] with shortest path = 2. The pair [4,6] is not good because the length of the shortest path between them is 4.
```

**Example 3:**
```
Input: root = [7,1,4,6,null,5,3,null,null,null,null,null,2], distance = 3
Output: 1
Explanation: The only good pair is [2,5].
```

**Constraints:**
- The number of nodes in the tree is in the range [1, 2^10].
- Each node's value is between [1, 100].
- 1 <= distance <= 10

## The Twist

This is a tree problem where we need to count pairs of leaf nodes within a certain distance. The key insight is to use post-order DFS to return the distances of all leaf nodes in the subtree to the current node, then count pairs that satisfy the distance constraint.

## Algorithm

### Approach: Post-Order DFS

1. For each node, return an array where `distances[i]` is the number of leaf nodes at distance `i` from the current node
2. For a leaf node, return `[0, 1, 0, 0, ...]` (1 leaf at distance 0)
3. For an internal node:
   - Get the distance arrays from left and right children
   - Count good pairs by combining distances from left and right subtrees
   - Merge the distance arrays by incrementing each distance by 1
4. Return the total count of good pairs

```go
func countPairs(root *TreeNode, distance int) int {
    result := 0
    dfs(root, distance, &result)
    return result
}

func dfs(node *TreeNode, distance int, result *int) []int {
    if node == nil {
        return make([]int, distance+1)
    }
    
    if node.Left == nil && node.Right == nil {
        distances := make([]int, distance+1)
        distances[0] = 1
        return distances
    }
    
    leftDistances := dfs(node.Left, distance, result)
    rightDistances := dfs(node.Right, distance, result)
    
    // Count good pairs
    for i := 0; i <= distance; i++ {
        for j := 0; i+j+2 <= distance; j++ {
            *result += leftDistances[i] * rightDistances[j]
        }
    }
    
    // Merge distances
    distances := make([]int, distance+1)
    for i := 0; i < distance; i++ {
        distances[i+1] = leftDistances[i] + rightDistances[i]
    }
    
    return distances
}
```

## Complexity

- **Time Complexity:** O(n * d^2) - For each node, we potentially combine O(d^2) pairs of distances
- **Space Complexity:** O(n * d) - For the distance arrays at each level of the tree

## Link

[LeetCode 1530 - Number of Good Leaf Nodes Pairs](https://leetcode.com/problems/number-of-good-leaf-nodes-pairs/)
