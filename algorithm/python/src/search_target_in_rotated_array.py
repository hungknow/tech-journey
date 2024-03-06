from typing import List

# https://leetcode.com/problems/search-in-rotated-sorted-array/description/

def searchInRotatedArray(nums: List[int], target: int) -> int:
    l = 0
    r = len(nums) - 1

    if nums[l] < nums[r] and (target < nums[l] or target > nums[r]):
        return -1

    while l <= r:
        if nums[l] == target:
            return l
        if nums[r] == target:
            return r

        m = (l + r) // 2

        if nums[m] == target:
            return m
        if nums[m] < nums[r]:
            # right half is sorted
            if nums[m] < target <= nums[r]:
                l = m + 1
            else:
                r = m - 1
        else:
            # left half is sorted
            if nums[l] <= target < nums[m]:
                r = m - 1
            else:
                l = m + 1
    
    return -1
    
