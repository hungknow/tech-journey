# 0822 Card Flipping Game

## Problem Description

You are given two integer arrays `fronts` and `backs` of length `n`, where `fronts[i]` and `backs[i]` represent the numbers on the front and back of the ith card respectively.

A card can be flipped if the number on the back is different from the number on the front. After flipping, the front shows the number that was previously on the back.

Return the minimum possible good integer after flipping any number of cards. A good integer is a number that does NOT appear on the front of any card after flipping.

If there is no good integer, return `0`.

### Example 1:
```
Input: fronts = [1,2,4,4,7], backs = [1,3,4,1,3]
Output: 2
Explanation: After flipping the second card, fronts becomes [1,3,4,4,7].
The good integers are 2 and 5. The minimum is 2.
```

### Example 2:
```
Input: fronts = [1], backs = [1]
Output: 0
Explanation: There are no good integers.
```

## The Twist

A Hash Set records any number that appears on the front **and** back of the same card (making it invalid). You then find the smallest number not in this set.

## Hash Table Usage

- **Key**: `invalid_number` (a number that appears on both sides of the same card)
- **Value**: `true` (or just use a set)

Algorithm:
1. Create a set to track invalid numbers
2. For each card:
   - If `fronts[i] == backs[i]`, add this number to the invalid set
3. Find the minimum number from all fronts and backs that is NOT in the invalid set
4. Return the minimum valid number, or 0 if none exists

## Complexity

- **Time**: O(n) - single pass through the arrays
- **Space**: O(n) - storing invalid numbers

## Link

[LeetCode 0822 Card Flipping Game](https://leetcode.com/problems/card-flipping-game/)
