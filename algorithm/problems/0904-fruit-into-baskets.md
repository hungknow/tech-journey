# 0904 Fruit Into Baskets

## Problem Description

You are visiting a farm that has a single row of fruit trees. The trees are represented by an array of integers where each integer represents the type of fruit on a tree.

You have two baskets, and each basket can carry only one type of fruit. You need to collect the maximum amount of fruits while following these rules:

- Each basket can only carry one type of fruit
- You must pick exactly one fruit from every tree starting from a tree of your choice
- You must stop picking when you encounter a tree with a fruit type that cannot fit in either basket

Return the maximum number of fruits you can pick.

### Example 1:
```
Input: fruits = [1,2,1]
Output: 3
Explanation: We can pick from all 3 trees.
```

### Example 2:
```
Input: fruits = [0,1,2,2]
Output: 3
Explanation: We can pick from trees [1,2,2].
If we start from the first tree, we would only pick [0,1].
```

### Example 3:
```
Input: fruits = [1,2,3,2,2]
Output: 4
Explanation: We can pick from trees [2,3,2,2].
```

## Sliding Window Approach

This problem is essentially asking for the length of the longest subarray with at most 2 distinct elements. We can solve it using a sliding window approach with a frequency map.

### Algorithm Steps:

1. Initialize a frequency map to track fruit types in the current window
2. Initialize `left = 0` and `maxFruits = 0`
3. Iterate through the array with `right` pointer from 0 to n-1:
   - Increment the count of `fruits[right]` in the frequency map
   - While the frequency map has more than 2 keys:
     - Decrement the count of `fruits[left]` in the frequency map
     - If the count becomes 0, remove it from the map
     - Increment `left`
   - Update `maxFruits` with `max(maxFruits, right - left + 1)`
4. Return `maxFruits`

## Complexity

- **Time**: O(n) - we iterate through the array once
- **Space**: O(1) - constant space for the frequency map (at most 2 keys)

## Solution Code

```go
package main

func totalFruit(fruits []int) int {
	n := len(fruits)
	if n <= 2 {
		return n
	}
	
	// Frequency map for fruit types in the current window
	freq := make(map[int]int)
	left := 0
	maxFruits := 0
	
	for right := 0; right < n; right++ {
		// Add current fruit to the window
		freq[fruits[right]]++
		
		// If we have more than 2 types of fruits, shrink the window
		for len(freq) > 2 {
			freq[fruits[left]]--
			if freq[fruits[left]] == 0 {
				delete(freq, fruits[left])
			}
			left++
		}
		
		// Update the maximum number of fruits
		currentLength := right - left + 1
		if currentLength > maxFruits {
			maxFruits = currentLength
		}
	}
	
	return maxFruits
}
```

## Link

[LeetCode 0904 Fruit Into Baskets](https://leetcode.com/problems/fruit-into-baskets/)