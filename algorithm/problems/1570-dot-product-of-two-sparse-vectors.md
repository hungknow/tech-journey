# 1570 Dot Product of Two Sparse Vectors

## Problem Description

Given two sparse vectors `v1` and `v2`, each represented as a list of non-zero indices and their corresponding values, return the dot product of the two vectors.

Follow up: What if only one of the vectors is sparse?

### Example 1:
```
Input: nums1 = [1,0,0,2,3], nums2 = [0,0,0,0,0]
Output: 0
Explanation: nums1 and nums2 are both sparse vectors, their dot product should be 0.
```

### Example 2:
```
Input: nums1 = [0,1,0,0,0], nums2 = [0,0,0,0,2]
Output: 0
Explanation: nums1 is a sparse vector, nums2 is not. Their dot product is 0.
```

### Example 3:
```
Input: nums1 = [0,1,0,0,2,0,0], nums2 = [1,0,0,0,3,0,4]
Output: 6
```

## The Twist

Implementing a sparse vector representation that efficiently computes the dot product by only considering non-zero elements.

## Algorithm

### HashMap Approach:
1. Store only non-zero elements and their indices in a HashMap
2. For SparseVector(nums):
   - Iterate through the input array
   - Store non-zero elements in the HashMap with their indices as keys
3. For dotProduct(vec):
   - Determine which vector is smaller (fewer non-zero elements)
   - Iterate through the smaller vector's non-zero elements
   - For each element, check if the same index exists in the other vector
   - Multiply the corresponding values and add to the result
   - Return the total

The key insight is only processing non-zero elements and iterating through the smaller vector for efficiency.

## Complexity

- **Time**: 
  - SparseVector constructor: O(n) where n is the length of the vector
  - dotProduct: O(min(k1, k2)) where k1 and k2 are the number of non-zero elements
- **Space**: O(k) where k is the number of non-zero elements

## Solution Code

```go
package main

type SparseVector struct {
	nonZero map[int]int
}

func Constructor(nums []int) SparseVector {
	nonZero := make(map[int]int)
	for i, val := range nums {
		if val != 0 {
			nonZero[i] = val
		}
	}
	
	return SparseVector{
		nonZero: nonZero,
	}
}

func (this *SparseVector) DotProduct(vec SparseVector) int {
	// Iterate through the smaller vector
	if len(this.nonZero) < len(vec.nonZero) {
		result := 0
		for i, val1 := range this.nonZero {
			if val2, exists := vec.nonZero[i]; exists {
				result += val1 * val2
			}
		}
		return result
	} else {
		result := 0
		for i, val2 := range vec.nonZero {
			if val1, exists := this.nonZero[i]; exists {
				result += val1 * val2
			}
		}
		return result
	}
}

/**
 * Your SparseVector object will be instantiated and called as such:
 * obj := Constructor(nums);
 * param_1 := obj.DotProduct(vec);
 */
```

## Link

[LeetCode 1570 Dot Product of Two Sparse Vectors](https://leetcode.com/problems/dot-product-of-two-sparse-vectors/)