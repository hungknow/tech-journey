import unittest

from src.largest_rectangle_in_histogram import largestRectangleInHistogram

class TestLargestRectangleInHistogram(unittest.TestCase):
    def test(self):
        testCases = [
            ([2,1,5,6,2,3], 10),
            ([2,4], 4),
            ([1,1], 2),
            ([2,1,2], 3),
            ([5,4,1,2], 8),
            ([4,2,0,3,2,4,3,4], 10),
            ([3,6,5,7,4,8,1,0], 20)
        ]
        for testCase in testCases:
            self.assertEqual(largestRectangleInHistogram(testCase[0]), testCase[1], msg = testCase[0])
        