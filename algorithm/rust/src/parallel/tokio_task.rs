// https://docs.rs/tokio/latest/tokio/task/index.html

use tokio::task;

#[tokio::test]
async fn test_task_spwan() {
    let join = task::spawn(async { "hello world" });
    assert_eq!(join.await.unwrap(), "hello world");

    let error_join = task::spawn(async { panic!("something went wrong") });
    assert!(error_join.await.is_err());
}

#[tokio::test]
async fn test_task_spawn_blocking() {
    let join_handle = task::spawn_blocking(|| {
        // Do some compute-heavy work or call synchronous code
        "blocking complete"
    });

    assert_eq!(join_handle.await.unwrap(), "blocking complete");

    let join_handle_error = task::spawn_blocking(|| {
        panic!("something went wrong")
    });
    assert!(join_handle_error.await.is_err());
}

#[tokio::test(flavor = "multi_thread", worker_threads = 1)]
async fn test_task_block_in_place() {
    // can call blocking only when running on the multi-threaded runtime
    let result = task::block_in_place(|| {
        // Do some compute-heavy work or call synchronous code
        "blocking in place"
    });
    assert_eq!(result, "blocking in place");
}
