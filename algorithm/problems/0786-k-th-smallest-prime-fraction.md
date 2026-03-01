# 0786 K-th Smallest Prime Fraction

## Problem Description

Given an integer array `arr` of length `n` sorted in ascending order and an integer `k`, return the `kth` smallest prime fraction `a/b`` where `a` and `b` are coprime.

The size of the fraction is `a + b` and the fraction is in reduced form.

### Example 1:
```
Input: arr = [1,2,3,5], k = 3
Output: [2,5]
Explanation: The fractions that can be constructed are: 1/1, 1/2, 1/3, 1/4, 2/3, 2/5, 3/5.
The 3rd smallest fraction is 2/5.
```

## The Twist

Finding the **kth smallest prime fraction** efficiently. This involves generating all possible fractions and using binary search to find the kth smallest.

## Algorithm

### Binary Search on Fractions:
1. For each numerator `a` from 1 to n-1:
   - For each denominator `b` from a+1 to n:
      - If `a` and `b` are coprime, the fraction `a/b` is valid
      - Add it to a list of valid fractions
2. Sort the list of valid fractions
3. Return the `kth` fraction from the sorted list

The key insight is that for any `a`, the smallest possible `b` that gives a valid fraction is `a+1`.

## Complexity

- **Time**: O(n² log n) - generating all fractions + sorting
- **Space**: O(n²) - storing all valid fractions

## Solution Code

```go
package main

import (
	"fmt"
	"math"
)

func kthSmallestPrimeFraction(arr []int, k int) []int {
	n := len(arr)
	fractions := []Fraction{}
	
	// Generate all valid fractions
	for a := 1; a < n; a++ {
		for b := a + 1; b <= n; b++ {
			if gcd(a, b) == 1 {
				fractions = append(fractions, Fraction{a, b})
			}
		}
	}
	
	// Sort fractions by value
	sort.Slice(fractions, func(i, j int) bool {
		return fractions[i].a*fractions[j].b < fractions[j].a*fractions[i].b
	})
	
	if k > len(fractions) {
		return []int{-1, -1}
	}
	
	result := fractions[k-1]
	return []int{result.a, result.b}
}

type Fraction struct {
	a, b int
}

func gcd(a, b int) int {
	for b != 0 {
		a, b = b, a%b
	}
	return a
}
```

## Link

[LeetCode 0786 K-th Smallest Prime Fraction](https://leetcode.com/problems/k-th-smallest-prime-fraction/)
