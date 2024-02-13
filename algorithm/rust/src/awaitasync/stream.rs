use std::{
    future,
    pin::{self, Pin},
    task::{Context, Poll},
    time::Duration,
    vec,
};

use futures::{Stream, StreamExt};
use tokio::time::sleep;

// trait Stream {
//     /// The type of the value yielded by the stream.
//     type Item;

//     /// Attempt to resolve the next item in the stream.
//     /// Returns `Poll::Pending` if not ready, `Poll::Ready(Some(x))` if a value
//     /// is ready, and `Poll::Ready(None)` if the stream has completed.
//     fn poll_next(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Option<Self::Item>>;
// }

// async fn send_recv() {
//     const BUFFER_SIZE: usize = 10;
//     let (mut tx, mut rx) = mpsc::channel::<i32>(1);

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
        async { println!("{}: {}", func_name, i) }.await;
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

async fn stream_sum(mut stream: Pin<&mut impl Stream<Item = i32>>) -> i32 {
    let mut sum = 0i32;
    while let Some(item) = stream.next().await {
        sum += item;
    }
    sum
}

#[tokio::test]
async fn test_stream_sum() {
    let stream = futures::stream::iter(1..=10);
    let mut stream = futures::stream::iter(1..=3);
    // stream.filter(|x| future::ready(x > &1));
    let pin_stream = Pin::new(&mut stream);
    let sum = stream_sum(pin_stream).await;
    assert_eq!(sum, 6);
}

#[tokio::test]
async fn test_chunk() {
    let stream = futures::stream::iter(1..=10);
    let mut chunks = stream.chunks(3);
    let mut chunks = Pin::new(&mut chunks);
    while let Some(chunk) = chunks.next().await {
        println!("{:?}", chunk);
    }
}

#[tokio::test]
async fn test_fuse() {
    let stream = futures::stream::iter(1..=3);
    let mut fuse = stream.fuse();
    let mut fuse = Pin::new(&mut fuse);
    while let Some(item) = fuse.next().await {
        println!("{:?}", item);
    }
}

#[tokio::test]
async fn test_once() {
    let stream = futures::stream::once(async { 1 });
    let collected = stream.collect::<Vec<i32>>().await;
    assert_eq!(collected[0], 1);
}

#[tokio::test]
async fn test_concat() {
    let stream = futures::stream::iter(vec![vec![1], vec![2], vec![3]]);
    let concat = stream.concat().await;
    assert_eq!(concat, vec![1, 2, 3]);
}

#[tokio::test]
async fn test_buffered() {
    async fn add_two(num: i32) -> i32 {
        num
    }

    let all_futures = (1..=3).map(|x| add_two(x)).collect::<Vec<_>>(); 
    let stream = futures::stream::iter(all_futures);
    let buffered = stream.buffered(3);
    let mut buffered = buffered.into_future().await;
    while let Some(chunk) = buffered.0 {
        println!("{:?}", chunk);
        buffered = buffered.1.into_future().await;
    }
}
