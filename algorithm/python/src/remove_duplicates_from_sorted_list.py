# https://leetcode.com/problems/remove-duplicates-from-sorted-list/description/
from typing import List, Optional

class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

def createListFromArray(arr: List[int]) -> ListNode:
    if not arr:
        return None
    head = ListNode(arr[0])
    current = head
    for i in range(1, len(arr)):
        current.next = ListNode(arr[i])
        current = current.next
    return head

def createArrayFromList(head: Optional[ListNode]) -> List[int]:
    arr = []
    current = head
    while current:
        arr.append(current.val)
        current = current.next
    return arr

def printNode(head: Optional[ListNode]) -> None:
    current = head
    while current:
        print(current.val, end=' ')
        current = current.next

def removeDuplicatesFromSortedList(head: Optional[ListNode]) -> Optional[ListNode]:
    if not head:
        return head
    current = head
    while current.next:
        if current.val == current.next.val:
            current.next = current.next.next
        else:
            current = current.next
    return head
