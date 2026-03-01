# 2241 Design an ATM Machine

## Problem Description

Design an ATM machine that can dispense cash efficiently.

Implement the `ATM` class:

- `ATM(int[] banknotes)` Initializes the ATM machine with the given denominations.
- `int[] withdraw(int amount)` Withdraws the given amount and returns an array of the number of each banknote in the optimal way.

The banknotes array is sorted in descending order.

### Example 1:
```
Input
["ATM","withdraw","withdraw","withdraw","withdraw"]
[[20,50,100,200,500],[600],[550],[1000],[1200]]
Output
[null,[0,0,1],[2,0],[0,1],[2,0],[2,0]]

Explanation
ATM atm = new ATM([20,50,100,200,500]);
atm.withdraw(600);  // return [0,0,1], 6 x 100
atm.withdraw(550);  // return [0,0,1], 5 x 100 + 1 x 50
atm.withdraw(1000); // return [0,0,1], 10 x 100
atm.withdraw(1200); // return [0,0,1], 6 x 200
```

## The Twist

Implementing an ATM machine that efficiently calculates the optimal distribution of banknotes for any withdrawal amount.

## Algorithm

### Greedy Approach:
1. Store banknotes in descending order
2. For withdraw(amount):
   - Initialize result array with zeros
   - For each denomination from largest to smallest:
     - Use as many of this denomination as possible
     - Update amount and result count
   - Return the result

The key insight is using a greedy approach with the largest denominations first for optimal cash distribution.

## Complexity

- **Time**: 
  - ATM constructor: O(n) where n is the number of denominations
  - withdraw: O(n) where n is the number of denominations
- **Space**: O(n) where n is the number of denominations

## Solution Code

```go
package main

type ATM struct {
	banknotes []int
	counts   []int
}

func Constructor(banknotes []int) ATM {
	// Banknotes are already in descending order
	counts := make([]int, len(banknotes))
	
	return ATM{
		banknotes: banknotes,
		counts:   counts,
	}
}

func (this *ATM) Withdraw(amount int) []int {
	result := make([]int, len(this.banknotes))
	
	// Calculate optimal distribution
	for i := 0; i < len(this.banknotes) && amount > 0; i++ {
		denomination := this.banknotes[i]
		count := amount / denomination
		if count > this.counts[i] {
			count = this.counts[i]
		}
		
		result[i] = count
		amount -= count * denomination
	}
	
	return result
}

/**
 * Your ATM object will be instantiated and called as such:
 * obj := Constructor(banknotes);
 * param_1 := obj.Withdraw(amount);
 */
```

## Link

[LeetCode 2241 Design an ATM Machine](https://leetcode.com/problems/design-an-atm-machine/)