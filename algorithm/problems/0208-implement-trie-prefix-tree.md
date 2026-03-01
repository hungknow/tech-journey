# 0208 Implement Trie (Prefix Tree)

## Problem Description

A trie (pronounced as "try") or prefix tree is a tree data structure used to efficiently store and retrieve keys in a dataset of strings. There are various applications of this data structure, such as autocomplete and spellchecker.

Implement the `Trie` class:
- `Trie()` Initializes the trie object.
- `void insert(String word)` Inserts the string `word` into the trie.
- `boolean search(String word)` Returns `true` if the string `word` is in the trie (i.e., was inserted before), and `false` otherwise.
- `boolean startsWith(String prefix)` Returns `true` if there is any string in the trie that has `prefix` as a prefix, and `false` otherwise.

### Example 1:
```
Input
["Trie", "insert", "search", "search", "startsWith", "insert", "search"]
[[], ["apple"], ["apple"], ["app"], ["app"], ["app"], ["apple"], ["app"]]
Output
[null, null, false, true, null, true]
```

### Example 2:
```
Input
["Trie", "insert", "search", "search", "startsWith", "insert", "search"]
[[], ["hello"], ["hell"], ["hello"], ["hell"], ["hell"], ["hello"], ["hell"]]
Output
[null, null, false, true, null, true]
```

## The Twist

A **Trie is a tree-like data structure** where each node represents a character. The path from root to a node represents a prefix. This allows efficient prefix-based operations.

## Algorithm

### Trie Node Structure:
- Each node has:
  - `children`: array/map of 26 possible next characters
  - `is_end`: boolean flag indicating if this node completes a word

### Operations:
1. **Insert**: Traverse/create nodes for each character, mark final node as end
2. **Search**: Traverse nodes for each character, return is_end at final node
3. **StartsWith**: Traverse nodes for each character, return true if path exists

## Complexity

- **insert()**: O(m) - m is word length
- **search()**: O(m) - m is word length
- **startsWith()**: O(m) - m is prefix length
- **Space**: O(n * m) - storing all words

## Link

[LeetCode 0208 Implement Trie (Prefix Tree)](https://leetcode.com/problems/implement-trie-prefix-tree/)
