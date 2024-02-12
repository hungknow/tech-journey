# https://leetcode.com/problems/contains-duplicate/description/

from typing import List

def contains_duplicate(nums: List[int]) -> bool:
    return len(nums) != len(set(nums)) 

def contains_duplicate_2(nums: List[int]) -> bool:
    nums.sort()
    for i in range(1, len(nums)):
        if nums[i] == nums[i-1]:
            return True
    return False

def contains_duplicate_3(nums: List[int]) -> bool:
    dict = {}
    for i in nums:
        if i in dict:
            return True
        else:
            dict[i] = 1
    return False
