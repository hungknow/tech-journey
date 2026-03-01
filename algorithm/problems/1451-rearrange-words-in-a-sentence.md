# 1451 Rearrange Words in a Sentence

## Problem Description

Given a sentence `text` (A sentence is a string of space-separated words). A word consists of only English letters.

You need to rearrange the words in the sentence such that:
1. All words are rearranged according to their length in ascending order.
2. If two words have the same length, arrange them in their original order.

Return the rearranged sentence.

### Example 1:
```
Input: text = "Leetcode is cool"
Output: "Is cool leetcode"
Explanation: There are 3 words, "Leetcode" is of length 8, "is" is of length 2 and "cool" is of length 4.
The output is sorted by the length of words in ascending order.
```

### Example 2:
```
Input: text = "Keep calm and code"
Output: "Keep and calm code"
Explanation: The output is sorted by the length of words in ascending order.
```

## Solution Approach

We need to sort the words in the sentence by their length while maintaining the original order for words with the same length. This is a stable sorting problem.

## Algorithm

1. Split the sentence into words.
2. Create pairs of (word, original_index) for each word.
3. Sort these pairs using a stable sort based on word length:
   - Primary key: word length (ascending)
   - Since we're using a stable sort, words with the same length will maintain their original order.
4. Extract the words from the sorted pairs.
5. Join the words with spaces to form the result sentence.
6. Return the result.

## Alternative Algorithm (Without Stable Sort)

1. Split the sentence into words.
2. Create a list of tuples (length, original_index, word) for each word.
3. Sort this list using a custom comparator:
   - First compare by length.
   - If lengths are equal, compare by original index.
4. Extract the words from the sorted list.
5. Join the words with spaces to form the result sentence.
6. Return the result.

## Complexity

- **Time**: O(n log n) where n is the number of words
- **Space**: O(n) for storing the word-index pairs

## Link

[LeetCode 1451 Rearrange Words in a Sentence](https://leetcode.com/problems/rearrange-words-in-a-sentence/)