# 1865 Finding Pairs With a Certain Sum

## Problem Description

You are given two integer arrays `nums1` and `nums2`. You need to find all pairs of values (one from each array) whose sum is equal to a given target value.

Implement the `FindSumPairs` class:

- `FindSumPairs(int[] nums1, int[] nums2)` Initializes the object with the two integer arrays.
- `void add(int index, int val)` Adds `val` to `nums1` at the given `index`.
- `int count(int total)` Returns the number of pairs (i, j) where `nums1[i] + nums2[j] == total`.

### Example 1:
```
Input
["FindSumPairs","count","count","count","count","add","count"]
[[[1,1,2,3],[1,2,3,4]],7,5,6,8,[1,2],[1],7]
Output
[null,8,5,4,0,null,8]

Explanation
FindSumPairs findSumPairs = new FindSumPairs([1,1,2,3], [1,2,3,4]);
findSumPairs.count(7);  // return 8; pairs are (1,6), (2,5), (3,4)
findSumPairs.count(5);  // return 5; pairs are (1,4), (2,3)
findSumPairs.count(6);  // return 4; pairs are (2,4), (3,3)
findSumPairs.count(8);  // return 0; no pairs sum to 8
findSumPairs.add(1,2); // now nums1 = [1,2,2,3]
findSumPairs.count(7);  // return 8; pairs are (1,6), (2,5), (2,5), (3,4)
```

## The Twist

Implementing a data structure that efficiently tracks pairs from two arrays that sum to a target value, with support for dynamic updates to one of the arrays.

## Algorithm

### HashMap + Frequency Tracking Approach:
1. Use a HashMap to count occurrences of each value in nums2
2. Maintain the sum of all elements in nums1 and the count of elements
3. For FindSumPairs(nums1, nums2):
   - Build frequency map for nums2
   - Calculate initial sums
4. For add(index, val):
   - Update the frequency map based on the change
   - Recalculate the sum and count
5. For count(total):
   - For each unique value in nums1:
     - Check if (total - value) exists in nums2
     - If yes, add (count[value] * frequency[total-value]) to the result

The key insight is using a frequency map for nums2 and efficiently calculating pair counts based on the frequency of complementary values.

## Complexity

- **Time**: 
  - FindSumPairs constructor: O(n1 + n2) where n1 and n2 are the lengths of the arrays
  - add: O(1) for updating frequency map
  - count: O(n1) where n1 is the length of nums1
- **Space**: O(n2) where n2 is the length of nums2

## Solution Code

```go
package main

type FindSumPairs struct {
	nums1     []int
	nums2Freq map[int]int
	sum       int
}

func Constructor(nums1 []int, nums2 []int) FindSumPairs {
	// Build frequency map for nums2
	nums2Freq := make(map[int]int)
	for _, num := range nums2 {
		nums2Freq[num]++
	}
	
	// Calculate initial sum
	sum := 0
	for _, num := range nums1 {
		sum += num
	}
	
	return FindSumPairs{
		nums1:     nums1,
		nums2Freq: nums2Freq,
		sum:       sum,
	}
}

func (this *FindSumPairs) Add(index int, val int)  {
	// Update sum
	this.sum += val - this.nums1[index]
	this.nums1[index] = val
}

func (this *FindSumPairs) Count(total int) int {
	count := 0
	
	for _, num1 := range this.nums1 {
		num2 := total - num1
		if freq, exists := this.nums2Freq[num2]; exists {
			count += freq
		}
	}
	
	return count
}

/**
 * Your FindSumPairs object will be instantiated and called as such:
 * obj := Constructor(nums1, nums2);
 * param_1 := obj.Add(index,val);
 * param_2 := obj.Count(total);
 */
```

## Link

[LeetCode 1865 Finding Pairs With a Certain Sum](https://leetcode.com/problems/finding-pairs-with-a-certain-sum/)