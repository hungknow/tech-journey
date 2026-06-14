import unittest

from src.time_based_key_value_store import TimeMap

class TestTimeBasedKeyValueStore(unittest.TestCase):
    def runTest(self, cases):
        timeMap = TimeMap()
        for case in cases:
            if case[0] == 'set':
                timeMap.set(*case[1])
            elif case[0] == 'get':
                self.assertEqual(timeMap.get(*case[1]), case[2], msg=f'Failed for case: {case[1]}')
                
            else:
                raise ValueError(f'Invalid case: {case[0]}') 

    def test(self):
        cases = [
            ('set', ["foo", "bar", 1]),
            ('get', ["foo", 1], "bar"),
            ('get', ["foo", 3], "bar"),
            ('set', ["foo", "bar2", 4]),
            ('get', ["foo", 4], "bar2"),
            ('get', ["foo", 5], "bar2"),
            ('get', ["foo", 3], "bar")
        ]
        self.runTest(cases)

    def test1(self):
        cases = [
            ('set', ["love", "high", 10]),
            ('set', ["love", "low", 20]),
            ('get', ["love", 5], ""),
            ('get', ["love", 10], "high"),
            ('get', ["love", 15], "high"),
            ('get', ["love", 20], "low"),
            ('get', ["love", 25], "low")
        ]
        self.runTest(cases)

       
