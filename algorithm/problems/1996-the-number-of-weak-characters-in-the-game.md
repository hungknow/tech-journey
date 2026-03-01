# 1996 The Number of Weak Characters in the Game

## Problem Description

You are given an integer array `properties` where `properties[i] = [attacki, defensei]` represents the properties of the ith character in a game.

A character is weak if there exists another character with both attack and defense strictly greater than this character's attack and defense.

Return the number of weak characters.

### Example 1:
```
Input: properties = [[5,5],[6,3],[3,6]]
Output: 0
Explanation: 
No character has both attack and defense strictly greater than any other character.
```

### Example 2:
```
Input: properties = [[2,2],[1,1],[8,1],[7,7]]
Output: 1
Explanation: 
Character 2 has attack 2 and defense 2.
Character 1 has attack 1 and defense 1.
Character 3 has attack 3 and defense 6.
Character 8 has attack 8 and defense 1.
Character 7 has attack 7 and defense 7.
Character 1 is weak because characters 2, 3, 8, and 7 all have both attack and defense strictly greater than 1 and 1.
```

## Solution Approach

We need to count characters that are weak, meaning there exists another character with both attack and defense strictly greater than theirs.

## Algorithm

1. Sort the characters by attack in descending order.
2. Initialize `weakCount` = 0.
3. For each character at index `i`:
   - For each character at index `j` where `j != i`:
     - If `properties[j][0] > properties[i][0]` and `properties[j][1] > properties[i][1]`:
       - Character `i` is weak, increment `weakCount`.
       - Break (no need to check further characters).
4. Return `weakCount`.

## Why This Works

By sorting by attack in descending order, we can stop checking early once we find a character with both higher attack and defense.

## Complexity

- **Time**: O(n²) - comparing each character with every other character
- **Space**: O(1) - constant extra space

## Link

[LeetCode 1996 The Number of Weak Characters in the Game](https://leetcode.com/problems/the-number-of-weak-characters-in-the-game/)