import unittest

from src.trapping_rain_water import trappingRainWater

class TrappingRainWater(unittest.TestCase):
    def test(self):
        testCases = [
            ( [0,1,0,2,1,0,1,3,2,1,2,1], 6 ),
            ( [4,2,0,3,2,5], 9 )
        ]

        for testCase in testCases:
            nums = testCase[0]
            expected = testCase[1]
            self.assertEqual(trappingRainWater(nums), expected, f'input: {nums}')