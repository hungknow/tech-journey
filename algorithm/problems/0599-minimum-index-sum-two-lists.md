# 0599 Minimum Index Sum of Two Lists

## Problem Description

Given two arrays of strings `list1` and `list2`, find the common strings with the least index sum. A common string is a string that appears in both lists.

If there is a tie, return all the common strings with the least index sum. You may return the answer in any order.

### Example 1:
```
Input: list1 = ["Shogun","Tapioca Express","Burger King","KFC"], list2 = ["Piatti","The Grill at Torrey Pines","Hungry Hunter Steakhouse","Shogun"]
Output: ["Shogun"]
Explanation: The only common string is "Shogun" with index sum 0 + 3 = 3.
```

### Example 2:
```
Input: list1 = ["Shogun","Tapioca Express","Burger King","KFC"], list2 = ["KFC","Shogun","Burger King"]
Output: ["Shogun"]
Explanation: The common strings with the least index sum are "Shogun" with index sum 0 + 1 = 1 and "KFC" with index sum 3 + 0 = 3. The minimum is 1.
```

### Example 3:
```
Input: list1 = ["happy","sad","good"], list2 = ["sad","happy","good"]
Output: ["sad","happy"]
Explanation: There are three common strings with index sum 0 + 1 = 1, 1 + 0 = 1, and 2 + 2 = 4. The minimum is 1.
```

## The Twist

Map stores `restaurant_name -> list_1_index`. You iterate list 2, checking the map to find the minimum index sum.

## Hash Table Usage

- **Key**: `restaurant_name` (a string from list1)
- **Value**: `list_1_index` (the index of this restaurant in list1)

Algorithm:
1. Build a map from restaurant names to their indices in list1
2. Iterate through list2:
   - For each restaurant, check if it exists in the map
   - Calculate the index sum: `map[restaurant] + current_index`
   - Track the minimum index sum and collect restaurants with this sum
3. Return all restaurants with the minimum index sum

## Complexity

- **Time**: O((m + n) * l) where m, n are list lengths, l is average string length
- **Space**: O(m * l) - storing all restaurants from list1

## Link

[LeetCode 0599 Minimum Index Sum of Two Lists](https://leetcode.com/problems/minimum-index-sum-of-two-lists/)
