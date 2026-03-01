# 0677 Map Sum Pairs

## Problem Description

Design a map that allows you to do the following:
- `insert(String key, int val)` - Inserts the key-val pair into the map. If the key already existed, the original key-val pair will be overridden to the new one.
- `int sum(String prefix)` - Returns the sum of all the pairs' value such that the key starts with `prefix`.

### Example 1:
```
Input
["MapSum", "insert", "sum", "insert", "sum"]
[[], ["apple",3], ["ap"], ["app",2], ["ap"]]
Output
[null, null, 3, null, 5]
```

### Example 2:
```
Input
["MapSum", "insert", "sum", "insert", "sum", "insert", "sum"]
[[], ["a",3], ["ap"], ["b",2], ["a"], ["aa",3], ["a"]]
Output
[null, null, 3, null, 8, null, 3]
```

## The Twist

We need to efficiently **find all keys with a given prefix** and sum their values. A simple linear scan would be too slow for multiple queries.

## Algorithm

### Trie with Value Storage:
1. Use a trie where each node stores:
   - Children for each possible character
   - Sum of all values in the subtree
2. **Insert**: Traverse the trie, creating nodes as needed, add val to all nodes on the path
3. **Sum**: Traverse the trie following the prefix, return the sum at the final node

## Complexity

- **insert()**: O(m) - m is key length
- **sum()**: O(m) - m is prefix length
- **Space**: O(n * m) - storing all keys

## Link

[LeetCode 0677 Map Sum Pairs](https://leetcode.com/problems/map-sum-pairs/)
