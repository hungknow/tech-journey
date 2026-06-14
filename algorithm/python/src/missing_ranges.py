from typing import List

def findMissingRanges(nums: List[int], lower: int, upper: int) -> List[List[int]]:
    if not nums:
        return [lower, upper]
    res = []

    if lower < nums[0]:
        res.append([lower, nums[0] - 1])
     
    # iterate each value in nums
    for i in range(len(nums) - 1):
        if nums[i + 1] - nums[i] > 1:
            res.append([nums[i] + 1, nums[i + 1] - 1])
        
    if nums[-1] < upper:
        res.append([nums[-1] + 1, upper])
    
    return res
