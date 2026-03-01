# 0451 Sort Characters By Frequency

## Problem Description

Given a string `s`, sort it in decreasing order based on the frequency of the characters. The frequency of a character is the number of times it appears in the string.

Return the sorted string. If there are multiple answers, return any of them.

### Example 1:
```
Input: s = "tree"
Output: "eert"
Explanation: 'e' appears twice while 'r' and 't' both appear once.
So 'e' must appear before both 'r' and 't'. Therefore "eetr" is also a valid answer.
```

### Example 2:
```
Input: s = "cccaaa"
Output: "aaaccc"
Explanation: Both 'c' and 'a' appear three times, so any order of "aaaccc" and "cccaaa" is valid.
```

## Solution Approach

We need to count the frequency of each character and then sort the characters based on their frequency in descending order.

## Algorithm

1. Count the frequency of each character using a hash map.
2. Create a list of character-frequency pairs.
3. Sort this list by frequency in descending order.
4. Build the result string by repeating each character according to its frequency.
5. Return the result string.

## Alternative Algorithm (Bucket Sort)

1. Count the frequency of each character using a hash map.
2. Find the maximum frequency.
3. Create buckets where the index represents the frequency:
   - For each character, place it in the bucket corresponding to its frequency.
4. Iterate from the highest frequency bucket downwards:
   - For each character in the bucket, add it to the result string frequency times.
5. Return the result string.

## Complexity

- **Time**: O(n log n) for the sorting approach, O(n) for the bucket sort approach
- **Space**: O(n) for both approaches (hash map and buckets/sorted list)

## Link

[LeetCode 0451 Sort Characters By Frequency](https://leetcode.com/problems/sort-characters-by-frequency/)