def test_delete():
    # Create a linked list
    linked_list = LinkedList()
    linked_list.append(1)
    linked_list.append(2)
    linked_list.append(3)
    linked_list.append(4)

    # Test deleting the head node
    linked_list.delete(1)
    assert linked_list.to_list() == [2, 3, 4]

    # Test deleting a middle node
    linked_list.delete(3)
    assert linked_list.to_list() == [2, 4]

    # Test deleting the tail node
    linked_list.delete(4)
    assert linked_list.to_list() == [2]

    # Test deleting a non-existent node
    linked_list.delete(5)
    assert linked_list.to_list() == [2]

    # Test deleting from an empty list
    empty_list = LinkedList()
    empty_list.delete(1)
    assert empty_list.to_list() == []