# 0760 Find Anagram Mappings

## Problem Description

You are given two integer arrays `nums1` and `nums2` where `nums2` is an anagram of `nums1`. Both arrays may contain duplicates.

Return an index mapping array `mapping` from `nums1` to `nums2` where `mapping[i] = j` means the ith element in `nums1` appears in `nums2` at index `j`. If there are multiple answers, return any of them.

### Example 1:
```
Input: nums1 = [12,28,46,32,50], nums2 = [50,12,32,46,28]
Output: [1,4,3,2,0]
Explanation: 
- nums1[0] = 12 appears at nums2[1]
- nums1[1] = 28 appears at nums2[4]
- nums1[2] = 46 appears at nums2[3]
- nums1[3] = 32 appears at nums2[2]
- nums1[4] = 50 appears at nums2[0]
```

### Example 2:
```
Input: nums1 = [84,46], nums2 = [84,46]
Output: [0,1]
```

## The Twist

Finding indices of elements **shifted between two arrays**. Since `nums2` is an anagram of `nums1`, we need to map each element from `nums1` to its corresponding position(s) in `nums2`.

## Hash Table Usage

- **Key**: `value` (the element value)
- **Value**: `[list_of_indices_in_nums2]` (all positions where this value appears in nums2)

Algorithm:
1. Build a map from `nums2` values to their indices
2. For each element in `nums1`, look up its indices in the map
3. Assign the first (or any) index from the list to the mapping array

## Complexity

- **Time**: O(n) - single pass to build map, single pass to create mapping
- **Space**: O(n) - storing indices for each value

## Link

[LeetCode 0760 Find Anagram Mappings](https://leetcode.com/problems/find-anagram-mappings/)
