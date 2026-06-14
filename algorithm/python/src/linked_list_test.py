import unittest
from linked_list import LinkedList

class TestLinkedList(unittest.TestCase):
    def setUp(self):
        self.linked_list = LinkedList()

    def test_is_empty(self):
        self.assertTrue(self.linked_list.is_empty())

        self.linked_list.insert_at_head(1)
        self.assertFalse(self.linked_list.is_empty())

    def test_insert_at_head(self):
        self.linked_list.insert_at_head(1)
        self.assertEqual(self.linked_list.get_data_at_index(0), 1)

        self.linked_list.insert_at_head(2)
        self.assertEqual(self.linked_list.get_data_at_index(0), 2)
        self.assertEqual(self.linked_list.get_data_at_index(1), 1)

    def test_insert_at_tail(self):
        self.linked_list.insert_at_tail(1)
        self.assertEqual(self.linked_list.get_data_at_index(0), 1)

        self.linked_list.insert_at_tail(2)
        self.assertEqual(self.linked_list.get_data_at_index(0), 1)
        self.assertEqual(self.linked_list.get_data_at_index(1), 2)

    def test_insert_at_index(self):
        self.linked_list.insert_at_index(0, 1)
        self.assertEqual(self.linked_list.get_data_at_index(0), 1)

        self.linked_list.insert_at_index(0, 2)
        self.assertEqual(self.linked_list.get_data_at_index(0), 2)
        self.assertEqual(self.linked_list.get_data_at_index(1), 1)

        self.linked_list.insert_at_index(1, 3)
        self.assertEqual(self.linked_list.get_data_at_index(0), 2)
        self.assertEqual(self.linked_list.get_data_at_index(1), 3)
        self.assertEqual(self.linked_list.get_data_at_index(2), 1)

    def test_delete(self):
        self.linked_list.insert_at_head(1)
        self.linked_list.insert_at_head(2)
        self.linked_list.insert_at_head(3)

        self.linked_list.delete(2)
        self.assertEqual(self.linked_list.get_data_at_index(0), 3)
        self.assertEqual(self.linked_list.get_data_at_index(1), 1)

        self.linked_list.delete(3)
        self.assertEqual(self.linked_list.get_data_at_index(0), 1)

    def test_search(self):
        self.linked_list.insert_at_head(1)
        self.linked_list.insert_at_head(2)
        self.linked_list.insert_at_head(3)

        self.assertTrue(self.linked_list.search(2))
        self.assertFalse(self.linked_list.search(4))

    def test_get_at_index(self):
        self.linked_list.insert_at_head(1)
        self.linked_list.insert_at_head(2)
        self.linked_list.insert_at_head(3)

        self.assertEqual(self.linked_list.get_data_at_index(0), 3)
        self.assertEqual(self.linked_list.get_data_at_index(1), 2)
        self.assertEqual(self.linked_list.get_data_at_index(2), 1)

    def test_display(self):
        self.linked_list.insert_at_head(1)
        self.linked_list.insert_at_head(2)
        self.linked_list.insert_at_head(3)

        # Redirect stdout to capture the output
        import sys
        from io import StringIO
        captured_output = StringIO()
        sys.stdout = captured_output

        self.linked_list.display()

        sys.stdout = sys.__stdout__  # Reset stdout
        self.assertEqual(captured_output.getvalue(), "3 2 1 \n")

if __name__ == "__main__":
    unittest.main()