class Node:
    def __init__(self, data, next=None):
        self.data = data
        self.next = next

class Stack:
    def __init__(self):
        self.top = None

    def push(self, data):
        self.top = Node(data, self.top)

    def pop(self):
        if not self.top:
            raise Exception("Stack is empty")
        pop_item = self.top
        self.top = pop_item.next
        return pop_item.data

    def peek(self):
        return self.top.data if self.top else None

    def is_empty(self):
        return not self.top


