# 2545 Sort the Students by Their Kth Score

## Problem Description

You are given a 2D integer array `score` where `score[i] = [IDi, marks]` represents the ID and marks of the ith student.

You are also given an integer `k`. Return the IDs of the top k students in descending order based on their kth score.

### Example 1:
```
Input: score = [[1,91],[2,84],[3,89],[4,85]], k = 2
Output: [1,2]
Explanation: 
Student 1 has the 2nd highest score (91).
Student 2 has the 3rd highest score (89).
The IDs of the top 2 students are [1,2].
```

### Example 2:
```
Input: score = [[1,70],[2,85],[3,85],[4,80]], k = 3
Output: [1,2,3,4]
Explanation: 
Students 1, 2, and 3 have the top 3 scores (70, 85, 85).
Their IDs are [1,2,3].
```

## Solution Approach

We need to find the kth highest scores and return the corresponding IDs. This can be solved efficiently using quickselect or a heap.

## Algorithm (Quickselect)

1. Use quickselect to find the kth largest score.
2. Collect the ID of this score.
3. Repeat until we have k scores.
4. Return the collected IDs.

## Alternative Algorithm (Heap)

1. Create a min-heap of size k.
2. Iterate through the scores:
   - Add each (ID, marks) pair to the heap.
   - If the heap size exceeds k, remove the smallest element.
   - If the current marks are larger than the smallest, replace the smallest.
3. Extract the IDs from the heap.
4. Return the collected IDs.

## Why This Works

Both approaches efficiently find the kth largest scores in O(n) average time.

## Complexity

- **Time**: O(n) on average for quickselect, O(n log k) for heap approach
- **Space**: O(k) for the heap

## Link

[LeetCode 2545 Sort the Students by Their Kth Score](https://leetcode.com/problems/sort-the-students-by-their-kth-score/)