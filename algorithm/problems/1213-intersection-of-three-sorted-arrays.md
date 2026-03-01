# 1213 Intersection of Three Sorted Arrays

## Problem Description

Given three integer arrays `arr1`, `arr2` and `arr3` sorted in strictly increasing order, return a sorted array of only the integers that appear in all three arrays.

### Example 1:
```
Input: arr1 = [1,2,3,4,5], arr2 = [1,2,5,7,9], arr3 = [1,3,4,5,8]
Output: [1,5]
Explanation: Only 1 and 5 appear in all three arrays.
```

### Example 2:
```
Input: arr1 = [197,418,523,876,1352], arr2 = [501,880,1593,1710,1870], arr3 = [521,682,1337,1395,1764]
Output: []
Explanation: No common elements in all three arrays.
```

## Approach

Since all three arrays are sorted, we can use a three-pointer approach to efficiently find the intersection:

1. Initialize three pointers, one for each array, all starting at index 0.
2. Compare the elements at the current positions of the three pointers:
   - If all three elements are equal, add to the result and advance all three pointers.
   - Otherwise, advance the pointer(s) pointing to the smallest element.
3. Continue until one of the pointers reaches the end of its array.

This approach works because if the smallest element is not common to all three arrays, advancing the pointer pointing to it might lead us to a common element.

## Solution Code

```go
func arraysIntersection(arr1 []int, arr2 []int, arr3 []int) []int {
    i, j, k := 0, 0, 0
    n1, n2, n3 := len(arr1), len(arr2), len(arr3)
    var result []int
    
    for i < n1 && j < n2 && k < n3 {
        // If all three elements are equal
        if arr1[i] == arr2[j] && arr2[j] == arr3[k] {
            result = append(result, arr1[i])
            i++
            j++
            k++
        } else {
            // Find the minimum element and advance its pointer
            minVal := min(arr1[i], min(arr2[j], arr3[k]))
            
            if arr1[i] == minVal {
                i++
            }
            if arr2[j] == minVal {
                j++
            }
            if arr3[k] == minVal {
                k++
            }
        }
    }
    
    return result
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

## Complexity Analysis

- **Time**: O(n1 + n2 + n3) - We traverse each array at most once
- **Space**: O(min(n1, n2, n3)) - The result array contains at most the minimum number of elements from the three arrays

## Link

[LeetCode 1213 Intersection of Three Sorted Arrays](https://leetcode.com/problems/intersection-of-three-sorted-arrays/)