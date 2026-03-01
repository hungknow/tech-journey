# 2512 Reward Top K Students

## Problem Description

You are given a string array `positiveFeedback` and `negativeFeedback`, and a string array `report` containing the comments of students.

A student is considered top if they have at least `k` positive feedback words and at most `k` negative feedback words.

Return the IDs of the top students in any order.

### Example 1:
```
Input: positiveFeedback = ["excellent","good","well-done"], negativeFeedback = ["noob","bad","boring"], report = ["The student is excellent","The student is well-done","The student is noob","The student is boring"], k = 2
Output: [1,2]
Explanation: 
Student 0 has 2 positive words and 0 negative words.
Student 1 has 1 positive word and 1 negative word.
Student 2 has 1 positive word and 1 negative word.
Students 0 and 1 are top students.
```

### Example 2:
```
Input: positiveFeedback = ["good","excellent","well-done"], negativeFeedback = ["noob","bad","boring"], report = ["The student is good","The student is excellent","The student is well-done","The student is noob","The student is boring"], k = 3
Output: [0,1,2]
Explanation: 
Student 0 has 2 positive words and 0 negative words.
Student 1 has 1 positive word and 1 negative word.
Student 2 has 2 positive words and 1 negative word.
All three students are top students.
```

## Solution Approach

We need to count positive and negative feedback words for each student and identify the top students based on these counts.

## Algorithm

1. Create sets of positive and negative feedback words for efficient lookup.
2. For each student report:
   - Count positive and negative words.
   - A student is top if positive >= k and negative <= k.
3. Collect IDs of all top students.
4. Sort the result if needed.
5. Return the result.

## Why This Works

By counting feedback words and comparing with thresholds, we efficiently identify top students.

## Complexity

- **Time**: O(n × m) where n is the number of students and m is the average number of words per report
- **Space**: O(p) - for the feedback sets

## Link

[LeetCode 2512 Reward Top K Students](https://leetcode.com/problems/reward-top-k-students/)