# 1065 Index Pairs of a String

## Problem Description

Given a string `text` and a string `words`, return all index pairs `[i, j]` such that `text[i]` and `text[j]` are in `words`.

Note that you may reuse `words[i]` and `words[j]` multiple times.

### Example 1:
```
Input: text = "thestoryofleetcodeandme", words = ["story","fleet","leetcode"]
Output: [[3,0],[9,13],[14,10],[19,23]]
```

### Example 2:
```
Input: text = "ababa", words = ["aba"]
Output: [[0,1],[0,2],[0,3],[1,2]]
```

## The Twist

We need to find **all occurrences** of words in `text` and return their index pairs. A naive O(n * m * k) approach would be too slow for multiple queries.

## Algorithm

### Aho-Corasick Automaton:
1. Build an Aho-Corasick automaton from the words
2. For each word, add it to the automaton with its ending node marked
3. Traverse the text through the automaton
4. For each position where a word ends, record the index pair
5. Return all recorded index pairs

### Trie with Position Tracking:
1. Build a trie from the words
2. For each starting position in text:
   - Traverse the trie with the text
   - When a word end node is reached, record the index pair
3. Return all recorded index pairs

## Complexity

- **Time**: O(n * m + z) - n is text length, m is total word length, z is total matches
- **Space**: O(n * m) - storing the automaton or trie

## Link

[LeetCode 1065 Index Pairs of a String](https://leetcode.com/problems/index-pairs-of-a-string/)
