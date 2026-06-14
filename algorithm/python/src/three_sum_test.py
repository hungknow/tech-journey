import unittest

from src.three_sum import threeSum, threeSum2

class TestThreeSum(unittest.TestCase):
    def test(self):
        testCases = [
            (
                [-1,0,1,2,-1,-4],
                [[-1,-1,2],[-1,0,1]]
            ),
            (
                [0,1,1],
                []
            ),
            (
                [0,0,0],
                [[0,0,0]]
            ),
            (
                [-4, -1, -1, 0, 1, 2],
                [[-1, -1, 2], [-1, 0, 1]]
            ),
            (
                [0,0,0,0],
                [[0,0,0]]
            ),
            (
                [-2,0,1,1,2],
                [[-2,0,2],[-2,1,1]]
            )
        ]

        for testCase in testCases:
            input, output = testCase
            self.assertEqual(threeSum(input), output, msg=f"input: {input}")
            self.assertEqual(threeSum2(input), output, msg=f"input: {input}")