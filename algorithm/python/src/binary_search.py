from typing import List

def binarySearch(nums: List[int], target: int) -> int:
    l = 0
    r = len(nums) - 1

    while l <= r:
        mid = l + (r - l) // 2
        if nums[mid] == target:
            return mid

        if nums[mid] < target:
            l = mid + 1
        else:
            r = mid - 1 

    return -1