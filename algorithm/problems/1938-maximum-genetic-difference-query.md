# Maximum Genetic Difference Query

## Problem Description

There is a tree family of `n` nodes, numbered from `0` to `n - 1`. Node `i`'s parent is `parent[i]`. The root of the tree is node `0`.

You are given a 2D integer array `queries` of length `m`, where `queries[j] = [nodej, valj]`. For each query `j`, find the maximum genetic difference between `valj` and `valx` where `x` is a node in the subtree of `nodej` (including `nodej` itself).

Return an array `ans` of length `m` where `ans[j]` is the answer to the `j`th query.

**Example 1:**
```
Input: parent = [-1,0,1,0], queries = [[0,2],[3,2]]
Output: [2,3]
Explanation: 
- Query 0: Node 0's subtree includes nodes 0, 1, 3. The maximum XOR with 2 is 2 XOR 0 = 2.
- Query 1: Node 3's subtree includes only node 3. The maximum XOR with 2 is 2 XOR 3 = 3.
```

**Example 2:**
```
Input: parent = [3,7,-1,2,0,7,0,2], queries = [[4,3],[3,7],[5,3],[5,6],[1,15]]
Output: [6,5,5,6,15]
```

**Constraints:**
- n == parent.length
- 2 <= n <= 10^5
- 0 <= parent[i] <= n - 1 for all i != 0
- parent[0] == -1
- 1 <= queries.length <= 10^5
- 0 <= nodej <= n - 1
- 0 <= valj <= 2 * 10^5

## The Twist

This is a variant of the "Maximum XOR With an Element From Array" problem applied to tree subtrees. The key insight is to use a Trie to efficiently find the maximum XOR with any value in a subtree, and use DFS with a "enter/exit" pattern to maintain the active set of nodes.

## Algorithm

### Approach: DFS with Trie

1. Build the tree adjacency list from the parent array
2. Group queries by their node
3. Use a Trie to store the values of nodes in the current subtree
4. Perform DFS with a "enter/exit" pattern:
   - When entering a node, add its value to the Trie
   - Process all queries for this node using the Trie to find maximum XOR
   - When exiting a node, remove its value from the Trie
5. Return the answers

```go
func maxGeneticDifference(parent []int, queries [][]int) []int {
    n := len(parent)
    
    // Build adjacency list
    adj := make([][]int, n)
    for i := 1; i < n; i++ {
        adj[parent[i]] = append(adj[parent[i]], i)
    }
    
    // Group queries by node
    queryMap := make(map[int][][2]int)
    for i, q := range queries {
        node, val := q[0], q[1]
        queryMap[node] = append(queryMap[node], [2]int{val, i})
    }
    
    // Trie
    trie := NewTrie()
    
    // DFS
    ans := make([]int, len(queries))
    dfs(0, adj, queryMap, trie, ans)
    
    return ans
}

func dfs(node int, adj [][]int, queryMap map[int][][2]int, trie *Trie, ans []int) {
    // Enter node: add value to trie
    trie.Insert(node)
    
    // Process queries for this node
    for _, q := range queryMap[node] {
        val, idx := q[0], q[1]
        ans[idx] = trie.Query(val)
    }
    
    // Visit children
    for _, child := range adj[node] {
        dfs(child, adj, queryMap, trie, ans)
    }
    
    // Exit node: remove value from trie
    trie.Remove(node)
}

type TrieNode struct {
    children [2]*TrieNode
    count    int
}

type Trie struct {
    root *TrieNode
}

func NewTrie() *Trie {
    return &Trie{
        root: &TrieNode{},
    }
}

func (t *Trie) Insert(val int) {
    node := t.root
    for i := 18; i >= 0; i-- {
        bit := (val >> i) & 1
        if node.children[bit] == nil {
            node.children[bit] = &TrieNode{}
        }
        node = node.children[bit]
        node.count++
    }
}

func (t *Trie) Remove(val int) {
    node := t.root
    for i := 18; i >= 0; i-- {
        bit := (val >> i) & 1
        node = node.children[bit]
        node.count--
    }
}

func (t *Trie) Query(val int) int {
    node := t.root
    result := 0
    for i := 18; i >= 0; i-- {
        bit := (val >> i) & 1
        toggle := 1 - bit
        if node.children[toggle] != nil && node.children[toggle].count > 0 {
            result |= (1 << i)
            node = node.children[toggle]
        } else {
            node = node.children[bit]
        }
    }
    return result
}
```

## Complexity

- **Time Complexity:** O((n + m) * log(maxVal)) - For each node and query, we perform O(log(maxVal)) operations on the Trie
- **Space Complexity:** O(n * log(maxVal)) - For the Trie

## Link

[LeetCode 1938 - Maximum Genetic Difference Query](https://leetcode.com/problems/maximum-genetic-difference-query/)
