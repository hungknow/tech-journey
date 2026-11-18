# 0305 Number of Islands II

## Problem Description

You are given an empty 2D binary grid `grid` of size `m x n`. The grid is initially empty (all cells are water).

You are also given an array `positions` where `positions[i] = [ri, ci]` represents the position (ri, ci) where you want to add a land cell.

Return the number of islands after each addition. An island is surrounded by water and is formed by connecting adjacent lands horizontally or vertically.

### Example 1:
```
Input: m = 3, n = 3, positions = [[0,0],[0,1],[1,2],[2,1]]
Output: [1,1,2,3]
```

### Example 2:
```
Input: m = 1, n = 2, positions = [[0,1],[0,0]]
Output: [1,1]
```

## The Twist

Hash map/array is used to store the **parent sets** (`flattened_1D_coordinate -> root_coordinate`) to fuel the Union-Find algorithm as islands are dynamically added.

## Hash Table Usage

- **Key**: `flattened_index` (i * n + j, the 1D representation of 2D coordinates)
- **Value**: `parent_index` (the root of this cell in the Union-Find structure)

Algorithm:
1. Initialize parent and rank arrays for Union-Find
2. For each position:
   - If already land, append current island count and continue
   - Add the new land cell
   - Check all 4 neighbors
   - If neighbor is land, union the current cell with the neighbor
   - Update island count accordingly
3. Append the current island count to the result

## Complexity

- **Time**: O(k * α(mn)) where k is number of positions, α is the inverse Ackermann function (nearly constant)
- **Space**: O(mn) - storing parent and rank arrays

## Solution Code

### Go

```go
func numIslands2(m int, n int, positions [][]int) []int {
	parent := make([]int, m*n)
	rank := make([]int, m*n)
	for i := range parent {
		parent[i] = i
	}
	isLand := make([]bool, m*n)
	count := 0
	result := make([]int, 0, len(positions))

	var find func(x int) int
	find = func(x int) int {
		if parent[x] != x {
			parent[x] = find(parent[x])
		}
		return parent[x]
	}

	union := func(x, y int) bool {
		rootX, rootY := find(x), find(y)
		if rootX == rootY {
			return false
		}
		if rank[rootX] < rank[rootY] {
			rootX, rootY = rootY, rootX
		}
		parent[rootY] = rootX
		if rank[rootX] == rank[rootY] {
			rank[rootX]++
		}
		return true
	}

	for _, pos := range positions {
		r, c := pos[0], pos[1]
		idx := r*n + c
		if isLand[idx] {
			result = append(result, count)
			continue
		}
		isLand[idx] = true
		count++
		for _, d := range [][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}} {
			nr, nc := r+d[0], c+d[1]
			if nr < 0 || nr >= m || nc < 0 || nc >= n || !isLand[nr*n+nc] {
				continue
			}
			if union(idx, nr*n+nc) {
				count--
			}
		}
		result = append(result, count)
	}

	return result
}
```

### Rust

```rust
impl Solution {
    fn find(parent: &mut [usize], mut x: usize) -> usize {
        while parent[x] != x {
            parent[x] = parent[parent[x]];
            x = parent[x];
        }
        x
    }

    pub fn num_islands2(m: i32, n: i32, positions: Vec<Vec<i32>>) -> Vec<i32> {
        let (m, n) = (m as usize, n as usize);
        let mut parent: Vec<usize> = (0..m * n).collect();
        let mut rank = vec![0usize; m * n];
        let mut is_land = vec![false; m * n];
        let mut count = 0i32;
        let mut result = Vec::with_capacity(positions.len());

        for pos in &positions {
            let (r, c) = (pos[0] as usize, pos[1] as usize);
            let idx = r * n + c;
            if is_land[idx] {
                result.push(count);
                continue;
            }
            is_land[idx] = true;
            count += 1;
            for (dr, dc) in [(-1isize, 0isize), (1, 0), (0, -1), (0, 1)] {
                let (nr, nc) = (r as isize + dr, c as isize + dc);
                if nr < 0 || nr >= m as isize || nc < 0 || nc >= n as isize {
                    continue;
                }
                let nidx = nr as usize * n + nc as usize;
                if !is_land[nidx] {
                    continue;
                }
                let (root_a, root_b) =
                    (Self::find(&mut parent, idx), Self::find(&mut parent, nidx));
                if root_a != root_b {
                    if rank[root_a] < rank[root_b] {
                        parent[root_a] = root_b;
                    } else {
                        parent[root_b] = root_a;
                        if rank[root_a] == rank[root_b] {
                            rank[root_a] += 1;
                        }
                    }
                    count -= 1;
                }
            }
            result.push(count);
        }

        result
    }
}
```

## Link

[LeetCode 0305 Number of Islands II](https://leetcode.com/problems/number-of-islands-ii/)
