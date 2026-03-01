# 0937 Reorder Log Files

## Problem Description

You are given an array of `logs`. Each log is a space-delimited string of words, where the first word is the identifier.

There are two types of logs:
- Letter-logs: All words (except the identifier) consist of lowercase English letters.
- Digit-logs: All words (except the identifier) consist of digits.

Reorder these logs so that:
1. The letter-logs come before all digit-logs.
2. The letter-logs are sorted lexicographically by their content. If their content is the same, then sort them lexicographically by their identifiers.
3. The digit-logs maintain their relative ordering.

Return the final order of the logs.

### Example 1:
```
Input: logs = ["dig1 8 1 5 1","let1 art can","dig2 3 6","let2 own kit dig","let3 art zero"]
Output: ["let1 art can","let3 art zero","let2 own kit dig","dig1 8 1 5 1","dig2 3 6"]
```

## Solution Approach

We need to separate the letter-logs from the digit-logs and sort the letter-logs according to the specified criteria.

## Algorithm

1. Separate the logs into letter-logs and digit-logs:
   - For each log, check if the first word after the identifier is a letter or digit.
   - Add the log to the appropriate list.
2. Sort the letter-logs using a custom comparator:
   - First compare by content (everything after the identifier).
   - If the content is the same, compare by identifier.
3. Concatenate the sorted letter-logs with the digit-logs (in their original order).
4. Return the result.

## Implementation Details

- To check if a log is a letter-log or digit-log, examine the first character after the identifier.
- For sorting, we can use the built-in sort function with a custom comparator that compares first by content and then by identifier.

## Complexity

- **Time**: O(n log n) - dominated by sorting the letter-logs
- **Space**: O(n) - for storing the separated logs

## Link

[LeetCode 0937 Reorder Log Files](https://leetcode.com/problems/reorder-log-files/)