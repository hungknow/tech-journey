use std::{
    pin::Pin,
    task::{Context, Poll},
};

trait Stream {
    /// The type of the value yielded by the stream.
    type Item;

    /// Attempt to resolve the next item in the stream.
    /// Returns `Poll::Pending` if not ready, `Poll::Ready(Some(x))` if a value
    /// is ready, and `Poll::Ready(None)` if the stream has completed.
    fn poll_next(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Option<Self::Item>>;
}

// async fn send_recv() {
//     const BUFFER_SIZE: usize = 10;
//     let (mut tx, mut rx) = mpsc::channel::<i32>();

//     tx.send(1).await.unwrap();
//     tx.send(2).await.unwrap();
//     drop(tx);

//     // `StreamExt::next` is similar to `Iterator::next`, but returns a
//     // type that implements `Future<Output = Option<T>>`.
//     assert_eq!(Some(1), rx.next().await);
//     assert_eq!(Some(2), rx.next().await);
//     assert_eq!(None, rx.next().await);
// }

#[cfg(test)]
mod tests {
    use futures::{channel::mpsc, SinkExt};
    use tokio_test::assert_err;

    #[tokio::test]
    async fn test_unbounded_channel() {
        let (mut tx, mut recv) = mpsc::unbounded::<i32>();

        tx.send(1).await.unwrap();
        assert_eq!(recv.try_next().unwrap(), Some(1));
        assert_err!(recv.try_next(), "");
        tx.close().await.unwrap();
        assert_eq!(recv.try_next().unwrap(), None);
    }
}
