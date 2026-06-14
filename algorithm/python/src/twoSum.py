from typing import List
import unittest

# https://leetcode.com/problems/two-sum/
def two_sum(nums: List[int], target: int) -> List[int]:
    # Create a dictionary to store the values
    dict = {}
    for i in range(len(nums)):
        diff = target - nums[i]
        # Check if the target - nums[i] is in the dictionary
        if diff in dict:
            # If it is, return the index of the value in the dictionary and the current index
            return [dict[diff], i]
        # If it's not, add the value to the dictionary
        dict[nums[i]] = i
    # If no solution is found, return an empty list
    return []
    
# Use two pointers
def two_sum_2(nums: List[int], target: int) -> List[int]:
    l = 0
    r = len(nums) - 1
    while l < r:
        sum = nums[l] + nums[r]
        if sum == target:
            return [l, r]
        
        if sum > target:
            r -= 1
        if sum < target:
            l += 1
    
    return []
# Test cases
class TwoSumTests(unittest.TestCase):
    def test_example_case_1(self):
        nums = [2, 7, 11, 15]
        target = 9
        expected = [0, 1]
        self.assertEqual(two_sum(nums, target), expected)
        self.assertEqual(two_sum_2(nums, target), expected)

    def test_example_case_2(self):
        nums = [2, 3, 4]
        target = 6
        expected = [0, 2]
        self.assertEqual(two_sum(nums, target), expected)
        self.assertEqual(two_sum_2(nums, target), expected)

    def test_example_case_3(self):
        nums = [3, 3]
        target = 6
        expected = [0, 1]
        self.assertEqual(two_sum(nums, target), expected)
        self.assertEqual(two_sum_2(nums, target), expected)

    def test_no_solution(self):
        nums = [1, 2, 3, 4]
        target = 10
        expected = []
        self.assertEqual(two_sum(nums, target), expected)
        self.assertEqual(two_sum_2(nums, target), expected)
