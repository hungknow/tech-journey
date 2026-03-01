# 2526 Find Consecutive Integers From a Data Stream

## Problem Description

Given a stream of integers, find the longest subsequence of consecutive integers of length `k`.

Implement the `DataStream` class:

- `DataStream(int k)` Initializes the object with the given `k`.
- `bool add(int num)` Adds the integer `num` to the data stream.
- `int[] consecutive()` Returns the the longest subsequence of consecutive integers of length `k`.

### Example 1:
```
Input
["DataStream","add","add","add","add","add","add","add","consecutive","consecutive"]
[[5],[1],[5],[2],[5],[2],[5],[5]]
Output
[null,null,null,null,null,2]

Explanation
DataStream ds = new DataStream(5);
ds.add(1); // stream: [1]
ds.add(5); // stream: [1,5]
ds.add(5); // stream: [1,5,5]
ds.consecutive(); // return 2, longest consecutive subsequence is [5,5] with length 2
```

## The Twist

Implementing a data stream tracker that efficiently finds the longest consecutive subsequence of length k.

## Algorithm

### Sliding Window + HashMap Approach:
1. Use a sliding window of size k
2. Use a HashMap to count occurrences of each number in the current window
3. For DataStream(k):
   - Initialize data structures
4. For add(num):
     - Add the number to the stream
     - Update the sliding window
5. For consecutive():
     - Iterate through the stream
     - For each position i from 0 to len(stream)-k+1:
       - Check if numbers at positions i to i+k-1 form a consecutive sequence
       - If yes, update the longest length
     - Return the longest length found

The key insight is using a sliding window approach to efficiently track consecutive sequences.

## Complexity

- **Time**: 
  - DataStream constructor: O(1)
  - add: O(1)
  - consecutive: O(n) where n is the stream length
- **Space**: O(k) where k is the window size

## Solution Code

```go
package main

type DataStream struct {
	stream  []int
	k     int
	window []int
	counts map[int]int
	maxLen int
}

func Constructor(k int) DataStream {
	return DataStream{
		stream: make([]int, 0),
		k:     k,
		counts: make(map[int]int),
		maxLen: 0,
	}
}

func (this *DataStream) Add(num int)  {
	this.stream = append(this.stream, num)
	this.counts[num]++
	
	// Update sliding window
	if len(this.stream) >= this.k {
		// Remove element that's too old
		oldNum := this.stream[len(this.stream)-this.k]
		this.counts[oldNum]--
	}
	
	// Add new element
	this.counts[num]++
}

func (this *DataStream) Consecutive() int {
	if len(this.stream) < this.k {
		return 0
	}
	
	maxLen := 0
	for i := 0; i <= len(this.stream)-this.k+1; i++ {
		// Check if numbers at positions i to i+k-1 form a consecutive sequence
		consecutive := true
		for j := i; j < i+this.k; j++ {
			if this.stream[j] != this.stream[i+j] {
				consecutive = false
				break
			}
		}
		
		if consecutive {
			if i-this.k+1 > maxLen {
				maxLen = i-this.k+1
			}
		}
	}
	
	return maxLen
}

/**
 * Your DataStream object will be instantiated and called as such:
 * obj := Constructor(k);
 * param_1 := obj.Add(num);
 * param_2 := obj.Consecutive();
 */
```

## Link

[LeetCode 2526 Find Consecutive Integers From a Data Stream](https://leetcode.com/problems/find-consecutive-integers-from-a-data-stream/)