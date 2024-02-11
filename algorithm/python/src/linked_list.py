class Node:
    def __init__(self, data, next=None):
        self.data = data
        self.next = next

class LinkedList:
    def __init__(self):
        self.head = None

    def is_empty(self):
        return self.head is None

    def insert_at_head(self, data):
        self.head = Node(data, self.head) 

    def insert_at_tail(self, data):
        if self.head is None:
            self.head = Node(data)
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = Node(data) 

    def insert_at_index(self, index, data):
        if index < 0:
            raise IndexError("Index out of range")
        if index == 0:
            self.insert_at_head(data)
            return
        current = self.head
        count = 0
        while current:
            if count == index - 1:
                current.next = Node(data, current.next)
                return
            current = current.next
            count += 1
        raise IndexError("Index out of range")

    def delete(self, data):
        if self.head is None:
            return
        if self.head.data == data:
            self.head = self.head.next
            return
        current = self.head
        while current.next:
            if current.next.data == data:
                current.next = current.next.next
                return
            current = current.next

    def search(self, data):
        current = self.head
        while current:
            if current.data == data:
                return True
            current = current.next
        return False

    def get_data_at_index(self, index):
        if index < 0:
            raise IndexError("Index out of range")
        current = self.head
        count = 0
        while current:
            if count == index:
                return current.data
            current = current.next
            count += 1
        raise IndexError("Index out of range")

    def display(self):
        current = self.head
        while current:
            print(current.data, end=" ")
            current = current.next
        print()
