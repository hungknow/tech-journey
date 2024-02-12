// Define a struct for the node
struct Node<T> {
    value: T,
    next: Option<Box<Node<T>>>,
}

// Define the queue struct
pub struct Queue<T> {
    head: Option<Box<Node<T>>>,
    tail: Option<*mut Node<T>>,
}

impl<T> Queue<T> {
    // Create a new empty queue
    pub fn new() -> Self {
        Queue {
            head: None,
            tail: None,
        }
    }

    // Check if the queue is empty
    pub fn is_empty(&self) -> bool {
        self.head.is_none()
    }

    // Enqueue an element to the back of the queue
    pub fn enqueue(&mut self, value: T) {
        let new_node = Box::new(Node {
            value,
            next: None,
        });

        let raw_node = Box::into_raw(new_node);

        unsafe {
            if let Some(&tail) = self.tail.as_ref() {
                (*tail).next = Some(Box::from_raw(raw_node));
            } else {
                self.head = Some(Box::from_raw(raw_node));
            }

            self.tail = Some(raw_node);
        }
    }

    // Dequeue an element from the front of the queue
    pub fn dequeue(&mut self) -> Option<T> {
        self.head.take().map(|node| {
            self.head = node.next;

            if self.head.is_none() {
                self.tail = None;
            }

            node.value
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_new_queue() {
        let queue: Queue<i32> = Queue::new();
        assert!(queue.is_empty());
    }

    #[test]
    fn test_enqueue() {
        let mut queue: Queue<i32> = Queue::new();
        queue.enqueue(1);
        queue.enqueue(2);
        queue.enqueue(3);

        assert!(!queue.is_empty());
    }

    #[test]
    fn test_dequeue() {
        let mut queue: Queue<i32> = Queue::new();
        queue.enqueue(1);
        queue.enqueue(2);
        queue.enqueue(3);

        assert_eq!(queue.dequeue(), Some(1));
        assert_eq!(queue.dequeue(), Some(2));
        assert_eq!(queue.dequeue(), Some(3));
        assert_eq!(queue.dequeue(), None);
        assert!(queue.is_empty());
    }
}
