use std::{
    future,
    pin::Pin,
    task::{Context, Poll},
    time::Duration,
};

use futures::future::join_all;
use tokio::time::sleep;

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

async fn async_print(func_name: &str) {
    for i in 0..10 {
        async {println!("{}: {}", func_name, i)}.await;
        sleep(Duration::from_millis(10)).await;
    }
}
#[tokio::test]
async fn multiple_print() {
    let print_1 = async_print("print_1");
    let print_2 = async_print("print_2");
    futures::join!(print_1, print_2);
}

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
