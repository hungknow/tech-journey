# 1847 Closest Room

## Problem Description

There is a hotel with `n` rooms. The rooms are represented by a 2D integer array `rooms` where `rooms[i] = [roomIdi, sizei]` denotes that there is a room with `roomIdi` and size `sizei`.

You are also given `queries` where `queries[j] = [preferredj, minSizej]`. The answer to the jth query is the room ID of a room such that:
- The room's size is at least `minSizej`.
- The absolute difference between the room's ID and `preferredj` is minimized.
- If there are multiple rooms with the same minimal absolute difference, return the one with the smallest room ID.
- If there is no such room, return -1.

Return an array `answer` where `answer[j]` is the answer to the jth query.

### Example 1:
```
Input: rooms = [[2,2],[1,2],[3,2]], queries = [[3,1],[1,3],[5,2]]
Output: [3,-1,3]
Explanation: 
The queries are as follows:
Query [3,1]: Room 3 is the closest with size >= 1.
Query [1,3]: There is no room with size >= 3.
Query [5,2]: Room 3 is the closest with size >= 2.
```

### Example 2:
```
Input: rooms = [[1,4],[2,3],[3,5],[4,1],[5,2]], queries = [[2,3],[2,4],[2,2]]
Output: [2,1,3]
```

## Solution Approach

This problem requires finding the closest room ID for each query, considering both size constraints and ID proximity. We can solve this by sorting both rooms and queries and using a TreeSet or similar data structure.

## Algorithm

1. Sort rooms by size in descending order.
2. Sort queries by minSize in descending order, keeping track of original indices.
3. Initialize an empty TreeSet to store room IDs.
4. Process queries one by one:
   - Add all rooms with size >= current query's minSize to the TreeSet.
   - Use the TreeSet to find the room ID closest to the preferred ID:
     - Find the floor (largest ID <= preferred) and ceiling (smallest ID >= preferred).
     - Choose the one with the smaller absolute difference, preferring the smaller ID in case of ties.
5. Store the result for each query at its original index.
6. Return the result array.

## Why This Works

By processing queries in descending order of minSize, we can maintain a TreeSet of all rooms that satisfy the size constraint. The TreeSet allows us to efficiently find the closest room ID to the preferred ID.

## Complexity

- **Time**: O(n log n + q log q + (n + q) log n) where n is the number of rooms and q is the number of queries
- **Space**: O(n) for the TreeSet

## Solution Code

```go
func closestRoom(rooms [][]int, queries [][]int) []int {
	sort.Slice(rooms, func(i, j int) bool {
		return rooms[i][1] > rooms[j][1]
	})
	for i := range queries {
		queries[i] = append(queries[i], i)
	}
	sort.Slice(queries, func(i, j int) bool {
		return queries[i][1] > queries[j][1]
	})
	result := make([]int, len(queries))
	for i := range result {
		result[i] = -1
	}
	available := []int{}
	j := 0
	for _, q := range queries {
		preferred, minSize, qi := q[0], q[1], q[2]
		for j < len(rooms) && rooms[j][1] >= minSize {
			available = append(available, rooms[j][0])
			j++
		}
		if len(available) == 0 {
			continue
		}
		sort.Ints(available)
		idx := sort.SearchInts(available, preferred)
		candidates := []int{-1, -1}
		if idx < len(available) {
			candidates[0] = available[idx]
		}
		if idx > 0 {
			candidates[1] = available[idx-1]
		}
		best := -1
		for _, c := range candidates {
			if c == -1 {
				continue
			}
			if best == -1 {
				best = c
			} else if abs(c-preferred) < abs(best-preferred) || (abs(c-preferred) == abs(best-preferred) && c < best) {
				best = c
			}
		}
		result[qi] = best
	}
	return result
}
func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
```

## Link

[LeetCode 1847 Closest Room](https://leetcode.com/problems/closest-room/)