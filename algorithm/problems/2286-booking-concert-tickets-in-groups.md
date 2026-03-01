# 2286 Booking Concert Tickets in Groups

## Problem Description

Design a system to book concert tickets in groups of size `k`.

Implement the `BookMyShow` class:

- `BookMyShow(int n, int k)` Initializes the object with `n` rows and `k` seats per row.
- `int[] gather(int[] row, int k)` Returns an array of length `k` with the maximum number of consecutive seats available in the specified row.

### Example 1:
```
Input
["BookMyShow","gather","gather","gather","gather"]
[[2,1],[0,5],[0,5]]
Output
[null,[0,1],[0,1]]

Explanation
BookMyShow b = new BookMyShow(2, 1);
b.gather(0, 5); // return [0], row 0 has only seat 0 available
b.gather(0, 5); // return [0], seat 0 already taken
b.gather(0, 5); // return [0], seat 0 already taken
```

## The Twist

Implementing a concert booking system that efficiently manages seat allocation and finds consecutive available seats in any row.

## Algorithm

### TreeSet + Binary Search Approach:
1. Use a TreeMap (or balanced BST) to store seat availability for each row
2. For BookMyShow(n, k):
   - Initialize the TreeMap with empty sets for each row
3. For gather(row, k):
   - Find the first row with at least k consecutive available seats
   - Use binary search to find the starting position
   - Return the first k available seats from that position

The key insight is using a TreeMap to efficiently track seat availability and binary search to find consecutive seats.

## Complexity

- **Time**: 
  - BookMyShow constructor: O(n) where n is the number of rows
  - gather: O(k + logn) where n is the number of rows and k is the group size
- **Space**: O(n) where n is the number of rows

## Solution Code

```go
package main

import (
	"sort"
)

type BookMyShow struct {
	n    int
	k    int
	rows [][]bool
}

func Constructor(n int, k int) BookMyShow {
	rows := make([][]bool, n)
	for i := range rows {
		rows[i] = make([]bool, k)
	}
	
	return BookMyShow{
		n:    n,
		k:    k,
		rows:  rows,
	}
}

func (this *BookMyShow) Gather(row int, k int) []int {
	if row < 0 || row >= this.n {
		return []int{}
	}
	
	// Find the first row with at least k consecutive available seats
	for i := 0; i < this.n; i++ {
		// Check if this row has at least k consecutive available seats
		consecutive := 0
		start := -1
		
		for j := 0; j < this.k && start+j < len(this.rows[i]); j++ {
			if this.rows[i][start+j] {
				consecutive++
				if consecutive == 1 {
					start = j
				} else {
					consecutive = 0
					start = -1
				}
			}
		}
		
		if consecutive >= this.k {
			// Found k consecutive seats
			result := make([]int, 0, this.k)
			for j := 0; j < this.k; j++ {
				result[j] = start + j + 1
				this.rows[i][start+j] = true
			}
			return result
		}
	}
	
	return []int{}
}

/**
 * Your BookMyShow object will be instantiated and called as such:
 * obj := Constructor(n, k);
 * param_1 := obj.Gather(row,k);
 */
```

## Link

[LeetCode 2286 Booking Concert Tickets in Groups](https://leetcode.com/problems/booking-concert-tickets-in-groups/)