# 1620 Coordinate With Maximum Network Quality

## Problem Description

You are given an array of network towers `towers` and an integer `radius`. Each tower i is located at coordinates (xi, yi) and has a quality value qi.

The signal quality of a tower at coordinate (x, y) from a tower at (xi, yi) is calculated as:
- If the distance between (x, y) and (xi, yi) is greater than radius, the signal quality is 0
- Otherwise, the signal quality is ⌊qi / (1 + d)⌋, where d is the Euclidean distance between the coordinates

The network quality at a coordinate (x, y) is the sum of signal qualities from all towers.

Find the coordinate (x, y) with the highest network quality. If there are multiple such coordinates, return the lexicographically smallest one.

### Example 1:
```
Input: towers = [[1,2,5],[2,1,7],[3,1,9]], radius = 2
Output: [2,1]
Explanation: The coordinate (2,1) has the highest network quality.
```

### Example 2:
```
Input: towers = [[23,11,21]], radius = 9
Output: [23,11]
```

## Solution Approach

We need to find the coordinate with the maximum network quality. Since the coordinates are integers and the range is limited, we can check all possible coordinates within the bounding box of the towers.

## Algorithm

1. Find the minimum and maximum x and y coordinates from all towers
2. For each coordinate (x, y) in the bounding box:
   - Calculate the total network quality from all towers
   - Keep track of the coordinate with the maximum quality
3. Return the coordinate with the highest quality (lexicographically smallest if ties)

## Why This Works

By checking all possible coordinates within the bounding box, we ensure we find the optimal solution. The lexicographical order is handled by updating the result only when we find a strictly better quality or the same quality with a smaller coordinate.

## Complexity

- **Time**: O(n²) where n is the range of coordinates
- **Space**: O(1) - constant extra space

## Link

[LeetCode 1620 Coordinate With Maximum Network Quality](https://leetcode.com/problems/coordinate-with-maximum-network-quality/)