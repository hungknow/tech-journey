# 2502 Design Memory Allocator

## Problem Description

Design a memory allocator that supports the following operations:

- `MemoryAllocator(int n)` Initializes the object with a memory block of size `n`.
- `int allocate(int size, int m)` Allocates a memory block of the given size `m` and returns the starting index of the block.
- `int free(int index)` Frees the memory block at the given index.

### Example 1:
```
Input
["MemoryAllocator","allocate","allocate","allocate","free","free","free"]
[[2],[1,2],[1,2]]
Output
[null,1,0,null,1]

Explanation
MemoryAllocator ma = new MemoryAllocator(2);
ma.allocate(1, 2);  // return 1, allocate block from index 1 with size 2
ma.allocate(1, 1);  // return 0, block from index 1 is already allocated
ma.free(1);  // free block at index 1
ma.allocate(1, 2); // return 1, block from index 1 is now free
```

## The Twist

Implementing a memory allocator that efficiently manages memory blocks with different sizes and supports allocation and deallocation.

## Algorithm

### Binary Search + Free List Approach:
1. Use a list to track free blocks
2. Use a HashMap to track allocated blocks
3. For MemoryAllocator(n):
   - Initialize free list with one block of size n
   - Add this block to the free list
4. For allocate(size, m):
   - Find the first free block that can accommodate the request
   - If found:
     - Mark it as allocated
     - Remove it from free list
     - Return the starting index
   - If no suitable block found, return -1
5. For free(index):
   - Add the block back to the free list
   - Mark it as free in the HashMap

The key insight is maintaining a sorted list of free blocks and using binary search to find the first suitable block.

## Complexity

- **Time**: 
  - MemoryAllocator constructor: O(n) where n is the memory size
  - allocate: O(logn) where n is the number of free blocks
  - free: O(1)
- **Space**: O(n) where n is the memory size

## Solution Code

```go
package main

import "sort"

type Block struct {
	start int
	size  int
	used  bool
}

type MemoryAllocator struct {
	blocks   []*Block
	free     []*Block
	used     map[int]bool
}

func Constructor(n int) MemoryAllocator {
	// Initialize with one block of size n
	block := &Block{
		start: 0,
		size:  n,
		used: false,
	}
	
	return MemoryAllocator{
		blocks: []*Block{block},
		free:  []*Block{block},
		used:  map[int]bool{0: false},
	}
	}
}

func (this *MemoryAllocator) Allocate(size int, m int) int {
	// Find the first free block that can accommodate the request
	for _, block := range this.free {
		if !block.used && block.size >= size {
			// Mark as allocated
			block.used = true
			delete(this.used, block)
			return block.start
		}
	}
	
	return -1
}

func (this *MemoryAllocator) Free(index int) {
	if index < 0 || index >= len(this.blocks) {
		return
	}
	
	block := this.blocks[index]
	if !block.used {
		return
	}
	
	// Mark as free
	block.used = false
	this.used[index] = false
	
	// Add back to free list
	this.free = append(this.free, block)
	
	// Remove from used map
	delete(this.used, index)
	
	// Add back to blocks list
	this.blocks = append(this.blocks, block)
	
	// Sort free blocks by start index
	sort.Slice(this.free, func(i, j int) bool {
		return this.free[i].start < this.free[j].start
	})
}

/**
 * Your MemoryAllocator object will be instantiated and called as such:
 * obj := Constructor(n);
 * param_1 := obj.Allocate(size,m);
 * param_2 := obj.Free(index);
 */
```

## Link

[LeetCode 2502 Design Memory Allocator](https://leetcode.com/problems/design-memory-allocator/)