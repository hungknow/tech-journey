use std::{
    rc::Rc,
    sync::{Arc, Mutex},
    thread,
};

#[test]
fn test_mutex() {
    let counter = Arc::new(Mutex::new(6));
    {
        let mut num = counter.lock().unwrap();
        *num = 0;
    }
    println!("m = {:?}", counter);

    // modify value in mutex in thread
    let mut handles = vec![];
    for _ in 1..10 {
        let cloned_counter = counter.clone();
        let handle = thread::spawn(move || {
            let mut num = cloned_counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }

    // Wait for all threads to finish.
    for handle in handles {
        handle.join().unwrap();
    }

    println!("after loop counter = {:?}", counter.lock().unwrap());
}
