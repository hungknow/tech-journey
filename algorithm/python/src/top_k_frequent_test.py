import unittest

from src.top_k_frequent import topKFrequent

class TestTopKFrequent(unittest.TestCase):
    def test(self):
        # Test case 1
        nums = [1, 1, 1, 2, 2, 3]
        k = 2
        expected_result = [1, 2]
        self.assertEqual(topKFrequent(nums, k), expected_result)

        # Test case 2
        nums = [1, 1, 2, 2, 3, 3, 3]
        k = 3
        expected_result = [1, 2, 3]
        self.assertEqual(topKFrequent(nums, k), expected_result)

        # Test case 3
        nums = [4, 1, -1, 2, -1, 2, 3]
        k = 2
        expected_result = [-1, 2]
        self.assertEqual(topKFrequent(nums, k), expected_result)

        # Test case 4
        nums = [1, 2, 3, 4, 5]
        k = 1
        expected_result = [1]
        self.assertEqual(topKFrequent(nums, k), expected_result)

        # Test case 5
        nums = [1, 2, 3, 4, 5]
        k = 5
        expected_result = [1, 2, 3, 4, 5]
        self.assertEqual(topKFrequent(nums, k), expected_result)