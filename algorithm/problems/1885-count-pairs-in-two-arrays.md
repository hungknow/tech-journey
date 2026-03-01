# 1885 Count Pairs in Two Arrays

## Problem Description

Given two integer arrays `nums1` and `nums2` of length `n`, count the number of pairs of indices `(i, j)` such that `i < j` and `nums1[i] + nums2[j] > nums2[i] + nums1[j]`.

Return the number of such pairs.

### Example 1:
```
Input: nums1 = [1,10,6,2], nums2 = [1,4,1,5]
Output: 5
Explanation: The valid pairs are:
(0, 1): nums1[0] + nums2[1] = 1 + 4 = 5 > nums2[0] + nums1[1] = 1 + 10 = 11 (false)
(0, 2): nums1[0] + nums2[2] = 1 + 1 = 2 > nums2[0] + nums1[2] = 1 + 6 = 7 (false)
(0, 3): nums1[0] + nums2[3] = 1 + 5 = 6 > nums2[0] + nums1[3] = 1 + 2 = 3 (true)
(1, 2): nums1[1] + nums2[2] = 10 + 1 = 11 > nums2[1] + nums1[2] = 4 + 6 = 10 (true)
(1, 3): nums1[1] + nums2[3] = 10 + 5 = 15 > nums2[1] + nums1[3] = 4 + 2 = 6 (true)
(2, 3): nums1[2] + nums2[3] = 6 + 5 = 11 > nums2[2] + nums1[3] = 1 + 2 = 3 (true)
```

### Example 2:
```
Input: nums1 = [4,0,1,2], nums2 = [3,2,1,0]
Output: 6
```

## Two Pointers Approach

This problem can be simplified by rearranging the inequality:
`nums1[i] + nums2[j] > nums2[i] + nums1[j]`
is equivalent to:
`nums1[i] - nums2[i] > nums1[j] - nums2[j]`

So we need to count pairs `(i, j)` where `i < j` and `nums1[i] - nums2[i] > nums1[j] - nums2[j]`.

### Algorithm Steps:

1. Create a new array `diff` where `diff[i] = nums1[i] - nums2[i]`
2. Sort the `diff` array
3. For each element `diff[i]`, count how many elements after it are smaller:
   - Use binary search to find the first element smaller than `diff[i]`
   - The number of valid pairs for this element is the count of smaller elements
4. Sum up all valid pairs

## Complexity

- **Time**: O(n log n) - sorting and binary search for each element
- **Space**: O(n) - space for the diff array

## Solution Code

```go
package main

import "sort"

func countPairs(nums1 []int, nums2 []int) int64 {
    n := len(nums1)
    diff := make([]int, n)
    
    // Calculate the difference array
    for i := 0; i < n; i++ {
        diff[i] = nums1[i] - nums2[i]
    }
    
    // Sort the difference array
    sort.Ints(diff)
    
    var result int64
    
    // For each element, count how many elements after it are smaller
    for i := 0; i < n; i++ {
        // Binary search for the first element smaller than diff[i]
        left, right := i+1, n-1
        count := 0
        
        for left <= right {
            mid := left + (right-left)/2
            if diff[mid] < diff[i] {
                count = mid - i
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        
        result += int64(count)
    }
    
    return result
}
```

## Alternative Approach (Fenwick Tree)

An alternative approach is to use a Fenwick Tree (Binary Indexed Tree) to efficiently count smaller elements after each position.

## Alternative Solution Code

```go
package main

func countPairs(nums1 []int, nums2 []int) int64 {
    n := len(nums1)
    diff := make([]int, n)
    
    // Calculate the difference array
    for i := 0; i < n; i++ {
        diff[i] = nums1[i] - nums2[i]
    }
    
    // Coordinate compression
    unique := make(map[int]int)
    sortedDiff := make([]int, n)
    copy(sortedDiff, diff)
    sort.Ints(sortedDiff)
    
    rank := 1
    for _, val := range sortedDiff {
        if unique[val] == 0 {
            unique[val] = rank
            rank++
        }
    }
    
    // Fenwick Tree implementation
    fenwick := make([]int, rank+1)
    
    // Process from right to left
    var result int64
    for i := n - 1; i >= 0; i-- {
        currentRank := unique[diff[i]]
        
        // Query for count of elements smaller than current
        count := query(fenwick, currentRank-1)
        result += int64(count)
        
        // Update Fenwick Tree
        update(fenwick, currentRank, 1)
    }
    
    return result
}

func update(fenwick []int, index, value int) {
    for index < len(fenwick) {
        fenwick[index] += value
        index += index & (-index)
    }
}

func query(fenwick []int, index int) int {
    result := 0
    for index > 0 {
        result += fenwick[index]
        index -= index & (-index)
    }
    return result
}
```

## Link

[LeetCode 1885 Count Pairs in Two Arrays](https://leetcode.com/problems/count-pairs-in-two-arrays/)