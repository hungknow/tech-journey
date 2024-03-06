from typing import List

# https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/description/

def findMinInRotatedArray(nums: List[int]) -> int:
    l = 0
    r = len(nums) - 1

    while l < r:
        m = (l + r) // 2
        if nums[m] < nums[r]:
            r = m
        else:
            l = m + 1
    
    return nums[l]
    
