# 1656 Design an Ordered Stream

## Problem Description

Design a stream that returns the values in increasing order of their IDs. The stream should initially be empty and should support the following operations:

- `OrderedStream(int n)` Initializes the stream with a capacity of `n`.
- `int[] insert(int idKey, string value)` Inserts a new `(idKey, value)` pair into the stream. If the stream has no gap before this insertion, returns the longest contiguous chunk of values starting from ID 1. Otherwise, returns an empty list.

### Example 1:
```
Input
["OrderedStream","insert","insert","insert","insert","insert"]
[[5],[3,"ccccc"],[1,"aaaaa"],[2,"bbbbb"],[5,"eeeee"],[4,"ddddd"]]
Output
[null,[],["aaaaa"],["bbbbb","ccccc"],[],["ddddd","eeeee"]]

Explanation
OrderedStream os = new OrderedStream(5);
os.insert(3, "ccccc"); // Inserts (3, "ccccc"), returns [] because there's a gap before ID 3.
os.insert(1, "aaaaa"); // Inserts (1, "aaaaa"), returns ["aaaaa"] because ID 1 is the first with no gaps.
os.insert(2, "bbbbb"); // Inserts (2, "bbbbb"), returns ["bbbbb", "ccccc"] because IDs 1, 2, and 3 are now contiguous.
os.insert(5, "eeeee"); // Inserts (5, "eeeee"), returns [] because there's a gap before ID 5.
os.insert(4, "ddddd"); // Inserts (4, "ddddd"), returns ["ddddd", "eeeee"] because IDs 4 and 5 are now contiguous.
```

## The Twist

Implementing an ordered stream that efficiently tracks inserted values and returns the longest contiguous chunk starting from ID 1.

## Algorithm

### Array with Pointer Approach:
1. Use an array to store values at their respective ID positions
2. Maintain a pointer to track the next expected ID
3. For OrderedStream(n):
   - Initialize an array of size n+1 (1-indexed)
   - Set the pointer to 1
4. For insert(idKey, value):
   - Store the value at position idKey
   - If idKey == nextExpected:
     - Collect all consecutive values starting from nextExpected
     - Update nextExpected to the first missing ID
     - Return the collected values
   - Otherwise, return empty list

The key insight is using an array to store values at their ID positions and tracking the next expected ID to efficiently return contiguous chunks.

## Complexity

- **Time**: 
  - OrderedStream constructor: O(n) where n is the capacity
  - insert: O(k) where k is the size of the returned chunk (in the worst case O(n))
- **Space**: O(n) where n is the capacity

## Solution Code

```go
package main

type OrderedStream struct {
	values      []string
	ptr         int
	capacity    int
}

func Constructor(n int) OrderedStream {
	return OrderedStream{
		values:   make([]string, n+1), // 1-indexed
		ptr:      1,
		capacity: n,
	}
}

func (this *OrderedStream) Insert(idKey int, value string) []string {
	// Store the value
	this.values[idKey] = value
	
	// If this is the next expected ID, collect consecutive values
	if idKey == this.ptr {
		result := make([]string, 0)
		
		// Collect consecutive values
		for this.ptr <= this.capacity && this.values[this.ptr] != "" {
			result = append(result, this.values[this.ptr])
			this.ptr++
		}
		
		return result
	}
	
	// Otherwise, return empty list
	return []string{}
}

/**
 * Your OrderedStream object will be instantiated and called as such:
 * obj := Constructor(n);
 * param_1 := obj.Insert(idKey,value);
 */
```

## Link

[LeetCode 1656 Design an Ordered Stream](https://leetcode.com/problems/design-an-ordered-stream/)