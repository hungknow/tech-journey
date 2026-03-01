# 1357 Apply Discount Every n Orders

## Problem Description

There is a sale in a supermarket, there will be a discount every `n` customer.
A discount is given to every `n`-th customer as a percentage of their bill.
The `n`-th customer is the one that comes just after the `n-1`-th customer.
The discount starts from the first customer and continues until the last customer.

Implement the `Cashier` class:

- `Cashier(int n, int discount, int[] products, int[] prices)` Initializes the instance with the given `n`, `discount`, `products` and `prices`.
- `double getBill(int[] product, int[] amount)` Returns the bill of the current customer. If this is the `n`-th customer, they will receive a discount.

### Example 1:
```
Input
["Cashier","getBill","getBill","getBill","getBill","getBill","getBill","getBill"]
[[3,50,[1,2,3,4,5,6,7],[100,200,300,400,300,200,100]],[[1,2],[1,2]],[[3,7],[1,9]],[[1,2,3,4,5,6,7],[1,10]],[[2],[3]],[[1,2,3,4,5,6,7],[10]],[[2],[2]]]
Output
[null,500.0,4000.0,2350.0,5237.5,2400.0,1600.0]

Explanation
Cashier cashier = new Cashier(3,50,[1,2,3,4,5,6,7],[100,200,300,400,300,200,100]);
cashier.getBill([1,2],[1,2]);                        // return 500.0, bill = 1 * 100 + 2 * 200 = 500.
cashier.getBill([3,7],[1,9]);                        // return 4000.0
cashier.getBill([1,2,3,4,5,6,7],[1,10]);             // return 2350.0, bill = 1 * 100 + 2 * 200 + 3 * 300 + 4 * 400 + 5 * 300 + 6 * 200 + 7 * 100 = 5000.
cashier.getBill([2],[3]);                               // return 2400.0, 3rd customer, 10% discount = 4000 * (1 - 0.1) = 3600.
cashier.getBill([1,2,3,4,5,6,7],[10,10]);           // return 1600.0
```

## The Twist

Implementing a cashier system that applies discounts to every nth customer while efficiently calculating bills based on product prices and quantities.

## Algorithm

### Counter + HashMap Approach:
1. Use a HashMap to map product IDs to their prices
2. Maintain a counter to track the number of customers served
3. For getBill(product, amount):
   - Increment the customer counter
   - Calculate the total bill by summing product prices * quantities
   - If the customer counter is divisible by n:
     - Apply the discount percentage to the total bill
   - Return the final bill amount

The key insight is tracking the customer count and applying discounts at regular intervals while efficiently looking up product prices.

## Complexity

- **Time**: 
  - Cashier constructor: O(m) where m is the number of products
  - getBill: O(k) where k is the number of products in the bill
- **Space**: O(m) where m is the number of products

## Solution Code

```go
package main

import "fmt"

type Cashier struct {
	n        int
	discount int
	customer int
	prices   map[int]int
}

func Constructor(n int, discount int, products []int, prices []int) Cashier {
	priceMap := make(map[int]int)
	for i := 0; i < len(products); i++ {
		priceMap[products[i]] = prices[i]
	}
	
	return Cashier{
		n:        n,
		discount: discount,
		customer: 0,
		prices:   priceMap,
	}
}

func (this *Cashier) GetBill(product []int, amount []int) float64 {
	this.customer++
	
	// Calculate the total bill
	total := 0
	for i := 0; i < len(product); i++ {
		total += this.prices[product[i]] * amount[i]
	}
	
	// Apply discount if this is the nth customer
	if this.customer%this.n == 0 {
		total = total * (100 - this.discount) / 100
	}
	
	// Convert to float64 for the return type
	return float64(total)
}

/**
 * Your Cashier object will be instantiated and called as such:
 * obj := Constructor(n, discount, products, prices);
 * param_1 := obj.GetBill(product,amount);
 */
```

## Link

[LeetCode 1357 Apply Discount Every n Orders](https://leetcode.com/problems/apply-discount-every-n-orders/)