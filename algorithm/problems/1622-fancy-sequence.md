# 1622 Fancy Sequence

## Problem Description

Write a program to calculate the nth element of a fancy sequence.

The fancy sequence is defined as follows:
- Initially, the sequence is empty.
- For each operation, you can:
  - Append an integer to the sequence.
  - Add 1 to all elements in the sequence.
  - Multiply all elements in the sequence by 2.
  - Index the sequence (0-indexed) to get the ith element.

The operations are represented by a string array `operations`, where each element is an operation.

### Example 1:
```
Input: operations = ["5","-2","4","C","C","C","-2","-2","4","C"]
Output: [5,3,5,8,8,8,3,3,5,8]
```

## The Twist

Implementing a sequence that supports various operations (append, add, multiply, index) efficiently without actually applying operations to all elements each time.

## Algorithm

### Modular Arithmetic Approach:
1. Track the sequence with two values: multiplier and adder
2. For append(x):
   - Store the original value adjusted by current operations: (x - adder) / multiplier
3. For addAll(x):
   - Increment the adder by x
4. For multAll(x):
   - Multiply both the multiplier and adder by x
5. For getIndex(x):
   - If x is out of bounds, return -1
   - Return (stored_value[x] * multiplier + adder) % MOD

The key insight is tracking cumulative operations and applying them only when needed, rather than to all elements.

## Complexity

- **Time**: 
  - append: O(1)
  - addAll: O(1)
  - multAll: O(1)
  - getIndex: O(1)
- **Space**: O(n) where n is the number of elements in the sequence

## Solution Code

```go
package main

const MOD = 1000000007

type Fancy struct {
	seq       []int
	multiplier int
	adder     int
}

func Constructor() Fancy {
	return Fancy{
		seq:       make([]int, 0),
		multiplier: 1,
		adder:     0,
	}
}

func (this *Fancy) Append(val int)  {
	// Store the value adjusted by current operations
	adjusted := (val - this.adder + MOD) % MOD
	// Find modular inverse of multiplier
	inv := this.modInverse(this.multiplier, MOD)
	adjusted = (adjusted * inv) % MOD
	this.seq = append(this.seq, adjusted)
}

func (this *Fancy) AddAll(inc int)  {
	this.adder = (this.adder + inc) % MOD
}

func (this *Fancy) MultAll(m int)  {
	this.multiplier = (this.multiplier * m) % MOD
	this.adder = (this.adder * m) % MOD
}

func (this *Fancy) GetIndex(idx int) int {
	if idx < 0 || idx >= len(this.seq) {
		return -1
	}
	
	// Apply the accumulated operations
	result := (this.seq[idx]*this.multiplier + this.adder) % MOD
	return result
}

func (this *Fancy) modInverse(a, m int) int {
	// Extended Euclidean Algorithm to find modular inverse
	m0, x0, x1 := m, 1, 0
	
	if m == 1 {
		return 0
	}
	
	for a > 1 {
		q := a / m
		t := m
		
		m = a % m
		a = t
		t = x0 - q*x1
		
		x0 = x1
		x1 = t
	}
	
	// Make x0 positive
	if x0 < 0 {
		x0 += m0
	}
	
	return x0
}

/**
 * Your Fancy object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Append(val);
 * obj.AddAll(inc);
 * obj.MultAll(m);
 * param_4 := obj.GetIndex(idx);
 */
```

## Link

[LeetCode 1622 Fancy Sequence](https://leetcode.com/problems/fancy-sequence/)