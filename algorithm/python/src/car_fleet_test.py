import unittest

from src.car_fleet import carFleet

class TestCarFleet(unittest.TestCase):
    def test(self):
        testCases = [
            # Iterate array with the speed
            # [12, 12, 1, 6, 6]
            # [12, 12, 2, 7, 7]
            # [12, 12, 3, 8, 8]
            # [12, 12, 4, 9, 9]
            # [12, 12, 5, 10, 10]

            # position: [0, 3, 5, 8, 10]
            # time to target: [12, 3, 7, 1, 1]
            ( (12, [10,8,0,5,3], [2,4,1,1,3]), 3),
            ( (10, [3], [3]), 1),
            # time to target: [25, 49, 96]
            ( (100, [0, 2, 4], [4, 2, 1]), 1)
        ]

        for testCase in testCases:
            value = testCase[0]
            expected = testCase[1]
            self.assertEqual(carFleet(value[0], value[1], value[2]), expected, f'input: {value}')