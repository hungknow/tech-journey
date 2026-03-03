# 0164 Maximum Gap

## Problem Description

Given an integer array `nums`, return the maximum difference between two successive elements in its sorted form. If the array contains less than two elements, return `0`.

You must write an algorithm that runs in linear time and uses linear extra space.

### Example 1:
```
Input: nums = [3,6,9,1]
Output: 3
Explanation: The sorted form of the array is [1,3,6,9], either (3,6) or (6,9) has the maximum difference 3.
```

### Example 2:
```
Input: nums = [10]
Output: 0
Explanation: The array contains less than 2 elements.
```

## Solution Approach

To achieve linear time complexity, we can use the Pigeonhole Principle with bucket sort. The key insight is that the maximum gap will occur between elements in different buckets, not within the same bucket.

## Algorithm

1. If the array has less than 2 elements, return 0.
2. Find the minimum and maximum values in the array.
3. Calculate the bucket size: `bucketSize = max(1, (max - min) / (n - 1))`.
4. Calculate the number of buckets: `bucketCount = (max - min) / bucketSize + 1`.
5. Initialize buckets to store the minimum and maximum values in each bucket.
6. Place each number in its corresponding bucket:
   - `bucketIndex = (num - min) / bucketSize`
   - Update the bucket's min and max values.
7. Find the maximum gap by comparing the difference between the min of the current bucket and the max of the previous non-empty bucket.
8. Return the maximum gap found.

## Complexity

- **Time**: O(n) - single pass to find min/max, another pass to place elements in buckets, and a final pass to find the maximum gap
- **Space**: O(n) - for the buckets

## Solution Code

```go
func maximumGap(nums []int) int {
	if len(nums) < 2 {
		return 0
	}
	minVal, maxVal := nums[0], nums[0]
	for _, v := range nums {
		if v < minVal {
			minVal = v
		}
		if v > maxVal {
			maxVal = v
		}
	}
	if maxVal == minVal {
		return 0
	}
	n := len(nums)
	bucketSize := (maxVal - minVal + n - 2) / (n - 1)
	minBucket := make([]int, n)
	maxBucket := make([]int, n)
	for i := range minBucket {
		minBucket[i] = 1<<31 - 1
		maxBucket[i] = -1
	}
	for _, v := range nums {
		idx := (v - minVal) / bucketSize
		if idx >= n {
			idx = n - 1
		}
		if v < minBucket[idx] {
			minBucket[idx] = v
		}
		if v > maxBucket[idx] {
			maxBucket[idx] = v
		}
	}
	maxGap := 0
	prevMax := minVal
	for i := 0; i < n; i++ {
		if maxBucket[i] == -1 {
			continue
		}
		if minBucket[i]-prevMax > maxGap {
			maxGap = minBucket[i] - prevMax
		}
		prevMax = maxBucket[i]
	}
	return maxGap
}
```

## Link

[LeetCode 0164 Maximum Gap](https://leetcode.com/problems/maximum-gap/)