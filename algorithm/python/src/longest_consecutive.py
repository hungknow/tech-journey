from typing import List

# https://leetcode.com/problems/longest-consecutive-sequence/

# Given an unsorted array of integers nums, return the length of the longest consecutive elements sequence.
def longestConsecutive(nums: List[int]) -> int:
    numsSet = set(nums)
    longest = 0
    for num in nums:
        if num - 1 not in nums:
            length = 1
            while (num + length) in nums:
                length += 1
            longest = max(longest, length)

    return longest