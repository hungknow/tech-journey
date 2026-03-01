# 1169 Invalid Transactions

## Problem Description

A transaction is possibly invalid if:

1. The amount exceeds $1000.
2. If it occurs within (and including) 60 minutes of another transaction with the same name in a different city.
3. The transaction is in a different city from another transaction with the same name within 60 minutes.

You are given an array of strings `transaction` where `transactions[i] = "{name},{time},{amount},{city}"`.

Return the transactions that are possibly invalid. You may return the answer in any order.

### Example 1:
```
Input: transactions = ["alice,20,800,mtv","alice,50,1200,mtv","alice,51,100,beijing"]
Output: ["alice,20,800,mtv","alice,50,1200,mtv","alice,51,100,beijing"]
Explanation: 
- "alice,20,800,mtv" is invalid because it's within 60 minutes of "alice,51,100,beijing" and in a different city.
- "alice,50,1200,mtv" is invalid because the amount exceeds $1000.
- "alice,51,100,beijing" is invalid because it's within 60 minutes of "alice,20,800,mtv" and in a different city.
```

### Example 2:
```
Input: transactions = ["bob,689,1910,amsterdam","chalice,736,2548,paris","bob,832,1726,paris","bob,924,1667,amsterdam"]
Output: ["bob,689,1910,amsterdam","chalice,736,2548,paris","bob,832,1726,paris","bob,924,1667,amsterdam"]
```

## Approach

This problem can be solved using a combination of sorting and two-pointer technique:

1. Parse each transaction into a structured format.
2. Sort transactions by name and then by time.
3. For each transaction, check:
   - If the amount exceeds $1000, mark it as invalid.
   - If there's another transaction with the same name within 60 minutes in a different city, mark both as invalid.
4. Use a sliding window approach to efficiently check for transactions within 60 minutes.

## Solution Code

```go
type Transaction struct {
    name    string
    time    int
    amount  int
    city    string
    index   int
    invalid bool
}

func invalidTransactions(transactions []string) []string {
    // Parse transactions
    parsed := make([]Transaction, len(transactions))
    for i, t := range transactions {
        parts := strings.Split(t, ",")
        time, _ := strconv.Atoi(parts[1])
        amount, _ := strconv.Atoi(parts[2])
        parsed[i] = Transaction{
            name:   parts[0],
            time:   time,
            amount: amount,
            city:   parts[3],
            index:  i,
        }
    }
    
    // Sort by name and then by time
    sort.Slice(parsed, func(i, j int) bool {
        if parsed[i].name != parsed[j].name {
            return parsed[i].name < parsed[j].name
        }
        return parsed[i].time < parsed[j].time
    })
    
    // Check for invalid transactions
    for i := 0; i < len(parsed); i++ {
        // Check if amount exceeds $1000
        if parsed[i].amount > 1000 {
            parsed[i].invalid = true
        }
        
        // Check for transactions with same name within 60 minutes in different city
        j := i - 1
        for j >= 0 && parsed[j].name == parsed[i].name && parsed[i].time-parsed[j].time <= 60 {
            if parsed[j].city != parsed[i].city {
                parsed[i].invalid = true
                parsed[j].invalid = true
            }
            j--
        }
        
        j = i + 1
        for j < len(parsed) && parsed[j].name == parsed[i].name && parsed[j].time-parsed[i].time <= 60 {
            if parsed[j].city != parsed[i].city {
                parsed[i].invalid = true
                parsed[j].invalid = true
            }
            j++
        }
    }
    
    // Collect invalid transactions
    var result []string
    for _, t := range parsed {
        if t.invalid {
            result = append(result, transactions[t.index])
        }
    }
    
    return result
}
```

## Complexity Analysis

- **Time**: O(n log n) for sorting + O(n * k) for checking, where k is the average number of transactions with the same name
- **Space**: O(n) - We store the parsed transactions

## Link

[LeetCode 1169 Invalid Transactions](https://leetcode.com/problems/invalid-transactions/)