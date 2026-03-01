# 0211 Add and Search Word - Data Structure Design

## Problem Description

Design a data structure that supports adding new words and finding if a string matches any previously added string.

Implement the `WordDictionary` class:
- `WordDictionary()` Initializes the object.
- `void addWord(word)` Adds `word` to the data structure, it can be matched later.
- `bool search(word)` Returns `true` if there is any string in the data structure that matches `word` or `false` otherwise. `word` may contain dots `'.'` where a dot can match any letter.

### Example 1:
```
Input
["WordDictionary","addWord","addWord","addWord","search","search","search","search"]
[[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."]]
Output
[null,null,null,null,false,true,true,true]
```

### Example 2:
```
Input
["WordDictionary","addWord","addWord","search","search","search","search","search","search"]
[[],["a"],["a"],["."],["a"],["aa"],["a"],[".a"],["a."]]
Output
[null,null,null,true,false,false,true,false,false]
```

## The Twist

The `search` method supports **wildcard dots** that can match any letter. This requires backtracking when encountering a dot to try all possible children.

## Algorithm

### Trie with DFS:
1. Use a Trie where each node has children (26 letters) and is_end flag
2. `addWord`: Traverse/create nodes for each character, mark end
3. `search`: Use DFS
   - If character is a letter: follow that child
   - If character is a dot: try all non-null children recursively
   - Return true if any path leads to a word end

## Complexity

- **addWord()**: O(m) - m is word length
- **search()**: O(26^m) worst case (all dots), O(m) average case
- **Space**: O(n * m) - storing all words

## Link

[LeetCode 0211 Add and Search Word - Data Structure Design](https://leetcode.com/problems/add-and-search-word-data-structure-design/)
