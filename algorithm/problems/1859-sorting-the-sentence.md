# 1859 Sorting the Sentence

## Problem Description

A sentence is a list of words separated by single spaces with no leading or trailing spaces. Each word consists of lowercase and uppercase English letters.

You are given a string `s` containing a sentence. The words in the sentence are sorted lexicographically.

Return the sorted sentence.

### Example 1:
```
Input: s = "is2 sentence4 this1 a3"
Output: "a3 is2 sentence4 this1"
Explanation: 
The words are ["is2","sentence4","this1","a3"].
Sorted lexicographically: ["a3","is2","sentence4","this1"].
```

### Example 2:
```
Input: s = "My name is john"
Output: "My name is john"
Explanation: 
The words are ["My","name","is","john"].
Sorted lexicographically: ["My","is","john","name"].
```

## Solution Approach

We need to sort the words in the sentence lexicographically. This can be done by splitting the sentence into words and sorting them.

## Algorithm

1. Split the sentence into words.
2. Sort the words lexicographically.
3. Join the sorted words with spaces.
4. Return the result.

## Why This Works

By splitting and sorting the words, we get the desired lexicographical order.

## Complexity

- **Time**: O(n log n) where n is the number of words
- **Space**: O(n) - for storing the words

## Link

[LeetCode 1859 Sorting the Sentence](https://leetcode.com/problems/sorting-the-sentence/)