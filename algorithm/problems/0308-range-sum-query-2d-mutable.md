# 0308 Range Sum Query 2D - Mutable

## Problem Description

Given a 2D matrix `matrix`, handle multiple queries of the following types:
1. **Update** the value of a cell in `matrix`.
2. **Calculate the sum** of the elements of `matrix` inside the rectangle defined by its upper left corner `(row1, col1)` and lower right corner `(row2, col2)`.

Implement the `NumMatrix` class:
- `NumMatrix(int[][] matrix)` Initializes the object with the integer matrix `matrix`.
- `void update(int row, int col, int val)` Updates `matrix[row][col] = matrix[row][col] + val`.
- `int sumRegion(int row1, int col1, int row2, int col2)` Returns the sum of all elements `matrix[i][j]` such that `row1 <= i <= row2` and `col1 <= j <= col2`.

### Example 1:
```
Input
["NumMatrix", "sumRegion", "update", "sumRegion", "sumRegion", "update", "sumRegion"]
[[[[3, 0, 1, 4, 2], [5, 6, 3, 2, 1], [1, 2, 0, 1, 5], [4, 1, 0, 1, 7], [1, 0, 3, 2, 1]]], [2, 1, 4, 3], [3, 2, 2], [2, 1, 4, 3], [0, 2, 2], [2, 1, 4, 3]]
Output
[null, 8, null, 10, null, 14]
```

### Example 2:
```
Input
["NumMatrix", "sumRegion", "update", "sumRegion", "sumRegion", "update", "sumRegion"]
[[[[1, 2, 3], [4, 5, 6], [7, 8, 9]]], [0, 0, 2, 2], [1, 1, 10], [0, 0, 2, 2], [0, 0, 2, 2], [1, 1, -10], [0, 0, 2, 2]]
Output
[null, 12, null, 12, null, 2]
```

## The Twist

This is the **2D version** of the range sum query problem. We need a data structure that supports efficient 2D updates and range sum queries.

## Algorithm

### 2D Binary Indexed Tree (Fenwick Tree):
1. Build 2D BIT from initial matrix
2. **update**: Update 2D BIT at (row, col), propagate in both dimensions
3. **sumRegion**: Use inclusion-exclusion principle with 2D prefix sums

### 2D Segment Tree:
1. Build 2D segment tree from initial matrix
2. **update**: Update leaf and propagate in both dimensions
3. **sumRegion**: Query 2D segment tree for range sum

### Quad Tree:
1. Divide matrix into quadrants recursively
2. Each node stores sum of its region
3. **update**: Update relevant nodes and propagate
4. **sumRegion**: Combine sums of relevant regions

## Complexity

- **Constructor**: O(m * n)
- **update()**: O(log m * log n) for BIT/Segment Tree
- **sumRegion()**: O(log m * log n) for BIT/Segment Tree
- **Space**: O(m * n)

## Solution Code

2D Binary Indexed Tree (Fenwick Tree), 1-indexed. Per the LeetCode 308 specification, `update` sets `matrix[row][col] = val`; the delta applied to the tree is `val - matrix[row][col]`.

### Go

```go
package main

type NumMatrix struct {
	m, n   int
	tree   [][]int // 2D BIT, 1-indexed
	matrix [][]int // current values, 0-indexed
}

func Constructor(matrix [][]int) NumMatrix {
	m := len(matrix)
	n := 0
	if m > 0 {
		n = len(matrix[0])
	}
	tree := make([][]int, m+1)
	for i := range tree {
		tree[i] = make([]int, n+1)
	}
	nm := NumMatrix{m: m, n: n, tree: tree, matrix: matrix}
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			nm.bitAdd(i+1, j+1, matrix[i][j])
		}
	}
	return nm
}

func (this *NumMatrix) bitAdd(row, col, delta int) {
	for i := row; i <= this.m; i += i & (-i) {
		for j := col; j <= this.n; j += j & (-j) {
			this.tree[i][j] += delta
		}
	}
}

func (this *NumMatrix) prefixSum(row, col int) int {
	sum := 0
	for i := row; i > 0; i -= i & (-i) {
		for j := col; j > 0; j -= j & (-j) {
			sum += this.tree[i][j]
		}
	}
	return sum
}

func (this *NumMatrix) Update(row int, col int, val int) {
	delta := val - this.matrix[row][col]
	this.matrix[row][col] = val
	this.bitAdd(row+1, col+1, delta)
}

func (this *NumMatrix) SumRegion(row1 int, col1 int, row2 int, col2 int) int {
	return this.prefixSum(row2+1, col2+1) -
		this.prefixSum(row1, col2+1) -
		this.prefixSum(row2+1, col1) +
		this.prefixSum(row1, col1)
}

/**
 * Your NumMatrix object will be instantiated and called as such:
 * obj := Constructor(matrix);
 * obj.Update(row,col,val);
 * param_2 := obj.SumRegion(row1,col1,row2,col2);
 */
```

### Rust

```rust
struct NumMatrix {
    m: usize,
    n: usize,
    tree: Vec<Vec<i32>>, // 2D BIT, 1-indexed
    matrix: Vec<Vec<i32>>, // current values, 0-indexed
}

impl NumMatrix {
    fn new(matrix: Vec<Vec<i32>>) -> Self {
        let m = matrix.len();
        let n = matrix.first().map_or(0, |row| row.len());
        let mut nm = NumMatrix {
            m,
            n,
            tree: vec![vec![0; n + 1]; m + 1],
            matrix,
        };
        for i in 0..m {
            for j in 0..n {
                let v = nm.matrix[i][j];
                nm.bit_add(i + 1, j + 1, v);
            }
        }
        nm
    }

    fn bit_add(&mut self, row: usize, col: usize, delta: i32) {
        let mut i = row;
        while i <= self.m {
            let mut j = col;
            while j <= self.n {
                self.tree[i][j] += delta;
                j += j & j.wrapping_neg();
            }
            i += i & i.wrapping_neg();
        }
    }

    fn prefix_sum(&self, row: usize, col: usize) -> i32 {
        let mut sum = 0;
        let mut i = row;
        while i > 0 {
            let mut j = col;
            while j > 0 {
                sum += self.tree[i][j];
                j -= j & j.wrapping_neg();
            }
            i -= i & i.wrapping_neg();
        }
        sum
    }

    fn update(&mut self, row: i32, col: i32, val: i32) {
        let (r, c) = (row as usize, col as usize);
        let delta = val - self.matrix[r][c];
        self.matrix[r][c] = val;
        self.bit_add(r + 1, c + 1, delta);
    }

    fn sum_region(&self, row1: i32, col1: i32, row2: i32, col2: i32) -> i32 {
        let (r1, c1, r2, c2) = (
            row1 as usize,
            col1 as usize,
            row2 as usize,
            col2 as usize,
        );
        self.prefix_sum(r2 + 1, c2 + 1) - self.prefix_sum(r1, c2 + 1)
            - self.prefix_sum(r2 + 1, c1)
            + self.prefix_sum(r1, c1)
    }
}
```

## Link

[LeetCode 0308 Range Sum Query 2D - Mutable](https://leetcode.com/problems/range-sum-query-2d-mutable/)
