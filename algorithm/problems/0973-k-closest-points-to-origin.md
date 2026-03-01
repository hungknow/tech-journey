# 0973 K Closest Points to Origin

## Problem Description

Given an array of `points` where `points[i] = [xi, yi]`, return the `k` closest points to the origin `(0, 0)`.

The distance between two points on the X-Y plane is the Euclidean distance (i.e., `√(x1 - x2)² + (y1 - y2)²`).

You may return the answer in any order. The answer is guaranteed to be unique (except for the order that it is in).

### Example 1:
```
Input: points = [[1,3],[-2,2]], k = 1
Output: [[-2,2]]
Explanation:
The distance between (1, 3) and the origin is sqrt(10).
The distance between (-2, 2) and the origin is sqrt(8).
Since sqrt(8) < sqrt(10), (-2, 2) is closer to the origin.
```

### Example 2:
```
Input: points = [[3,3],[5,-1],[-2,4]], k = 2
Output: [[3,3],[-2,4]]
```

## Solution Approach

We need to find the k closest points to the origin. There are several approaches:
1. Sort all points by distance and take the first k (O(n log n)).
2. Use a max-heap of size k (O(n log k)).
3. Use Quickselect to find the k-th smallest distance (O(n) on average).

## Algorithm (Quickselect)

1. Define a distance function that calculates the squared distance from the origin (no need for the actual square root).
2. Use Quickselect to partition the points around the k-th smallest distance:
   - Choose a pivot point.
   - Partition the array such that points closer than the pivot are on the left, and points farther are on the right.
   - Recursively apply Quickselect to the appropriate partition until the pivot is at position k.
3. Return the first k points.

## Alternative Algorithm (Max-Heap)

1. Create a max-heap to store the k closest points found so far.
2. For each point:
   - Calculate its distance from the origin.
   - If the heap has fewer than k points, add the current point.
   - Otherwise, if the current point is closer than the farthest point in the heap, replace it.
3. Return all points in the heap.

## Complexity

- **Time**: O(n) on average for Quickselect, O(n log k) for heap approach, O(n log n) for sorting approach
- **Space**: O(k) for heap approach, O(1) for Quickselect (in-place), O(n) for sorting approach

## Link

[LeetCode 0973 K Closest Points to Origin](https://leetcode.com/problems/k-closest-points-to-origin/)