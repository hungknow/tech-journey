# 0692 Top K Frequent Words

## Problem Description

Given an array of strings `words` and an integer `k`, return the `k` most frequent strings.

Return the answer sorted by the number of occurrences of the word in descending order. If two words have the same frequency, then the word with the lower alphabetical order comes first.

### Example 1:
```
Input: words = ["i","love","leetcode","i","love","coding"], k = 2
Output: ["i","love"]
Explanation: "i" and "love" are the two most frequent words.
Note that "i" comes before "love" due to a lower alphabetical order.
```

### Example 2:
```
Input: words = ["the","day","is","sunny","the","the","the","sunny","is","is"], k = 4
Output: ["the","is","sunny","day"]
Explanation: "the", "is", "sunny" and "day" are the four most frequent words, with the number of occurrences being 4, 3, 2 and 1 respectively.
```

## Solution Approach

We need to find the k most frequent words, with ties broken by alphabetical order. This can be solved using a min-heap of size k with a custom comparator.

## Algorithm

1. Count the frequency of each word using a hash map.
2. Use a min-heap to keep track of the k most frequent words:
   - The comparator should prioritize lower frequency first, and for equal frequencies, higher alphabetical order first.
   - For each word-frequency pair, add it to the heap.
   - If the heap size exceeds k, remove the top element (which is the least frequent or has higher alphabetical order).
3. Extract all elements from the heap and reverse them to get the result in descending frequency order.

## Alternative Algorithm (Sorting)

1. Count the frequency of each word using a hash map.
2. Convert the map entries to a list and sort with a custom comparator:
   - Primary key: frequency in descending order
   - Secondary key: word in ascending (alphabetical) order
3. Take the first k elements from the sorted list.

## Complexity

- **Time**: O(n log k) for heap approach, O(n log n) for sorting approach
- **Space**: O(n) for both approaches (hash map and heap/sorted list)

## Link

[LeetCode 0692 Top K Frequent Words](https://leetcode.com/problems/top-k-frequent-words/)