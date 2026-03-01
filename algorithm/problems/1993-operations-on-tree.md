# 1993 Operations on Tree

## Problem Description

You are given a tree with `n` nodes numbered from `0` to `n - 1` in the form of a parent array `parent` where `parent[i]` is the parent of node `i`. The root of the tree is node `0`.

Implement the `LockingTree` class:

- `LockingTree(int[] parent)` Initializes the tree with the given parent array.
- `bool lock(int num, int user)` Locks the given node for the given user. Returns `true` if the node is successfully locked, `false` otherwise.
- `bool unlock(int num, int user)` Unlocks the given node for the given user. Returns `true` if the node is successfully unlocked, `false` otherwise.
- `bool upgrade(int num, int user)` Locks the given node for the given user and all its descendants. Returns `true` if the operation is successful, `false` otherwise.

The lock and unlock operations must follow these rules:
- A node can be locked only if it is not locked and none of its descendants are locked.
- A node can be unlocked only if it is currently locked by the same user.
- The upgrade operation locks the given node and all its descendants for the given user if:
  - The node is unlocked
  - It doesn't have any locked descendants
  - It locks all its descendants that are unlocked and have at least one locked descendant

### Example 1:
```
Input
["LockingTree","lock","upgrade","upgrade","lock","upgrade","unlock"]
[[-1,0,0,1,2,2],[2,2],[1,2],[2,3],[4,2],[1,2],[2,3]]
Output
[null,true,false,true,false,true,false,true]

Explanation
LockingTree lockingTree = new LockingTree([-1,0,0,1,2,2]);
lockingTree.lock(2, 2);    // return true, node 2 is locked by user 2.
lockingTree.upgrade(1, 2);    // return false, node 1 has a locked descendant (node 2).
lockingTree.upgrade(2, 3);    // return true, node 2 and its descendants (4,5) are locked by user 3.
lockingTree.lock(4, 2);    // return false, node 4 is already locked by user 3.
lockingTree.upgrade(1, 2);    // return true, node 1 and its descendants (2,3,4,5) are locked by user 2.
lockingTree.unlock(2, 3);    // return true, node 2 is unlocked by user 3.
```

## The Twist

Implementing a tree locking system that efficiently manages locks on nodes and supports upgrading locks with proper descendant tracking.

## Algorithm

### HashMap + BFS Approach:
1. Use a HashMap to track locked nodes and their users
2. Build the tree structure from the parent array
3. For lock(num, user):
   - Check if node or any descendant is locked
   - If not, lock the node for the user
4. For unlock(num, user):
   - Check if node is locked by the same user
   - If yes, unlock the node
5. For upgrade(num, user):
   - Check if node is locked or has locked descendants
   - Find all unlocked descendants with at least one locked descendant
   - Lock them all for the user
   - Return true if successful

The key insight is using BFS to efficiently find descendants and check lock status, while maintaining lock information in a HashMap.

## Complexity

- **Time**: 
  - LockingTree constructor: O(n) where n is the number of nodes
  - lock: O(n) where n is the number of nodes in the subtree
  - unlock: O(1)
  - upgrade: O(n) where n is the number of nodes in the subtree
- **Space**: O(n) where n is the number of nodes

## Solution Code

```go
package main

type LockingTree struct {
	parent    []int
	locked    map[int]int
	children  map[int][]int
}

func Constructor(parent []int) LockingTree {
	n := len(parent)
	children := make(map[int][]int)
	
	// Build children map
	for i := 0; i < n; i++ {
		if parent[i] != -1 {
			children[parent[i]] = append(children[parent[i]], i)
		}
	}
	
	return LockingTree{
		parent:   parent,
		locked:   make(map[int]int),
		children: children,
	}
}

func (this *LockingTree) Lock(num int, user int) bool {
	// Check if node or any descendant is locked
	if this.isLocked(num) {
		return false
	}
	
	// Lock the node
	this.locked[num] = user
	return true
}

func (this *LockingTree) Unlock(num int, user int) bool {
	// Check if node is locked by the same user
	if u, exists := this.locked[num]; exists && u == user {
		delete(this.locked, num)
		return true
	}
	
	return false
}

func (this *LockingTree) Upgrade(num int, user int) bool {
	// Check if node is locked or has locked descendants
	if this.isLocked(num) {
		return false
	}
	
	// Find all unlocked descendants with at least one locked descendant
	targets := make([]int, 0)
	this.findTargets(num, &targets)
	
	if len(targets) == 0 {
		return false
	}
	
	// Lock all targets
	for _, target := range targets {
		this.locked[target] = user
	}
	
	return true
}

func (this *LockingTree) isLocked(num int) bool {
	// Check if node is locked
	if _, exists := this.locked[num]; exists {
		return true
	}
	
	// Check if any descendant is locked
	queue := []int{num}
	for len(queue) > 0 {
		current := queue[0]
		queue = queue[1:]
		
		for _, child := range this.children[current] {
			queue = append(queue, child)
		}
	}
	
	return false
}

func (this *LockingTree) findTargets(num int, targets *[]int) {
	queue := []int{num}
	lockedDescendant := false
	
	for len(queue) > 0 {
		current := queue[0]
		queue = queue[1:]
		
		// Check if this node has a locked descendant
		hasLockedDescendant := false
		for _, child := range this.children[current] {
			if this.isLocked(child) {
				hasLockedDescendant = true
				break
			}
		}
		
		// If this node is unlocked and has at least one locked descendant, add to targets
		if !this.isLocked(current) && hasLockedDescendant {
			*targets = append(*targets, current)
		}
		
		// Add children to queue
		for _, child := range this.children[current] {
			queue = append(queue, child)
		}
	}
}

/**
 * Your LockingTree object will be instantiated and called as such:
 * obj := Constructor(parent);
 * param_1 := obj.Lock(num,user);
 * param_2 := obj.Unlock(num,user);
 * param_3 := obj.Upgrade(num,user);
 */
```

## Link

[LeetCode 1993 Operations on Tree](https://leetcode.com/problems/operations-on-tree/)