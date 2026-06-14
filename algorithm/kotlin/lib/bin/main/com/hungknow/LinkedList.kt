class LinkedList<T> {
    class Node<T>(var data: T, var next: Node<T>? = null) {}

    private var head: Node<T>? = null

    fun add(data: T) {
        val newNode = Node(data)
        if (head == null) {
            head = newNode
        } else {
            var current = head
            while (current?.next != null) {
                current = current.next
            }
            current?.next = newNode
        }
    }

    fun addAtIndex(index: Int, data: T) {
        val newNode = Node(data)
        if (index == 0) {
            newNode.next = head
            head = newNode
        } else {
            var current = head
            var count = 0
            while (current != null && count < index - 1) {
                current = current.next
                count++
            }
            if (current != null) {
                newNode.next = current.next
                current.next = newNode
            }
        }
    }

    fun display() {
        var current = head
        while (current != null) {
            println(current.data)
            current = current.next
        }
    }
}
