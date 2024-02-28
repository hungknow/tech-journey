import unittest

from src.longest_consecutive import longestConsecutive

class TestLongestConsecutive(unittest.TestCase):
    def test(self):
        testCases = [
            ( [100,4,200,1,3,2], 4 ),
            ( [0,3,7,2,5,8,4,6,0,1], 9 ),
            ( [4, 1, 3, 2, 6], 4 )
        ]
        for testCase in testCases:
            self.assertEqual(longestConsecutive(testCase[0]), testCase[1], msg = testCase[0])