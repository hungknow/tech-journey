package com.hungknow.kotlin;

class Queue<T> {
    class Node<T>(val value: T, var next: Node<T>? = null)

    private var head: Node<T>? = null
    private var tail: Node<T>? = null

    fun enqueue(value: T) {
        val newNode = Node(value)
        if (head == null) {
            head = newNode
            tail = newNode
        } else {
            tail?.next = newNode
            tail = newNode
        }
    }

    fun dequeue(): T? {
        if (head == null) {
            return null
        }
        val dequeuedValue = head?.value
        head = head?.next
        if (head == null) {
            tail = null
        }
        return dequeuedValue
    }

    fun isEmpty(): Boolean {
        return head == null
    }

    fun peek(): T? {
        return head?.value
    }
}
