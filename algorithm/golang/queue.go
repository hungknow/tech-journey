package algo

type QueueNode[T any] struct {
    data T
    next *QueueNode[T]
}

type Queue[T any] struct {
    head *QueueNode[T]
    tail *QueueNode[T]
}

func (q *Queue[T]) Enqueue(data T) {
    newNode := &QueueNode[T]{data: data}

    if q.head == nil {
        q.head = newNode
        q.tail = newNode
    } else {
        q.tail.next = newNode
        q.tail = newNode
    }
}

func (q *Queue[T]) Dequeue() T {
    if q.head == nil {
        panic("Queue is empty")
    }

    data := q.head.data
    q.head = q.head.next

    if q.head == nil {
        q.tail = nil
    }

    return data
}

func (q *Queue[T]) IsEmpty() bool {
    return q.head == nil
}
