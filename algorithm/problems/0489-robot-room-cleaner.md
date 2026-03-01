# 0489 Robot Room Cleaner

## Problem Description

You are controlling a robot that is located somewhere in a room. The room is modeled as an m x n grid, and each cell can be either empty or blocked.

The robot and the room are represented by an API:

```
Robot {
  // returns true if next cell is open and robot moves into the cell.
  // returns false if next cell is obstacle and robot stays on the current cell.
  move(boolean direction);

  // Robot will stay on the same cell after calling turnLeft/turnRight.
  turnLeft(boolean direction);
  turnRight(boolean direction);

  // Clean the current cell.
  clean();
}
```

The directions can be:
- Up: `direction = 0`
- Right: `direction = 1`
- Down: `direction = 2`
- Left: `direction = 3`

Implement the `cleanRoom` method to clean the entire room.

### Example 1:
```
Input:
room = [
  [1,1,1,1,1,1,1],
  [1,0,0,0,0,0,1],
  [1,0,1,1,1,0,1],
  [1,0,0,0,0,0,1],
  [1,0,1,1,1,0,1],
  [1,0,0,0,0,0,1],
  [1,1,1,1,1,1,1]
],
row = 1,
col = 2

Explanation:
All grids in the room are marked by either 0 or 1.
0 means the cell is blocked, while 1 means the cell is accessible.
The robot initially starts at the position of row=1, col=2.
From top-left corner to bottom-right corner, the room is represented by the following grid:
```

## The Twist

Implementing a room cleaning algorithm for a robot with limited sensors that can only see the next cell in the current direction, requiring backtracking and state tracking to ensure complete coverage.

## Algorithm

### Backtracking with Spiral Movement Approach:
1. Use a set to track visited cells
2. Define directions in order: up, right, down, left
3. Start from the initial position and clean it
4. For each direction:
   - Try to move forward
   - If move is successful:
     - Clean the new cell
     - Recursively clean from the new position
     - Backtrack to the previous position
   - If move fails or after backtracking, turn right to try the next direction
5. After exploring all directions, turn left to restore the original direction
6. Use coordinates relative to the starting position to track visited cells

The key insight is using a systematic backtracking approach that explores all directions from each position, ensuring complete coverage of the accessible area.

## Complexity

- **Time**: O(N) where N is the number of accessible cells in the room
- **Space**: O(N) for the visited set and recursion stack

## Solution Code

```go
package main

/**
 * // This is the robot's control interface.
 * // You should not implement it, or speculate about its implementation
 * type Robot struct {
 * }
 *
 * // Returns true if the cell in front is open and robot moves into the cell.
 * // Returns false if the cell in front is blocked and robot stays on the current cell.
 * func (robot *Robot) Move() bool {}
 *
 * // Robot will stay on the same cell after calling TurnLeft/TurnRight.
 * // Each turn will be 90 degrees.
 * func (robot *Robot) TurnLeft() {}
 * func (robot *Robot) TurnRight() {}
 *
 * // Clean the current cell.
 * func (robot *Robot) Clean() {}
 */

func cleanRoom(robot *Robot) {
	visited := make(map[[2]int]bool)
	// Directions: up, right, down, left
	directions := [][2]int{{-1, 0}, {0, 1}, {1, 0}, {0, -1}}
	
	backtrack(robot, 0, 0, 0, visited, directions)
}

func backtrack(robot *Robot, row, col, dir int, visited map[[2]int]bool, directions [][2]int) {
	// Clean current cell
	robot.Clean()
	visited[[2]int{row, col}] = true
	
	// Try all 4 directions
	for i := 0; i < 4; i++ {
		// Calculate new position
		newRow := row + directions[dir][0]
		newCol := col + directions[dir][1]
		
		// Check if new position is valid and not visited
		if !visited[[2]int{newRow, newCol}] && robot.Move() {
			// Clean the next room
			backtrack(robot, newRow, newCol, dir, visited, directions)
			
			// Move back to the original position
			goBack(robot)
		}
		
		// Change direction clockwise
		robot.TurnRight()
		dir = (dir + 1) % 4
	}
}

func goBack(robot *Robot) {
	robot.TurnRight()
	robot.TurnRight()
	robot.Move()
	robot.TurnRight()
	robot.TurnRight()
}
```

## Link

[LeetCode 0489 Robot Room Cleaner](https://leetcode.com/problems/robot-room-cleaner/)