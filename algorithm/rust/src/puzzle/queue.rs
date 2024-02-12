pub struct Queue<T> {
    head: Option<Box<Node<T>>>,
    tail: Option<*mut Node<T>>,
}

struct Node<T> {
    data: T,
    next: Option<Box<Node<T>>>,
}

impl<T> Queue<T> {
    pub fn new() -> Self {
        Queue {
            head: None,
            tail: None,
        }
    }

    pub fn is_empty(&self) -> bool {
        self.head.is_none()
    }

    pub fn enqueue(&mut self, data: T) {
        let new_node = Box::new(Node {
            data,
            next: None,
        });

        let raw_node = Box::into_raw(new_node);

        unsafe {
            if let Some(&mut tail) = self.tail.as_mut() {
                (*tail).next = Some(Box::from_raw(raw_node));
            } else {
                self.head = Some(Box::from_raw(raw_node));
            }

            self.tail = Some(raw_node);
        }
    }

    pub fn dequeue(&mut self) -> Option<T> {
        self.head.take().map(|node| {
            self.head = node.next;

            if self.head.is_none() {
                self.tail = None;
            }

            node.data
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
