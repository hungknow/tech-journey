# 0149 Max Points on a Line

## Problem Description

Given an array of points where `points[i] = [xi, yi]` represents a point on the X-Y plane, return the maximum number of points that lie on the same straight line.

### Example 1:
```
Input: points = [[1,1],[2,2],[3,3]]
Output: 3
```

### Example 2:
```
Input: points = [[1,1],[3,2],[5,3],[4,1],[2,3],[1,4]]
Output: 4
```

## The Twist

Finding **collinear points**. For each point, we need to find how many other points lie on the same line passing through it.

## Hash Table Usage

- **Key**: `slope` (strictly reduced fraction of dy/dx)
- **Value**: `count_of_points` (number of points with this slope from the current point)

Algorithm:
1. For each point i:
   - Calculate the slope to every other point j
   - Use the reduced fraction (dy/gcd, dx/gcd) as the key
   - Count how many points share each slope
   - Track the maximum count for this point
2. Return the overall maximum + 1 (including the point itself)

Special cases:
- Vertical lines: dx = 0, use a special key like "inf"
- Duplicate points: count separately

## Complexity

- **Time**: O(n²) - for each point, calculate slope to all other points
- **Space**: O(n) - storing slopes for each point

## Solution Code

### Go

```go
package main

func maxPoints(points [][]int) int {
	n := len(points)
	if n <= 2 {
		return n
	}

	best := 1
	for i := 0; i < n; i++ {
		slopes := make(map[[2]int]int)
		duplicates := 0
		localMax := 0

		for j := 0; j < n; j++ {
			if i == j {
				continue
			}
			dx := points[j][0] - points[i][0]
			dy := points[j][1] - points[i][1]

			// Duplicate points lie on every line through points[i]
			if dx == 0 && dy == 0 {
				duplicates++
				continue
			}

			// Reduce the fraction to get an exact slope key
			g := gcd(abs(dx), abs(dy))
			dx /= g
			dy /= g

			// Normalize sign so (dy/dx) and (-dy/-dx) share one key;
			// dx == 0 covers vertical lines, dy == 0 covers horizontal ones
			if dx < 0 || (dx == 0 && dy < 0) {
				dx, dy = -dx, -dy
			}

			slopes[[2]int{dx, dy}]++
			if slopes[[2]int{dx, dy}] > localMax {
				localMax = slopes[[2]int{dx, dy}]
			}
		}

		if localMax+duplicates+1 > best {
			best = localMax + duplicates + 1
		}
	}
	return best
}

func gcd(a, b int) int {
	for b != 0 {
		a, b = b, a%b
	}
	return a
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
```

### Rust

```rust
use std::collections::HashMap;

pub fn max_points(points: Vec<Vec<i32>>) -> i32 {
    let n = points.len();
    if n <= 2 {
        return n as i32;
    }

    let mut best = 1;
    for i in 0..n {
        let mut slopes: HashMap<(i32, i32), i32> = HashMap::new();
        let mut duplicates = 0;
        let mut local_max = 0;

        for j in 0..n {
            if i == j {
                continue;
            }
            let mut dx = points[j][0] - points[i][0];
            let mut dy = points[j][1] - points[i][1];

            // Duplicate points lie on every line through points[i]
            if dx == 0 && dy == 0 {
                duplicates += 1;
                continue;
            }

            // Reduce the fraction to get an exact slope key
            let g = gcd(dx.unsigned_abs(), dy.unsigned_abs()) as i32;
            dx /= g;
            dy /= g;

            // Normalize sign so (dy/dx) and (-dy/-dx) share one key;
            // dx == 0 covers vertical lines, dy == 0 covers horizontal ones
            if dx < 0 || (dx == 0 && dy < 0) {
                dx = -dx;
                dy = -dy;
            }

            let count = slopes.entry((dx, dy)).or_insert(0);
            *count += 1;
            local_max = local_max.max(*count);
        }

        best = best.max(local_max + duplicates + 1);
    }
    best
}

fn gcd(a: u32, b: u32) -> u32 {
    if b == 0 {
        a
    } else {
        gcd(b, a % b)
    }
}
```

## Link

[LeetCode 0149 Max Points on a Line](https://leetcode.com/problems/max-points-on-a-line/)
