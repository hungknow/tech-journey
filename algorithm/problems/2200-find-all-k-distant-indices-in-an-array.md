# 2200 Find All K-Distant Indices in an Array

## Problem Description

You are given a 0-indexed integer array `nums` and two integers `key` and `k`. A k-distant index is an index `i` such that there exists at least one index `j` where `|i - j| <= k` and `nums[j] == key`.

Return a list of all k-distant indices sorted in increasing order.

### Example 1:
```
Input: nums = [3,4,9,1,3,9,5], key = 9, k = 1
Output: [1,2,3,4,5,6]
Explanation: The indices where nums[j] == 9 are 2 and 5.
For index 0: |0 - 2| > k and |0 - 5| > k, so 0 is not a k-distant index.
For index 1: |1 - 2| <= k, so 1 is a k-distant index.
For index 2: |2 - 2| <= k, so 2 is a k-distant index.
For index 3: |3 - 2| <= k, so 3 is a k-distant index.
For index 4: |4 - 5| <= k, so 4 is a k-distant index.
For index 5: |5 - 5| <= k, so 5 is a k-distant index.
For index 6: |6 - 5| <= k, so 6 is a k-distant index.
```

### Example 2:
```
Input: nums = [2,2,2,2,2], key = 2, k = 2
Output: [0,1,2,3,4]
Explanation: All indices are k-distant indices because every index has a key within distance k.
```

## Approach

This problem can be solved using a sliding window approach:

1. First, find all indices where `nums[j] == key`.
2. For each index `i` in the array, check if there exists a key index `j` such that `|i - j| <= k`.
3. To efficiently check this, we can use a sliding window approach:
   - Sort the key indices.
   - For each index `i`, use binary search to find if there's a key index within distance `k`.

## Solution Code

```go
func findKDistantIndices(nums []int, key int, k int) []int {
    n := len(nums)
    var keyIndices []int
    
    // Find all indices where nums[j] == key
    for j := 0; j < n; j++ {
        if nums[j] == key {
            keyIndices = append(keyIndices, j)
        }
    }
    
    var result []int
    
    // For each index i, check if there's a key index within distance k
    for i := 0; i < n; i++ {
        found := false
        
        // Check each key index
        for _, j := range keyIndices {
            if abs(i-j) <= k {
                found = true
                break
            }
        }
        
        if found {
            result = append(result, i)
        }
    }
    
    return result
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

## Complexity Analysis

- **Time**: O(n * m) - For each index, we check all key indices, where m is the number of key indices
- **Space**: O(m) - We store the key indices

## Link

[LeetCode 2200 Find All K-Distant Indices in an Array](https://leetcode.com/problems/find-all-k-distant-indices-in-an-array/)