# 2034 Stock Price Fluctuation

## Problem Description

You are given a stream of stock prices where each price is recorded at a specific timestamp. Design a data structure to support the following operations:

- `StockPriceFluctuation()` Initializes the object with an empty price history.
- `void update(int timestamp, int price)` Updates or records the price of the stock at the given timestamp.
- `int current()` Returns the latest price of the stock.
- `int maximum()` Returns the maximum price of the stock.
- `int minimum()` Returns the minimum price of the stock.

### Example 1:
```
Input
["StockPriceFluctuation","update","update","current","maximum","minimum","update","current","maximum","minimum"]
[[],[1,10],[2,5],[],[],[],[3,6],[],[],[]]
Output
[null,null,null,5,10,5,null,6,6]

Explanation
StockPriceFluctuation stockPriceFluctuation = new StockPriceFluctuation();
stockPriceFluctuation.update(1, 10); // Timestamp 1, price 10
stockPriceFluctuation.update(2, 5);  // Timestamp 2, price 5
stockPriceFluctuation.current();     // return 5, the latest price is 5
stockPriceFluctuation.maximum();    // return 10, the maximum price is 10
stockPriceFluctuation.minimum();    // return 5, the minimum price is 5
stockPriceFluctuation.update(3, 6);  // Timestamp 3, price 6
stockPriceFluctuation.current();     // return 6, the latest price is 6
stockPriceFluctuation.maximum();    // return 6, the maximum price is 6
stockPriceFluctuation.minimum();    // return 6, the minimum price is 6
```

## The Twist

Implementing a stock price tracking system that efficiently maintains the latest, maximum, and minimum prices with support for timestamp-based updates.

## Algorithm

### HashMap + SortedList Approach:
1. Use a HashMap to store timestamp -> price mapping
2. Keep track of current timestamp, max price, and min price
3. For update(timestamp, price):
   - Store the price in the HashMap
   - Update current timestamp if this is the latest
   - Update max price if this price is higher
   - Update min price if this price is lower
4. For current():
   - Return the price at the current timestamp
5. For maximum():
   - Return the current max price
6. For minimum():
   - Return the current min price

The key insight is tracking current, max, and min prices directly during updates for O(1) retrieval.

## Complexity

- **Time**: 
  - StockPriceFluctuation constructor: O(1)
  - update: O(1)
  - current: O(1)
  - maximum: O(1)
  - minimum: O(1)
- **Space**: O(n) where n is the number of updates

## Solution Code

```go
package main

type StockPriceFluctuation struct {
	prices     map[int]int
	current    int
	maxPrice   int
	minPrice   int
	maxTime    int
}

func Constructor() StockPriceFluctuation {
	return StockPriceFluctuation{
		prices:  make(map[int]int),
		maxTime: -1,
	}
}

func (this *StockPriceFluctuation) Update(timestamp int, price int)  {
	this.prices[timestamp] = price
	
	// Update current timestamp and price
	if timestamp >= this.maxTime {
		this.maxTime = timestamp
		this.current = price
	}
	
	// Update max and min prices
	if timestamp == this.maxTime {
		this.maxPrice = price
		this.minPrice = price
	} else if price > this.maxPrice {
		this.maxPrice = price
	} else if price < this.minPrice {
		this.minPrice = price
	}
}

func (this *StockPriceFluctuation) Current() int {
	if this.maxTime == -1 {
		return 0
	}
	return this.current
}

func (this *StockPriceFluctuation) Maximum() int {
	if this.maxTime == -1 {
		return 0
	}
	return this.maxPrice
}

func (this *StockPriceFluctuation) Minimum() int {
	if this.maxTime == -1 {
		return 0
	}
	return this.minPrice
}

/**
 * Your StockPriceFluctuation object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Update(timestamp,price);
 * param_2 := obj.Current();
 * param_3 := obj.Maximum();
 * param_4 := obj.Minimum();
 */
```

## Link

[LeetCode 2034 Stock Price Fluctuation](https://leetcode.com/problems/stock-price-fluctuation/)