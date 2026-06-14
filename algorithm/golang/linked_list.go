package algo

import (
	"fmt"
	"strings"
)

type LinkedListNode struct {
    data interface{}
    next *LinkedListNode
}

type LinkedList struct {
    head *LinkedListNode
}

func NewLinkedList() *LinkedList {
    return &LinkedList{}
}

func (ll *LinkedList) Insert(data interface{}) {
   ll.head = &LinkedListNode{data: data, next: ll.head} 
}
func (ll *LinkedList) InsertAtIndex(data interface{}, index int) {
    newNode := &LinkedListNode{data: data, next: nil}

    if index == 0 {
        newNode.next = ll.head
        ll.head = newNode
        return
    }

    current := ll.head
    for i := 0; i < index-1 && current != nil; i++ {
        current = current.next
    }

    if current == nil {
        return
    }

    newNode.next = current.next
    current.next = newNode
}

func (ll *LinkedList) RemoveAtIndex(index int) {
    if ll.head == nil {
        return
    }

    if index == 0 {
        ll.head = ll.head.next
        return
    }

    current := ll.head
    for i := 0; i < index-1 && current != nil; i++ {
        current = current.next
    }

    if current == nil || current.next == nil {
        return
    }

    current.next = current.next.next
}

func (ll *LinkedList) IsEmpty() bool {
	return ll.head == nil
}

func (ll *LinkedList) Size() int {
	count := 0
	current := ll.head
	for current != nil {
		count++
		current = current.next
	}
	return count
}

func (ll *LinkedList) Display() string {
    var sb strings.Builder
    current := ll.head
    for current != nil {
        sb.WriteString(fmt.Sprintf("%v", current.data))
        if current.next != nil {
            sb.WriteString(" -> ")
        }
        current = current.next
    }
    return sb.String()
}
