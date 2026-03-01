# 1305 All Elements in Two Binary Search Trees

## Problem Description

Given two binary search trees `root1` and `root2`, return a list containing all the integers from both trees sorted in ascending order.

### Example 1:
```
Input: root1 = [2,1,4], root2 = [1,0,3]
Output: [0,1,1,2,3,4]
```

### Example 2:
```
Input: root1 = [1,null,8], root2 = [8,1]
Output: [1,1,8,8]
```

## Approach

This problem can be solved using a combination of in-order traversal and the merge step of merge sort:

1. Perform an in-order traversal of both BSTs to get two sorted arrays of values.
2. Use a two-pointer approach to merge these two sorted arrays into a single sorted array.

The in-order traversal of a BST yields the values in ascending order, which is why this approach works.

## Solution Code

```go
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func getAllElements(root1 *TreeNode, root2 *TreeNode) []int {
    // Get sorted arrays from both trees
    arr1 := inorderTraversal(root1)
    arr2 := inorderTraversal(root2)
    
    // Merge the two sorted arrays
    return mergeSortedArrays(arr1, arr2)
}

func inorderTraversal(root *TreeNode) []int {
    var result []int
    var stack []*TreeNode
    current := root
    
    for current != nil || len(stack) > 0 {
        // Go as far left as possible
        for current != nil {
            stack = append(stack, current)
            current = current.Left
        }
        
        // Process the node
        current = stack[len(stack)-1]
        stack = stack[:len(stack)-1]
        result = append(result, current.Val)
        
        // Move to the right subtree
        current = current.Right
    }
    
    return result
}

func mergeSortedArrays(arr1, arr2 []int) []int {
    i, j := 0, 0
    n1, n2 := len(arr1), len(arr2)
    result := make([]int, 0, n1+n2)
    
    for i < n1 && j < n2 {
        if arr1[i] <= arr2[j] {
            result = append(result, arr1[i])
            i++
        } else {
            result = append(result, arr2[j])
            j++
        }
    }
    
    // Add remaining elements from arr1
    for i < n1 {
        result = append(result, arr1[i])
        i++
    }
    
    // Add remaining elements from arr2
    for j < n2 {
        result = append(result, arr2[j])
        j++
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n1 + n2) - We traverse both trees once and then merge the sorted arrays
- **Space**: O(n1 + n2) - We store the values from both trees and the result array

## Link

[LeetCode 1305 All Elements in Two Binary Search Trees](https://leetcode.com/problems/all-elements-in-two-binary-search-trees/)