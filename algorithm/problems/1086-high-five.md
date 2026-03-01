# 1086 High Five

## Problem Description

Each student's exam scores are stored in a list. The scores may not be in order. We need to find the average of the top five scores for each student.

Given a list of `items` where each `item` is a pair `[id, score]`, return the top five highest averages for each student.

### Example 1:
```
Input: items = [[1,91],[1,92],[2,93],[2,97],[1,60],[2,77],[1,65],[1,87],[1,100],[2,100],[2,76]]
Output: [[1,87],[2,88]]
Explanation: 
- For student 1, the scores are [91, 92, 60, 65, 87, 100]. The top five scores are [100, 92, 91, 87, 65], and the average is (100+92+91+87+65)/5 = 87.
- For student 2, the scores are [93, 97, 77, 100, 76]. The top five scores are [100, 97, 93, 77, 76], and the average is (100+97+93+77+76)/5 = 88.
```

## Solution Approach

We need to group scores by student ID, find the top five scores for each student, calculate their average, and return the results.

## Algorithm

1. Use a hash map to group scores by student ID:
   - For each item [id, score], add the score to the list of scores for that student.
2. For each student:
   - Sort their scores in descending order.
   - Take the top five scores (or all if fewer than five).
   - Calculate the average of these scores (integer division).
3. Create a list of [id, average] pairs.
4. Sort the result by student ID (ascending).
5. Return the sorted result.

## Alternative Algorithm (Using Min-Heap)

1. Use a hash map where each value is a min-heap of size up to 5:
   - For each item [id, score], add the score to the student's heap.
   - If the heap size exceeds 5, remove the smallest score.
2. For each student:
   - Calculate the average of all scores in their heap.
3. Create a list of [id, average] pairs.
4. Sort the result by student ID (ascending).
5. Return the sorted result.

## Complexity

- **Time**: O(n log n) for sorting approach, O(n log k) where k=5 for heap approach
- **Space**: O(n) for both approaches

## Link

[LeetCode 1086 High Five](https://leetcode.com/problems/high-five/)