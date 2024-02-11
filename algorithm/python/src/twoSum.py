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

# Test cases
class TwoSumTests(unittest.TestCase):
    def test_example_case_1(self):
        nums = [2, 7, 11, 15]
        target = 9
        expected = [0, 1]
        self.assertEqual(two_sum(nums, target), expected)

    def test_example_case_2(self):
        nums = [3, 2, 4]
        target = 6
        expected = [1, 2]
        self.assertEqual(two_sum(nums, target), expected)

    def test_example_case_3(self):
        nums = [3, 3]
        target = 6
        expected = [0, 1]
        self.assertEqual(two_sum(nums, target), expected)

    def test_no_solution(self):
        nums = [1, 2, 3, 4]
        target = 10
        expected = []
        self.assertEqual(two_sum(nums, target), expected)
    def setUp(self):
        self.two_sum = two_sum

    def test_example_case_1(self):
        nums = [2, 7, 11, 15]
        target = 9
        expected = [0, 1]
        self.assertEqual(self.two_sum(nums, target), expected)

    def test_example_case_2(self):
        nums = [3, 2, 4]
        target = 6
        expected = [1, 2]
        self.assertEqual(self.two_sum(nums, target), expected)

    def test_example_case_3(self):
        nums = [3, 3]
        target = 6
        expected = [0, 1]
        self.assertEqual(self.two_sum(nums, target), expected)

    def test_no_solution(self):
        nums = [1, 2, 3, 4]
        target = 10
        expected = []
        self.assertEqual(self.two_sum(nums, target), expected)

if __name__ == '__main__':
    unittest.main()
