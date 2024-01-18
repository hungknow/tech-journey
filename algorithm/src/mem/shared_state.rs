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

#[test]
fn test_rc_array() {
    let constant_arr = [1,2,3];
    let arr1: Rc<&[i32]> = Rc::new(&constant_arr);
    let arr2 = arr1.clone();
    let arr3 = arr2.clone();
    assert_eq!(arr1[0], 1);
    assert_eq!(arr3[2], 3);
}
