# 1274 Number of Ships in a Rectangle

## Problem Description

(This problem is an interactive problem.)

Each ship is located at an integer point on the sea represented by a cartesian plane, and each integer point may contain at most one ship.

You have a function `Sea.hasShips(topRight, bottomLeft)` which returns true if there is at least one ship in the rectangle represented by its top right and bottom left corners (inclusive), and false otherwise.

Use the function `Sea.hasShips` to find the number of ships on the sea.

### Example 1:
```
Input: 
ships = [[1,1],[2,2],[3,3],[5,5]], topRight = [4,4], bottomLeft = [0,0]
Output: 3
Explanation: From [0,0] to [4,4] we can count 3 ships within the rectangle.
```

## The Twist

Finding the **number of ships** in a rectangle using divide and conquer with binary search. The key is to recursively divide the search space.

## Algorithm

### Divide and Conquer with Binary Search:
1. Base cases:
   - If rectangle is empty or has no ships, return 0
   - If rectangle is a single point, return 1 if it has a ship
2. Divide the rectangle into 4 quadrants
3. Recursively count ships in each quadrant
4. Return the sum of ships from all quadrants

The key insight is to stop recursion early when a quadrant has no ships.

## Complexity

- **Time**: O(log(m * n)) - divide and conquer
- **Space**: O(log(m * n)) - recursion depth

## Solution Code

```go
package main

/**
 * // This is Sea's API interface.
 * // You should not implement it, or speculate about its implementation
 * type Sea struct {
 *     func hasShips(topRight, bottomLeft []int) bool
 * }
 */

type Sea struct {
	// This would be provided by the platform
	// For testing purposes, let's implement a simple version
	ships [][]int
}

func (s *Sea) hasShips(topRight, bottomLeft []int) bool {
	// Check if any ship is in the rectangle
	for _, ship := range s.ships {
		if ship[0] >= bottomLeft[0] && ship[0] <= topRight[0] &&
		   ship[1] >= bottomLeft[1] && ship[1] <= topRight[1] {
			return true
		}
	}
	return false
}

func countShips(sea Sea, topRight, bottomLeft []int) int {
	// Base case: no ships in this area
	if !sea.hasShips(topRight, bottomLeft) {
		return 0
	}
	
	// Base case: single point
	if topRight[0] == bottomLeft[0] && topRight[1] == bottomLeft[1] {
		return 1
	}
	
	// Divide the area into 4 quadrants
	midX := (topRight[0] + bottomLeft[0]) / 2
	midY := (topRight[1] + bottomLeft[1]) / 2
	
	// Top-right quadrant
	count := countShips(sea, topRight, []int{midX + 1, midY + 1})
	
	// Top-left quadrant
	count += countShips(sea, []int{midX, topRight[1]}, []int{bottomLeft[0], midY + 1})
	
	// Bottom-right quadrant
	count += countShips(sea, []int{topRight[0], midY}, []int{midX + 1, bottomLeft[1]})
	
	// Bottom-left quadrant
	count += countShips(sea, []int{midX, midY}, bottomLeft)
	
	return count
}
```

## Link

[LeetCode 1274 Number of Ships in a Rectangle](https://leetcode.com/problems/number-of-ships-in-a-rectangle/)
