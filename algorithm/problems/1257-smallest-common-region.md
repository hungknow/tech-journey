# 1257 Smallest Common Region

## Problem Description

You are given some lists `regions` where the first list of each pair is a parent region and the second list is a list of child regions.

If two regions have the same name and share a common border, they belong to the same region.

Return the smallest region that contains all the given regions. If there are multiple smallest regions, return any of them.

### Example 1:
```
Input: regions = [["Earth","North America","South America"],
["North America","South America"],
["North America","Canada"],
["Canada","Quebec","Ontario","Manitoba"]]
Output: "North America"
```

### Example 2:
```
Input: regions = [["Earth","North America","South America"],
["North America","United States","New York"],
["United States","New York","Albany","Manhattan"],
["Canada","Ontario","Quebec","Manitoba"]]
Output: "North America"
```

## The Twist

We need to find the **smallest region** that contains all given regions. This requires building a hierarchy from the parent-child relationships.

## Algorithm

### Union-Find with Hierarchy Building:
1. Build a hash map from region name to its parent
2. Use Union-Find to connect all regions
3. Find the root of each region
4. For each root, count how many of the given regions belong to its subtree
5. Return the root with the maximum count

### Using DFS with Parent Tracking:
1. Build adjacency list from the parent-child relationships
2. Use DFS to find the root of each region
3. For each root, count regions in its subtree
4. Return the root with maximum count

## Complexity

- **Time**: O(n + m * n) - n is number of regions, m is number of parent-child pairs
- **Space**: O(n + m * n) - storing adjacency and parent relationships

## Link

[LeetCode 1257 Smallest Common Region](https://leetcode.com/problems/smallest-common-region/)
