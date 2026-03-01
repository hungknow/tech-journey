# 1772 Sort Features by Popularity

## Problem Description

You are given a string array `features` where each `features[i]` is a single word that represents a feature of an app. You are also given a string array `responses` where each `responses[i]` is a space-separated list of words that users like.

A feature is popular if it was liked by at least one user. The popularity of a feature is the number of users who like it.

Return the features sorted by popularity in descending order. If two features have the same popularity, sort them lexicographically.

### Example 1:
```
Input: features = ["cooler","lock","touch"], responses = ["i like cooler cooler","lock touch cool","i like lock","cooler lock cooler"]
Output: ["cooler","lock"]
Explanation: 
"cooler" appears in 2 responses.
"lock" appears in 1 response.
"touch" appears in 0 responses.
```

### Example 2:
```
Input: features = ["a","b","c"], responses = ["a b c","a b c","a b c"]
Output: ["a","b","c"]
Explanation: 
All features appear in 3 responses, so they have the same popularity.
Sorted lexicographically: ["a","b","c"].
```

## Solution Approach

We need to count how many users like each feature and then sort based on popularity (descending) and lexicographical order (ascending) for ties.

## Algorithm

1. Create a frequency map to count how many responses contain each feature.
2. Sort the features using a custom comparator:
   - Primary key: frequency in descending order.
   - Secondary key: feature name in ascending (lexicographical) order.
3. Return the sorted list of features.

## Why This Works

By counting the frequency of each feature and sorting accordingly, we get the desired ordering.

## Complexity

- **Time**: O(n × m + n log n) where n is the number of features and m is the average number of words per response
- **Space**: O(n) - for the frequency map

## Link

[LeetCode 1772 Sort Features by Popularity](https://leetcode.com/problems/sort-features-by-popularity/)