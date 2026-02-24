# 0721 Accounts Merge

## Problem Description

Given a list of accounts where each element `accounts[i]` is a list of strings, where the first element `accounts[i][0]` is a name, and the rest of the elements are emails representing emails of the account.

Now, we would like to merge these accounts. Two accounts definitely belong to the same person if there is some common email in both accounts. Note that even if two accounts have the same name, they may belong to different people as people could have the same name.

After merging the accounts, return the accounts in the following format: the first element of each account is the name, and the rest of the elements are emails in sorted order.

### Example 1:
```
Input: accounts = [["John","johnsmith@mail.com","john_newyork@mail.com"],["John","johnsmith@mail.com","john00@mail.com"],["Mary","mary@mail.com"],["John","johnnybravo@mail.com"]]
Output: [["John","john00@mail.com","john_newyork@mail.com","johnsmith@mail.com"],["Mary","mary@mail.com"],["John","johnnybravo@mail.com"]]
```

### Example 2:
```
Input: accounts = [["Gabe","Gabe0@m.co","Gabe3@m.co","Gabe1@m.co"],["Kevin","Kevin3@m.co","Kevin5@m.co","Kevin0@m.co"],["Ethan","Ethan5@m.co","Ethan4@m.co","Ethan0@m.co"],["Hanzo","Hanzo3@m.co","Hanzo1@m.co","Hanzo0@m.co"],["Fern","Fern5@m.co","Fern1@m.co","Fern0@m.co"]]
Output: [["Ethan","Ethan0@m.co","Ethan4@m.co","Ethan5@m.co"],["Gabe","Gabe0@m.co","Gabe1@m.co","Gabe3@m.co"],["Hanzo","Hanzo0@m.co","Hanzo1@m.co","Hanzo3@m.co"],["Kevin","Kevin0@m.co","Kevin3@m.co","Kevin5@m.co"],["Fern","Fern0@m.co","Fern1@m.co","Fern5@m.co"]]
```

## The Twist

Hash map `email -> account_name` and another maps `email -> unique_ID` to unify disjoint sets of identical users using Union-Find.

## Hash Table Usage

Two maps are used:
1. **Map 1**: `email -> account_name` (to track the name associated with each email)
2. **Map 2**: `email -> unique_ID` (for Union-Find to connect emails belonging to the same person)

Algorithm:
1. Assign a unique ID to each email
2. Use Union-Find to connect emails in the same account
3. Group emails by their root ID
4. For each group, get the account name and sort the emails
5. Return the merged accounts

## Complexity

- **Time**: O(n log n) where n is total number of emails (due to sorting)
- **Space**: O(n) - storing email mappings and Union-Find structures

## Link

[LeetCode 0721 Accounts Merge](https://leetcode.com/problems/accounts-merge/)
