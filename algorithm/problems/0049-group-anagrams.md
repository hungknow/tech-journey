# 0049 Group Anagrams

## Problem Description

Given an array of strings `strs`, group the anagrams together. You can return the answer in any order.

An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.

### Example 1:
```
Input: strs = ["eat","tea","tan","ate","nat","bat"]
Output: [["bat"],["nat","tan"],["ate","eat","tea"]]
```

### Example 2:
```
Input: strs = [""]
Output: [[""]]
```

### Example 3:
```
Input: strs = ["a"]
Output: [["a"]]
```

## The Twist

Grouping **scrambled words**. We need to identify words that are anagrams of each other and group them together.

## Hash Table Usage

- **Key**: `signature` (either the sorted string or character count tuple)
- **Value**: `[list_of_original_words]` (all words with this signature)

Two common approaches for the signature key:
1. **Sorted string**: Sort the characters of each word - "eat" → "aet", "tea" → "aet"
2. **Character count tuple**: Count each character - "eat" → (1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0)

Algorithm:
1. For each word, compute its signature key
2. Use the key to group words in the hash map
3. Return all groups from the map

## Complexity

- **Time**: O(n * k log k) where n is number of words, k is average word length (for sorting approach)
- **Space**: O(n * k) - storing all words in the map

## Link

[LeetCode 0049 Group Anagrams](https://leetcode.com/problems/group-anagrams/)
