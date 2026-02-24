# 0187 Repeated DNA Sequences

## Problem Description

The DNA sequence is composed of a series of nucleotides abbreviated as `'A'`, `'C'`, `'G'`, and `'T'`.

Given a string `s` that represents a DNA sequence, return all the 10-letter-long sequences (substrings) that occur more than once in a DNA molecule. You may return the answer in any order.

### Example 1:
```
Input: s = "AAAAACCCCCAAAAACCCCCCAAAAAGGGTTT"
Output: ["AAAAACCCCC","CCCCCAAAAA"]
```

### Example 2:
```
Input: s = "AAAAAAAAAAAAA"
Output: ["AAAAAAAAAA"]
```

## The Twist

Searching for **10-character duplicates**. We need to efficiently track all 10-character substrings and identify those that appear more than once.

## Hash Table Usage

- **Key**: `dna_slice` (10-character substring)
- **Value**: `count` (how many times this slice has been seen)

Algorithm:
1. Iterate through the string, extracting 10-character slices
2. Store each slice in a hash set or map with its count
3. If a slice has been seen before (count >= 2), add it to results
4. Return all slices that appeared at least twice

Optimization: Use bit encoding to represent each nucleotide (A=00, C=01, G=10, T=11), allowing O(1) substring extraction using bit operations.

## Complexity

- **Time**: O(n) - single pass through the string
- **Space**: O(n) - storing up to n-9 unique slices

## Link

[LeetCode 0187 Repeated DNA Sequences](https://leetcode.com/problems/repeated-dna-sequences/)
