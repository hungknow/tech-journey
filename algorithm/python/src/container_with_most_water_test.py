import unittest

from src.container_with_most_water import containerWithMostWater

class Testcontainer_with_most_water(unittest.TestCase):
    def test(self):
        testCases = [
            ( [1,8,6,2,5,4,8,3,7], 49 ),
            ( [1, 1], 1),
            ( [1,1000,1000,6,2,5,4,8,3,7], 1000 )
        ]

        for testCase in testCases:
            nums = testCase[0]
            expected = testCase[1]
            self.assertEqual(containerWithMostWater(nums), expected, f'input: {nums}')