import unittest
from src.search_target_in_rotated_array import searchInRotatedArray

class TestSearchInRotatedArray(unittest.TestCase):
    def test(self):
        testCases = [
            ([4,5,6,7,0,1,2], 0, 4),
            ([4,5,6,7,0,1,2], 3, -1),
            ([1], 0, -1),
        ]

        for testCase in testCases:
            self.assertEqual(searchInRotatedArray(testCase[0], testCase[1]), testCase[2], msg = testCase[0])