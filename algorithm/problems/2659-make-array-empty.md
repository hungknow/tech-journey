# 2659 Make Array Empty

## Problem Description

You are given an integer array `nums`. An operation is defined as removing an element from the array.

Perform exactly `k` operations and return the array after all operations.

### Example 1:
```
Input: nums = [3,2,4,1], k = 2
Output: [4,2]
Explanation: 
Remove 2: [3,4,1]
Remove 1: [3,4]
Remaining array: [4,2]
```

### Example 2:
```
Input: nums = [1,2,3,4,5], k = 5
Output: []
Explanation: 
Remove 5 elements: [1,2,3,4,5]
Remaining array is empty.
```

## Solution Approach

We need to simulate k removal operations efficiently. This can be done using a frequency map or a min-heap.

## Algorithm

1. Count the frequency of each number in the array.
2. While `k > 0` and there are still elements to remove:
   - Find the most frequent element.
   - Remove one occurrence of this element.
   - Decrement `k` and update frequencies.
3. Return the array after all removals.

## Why This Works

By always removing the most frequent element, we ensure we minimize the number of operations needed to make the array empty.

## Complexity

- **Time**: O(n + k log n) - counting frequencies is O(n), each removal is O(log n) for heap operations
- **Space**: O(n) - for the frequency map

## Solution Code

```go
func countOperationsToEmptyArray(nums []int) int64 {
	pos := make(map[int]int)
	for i, v := range nums {
		pos[v] = i
	}
	sorted := make([]int, len(nums))
	copy(sorted, nums)
	sort.Ints(sorted)
	n := len(nums)
	bit := make([]int, n+1)
	add := func(i, delta int) {
		for i <= n {
			bit[i] += delta
			i += i & -i
		}
	}
	query := func(i int) int {
		s := 0
		for i > 0 {
			s += bit[i]
			i -= i & -i
		}
		return s
	}
	for i := 1; i <= n; i++ {
		add(i, 1)
	}
	var ans int64
	prev := 0
	for _, v := range sorted {
		cur := pos[v]
		cur1 := cur + 1
		prev1 := prev + 1
		dist := query(cur1) - query(prev1)
		if dist < 0 {
			dist += query(n)
		}
		ans += int64(dist + 1)
		add(cur1, -1)
		prev = cur
	}
	return ans
}
```

## Link

[LeetCode 2659 Make Array Empty](https://leetcode.com/problems/make-array-empty/)