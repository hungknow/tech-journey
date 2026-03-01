# 2069 Walking Robot Simulation II

## Problem Description

A robot walks on a plane with a width and height. The robot starts at position (0, 0) facing north.

The robot can receive the following commands:
- `-2`: turn left 90 degrees
- `-1`: turn right 90 degrees
- `1 <= k <= 9`: move forward k units

Implement the `Robot` class:

- `Robot(int width, int height)` Initializes the robot with the given dimensions.
- `void step(int num)` Executes the command `num`.
- `int[] getPos()` Returns the current position of the robot as [x, y].
- `string getDir()` Returns the current direction of the robot: "East", "West", "North", or "South".

### Example 1:
```
Input
["Robot","step","step","getPos","getDir","step","getPos","getDir"]
[[6,2],[2],[-2],[1],[4],[-1],[1]]
Output
[null,null,null,[2,1],"East",null,null,[4,1],"East"]

Explanation
Robot robot = new Robot(6, 2); // 6x2 grid, robot starts at (0, 0) facing North
robot.step(2);  // move forward 2 units to (0, 2)
robot.step(-2); // turn left 90 degrees, now facing West
robot.getPos();    // return [2, 1]
robot.getDir();    // return "East"
robot.step(4);  // move forward 4 units to (4, 1), still facing West
robot.getPos();    // return [4, 1]
robot.getDir();    // return "East"
```

## The Twist

Implementing a robot simulation that efficiently tracks position and direction while handling turns and movements within grid boundaries.

## Algorithm

### State Tracking Approach:
1. Track the robot's position (x, y) and direction (0=N, 1=E, 2=S, 3=W)
2. Define direction vectors for each direction
3. For Robot(width, height):
   - Initialize position at (0, 0) facing North
4. For step(num):
   - If num is -2 or -1, update direction (turn left or right)
   - If num is between 1 and 9, move forward in the current direction
   - Update position based on direction vector
   - Ensure position stays within bounds
5. For getPos():
   - Return current position
6. For getDir():
   - Return the direction string based on current direction

The key insight is using simple state tracking with direction vectors for efficient movement and boundary checking.

## Complexity

- **Time**: 
  - Robot constructor: O(1)
  - step: O(1)
  - getPos: O(1)
  - getDir: O(1)
- **Space**: O(1)

## Solution Code

```go
package main

type Robot struct {
	width  int
	height int
	x      int
	y      int
	dir    int // 0=N, 1=E, 2=S, 3=W
}

func Constructor(width int, height int) Robot {
	return Robot{
		width:  width,
		height: height,
		x:      0,
		y:      0,
		dir:    0, // facing North
	}
}

func (this *Robot) Step(num int)  {
	if num == -2 {
		// Turn left 90 degrees
		this.dir = (this.dir + 3) % 4
	} else if num == -1 {
		// Turn right 90 degrees
		this.dir = (this.dir + 1) % 4
	} else if num >= 1 && num <= 9 {
		// Move forward
		dx := []int{0, 1, 0, -1}
		dy := []int{1, 0, -1, 0}
		
		newX := this.x + dx[this.dir]*num
		newY := this.y + dy[this.dir]*num
		
		// Check boundaries
		if newX >= 0 && newX < this.width && newY >= 0 && newY < this.height {
			this.x = newX
			this.y = newY
		}
	}
}

func (this *Robot) GetPos() []int {
	return []int{this.x, this.y}
}

func (this *Robot) GetDir() string {
	directions := []string{"North", "East", "South", "West"}
	return directions[this.dir]
}

/**
 * Your Robot object will be instantiated and called as such:
 * obj := Constructor(width, height);
 * obj.Step(num);
 * param_2 := obj.GetPos();
 * param_3 := obj.GetDir();
 */
```

## Link

[LeetCode 2069 Walking Robot Simulation II](https://leetcode.com/problems/walking-robot-simulation-ii/)