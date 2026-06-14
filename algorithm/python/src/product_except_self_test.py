import unittest

from src.product_except_self import productExceptSelf

class Test_productExceptSelf(unittest.TestCase):
    def test_basic_input(self):
        nums = [1, 2, 3, 4]
        expected_output = [24, 12, 8, 6]
        self.assertEqual(productExceptSelf(nums), expected_output)

    def test_empty_input(self):
        nums = []
        expected_output = []
        self.assertEqual(productExceptSelf(nums), expected_output)

    def test_input_with_one_element(self):
        nums = [5]
        expected_output = [1.0]
        self.assertEqual(productExceptSelf(nums), expected_output)

    def test_input_with_all_zeros(self):
        nums = [0, 0, 0, 0]
        expected_output = [0, 0, 0, 0]
        self.assertEqual(productExceptSelf(nums), expected_output)

    def test_input_with_negative_numbers(self):
        nums = [-1, 2, -3, 4]
        expected_output = [-24, 12, -8, 6]
        self.assertEqual(productExceptSelf(nums), expected_output)

    def test_1(self):
        nums = [-1,1,0,-3,3]
        expected_output = [0,0,9,0,0]
        self.assertEqual(productExceptSelf(nums), expected_output)