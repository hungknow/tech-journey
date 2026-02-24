# 0811 Subdomain Visit Count

## Problem Description

A website domain like "discuss.leetcode.com" consists of various subdomains. At the top level, we have "com", at the next level, we have "leetcode.com", and at the lowest level, "discuss.leetcode.com".

When we visit a domain like "discuss.leetcode.com", we will also visit the parent domains "leetcode.com" and "com" implicitly.

A count-paired domain is a domain that has one of the two formats "rep d1.d2.d3" or "rep d1.d2", where rep is the number of visits to the domain and d1, d2, and d3 are domains.

Given a list `cpdomains` of count-paired domains, return a list of count-paired domains of each subdomain in the input. You may return the answer in any order.

### Example 1:
```
Input: cpdomains = ["9001 discuss.leetcode.com"]
Output: ["9001 leetcode.com","9001 discuss.leetcode.com","9001 com"]
Explanation: We only have one domain: "discuss.leetcode.com".
- "discuss.leetcode.com" has 9001 visits
- "leetcode.com" has 9001 visits (implied)
- "com" has 9001 visits (implied)
```

### Example 2:
```
Input: cpdomains = ["900 google.mail.com", "50 yahoo.com", "1 intel.mail.com", "5 wiki.org"]
Output: ["901 mail.com","50 yahoo.com","900 google.mail.com","5 wiki.org","5 org","1 intel.mail.com","951 com"]
```

## The Twist

Map stores `domain_fragment -> total_visits`. You split domains (e.g., "discuss.leetcode.com", "leetcode.com", "com") and accumulate visits.

## Hash Table Usage

- **Key**: `domain_fragment` (a subdomain)
- **Value**: `total_visits` (accumulated visit count)

Algorithm:
1. Create an empty map to store domain visit counts
2. For each count-paired domain:
   - Parse the count and the domain
   - Split the domain by dots
   - For each subdomain (from full domain to top-level):
     - Add the count to the map entry for this subdomain
3. Convert the map to the required output format

## Complexity

- **Time**: O(n * l) where n is number of domains, l is average domain length
- **Space**: O(n * l) - storing all subdomains and their visit counts

## Link

[LeetCode 0811 Subdomain Visit Count](https://leetcode.com/problems/subdomain-visit-count/)
