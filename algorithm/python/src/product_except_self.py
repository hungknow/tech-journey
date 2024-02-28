from typing import List

# https://leetcode.com/problems/product-of-array-except-self/
# Given an integer array nums, return an array answer such that answer[i] is equal to the product of all the elements of nums except nums[i].
def productExceptSelf(nums: List[int]) -> List[int]:
    results = [1.0] * len(nums)
    prefixProduct = 1.0
    suffixProduct = 1.0
    for i in range(len(nums)):
        results[i] = prefixProduct
        prefixProduct *= nums[i]

    for i in range(len(nums)-1, -1, -1):
        results[i] *= suffixProduct
        suffixProduct *= nums[i]
    return results