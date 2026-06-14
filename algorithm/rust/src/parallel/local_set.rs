// https://docs.rs/tokio/latest/tokio/task/struct.LocalSet.html

use std::rc::Rc;

use tokio::{
    runtime::Builder,
    sync::{mpsc, oneshot},
    task::{self, LocalSet},
    time,
};

#[tokio::test]
async fn test_local_set() {
    let nonsend_data = Rc::new("my nonsend data...");

    let local = LocalSet::new();
    // Run the local task set
    local
        .run_until(async move {
            let cloned_nonsend_data = nonsend_data.clone();
            // spawn_local ensures that the future runs on the local task set
            task::spawn_local(async move {
                println!("running on the current thread: {}", cloned_nonsend_data);
            })
            .await
            .unwrap();
        })
        .await;

    let local1 = LocalSet::new();
    let nonsend_data = Rc::new("world");
    local1.spawn_local(async move {
        time::sleep(time::Duration::from_millis(200)).await;
        println!("goodbye {}", nonsend_data)
    });

    local1.await;
}

enum Task {
    PrintNumber(u32),
    AddOne(u32, oneshot::Sender<u32>),
}

struct LocalSpawner {
    send: mpsc::UnboundedSender<Task>,
}

impl LocalSpawner {
    fn new() -> Self {
        let (send, mut recv) = mpsc::unbounded_channel();

        let rt = Builder::new_current_thread().enable_all().build().unwrap();

        std::thread::spawn(move || {
            let local = LocalSet::new();

            local.spawn_local(async move {
                while let Some(some_task) = recv.recv().await {
                    tokio::task::spawn_local(run_task(some_task));
                }
            });

            rt.block_on(local);
        });

        Self { send }
    }

    fn spawn(&self, task: Task) {
        let _ = self.send.send(task);
    }
}

async fn run_task(task: Task) {
    match task {
        Task::PrintNumber(n) => {
            println!("number: {}", n);
        }
        Task::AddOne(n, response) => {
            let _ = response.send(n + 1);
        }
    }
}

#[tokio::test]
async fn test_different_thread() {
    let spawner = LocalSpawner::new();
    let (send, recv) = oneshot::channel();
    spawner.spawn(Task::PrintNumber(5));
    spawner.spawn(Task::AddOne(10, send));
    let element = recv.await.unwrap();
    assert_eq!(element, 11);
}
