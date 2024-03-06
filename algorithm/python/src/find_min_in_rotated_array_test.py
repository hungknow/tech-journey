import unittest
from src.find_min_in_rotated_array import findMinInRotatedArray

class TestFindMinInRotatedArray(unittest.TestCase):
    def test(self):
        testCases = [
           ([3,4,5,1,2], 1) ,
           ([4,5,6,7,0,1,2], 0),
           ([11,13,15,17], 11)
        ]

        for testCase in testCases:
            self.assertEqual(findMinInRotatedArray(testCase[0]), testCase[1], msg = testCase[0])