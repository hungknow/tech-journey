pub struct Stack<T> {
    top: Option<Box<Node<T>>>,
}

struct Node<T> {
    value: T,
    next: Option<Box<Node<T>>>,
}

impl<T> Stack<T> {
    pub fn new() -> Self {
        Stack { top: None }
    }

    pub fn push(&mut self, value: T) {
        let newNode = Box::new(Node {
            value: value,
            next: self.top.take(),
        });
        self.top = Some(newNode);
    }

    pub fn pop(&mut self) -> Option<T> {
        self.top.take().map(|node| {
            self.top = node.next;
            node.value
        })
    }

    pub fn peek(&self) -> Option<&T> {
        self.top.as_ref().map(|node| &node.value)
    }

    pub fn is_empty(&self) -> bool {
        self.top.is_none()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_push() {
        let mut stack: Stack<i32> = Stack::new();
        stack.push(1);
        stack.push(2);
        stack.push(3);
    }

    #[test]
    fn test_pop() {
        let mut stack: Stack<i32> = Stack::new();
        stack.push(1);
        stack.push(2);
        stack.push(3);

        assert_eq!(stack.pop(), Some(3));
        assert_eq!(stack.pop(), Some(2));
        assert_eq!(stack.pop(), Some(1));
        assert_eq!(stack.pop(), None);
    }

    #[test]
    fn test_peek() {
        let mut stack: Stack<i32> = Stack::new();
        stack.push(1);
        stack.push(2);
        stack.push(3);

        assert_eq!(stack.peek(), Some(&3));
        stack.pop();
        assert_eq!(stack.peek(), Some(&2));
        stack.pop();
        assert_eq!(stack.peek(), Some(&1));
        stack.pop();
        assert_eq!(stack.peek(), None);
    }

    #[test]
    fn test_is_empty() {
        let mut stack: Stack<i32> = Stack::new();
        assert_eq!(stack.is_empty(), true);

        stack.push(1);
        assert_eq!(stack.is_empty(), false);

        stack.pop();
        assert_eq!(stack.is_empty(), true);
    }
}
