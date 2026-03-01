# 0913 Cat and Mouse

## Problem Description

A game is played on a graph of `n` nodes labeled from `0` to `n-1`. The graph is represented by an `edges` array where `edges[i] = [ui, vi]` represents an edge between `ui` and `vi`.

There are two players: a cat and a mouse. The cat starts at node `cat` and the mouse starts at node `mouse`. They take turns moving, with the mouse moving first.

On each turn, a player can move to an adjacent node or stay in place.

The mouse wins if it reaches node `0` before the cat catches it.
The cat wins if it catches the mouse (reaches the same node).
If the game continues indefinitely, it's a draw.

Return the winner: `1` if mouse wins, `2` if cat wins, or `0` if it's a draw.

### Example 1:
```
Input: graph = [[2,5],[3],[0,4,5],[1,4,5],[2,3],[0,2,3,4]]
cat = 2, mouse = 3
Output: 1
```

### Example 2:
```
Input: graph = [[1,3],[0],[3],[0,2]]
cat = 0, mouse = 2
Output: 2
```

## Approach

This problem can be solved using BFS with game theory concepts:

1. **State Representation**:
   - Each state is (cat_position, mouse_position, turn)
   - Turn alternates between mouse (0) and cat (1)

2. **BFS from Terminal States**:
   - Start from terminal states where the game is decided
   - Mouse wins when mouse reaches node 0
   - Cat wins when cat catches mouse
   - Work backwards to determine the outcome of all states

3. **Game Theory Logic**:
   - If it's mouse's turn and any neighbor leads to mouse win, current state is mouse win
   - If all neighbors lead to cat win, current state is cat win
   - Otherwise, it's a draw

## Solution Code

```go
func catMouseGame(graph [][]int) int {
    n := len(graph)
    
    // State: (cat_position, mouse_position, turn)
    // turn: 0 = mouse's turn, 1 = cat's turn
    // Result: 0 = draw, 1 = mouse win, 2 = cat win
    
    // Initialize result and degree arrays
    result := make([][][]int, n)
    degree := make([][][]int, n)
    for i := 0; i < n; i++ {
        result[i] = make([][]int, n)
        degree[i] = make([][]int, n)
        for j := 0; j < n; j++ {
            result[i][j] = make([]int, 2)
            degree[i][j] = make([]int, 2)
        }
    }
    
    queue := [][3]int{}
    
    // Initialize terminal states
    for i := 0; i < n; i++ {
        for j := 1; j < n; j++ {
            // Mouse at 0 -> mouse wins
            result[0][j][0] = 1
            result[0][j][1] = 1
            queue = append(queue, [3]int{0, j, 0})
            queue = append(queue, [3]int{0, j, 1})
            
            // Cat catches mouse -> cat wins
            if i != 0 {
                result[i][i][0] = 2
                result[i][i][1] = 2
                queue = append(queue, [3]int{i, i, 0})
                queue = append(queue, [3]int{i, i, 1})
            }
        }
    }
    
    // Calculate degrees
    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
            degree[i][j][0] = len(graph[j]) // Mouse's turn: mouse can move to any neighbor
            degree[i][j][1] = len(graph[i]) // Cat's turn: cat can move to any neighbor
        }
    }
    
    // BFS
    for len(queue) > 0 {
        state := queue[0]
        queue = queue[1:]
        
        cat, mouse, turn := state[0], state[1], state[2]
        currentResult := result[cat][mouse][turn]
        
        // Find parent states
        parents := [][3]int{}
        
        if turn == 0 { // Mouse's turn, previous was cat's turn
            for _, prevCat := range graph[cat] {
                if prevCat != 0 { // Cat can't go to hole
                    parents = append(parents, [3]int{prevCat, mouse, 1})
                }
            }
        } else { // Cat's turn, previous was mouse's turn
            for _, prevMouse := range graph[mouse] {
                parents = append(parents, [3]int{cat, prevMouse, 0})
            }
        }
        
        for _, parent := range parents {
            prevCat, prevMouse, prevTurn := parent[0], parent[1], parent[2]
            
            if result[prevCat][prevMouse][prevTurn] != 0 {
                continue
            }
            
            // If current player can force a win, parent state is also a win
            if (prevTurn == 0 && currentResult == 1) || (prevTurn == 1 && currentResult == 2) {
                result[prevCat][prevMouse][prevTurn] = currentResult
                queue = append(queue, [3]int{prevCat, prevMouse, prevTurn})
                continue
            }
            
            degree[prevCat][prevMouse][prevTurn]--
            
            // If all moves lead to opponent win, current player loses
            if degree[prevCat][prevMouse][prevTurn] == 0 {
                result[prevCat][prevMouse][prevTurn] = 3 - currentResult
                queue = append(queue, [3]int{prevCat, prevMouse, prevTurn})
            }
        }
    }
    
    return result[cat][mouse][0]
}
```

## Complexity Analysis

- **Time**: O(n^3) where n is the number of nodes
  - There are O(n^2) states with 2 turns each
  - For each state, we process O(n) parent states
- **Space**: O(n^2) for the result and degree arrays

## Link

[LeetCode 0913 Cat and Mouse](https://leetcode.com/problems/cat-and-mouse/)