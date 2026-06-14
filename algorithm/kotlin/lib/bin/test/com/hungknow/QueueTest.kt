package com.hungknow.kotlin;

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFalse
import kotlin.test.assertNull
import kotlin.test.assertTrue

class QueueTest {
    @Test
    fun testEnqueueAndDequeue() {
        val queue = Queue<Int>()

        queue.enqueue(1)
        queue.enqueue(2)
        queue.enqueue(3)

        assertEquals(1, queue.dequeue())
        assertEquals(2, queue.dequeue())
        assertEquals(3, queue.dequeue())
        assertNull(queue.dequeue())
    }

    @Test
    fun testIsEmpty() {
        val queue = Queue<String>()

        assertTrue(queue.isEmpty())

        queue.enqueue("a")
        assertFalse(queue.isEmpty())

        queue.dequeue()
        assertTrue(queue.isEmpty())
    }

    @Test
    fun testPeek() {
        val queue = Queue<Double>()

        assertNull(queue.peek())

        queue.enqueue(3.14)
        assertEquals(3.14, queue.peek())

        queue.enqueue(2.71)
        assertEquals(3.14, queue.peek())

        queue.dequeue()
        assertEquals(2.71, queue.peek())
    }
}
