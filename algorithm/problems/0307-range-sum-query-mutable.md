# 0307 Range Sum Query - Mutable

## Problem Description

Given an integer array `nums`, handle multiple queries of the following types:
1. **Update** the value of an element in `nums`.
2. **Calculate the sum** of the elements of `nums` between indices `left` and `right` inclusive.

Implement the `NumArray` class:
- `NumArray(int[] nums)` Initializes the object with the integer array `nums`.
- `void update(int index, int val)` Updates the value of `nums[index]` to `val`.
- `int sumRange(int left, int right)` Returns the sum of all the elements `nums[i]` such that `left <= i <= right`.

### Example 1:
```
Input
["NumArray", "sumRange", "update", "sumRange"]
[[[1, 3, 5]], [0, 2], [1, 2], [0, 2]]
Output
[null, 9, null, 8]
```

### Example 2:
```
Input
["NumArray", "sumRange", "update", "sumRange"]
[[[1, 1, 1, 1, 1]], [0, 4], [1, 3], [0, 4]]
Output
[null, 5, null, 7]
```

## The Twist

The array is **mutable** with frequent updates. A naive sumRange would be O(n) per query, which is too slow. We need a data structure that supports both updates and range sum queries efficiently.

## Algorithm

### Binary Indexed Tree (Fenwick Tree):
1. Build BIT from initial array
2. **update**: Add delta to BIT at index, propagate up
3. **sumRange**: Return prefixSum(right) - prefixSum(left - 1)

### Segment Tree:
1. Build segment tree from initial array
2. **update**: Update leaf and propagate changes up
3. **sumRange**: Query segment tree for range sum

## Complexity

- **Constructor**: O(n)
- **update()**: O(log n)
- **sumRange()**: O(log n)
- **Space**: O(n)

## Solution Code

### Go

```go
type NumArray struct {
    nums []int
    tree []int // Binary Indexed Tree, 1-indexed
}

func Constructor(nums []int) NumArray {
    na := NumArray{
        nums: append([]int(nil), nums...),
        tree: make([]int, len(nums)+1),
    }
    for i, v := range nums {
        na.add(i+1, v)
    }
    return na
}

func (na *NumArray) add(i int, delta int) {
    for i < len(na.tree) {
        na.tree[i] += delta
        i += i & (-i)
    }
}

func (na *NumArray) prefixSum(i int) int {
    sum := 0
    for i > 0 {
        sum += na.tree[i]
        i -= i & (-i)
    }
    return sum
}

func (na *NumArray) Update(index int, val int) {
    delta := val - na.nums[index]
    na.nums[index] = val
    na.add(index+1, delta)
}

func (na *NumArray) SumRange(left int, right int) int {
    return na.prefixSum(right+1) - na.prefixSum(left)
}
```

### Rust

```rust
struct NumArray {
    nums: Vec<i32>,
    tree: Vec<i32>, // Binary Indexed Tree, 1-indexed
}

impl NumArray {
    fn new(nums: Vec<i32>) -> Self {
        let mut obj = NumArray {
            nums: nums.clone(),
            tree: vec![0; nums.len() + 1],
        };
        for (i, &v) in nums.iter().enumerate() {
            obj.add(i + 1, v);
        }
        obj
    }

    fn add(&mut self, mut i: usize, delta: i32) {
        while i < self.tree.len() {
            self.tree[i] += delta;
            i += i & i.wrapping_neg();
        }
    }

    fn prefix_sum(&self, mut i: usize) -> i32 {
        let mut sum = 0;
        while i > 0 {
            sum += self.tree[i];
            i -= i & i.wrapping_neg();
        }
        sum
    }

    fn update(&mut self, index: i32, val: i32) {
        let index = index as usize;
        let delta = val - self.nums[index];
        self.nums[index] = val;
        self.add(index + 1, delta);
    }

    fn sum_range(&self, left: i32, right: i32) -> i32 {
        self.prefix_sum(right as usize + 1) - self.prefix_sum(left as usize)
    }
}
```

## Link

[LeetCode 0307 Range Sum Query - Mutable](https://leetcode.com/problems/range-sum-query-mutable/)
