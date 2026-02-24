# 0244 Shortest Word Distance II

## Problem Description

Design a class that receives a list of words in the constructor and implements a method that takes two words `word1` and `word2` and returns the shortest distance between these two words in the list.

### Example 1:
```
Input: 
WordDistance(["practice", "makes", "perfect", "coding", "makes"])
shortest("coding", "practice") → 3
shortest("makes", "coding") → 1
```

### Example 2:
```
Input: 
WordDistance(["a","b","c","d","d"])
shortest("a","d") → 3
shortest("d","a") → 3
```

## The Twist

We need to efficiently answer multiple distance queries. Preprocessing the word positions allows O(a + b) lookup time where a and b are the frequencies of the two words.

## Hash Table Usage

- **Key**: `word` (a word from the list)
- **Value**: `[list_of_indices]` (all positions where this word appears)

Algorithm:
1. Constructor: Build a map from each word to its list of indices
2. shortest(word1, word2):
   - Get the two index lists
   - Use two pointers to find the minimum difference between any pair of indices
   - Return the minimum distance

## Complexity

- **Time**: O(n) for constructor, O(a + b) for each query
- **Space**: O(n) - storing all word indices

## Link

[LeetCode 0244 Shortest Word Distance II](https://leetcode.com/problems/shortest-word-distance-ii/)
