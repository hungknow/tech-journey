import unittest

from src.remove_duplicates_from_sorted_list import createArrayFromList, createListFromArray, printNode, removeDuplicatesFromSortedList

class TestRemoveDuplicatesFromSortedList(unittest.TestCase):
    def test(self):
        testCases = [
            ([1,1,2], [1, 2]),
            ([1,1,2,3,3], [1, 2, 3])
        ]
        for testCase in testCases:
            listFromArray = createListFromArray(testCase[0])
            result = removeDuplicatesFromSortedList(listFromArray)
            # printNode(listFromArray)
            # printNode(result)
            self.assertEqual(
                createArrayFromList(result),
                testCase[1],
                msg = testCase[0])
        