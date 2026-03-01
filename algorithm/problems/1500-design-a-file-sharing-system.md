# 1500 Design a File Sharing System

## Problem Description

We need to implement a file sharing system that allows users to join and leave file sharing groups.

Implement the `FileSharing` class:

- `FileSharing(int m)` Initializes the system with `m` available chunks, numbered from `1` to `m`.
- `int join(int[] ownedChunks)` A new user joins the system with a list of owned chunks. The system should assign an ID to this user (the smallest unused ID). Return the ID.
- `int[] leave(int userID)` The user with ID `userID` leaves the system, making all chunks they owned available. Return the list of chunks owned by this user before they left.
- `int[] read(int userID)` Returns the list of chunks owned by the user with ID `userID`.

### Example 1:
```
Input
["FileSharing","join","join","join","read","read","read","leave","join","read"]
[[4],[[1,2]],[[2,3]],[[4]],[1],[2],[3],[2],[[]],[1]]
Output
[null,1,2,3,[1,2],[2,3],[4],[2,3],4,[1,2]]

Explanation
FileSharing fileSharing = new FileSharing(4);
fileSharing.join([1,2]);    // return 1
fileSharing.join([2,3]);    // return 2
fileSharing.join([4]);       // return 3
fileSharing.read(1);        // return [1,2]
fileSharing.read(2);        // return [2,3]
fileSharing.read(3);        // return [4]
fileSharing.leave(2);        // return [2,3]
fileSharing.join([]);        // return 4
fileSharing.read(1);        // return [1,2]
```

## The Twist

Implementing a file sharing system that efficiently manages user groups, chunk ownership, and user IDs with proper cleanup when users leave.

## Algorithm

### TreeMap + PriorityQueue Approach:
1. Use a TreeMap to map user IDs to their owned chunks
2. Use a PriorityQueue to track the smallest available user ID
3. Use a HashMap to track which users own each chunk
4. For FileSharing(m):
   - Initialize available chunks from 1 to m
   - Initialize the priority queue with user IDs starting from 1
5. For join(ownedChunks):
   - Get the smallest available user ID from the priority queue
   - Add the user to the TreeMap with their owned chunks
   - Update the chunk ownership mapping
   - Return the user ID
6. For leave(userID):
   - Get the user's owned chunks
   - Remove the user from the TreeMap
   - Update the chunk ownership mapping
   - Return the user's owned chunks
7. For read(userID):
   - Return the list of chunks owned by the user, sorted

The key insight is using a priority queue to efficiently assign the smallest available user ID and maintaining mappings for quick lookups.

## Complexity

- **Time**: 
  - FileSharing constructor: O(m) where m is the number of chunks
  - join: O(klogn) where k is the number of chunks and n is the number of users
  - leave: O(klogn) where k is the number of chunks
  - read: O(klogk) where k is the number of chunks for sorting
- **Space**: O(n + m) where n is the number of users and m is the number of chunks

## Solution Code

```go
package main

import (
	"container/heap"
	"sort"
)

type User struct {
	id     int
	chunks []int
}

type MinHeap []int

func (h MinHeap) Len() int           { return len(h) }
func (h MinHeap) Less(i, j int) bool { return h[i] < h[j] }
func (h MinHeap) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }

func (h *MinHeap) Push(x interface{}) {
	*h = append(*h, x.(int))
}

func (h *MinHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}

type FileSharing struct {
	users       map[int]*User
	availableID *MinHeap
	chunkOwners map[int]map[int]bool
}

func Constructor(m int) FileSharing {
	// Initialize available IDs (starting from 1)
	availableID := &MinHeap{}
	heap.Init(availableID)
	
	// Pre-populate with some initial IDs
	for i := 1; i <= 1000; i++ {
		heap.Push(availableID, i)
	}
	
	return FileSharing{
		users:       make(map[int]*User),
		availableID: availableID,
		chunkOwners: make(map[int]map[int]bool),
	}
}

func (this *FileSharing) Join(ownedChunks []int) int {
	// Get the smallest available ID
	userID := heap.Pop(this.availableID).(int)
	
	// Sort the chunks
	sort.Ints(ownedChunks)
	
	// Create the user
	user := &User{
		id:     userID,
		chunks: ownedChunks,
	}
	
	// Add user to the system
	this.users[userID] = user
	
	// Update chunk ownership
	for _, chunk := range ownedChunks {
		if _, exists := this.chunkOwners[chunk]; !exists {
			this.chunkOwners[chunk] = make(map[int]bool)
		}
		this.chunkOwners[chunk][userID] = true
	}
	
	return userID
}

func (this *FileSharing) Leave(userID int) []int {
	user, exists := this.users[userID]
	if !exists {
		return []int{}
	}
	
	// Get the user's chunks
	chunks := make([]int, len(user.chunks))
	copy(chunks, user.chunks)
	
	// Remove user from chunk ownership
	for _, chunk := range user.chunks {
		if owners, exists := this.chunkOwners[chunk]; exists {
			delete(owners, userID)
			if len(owners) == 0 {
				delete(this.chunkOwners, chunk)
			}
		}
	}
	
	// Remove user from the system
	delete(this.users, userID)
	
	// Make the user ID available again
	heap.Push(this.availableID, userID)
	
	return chunks
}

func (this *FileSharing) Read(userID int) []int {
	user, exists := this.users[userID]
	if !exists {
		return []int{}
	}
	
	// Return a copy of the user's chunks
	chunks := make([]int, len(user.chunks))
	copy(chunks, user.chunks)
	return chunks
}

/**
 * Your FileSharing object will be instantiated and called as such:
 * obj := Constructor(m);
 * param_1 := obj.Join(ownedChunks);
 * param_2 := obj.Leave(userID);
 * param_3 := obj.Read(userID);
 */
```

## Link

[LeetCode 1500 Design a File Sharing System](https://leetcode.com/problems/design-a-file-sharing-system/)