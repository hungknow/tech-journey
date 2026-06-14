import unittest

from src.binary_search import binarySearch

class TestBinarySearch(unittest.TestCase):
    def test(self):
        testCases = [
            ([-1,0,3,5,9,12], 9, 4),
            ([-1,0,3,5,9,12], 2, -1),
            ([2,5], 2, 0),
        ]

        for testCase in testCases:
            self.assertEqual(binarySearch(testCase[0], testCase[1]), testCase[2], f'input: {testCase}')