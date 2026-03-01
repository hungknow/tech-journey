# 1366 Rank Teams by Votes

## Problem Description

You are given a list of strings `votes`, where each string represents a vote for a team in the order of preference. The teams are identified by uppercase English letters.

Create a ranking system for the teams based on the votes. The ranking should be determined by the following rules:
1. Teams are ranked based on the number of first-place votes they received.
2. If there is a tie, the number of second-place votes is considered, and so on.
3. If there is still a tie, teams are ranked alphabetically.

Return a string representing the teams ranked from most to least preferred.

### Example 1:
```
Input: votes = ["ABC","ACB","ABC","ACB","ACB"]
Output: "ACB"
Explanation: 
Team A received 3 first-place votes and 2 second-place votes.
Team B received 2 first-place votes and 3 second-place votes.
Team C received 0 first-place votes and 5 second-place votes.
Since team A has more first-place votes, it is ranked first.
Between teams B and C, team B has more first-place votes, so it is ranked second.
Team C is ranked third.
```

### Example 2:
```
Input: votes = ["WXYZ","XYZW"]
Output: "XWYZ"
Explanation: 
X has 1 first-place vote and 1 second-place vote.
W has 1 first-place vote and 0 second-place votes.
Y has 0 first-place votes and 2 second-place votes.
Z has 0 first-place votes and 0 second-place votes.
X is ranked first.
W is ranked second.
Y is ranked third.
Z is ranked fourth.
```

## Solution Approach

We need to count the votes for each team at each position and then sort the teams based on these counts.

## Algorithm

1. Determine all unique teams from the votes.
2. Create a map to store the vote counts for each team at each position.
3. For each vote:
   - For each position, increment the count for the corresponding team.
4. Sort the teams using a custom comparator:
   - Compare teams based on their vote counts from first place to last place.
   - If all vote counts are equal, compare alphabetically.
5. Concatenate the sorted team identifiers to form the result string.
6. Return the result.

## Implementation Details

- The number of positions is equal to the length of each vote string.
- For the comparator, we compare teams position by position, giving priority to earlier positions.

## Complexity

- **Time**: O(n × m × log m) where n is the number of votes and m is the number of teams
- **Space**: O(m²) for storing vote counts for each team at each position

## Link

[LeetCode 1366 Rank Teams by Votes](https://leetcode.com/problems/rank-teams-by-votes/)