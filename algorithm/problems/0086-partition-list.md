# 0086 Partition List

## Problem Description

Given the `head` of a linked list and a value `x`, partition it such that all nodes less than `x` come before nodes greater than or equal to `x`.

You should preserve the original relative order of the nodes in each of the two partitions.

### Example 1:
```
Input: head = [1,4,3,2,5,2], x = 3
Output: [1,2,2,4,3,5]
```

### Example 2:
```
Input: head = [2,1], x = 2
Output: [1,2]
```

## Two Pointers Approach (Dummy Nodes)

This problem can be efficiently solved using two pointers with dummy nodes to create two separate lists: one for nodes less than x and another for nodes greater than or equal to x.

### Algorithm Steps:

1. Create two dummy nodes: `lessHead` and `greaterOrEqualHead`
2. Initialize two pointers: `less` pointing to `lessHead` and `greaterOrEqual` pointing to `greaterOrEqualHead`
3. Traverse the original list:
   - If the current node's value is less than x, append it to the `less` list
   - Otherwise, append it to the `greaterOrEqual` list
4. Connect the `less` list to the `greaterOrEqual` list (skipping the dummy node)
5. Return the head of the partitioned list

## Complexity

- **Time**: O(n) - we traverse the list once
- **Space**: O(1) - constant space for the dummy nodes and pointers

## Solution Code

```go
package main

/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func partition(head *ListNode, x int) *ListNode {
    // Create dummy nodes for the two partitions
    lessHead := &ListNode{}
    greaterOrEqualHead := &ListNode{}
    
    // Pointers to the current end of each partition
    less := lessHead
    greaterOrEqual := greaterOrEqualHead
    
    // Traverse the original list
    current := head
    for current != nil {
        if current.Val < x {
            less.Next = current
            less = less.Next
        } else {
            greaterOrEqual.Next = current
            greaterOrEqual = greaterOrEqual.Next
        }
        current = current.Next
    }
    
    // Connect the two partitions
    greaterOrEqual.Next = nil
    less.Next = greaterOrEqualHead.Next
    
    return lessHead.Next
}
```

## Alternative Approach (In-place Partition)

An alternative approach is to rearrange nodes in-place by moving nodes that are less than x to the front of the list while maintaining their relative order.

## Alternative Solution Code

```go
package main

/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func partition(head *ListNode, x int) *ListNode {
    if head == nil || head.Next == nil {
        return head
    }
    
    // Find the first node with value >= x
    partition := head
    for partition != nil && partition.Val < x {
        partition = partition.Next
    }
    
    if partition == nil {
        return head // All nodes are less than x
    }
    
    // Traverse and move nodes less than x
    current := partition.Next
    prev := partition
    
    for current != nil {
        if current.Val < x {
            // Remove current from its position
            prev.Next = current.Next
            
            // Insert current before partition
            current.Next = partition
            head = current
            
            // Update current to continue traversal
            current = prev.Next
        } else {
            prev = current
            current = current.Next
        }
    }
    
    return head
}
```

## Link

[LeetCode 0086 Partition List](https://leetcode.com/problems/partition-list/)