# 1146 Snapshot Array

## Problem Description

Implement a SnapshotArray that supports the following interface:

- `SnapshotArray(int length)` initializes an array-like data structure with the given length. Initially, each element equals 0.
- `void set(int index, int val)` sets the element at the given index to be equal to val.
- `int snap()` takes a snapshot of the array and returns the snap_id (the total number of times we called snap() - 1).
- `int get(int index, int snap_id)` returns the value at the given index as of the snap with the given snap_id.

### Example 1:
```
Input: ["SnapshotArray","set","snap","set","get"]
[[3],[0,5],[],[0,6],[0,0]]
Output: [null,null,0,null,5]
Explanation: 
SnapshotArray snapshotArr = new SnapshotArray(3); // set the length to be 3
snapshotArr.set(0,5);  // Set array[0] = 5
snapshotArr.snap();  // Take a snapshot, returning snap_id = 0
snapshotArr.set(0,6);
snapshotArr.get(0,0);  // Get the value of array[0] with snap_id = 0, return 5
```

## The Twist

Implementing an array that can efficiently take snapshots and retrieve values from previous snapshots without storing the entire array for each snapshot.

## Algorithm

### HashMap + Binary Search Approach:
1. Use an array of HashMaps to store the history of values for each index
2. Each HashMap maps snap_id to the value at that index
3. For set(index, val):
   - Store the value with the current snap_id in the index's HashMap
   - Only store if the value is different from the previous value at the same snap_id
4. For snap():
   - Increment the snap_id counter
   - Return the previous snap_id
5. For get(index, snap_id):
   - In the index's HashMap, find the greatest snap_id that is <= the requested snap_id
   - Use binary search to efficiently find this snap_id
   - Return the corresponding value or 0 if no such snap_id exists

The key insight is storing only the changes at each index and using binary search to efficiently retrieve values from specific snapshots.

## Complexity

- **Time**: 
  - set: O(1)
  - snap: O(1)
  - get: O(logn) where n is the number of snapshots for the given index
- **Space**: O(n * m) where n is the array length and m is the number of snapshots

## Solution Code

```go
package main

import "sort"

type SnapshotArray struct {
	snapshots []map[int]int
	snapId    int
}

func Constructor(length int) SnapshotArray {
	snapshots := make([]map[int]int, length)
	for i := range snapshots {
		snapshots[i] = make(map[int]int)
		snapshots[i][0] = 0 // Initialize with snap_id 0 and value 0
	}
	
	return SnapshotArray{
		snapshots: snapshots,
		snapId:    0,
	}
}

func (this *SnapshotArray) Set(index int, val int) {
	this.snapshots[index][this.snapId] = val
}

func (this *SnapshotArray) Snap() int {
	this.snapId++
	return this.snapId - 1
}

func (this *SnapshotArray) Get(index int, snap_id int) int {
	snapshot := this.snapshots[index]
	
	// Get all snap_ids for this index and sort them
	snapIds := make([]int, 0, len(snapshot))
	for id := range snapshot {
		snapIds = append(snapIds, id)
	}
	sort.Ints(snapIds)
	
	// Binary search for the largest snap_id <= requested snap_id
	left, right := 0, len(snapIds)-1
	result := 0
	
	for left <= right {
		mid := (left + right) / 2
		if snapIds[mid] <= snap_id {
			result = snapIds[mid]
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	
	return snapshot[result]
}

/**
 * Your SnapshotArray object will be instantiated and called as such:
 * obj := Constructor(length);
 * obj.Set(index,val);
 * param_2 := obj.Snap();
 * param_3 := obj.Get(index,snap_id);
 */
```

## Link

[LeetCode 1146 Snapshot Array](https://leetcode.com/problems/snapshot-array/)