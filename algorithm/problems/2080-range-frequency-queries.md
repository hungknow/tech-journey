# 2080 Range Frequency Queries

## Problem Description

Design a data structure to efficiently answer queries about the frequency of values in a range.

Implement the `RangeFreqQuery` class:

- `RangeFreqQuery(int[] arr)` Initializes the object with the given array `arr`.
- `int query(int left, int right, int value)` Returns the frequency of `value` in the inclusive range `[left, right]`.

### Example 1:
```
Input
["RangeFreqQuery","query","query","query","query","query"]
[[[12,33,4,56,22,2,34,33,22,12,34,33,22,12],[1,2,55],[0,11,22],[1,22,33],[2,33],[2,12]]
Output
[null,1,1,2,2]

Explanation
RangeFreqQuery rangeFreqQuery = new RangeFreqQuery([12,33,4,56,22,2,34,33,22,12,34,33,22,12]);
rangeFreqQuery.query(1, 2, 55); // return 1, the value 55 appears once in the range [1, 2]
rangeFreqQuery.query(0, 11, 22); // return 1, the value 22 appears once in the range [0, 11]
rangeFreqQuery.query(1, 22, 33); // return 2, the value 33 appears twice in the range [1, 22]
rangeFreqQuery.query(2, 12, 33); // return 2, the value 33 appears twice in the range [2, 12]
```

## The Twist

Implementing a data structure that efficiently counts the frequency of values in a range with support for dynamic updates.

## Algorithm

### HashMap + Prefix Sum Approach:
1. Use a HashMap to store the frequency of each value
2. Use a HashMap of HashMaps to store prefix frequencies for each value
3. For RangeFreqQuery(arr):
   - Build frequency map for the entire array
   - Build prefix frequency maps for each index
4. For query(left, right, value):
   - If left == 0, return frequency from the right index
   - Otherwise, calculate frequency as freq[right] - freq[left-1]

The key insight is using prefix frequency maps to efficiently calculate frequency in any range.

## Complexity

- **Time**: 
  - RangeFreqQuery constructor: O(n) where n is the length of the array
  - query: O(1)
- **Space**: O(n) where n is the length of the array

## Solution Code

```go
package main

type RangeFreqQuery struct {
	freq       map[int]int
	prefixFreq []map[int]int
}

func Constructor(arr []int) RangeFreqQuery {
	freq := make(map[int]int)
	prefixFreq := make([]map[int]int, len(arr))
	
	// Build frequency map
	for _, num := range arr {
		freq[num]++
	}
	
	// Build prefix frequency maps
	currentFreq := make(map[int]int)
	for i, num := range arr {
		currentFreq[num] = freq[num]
		prefixFreq[i] = make(map[int]int)
		for k, v := range currentFreq {
			prefixFreq[i][k] = v
		}
	}
	
	return RangeFreqQuery{
		freq:       freq,
		prefixFreq: prefixFreq,
	}
}

func (this *RangeFreqQuery) Query(left int, right int, value int) int {
	if left == 0 {
		if right >= len(this.prefixFreq) {
			return 0
		}
		return this.prefixFreq[right][value]
	}
	
	leftFreq := this.prefixFreq[left-1]
	rightFreq := this.prefixFreq[right]
	
	return rightFreq[value] - leftFreq[value]
}

/**
 * Your RangeFreqQuery object will be instantiated and called as such:
 * obj := Constructor(arr);
 * param_2 := obj.Query(left,right,value);
 */
```

## Link

[LeetCode 2080 Range Frequency Queries](https://leetcode.com/problems/range-frequency-queries/)