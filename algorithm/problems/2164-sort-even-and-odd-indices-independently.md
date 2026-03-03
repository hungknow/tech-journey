# 2164 Sort Even and Odd Indices Independently

## Problem Description

You are given an integer array `nums`. Sort the array in the following way:

1. Sort the elements at even indices in non-decreasing order.
2. Sort the elements at odd indices in non-increasing order.

Return the sorted array.

### Example 1:
```
Input: nums = [4,1,2,3]
Output: [2,1,4,3]
Explanation: 
Even indices: 0, 2 → [4,2] sorted to [2,4]
Odd indices: 1, 3 → [1,3] sorted to [1,3]
Result: [2,1,4,3]
```

### Example 2:
```
Input: nums = [2,3]
Output: [2,3]
Explanation: 
Even indices: 0 → [2]
Odd indices: 1 → [3]
Result: [2,3]
```

## Solution Approach

We need to sort the even and odd indexed elements independently and then merge them back into their original positions.

## Algorithm

1. Extract elements at even indices into one list.
2. Extract elements at odd indices into another list.
3. Sort the even-indexed list in non-decreasing order.
4. Sort the odd-indexed list in non-increasing order.
5. Merge the two lists back into the original array:
   - For each position from 0 to n-1:
     - If the position is even, take the next element from the even-indexed list.
     - Otherwise, take the next element from the odd-indexed list.
6. Return the merged array.

## Why This Works

By separating even and odd indexed elements and sorting them independently, we achieve the desired sorting pattern.

## Complexity

- **Time**: O(n log n) - sorting the two subarrays
- **Space**: O(n) - for storing the two subarrays

## Solution Code

```go
func sortEvenOdd(nums []int) []int {
	var even, odd []int
	for i, v := range nums {
		if i%2 == 0 {
			even = append(even, v)
		} else {
			odd = append(odd, v)
		}
	}
	sort.Ints(even)
	sort.Slice(odd, func(i, j int) bool { return odd[i] > odd[j] })
	for i := range nums {
		if i%2 == 0 {
			nums[i] = even[i/2]
		} else {
			nums[i] = odd[i/2]
		}
	}
	return nums
}
```

## Link

[LeetCode 2164 Sort Even and Odd Indices Independently](https://leetcode.com/problems/sort-even-and-odd-indices-independently/)