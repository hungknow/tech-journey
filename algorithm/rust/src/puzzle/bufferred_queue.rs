// https://dhruv-ahuja.github.io/posts/implementing-buffered-queue-in-rust/
use std::collections::VecDeque;
use std::sync::{Arc, Mutex};

struct Producer<T>(Arc<BufferedQueue<T>>);
struct Consumer<T>(Arc<BufferedQueue<T>>);

struct BufferedQueue<T> {
    data: Mutex<VecDeque<T>>,
    pub capacity: usize,
}
