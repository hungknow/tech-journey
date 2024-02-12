import unittest
from src.contains_duplicate import contains_duplicate, contains_duplicate_2, contains_duplicate_3

class ContainsDuplicate(unittest.TestCase):
    def test(self):
        test_cases = [
            ([1,2,3,1], True),
            ([1,2,3,4], False),
            ([1,1,1,3,3,4,3,2,4,2], True)
        ]

        for (nums, result) in test_cases:
            self.assertEqual(contains_duplicate(nums), result)
            self.assertEqual(contains_duplicate_2(nums), result)
            self.assertEqual(contains_duplicate_3(nums), result)
