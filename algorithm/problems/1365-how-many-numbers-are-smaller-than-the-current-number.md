# 1365 How Many Numbers Are Smaller Than the Current Number

## Problem Description

Given the array `nums`, for each `nums[i]` find out how many numbers in the array are smaller than it. That is, for each `nums[i]` you have to count the number of valid `j's` such that `j != i` and `nums[j] < nums[i]`.

Return the answer in an array.

### Example 1:
```
Input: nums = [8,1,2,2,3]
Output: [4,0,1,1,3]
Explanation: 
For nums[0]=8, there are four numbers smaller than it (1, 2, 2, and 3).
For nums[1]=1, there is no number smaller than it.
For nums[2]=2, there is one number smaller than it (1).
For nums[3]=2, there is one number smaller than it (1).
For nums[4]=3, there are three numbers smaller than it (1, 2, and 2).
```

### Example 2:
```
Input: nums = [6,5,4,8]
Output: [2,1,0,3]
```

## Solution Approach

We need to count, for each element, how many elements in the array are smaller than it. This can be efficiently solved using counting sort.

## Algorithm

1. Create a copy of the original array and sort it.
2. Create a hash map to store the rank of each number:
   - For each number in the sorted array, if it's not already in the map, map it to its index.
   - This gives us the count of numbers smaller than each unique number.
3. For each number in the original array, look up its rank in the hash map.
4. Return the array of ranks.

## Alternative Algorithm (Counting Sort)

If the range of numbers is limited:
1. Find the minimum and maximum values in the array.
2. Create a count array of size (max - min + 1).
3. Count the frequency of each number.
4. Compute the prefix sum of the count array to get the cumulative count.
5. For each number in the original array, the answer is the cumulative count up to that number minus 1.
6. Return the result array.

## Complexity

- **Time**: O(n log n) for sorting approach, O(n + m) for counting sort where m is the range of values
- **Space**: O(n) for both approaches

## Link

[LeetCode 1365 How Many Numbers Are Smaller Than the Current Number](https://leetcode.com/problems/how-many-numbers-are-smaller-than-the-current-number/)