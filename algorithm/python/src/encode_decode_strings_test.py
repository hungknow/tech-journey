import unittest

from src.encode_decode_strings import decodeString, encodeString

class TestEncodeDecodeStrings(unittest.TestCase):
    def test(self):
        testCases = [
            (["hello", "world"], "5#hello5#world"),
            (["how ", "are", "you?"], "4#how 3#are4#you?")
        ]
        for testCase in testCases:
            self.assertEqual(encodeString(testCase[0]), testCase[1])
            self.assertEqual(decodeString(testCase[1]), testCase[0])
        pass