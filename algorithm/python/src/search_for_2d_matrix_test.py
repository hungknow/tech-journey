import unittest

from src.search_for_2d_matrix import searchFor2DMatrix


class TestSearchFor2DMatrix(unittest.TestCase):
    def test(self):
        testCases = [
            ( [[1,3,5,7],[10,11,16,20],[23,30,34,60]], 3, True ),
            ( [[1,3,5,7],[10,11,16,20],[23,30,34,60]], 13, False ),
            ( [[1],[3]], 2, False )
        ]
        for testCase in testCases:
            self.assertEqual(searchFor2DMatrix(testCase[0], testCase[1]), testCase[2], msg = "{} {}".format(testCase[0], testCase[1]))