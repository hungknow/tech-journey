# 0204 Count Primes

## Problem Description

Given an integer `n`, return the number of prime numbers that are strictly less than `n`.

### Example 1:
```
Input: n = 10
Output: 4
Explanation: There are 4 prime numbers less than 10: 2, 3, 5, 7.
```

### Example 2:
```
Input: n = 0
Output: 0
```

### Example 3:
```
Input: n = 1
Output: 0
```

## The Twist

Uses an array as a **boolean map** to mark composite numbers (Sieve of Eratosthenes). The hash table here is the array itself, used to efficiently filter out non-prime numbers.

## Hash Table Usage

- **Key**: `index` (the number being checked)
- **Value**: `boolean` (true if prime, false if composite)

Algorithm:
1. Create a boolean array `is_prime` of size n, initialized to true
2. Mark 0 and 1 as not prime
3. For each number i from 2 to sqrt(n):
   - If i is prime, mark all multiples of i as composite
4. Count all numbers marked as prime
5. Return the count

## Complexity

- **Time**: O(n log log n) - Sieve of Eratosthenes
- **Space**: O(n) - storing the boolean array

## Link

[LeetCode 0204 Count Primes](https://leetcode.com/problems/count-primes/)
