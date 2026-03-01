# 1868 Product of Two Run-Length Encoded Arrays

## Problem Description

Run-length encoding is a compression algorithm that allows for the efficient transmission of data. In this problem, we are given two run-length encoded arrays `encoded1` and `encoded2`.

`encoded1[i] = [val_i, freq_i]` means that the `i-th group of numbers in the original array is `val_i` repeated `freq_i` times.

`encoded2[i] = [val_i, freq_i]` means that the `i-th group of numbers in the original array is `val_i` repeated `freq_i` times.

Return the product of the two run-length encoded arrays.

The product of two arrays is defined as the element-wise product of the original arrays, then run-length encoded again.

### Example 1:
```
Input: encoded1 = [[1,3],[2,3]], encoded2 = [[6,3],[3,3]]
Output: [[6,6]]
Explanation: The original arrays are [1,1,1,2,2,2] and [6,6,6,3,3,3].
The product is [6,6,6,6,6,6], which when run-length encoded is [[6,6]].
```

### Example 2:
```
Input: encoded1 = [[1,3],[2,1],[3,2]], encoded2 = [[2,3],[3,3]]
Output: [[2,3],[6,1],[9,2]]
Explanation: The original arrays are [1,1,1,2,3,3] and [2,2,2,3,3,3].
The product is [2,2,2,6,9,9], which when run-length encoded is [[2,3],[6,1],[9,2]].
```

## Approach

This problem can be solved using a two-pointer approach:

1. Use two pointers to traverse both encoded arrays simultaneously.
2. For each pair of encoded values, calculate the product and the minimum frequency.
3. Add the product and minimum frequency to the result.
4. Advance the pointer(s) based on which frequency was smaller.
5. If the frequencies were equal, advance both pointers.
6. If the result has consecutive entries with the same value, merge them.

## Solution Code

```go
func findRLEArray(encoded1 [][]int, encoded2 [][]int) [][]int {
    i, j := 0, 0
    n1, n2 := len(encoded1), len(encoded2)
    var result [][]int
    
    for i < n1 && j < n2 {
        val1, freq1 := encoded1[i][0], encoded1[i][1]
        val2, freq2 := encoded2[j][0], encoded2[j][1]
        
        // Calculate the product and minimum frequency
        product := val1 * val2
        minFreq := min(freq1, freq2)
        
        // Add to result
        if len(result) > 0 && result[len(result)-1][0] == product {
            result[len(result)-1][1] += minFreq
        } else {
            result = append(result, []int{product, minFreq})
        }
        
        // Update frequencies
        encoded1[i][1] -= minFreq
        encoded2[j][1] -= minFreq
        
        // Advance pointers
        if encoded1[i][1] == 0 {
            i++
        }
        if encoded2[j][1] == 0 {
            j++
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

- **Time**: O(n1 + n2) - We traverse both encoded arrays once
- **Space**: O(n1 + n2) - In the worst case, the result array has a size proportional to the sum of the input sizes

## Link

[LeetCode 1868 Product of Two Run-Length Encoded Arrays](https://leetcode.com/problems/product-of-two-run-length-encoded-arrays/)