# 0353 Design Snake Game

## Problem Description

Design a Snake game that is played on a device with screen size `height x width`. The snake is initially positioned at the top left corner (0, 0) with length 1.

The snake moves on the screen according to the following rules:

1. Every second, the snake moves to the right by one unit.
2. If the snake crosses the screen boundary or bites its own body, the game is over.
3. If the snake eats food, its length increases by 1 and it continues moving.
4. The food appears at random positions on the screen, but never on the snake's body.

Implement the `SnakeGame` class:

- `SnakeGame(int width, int height, int[][] food)` Initializes the game with screen size and food positions.
- `int move(String direction)` Returns the score after the move. If the game is over, returns -1.

### Example 1:
```
Input
["SnakeGame", "move", "move", "move", "move", "move", "move"]
[[3, 2, [[1, 2], [0, 1]]], ["R"], ["D"], ["R"], ["U"], ["L"], ["D"]]
Output
[null, 0, 0, 1, 1, 2, -1]

Explanation
SnakeGame snakeGame = new SnakeGame(3, 2, [[1, 2], [0, 1]]);
snakeGame.move("R"); // return 0
snakeGame.move("D"); // return 0
snakeGame.move("R"); // return 1 (ate food)
snakeGame.move("U"); // return 1
snakeGame.move("L"); // return 2 (ate food)
snakeGame.move("D"); // return -1 (game over)
```

## The Twist

Implementing the Snake game with efficient collision detection and food management. The challenge is to maintain the snake's body and check for collisions in O(1) time.

## Algorithm

### Deque + HashSet Approach:
1. Use a deque to represent the snake's body (head at front, tail at back)
2. Use a hash set to store all body positions for O(1) collision detection
3. Track the current food index and move the snake according to direction
4. For each move:
   - Calculate new head position
   - Check if new position is out of bounds or collides with body (excluding tail)
   - If food is at new position:
     - Increase score and move to next food
     - Add new head without removing tail (snake grows)
   - If no food:
     - Remove tail from deque and hash set
     - Add new head to deque and hash set
   - Return current score or -1 if game over

## Complexity

- **Time**: O(1) for each move operation
- **Space**: O(width × height) - worst case when snake fills entire screen

## Solution Code

```go
package main

type SnakeGame struct {
    width      int
    height     int
    food       [][]int
    foodIndex  int
    body       [][2]int
    bodySet    map[[2]int]bool
    head       [2]int
}

func Constructor(width int, height int, food [][]int) SnakeGame {
    bodySet := make(map[[2]int]bool)
    bodySet[[2]int{0, 0}] = true
    
    return SnakeGame{
        width:     width,
        height:    height,
        food:      food,
        foodIndex: 0,
        body:      [][2]int{{0, 0}},
        bodySet:   bodySet,
        head:      [2]int{0, 0},
    }
}

func (this *SnakeGame) Move(direction string) int {
    // Calculate new head position
    newHead := [2]int{this.head[0], this.head[1]}
    
    switch direction {
    case "U":
        newHead[0]--
    case "D":
        newHead[0]++
    case "L":
        newHead[1]--
    case "R":
        newHead[1]++
    }
    
    // Check if out of bounds
    if newHead[0] < 0 || newHead[0] >= this.height || 
       newHead[1] < 0 || newHead[1] >= this.width {
        return -1
    }
    
    // Get current tail position
    tail := this.body[len(this.body)-1]
    
    // Remove tail from body set temporarily
    delete(this.bodySet, tail)
    
    // Check if new head collides with body
    if _, exists := this.bodySet[newHead]; exists {
        return -1
    }
    
    // Add new head to body
    this.head = newHead
    this.body = append([][2]int{newHead}, this.body...)
    this.bodySet[newHead] = true
    
    // Check if food is eaten
    if this.foodIndex < len(this.food) && 
       newHead[0] == this.food[this.foodIndex][0] && 
       newHead[1] == this.food[this.foodIndex][1] {
        this.foodIndex++
        return this.foodIndex
    }
    
    // If no food eaten, remove tail permanently
    this.body = this.body[:len(this.body)-1]
    this.bodySet[tail] = false
    
    return this.foodIndex
}
```

## Link

[LeetCode 0353 Design Snake Game](https://leetcode.com/problems/design-snake-game/)