# 2043 Simple Bank System

## Problem Description

You are given a simple bank system that supports the following operations:

- `SimpleBankSystem(int balance)` Initializes the system with the given initial balance.
- `bool transfer(int from, int to, int amount)` Transfers `amount` from account `from` to account `to`. Returns `true` if the transfer was successful, `false` otherwise.
- `boolean deposit(int account, int amount)` Deposits `amount` into account `account`. Returns `true` if the deposit was successful, `false` otherwise.
- `boolean withdraw(int account, int amount)` Withdraws `amount` from account `account`. Returns `true` if the withdrawal was successful, `false` otherwise.

### Example 1:
```
Input
["SimpleBankSystem","withdraw","transfer","deposit","transfer","transfer"]
[[10],[2,10],[3,2],[5,20],[3,4,10],[5,2,50]]
Output
[null,true,false,true,false,true]

Explanation
SimpleBankSystem bank = new SimpleBankSystem(10);
bank.withdraw(2, 10);    // return true, account 2 has sufficient balance
bank.transfer(3, 2, 10); // return false, account 3 has insufficient balance
bank.deposit(5, 20);     // return true, account 5 now has balance 30
bank.transfer(3, 4, 10); // return false, account 3 still has insufficient balance
bank.transfer(5, 2, 50); // return true, account 5 has sufficient balance
```

## The Twist

Implementing a simple bank system that efficiently manages account balances and supports transfer, deposit, and withdrawal operations with proper validation.

## Algorithm

### Array Balance Tracking Approach:
1. Use an array to store balances for each account
2. For SimpleBankSystem(balance):
   - Initialize all accounts with the given balance
3. For transfer(from, to, amount):
   - Check if from account has sufficient balance
   - If yes, subtract amount from from and add to to
   - Return true
4. For deposit(account, amount):
   - Add amount to the account balance
   - Return true
5. For withdraw(account, amount):
   - Check if account has sufficient balance
   - If yes, subtract amount from the account
   - Return true

The key insight is using a simple array to track balances and performing direct operations with proper validation.

## Complexity

- **Time**: 
  - SimpleBankSystem constructor: O(n) where n is the number of accounts
  - transfer: O(1)
  - deposit: O(1)
  - withdraw: O(1)
- **Space**: O(n) where n is the number of accounts

## Solution Code

```go
package main

type SimpleBankSystem struct {
	balances []int
	n        int
}

func Constructor(balance int) SimpleBankSystem {
	balances := make([]int, balance)
	return SimpleBankSystem{
		balances: balances,
		n:        balance,
	}
}

func (this *SimpleBankSystem) Transfer(from int, to int, amount int) bool {
	if from < 0 || from >= this.n || to < 0 || to >= this.n {
		return false
	}
	
	if this.balances[from] < amount {
		return false
	}
	
	this.balances[from] -= amount
	this.balances[to] += amount
	
	return true
}

func (this *SimpleBankSystem) Deposit(account int, amount int) bool {
	if account < 0 || account >= this.n {
		return false
	}
	
	this.balances[account] += amount
	return true
}

func (this *SimpleBankSystem) Withdraw(account int, amount int) bool {
	if account < 0 || account >= this.n {
		return false
	}
	
	if this.balances[account] < amount {
		return false
	}
	
	this.balances[account] -= amount
	return true
}

/**
 * Your SimpleBankSystem object will be instantiated and called as such:
 * obj := Constructor(balance);
 * param_1 := obj.Transfer(from,to,amount);
 * param_2 := obj.Deposit(account,amount);
 * param_3 := obj.Withdraw(account,amount);
 */
```

## Link

[LeetCode 2043 Simple Bank System](https://leetcode.com/problems/simple-bank-system/)