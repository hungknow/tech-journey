# 0825 Friends Of Appropriate Ages

## Problem Description

There are `n` persons with certain ages. Some friend requests are sent from person `A` to person `B`.

A person `A` will NOT send a request to person `B` (`A != B`) if any of the following conditions are true:
- `age[B] <= 0.5 * age[A] + 7`
- `age[B] > age[A]`
- `age[B] > 100 && age[A] < 100`

Otherwise, `A` will send a request to `B`.

Given the ages `ages` and the number of friend requests made, return the total number of friend requests made.

### Example 1:
```
Input: ages = [16,16]
Output: 2
Explanation: 2 people friend request each other.
```

### Example 2:
```
Input: ages = [16,17,18]
Output: 2
Explanation: Friend requests are made 17 -> 16, 18 -> 17.
```

### Example 3:
```
Input: ages = [20,30,100,110,120]
Output: 3
Explanation: Friend requests are made 110 -> 100, 120 -> 110, 120 -> 100.
```

## The Twist

Validating **age rules** across a population. The constraints are mathematical relationships between ages, and we need to count valid pairs efficiently without checking every person against every other person.

## Hash Table Usage

- **Key**: `age` (the age value)
- **Value**: `frequency` (how many people have this age)

The map allows us to mathematically calculate valid friend requests between age groups rather than checking person-by-person:
1. Count the frequency of each age
2. For each age `A`, determine valid age range for `B`
3. Sum up valid pairs using frequency counts

## Complexity

- **Time**: O(n + a²) where a is the range of ages (max 121)
- **Space**: O(a) - storing frequencies for each possible age

## Link

[LeetCode 0825 Friends Of Appropriate Ages](https://leetcode.com/problems/friends-of-appropriate-ages/)
