use tokio::sync::oneshot;
use tokio::time::{self, Duration};
use tokio::{select, time::sleep};
use tokio_stream::{self as stream, StreamExt};

#[tokio::test]
async fn test_select_future() {
    async fn do_stuff_1() -> u32 {
        1
    }
    async fn do_stuff_2() -> u32 {
        2
    }
    let value = select! {
        val = do_stuff_1() => {
            assert_eq!(val, 1);
            val
        }
        val = do_stuff_2() => {
            assert_eq!(val, 2);
            val
        }
    };
    assert!(value == 1 || value == 2);
}

#[tokio::test]
async fn test_select_either_stream() {
    let mut stream1 = stream::iter(1..=3);
    let mut stream2 = stream::iter(4..=6);
    let next = select! {
        item = stream1.next() => {
            assert_eq!(item, Some(1));
            item.unwrap()
        }
        item = stream2.next() => {
            assert_eq!(item, Some(4));
            item.unwrap()
        }
    };
    assert!(next == 1 || next == 4);
}

#[tokio::test]
async fn test_select_wait_all_stream() {
    let mut stream1 = stream::iter(1..=3);
    let mut stream2 = stream::iter(4..=6);
    let mut values = Vec::new();
    loop {
        select! {
            Some(v) = stream1.next() => values.push(v),
            Some(v) = stream2.next() => values.push(v),
            else => break,
        }
    }
    values.sort();
    assert_eq!(&[1, 2, 3, 4, 5, 6], &values[..]);
}

#[tokio::test]
async fn test_select_timeout() {
    let mut stream1 = stream::iter(1..3);
    let sleep = time::sleep(Duration::from_secs(3));
    tokio::pin!(sleep);

    loop {
        select! {
            Some(v) = stream1.next() => {
                println!("stream1: {:?}", v);
            }
            _ = &mut sleep => {
                println!("timeout");
                break;
            }
        }
    }
}

#[tokio::test]
async fn test_select_channel() {
    let (tx1, mut rx1) = oneshot::channel::<i32>();
    let (tx2, mut rx2) = oneshot::channel::<i32>();

    // Create thread to send messages from channels
    tokio::spawn(async move {
        tx1.send(1).unwrap();
    });
    tokio::spawn(async move {
        tx2.send(2).unwrap();
    });

    let mut a = None;
    let mut b = None;

    // Select to receive messages from channels
    while a.is_none() || b.is_none() {
        select! {
            v1 = (&mut rx1), if a.is_none() => { a = Some(v1.unwrap()); },
            v2 = (&mut rx2), if b.is_none() => { b = Some(v2.unwrap()); },
        }
    }

    assert_eq!(a, Some(1));
    assert_eq!(b, Some(2));
}
