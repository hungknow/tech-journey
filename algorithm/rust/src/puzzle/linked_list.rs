// Define the Node struct
struct Node<T> {
    value: T,
    next: Option<Box<Node<T>>>,
}

// Define the LinkedList struct
struct LinkedList<T> {
    head: Option<Box<Node<T>>>,
}

impl<T> LinkedList<T> {
    // Create a new empty linked list
    fn new() -> Self {
        LinkedList { head: None }
    }

    // Check if the linked list is empty
    fn is_empty(&self) -> bool {
        self.head.is_none()
    }

    // Insert a value at the beginning of the linked list
    fn insert_at_head(&mut self, value: T) {
        self.head = Some(Box::new(Node {
            value: value,
            next: self.head.take(),
        }))
    }

    fn insert_at_index(&mut self, index: usize, value: T) {
        if index == 0 {
            self.insert_at_head(value);
            return;
        }

        let mut current = &mut self.head;
        for _ in 0..index {
            match current {
                Some(node) => {
                    current = &mut node.next;
                }
                None => {
                    return;
                }
            }
        }

        *current = Some(Box::new(Node {
            value: value,
            next: current.take(),
        }));
    }

    fn size(&self) -> usize {
        let mut count = 0;
        let mut current = &self.head;
        while let Some(node) = current {
            count += 1;
            current = &node.next;
        }
        count
    }

    fn get_data_at_index(&self, index: usize) -> Option<&T> {
        let mut current = &self.head;
        for _ in 0..index {
            match current {
                Some(node) => {
                    current = &node.next;
                }
                None => {
                    return None;
                }
            }
        }
        current.as_ref().map(|node| &node.value)
    }

    // Remove and return the value at the beginning of the linked list
    fn remove(&mut self) -> Option<T> {
        self.head.take().map(|node| {
            self.head = node.next;
            node.value
        })
    }

    fn remove_at_index(&mut self, index: usize) -> Option<T> {
        if index == 0 {
            return self.remove();
        }

        let mut current = &mut self.head;
        for _ in 0..index {
            match current {
                Some(node) => {
                    current = &mut node.next;
                }
                None => {
                    return None;
                }
            }
        }

        current.take().map(|node| {
            *current = node.next;
            node.value
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_new() {
        let list: LinkedList<i32> = LinkedList::new();
        assert!(list.is_empty());
    }

    #[test]
    fn test_insert_at_head() {
        let mut list: LinkedList<i32> = LinkedList::new();
        list.insert_at_head(1);
        assert!(!list.is_empty());
    }

    #[test]
    fn test_remove() {
        let mut list: LinkedList<i32> = LinkedList::new();
        list.insert_at_head(1);
        let value = list.remove();
        assert_eq!(value, Some(1));
        assert!(list.is_empty());
    }

    #[test]
    fn test_insert_at_index() {
        let mut list: LinkedList<i32> = LinkedList::new();
        list.insert_at_index(0, 1);
        assert_eq!(list.get_data_at_index(0), Some(&1));
        list.insert_at_index(0, 2);
        assert_eq!(list.get_data_at_index(0), Some(&2));
        assert_eq!(list.get_data_at_index(1), Some(&1));
        list.insert_at_index(1, 3);
        assert_eq!(list.get_data_at_index(0), Some(&2));
        assert_eq!(list.get_data_at_index(1), Some(&3));
        assert_eq!(list.get_data_at_index(2), Some(&1));
        assert_eq!(list.size(), 3);
    }

    #[test]
    fn test_remove_at_index() {
        let mut list: LinkedList<i32> = LinkedList::new();
        list.insert_at_index(0, 1);
        list.insert_at_index(1, 2);
        list.insert_at_index(2, 3);
        list.insert_at_index(3, 4);
        list.insert_at_index(4, 5);

        let removed_value = list.remove_at_index(2);
        assert_eq!(removed_value, Some(3));
        assert_eq!(list.get_data_at_index(0), Some(&1));
        assert_eq!(list.get_data_at_index(1), Some(&2));
        assert_eq!(list.get_data_at_index(2), Some(&4));
        assert_eq!(list.get_data_at_index(3), Some(&5));
        assert_eq!(list.size(), 4);

        let removed_value = list.remove_at_index(0);
        assert_eq!(removed_value, Some(1));
        assert_eq!(list.get_data_at_index(0), Some(&2));
        assert_eq!(list.get_data_at_index(1), Some(&4));
        assert_eq!(list.get_data_at_index(2), Some(&5));
        assert_eq!(list.size(), 3);

        let removed_value = list.remove_at_index(2);
        assert_eq!(removed_value, Some(5));
        assert_eq!(list.get_data_at_index(0), Some(&2));
        assert_eq!(list.get_data_at_index(1), Some(&4));
        assert_eq!(list.size(), 2);

        let removed_value = list.remove_at_index(1);
        assert_eq!(removed_value, Some(4));
        assert_eq!(list.get_data_at_index(0), Some(&2));
        assert_eq!(list.size(), 1);

        let removed_value = list.remove_at_index(0);
        assert_eq!(removed_value, Some(2));
        assert_eq!(list.size(), 0);
        assert!(list.is_empty());

        let removed_value = list.remove_at_index(0);
        assert_eq!(removed_value, None);
    }
}
