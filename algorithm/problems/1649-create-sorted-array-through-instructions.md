# Create Sorted Array Through Instructions

## Problem Description

Given an integer array `instructions`, you need to create a sorted array from the elements in `instructions`. You start with an empty container `nums`. For each element from `instructions`, insert it into `nums`. The cost of each insertion is the minimum of:

- The number of elements currently in `nums` that are strictly less than `instructions[i]`
- The number of elements currently in `nums` that are strictly greater than `instructions[i]`

For example, if inserting `3` into `nums = [1,2,3,5]`, the cost is `min(2, 1)` (elements less than 3 are 1 and 2, elements greater than 3 is 5).

Return the total cost to insert all elements from `instructions` into `nums`. Since the answer may be large, return it modulo `10^9 + 7`.

**Example 1:**
```
Input: instructions = [1,5,6,2]
Output: 1
Explanation: Begin with nums = [].
Insert 1, cost = min(0, 0) = 0, nums = [1]
Insert 5, cost = min(1, 0) = 0, nums = [1,5]
Insert 6, cost = min(2, 0) = 0, nums = [1,5,6]
Insert 2, cost = min(1, 2) = 1, nums = [1,2,5,6]
The total cost is 0 + 0 + 0 + 1 = 1.
```

**Example 2:**
```
Input: instructions = [1,2,3,6,5,4]
Output: 3
Explanation: Begin with nums = [].
Insert 1, cost = min(0, 0) = 0, nums = [1]
Insert 2, cost = min(1, 0) = 0, nums = [1,2]
Insert 3, cost = min(2, 0) = 0, nums = [1,2,3]
Insert 6, cost = min(3, 0) = 0, nums = [1,2,3,6]
Insert 5, cost = min(3, 1) = 1, nums = [1,2,3,5,6]
Insert 4, cost = min(3, 2) = 2, nums = [1,2,3,4,5,6]
The total cost is 0 + 0 + 0 + 0 + 1 + 2 = 3.
```

**Example 3:**
```
Input: instructions = [1,3,3,3,2,4,2,1,2]
Output: 5
```

**Constraints:**
- 1 <= instructions.length <= 10^5
- 1 <= instructions[i] <= 10^5

## The Twist

This is a variant of the "Count of Smaller Numbers After Self" problem. The key insight is that we need to efficiently count the number of elements less than and greater than each element as we insert them. We can use a Binary Indexed Tree (Fenwick Tree) or a Segment Tree to achieve this efficiently.

## Algorithm

### Approach: Binary Indexed Tree (Fenwick Tree)

1. Coordinate compress the values in `instructions` to reduce the range
2. Use a BIT to maintain the count of each value that has been inserted
3. For each element:
   - Query the BIT to get the count of elements strictly less than the current element
   - Query the BIT to get the count of elements strictly greater than the current element
   - Add the minimum of these two counts to the total cost
   - Update the BIT with the current element
4. Return the total cost modulo 10^9 + 7

```go
func createSortedArray(instructions []int) int {
    MOD := 1000000007
    
    // Coordinate compression
    unique := make(map[int]bool)
    for _, num := range instructions {
        unique[num] = true
    }
    
    sorted := make([]int, 0, len(unique))
    for num := range unique {
        sorted = append(sorted, num)
    }
    sort.Ints(sorted)
    
    rank := make(map[int]int)
    for i, num := range sorted {
        rank[num] = i + 1
    }
    
    // BIT
    n := len(sorted)
    bit := NewBIT(n)
    
    result := 0
    for _, num := range instructions {
        r := rank[num]
        less := bit.Query(r - 1)
        greater := bit.Query(n) - bit.Query(r)
        result = (result + min(less, greater)) % MOD
        bit.Add(r, 1)
    }
    
    return result
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

type BIT struct {
    tree []int
    n    int
}

func NewBIT(n int) *BIT {
    return &BIT{
        tree: make([]int, n+1),
        n:    n,
    }
}

func (b *BIT) Add(i int, delta int) {
    for i <= b.n {
        b.tree[i] += delta
        i += i & (-i)
    }
}

func (b *BIT) Query(i int) int {
    sum := 0
    for i > 0 {
        sum += b.tree[i]
        i -= i & (-i)
    }
    return sum
}
```

## Complexity

- **Time Complexity:** O(n log n) - For each element, we perform O(log n) BIT operations
- **Space Complexity:** O(n) - For the BIT and the rank map

## Link

[LeetCode 1649 - Create Sorted Array Through Instructions](https://leetcode.com/problems/create-sorted-array-through-instructions/)
