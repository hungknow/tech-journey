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

fn use_shared_state(arr: Rc<&[i32]>) {
    assert_eq!(arr[0], 1);
}
#[test]
fn test_rc_array() {
    let constant_arr = [1, 2, 3];
    let arr1: Rc<&[i32]> = Rc::new(&constant_arr);
    let arr2 = arr1.clone();
    let arr3 = arr2.clone();
    assert_eq!(arr1[0], 1);
    assert_eq!(arr3[2], 3);
    use_shared_state(arr1);
    use_shared_state(arr2);

    // Convert vector to reference of array
    let vec1 = vec![1, 2, 3];
    use_shared_state(Rc::new(vec1.as_slice()));
}

#[test]
fn test_moveable_buf() {
    struct MoveableBuf {
        buf: Vec<i32>,
    }
    struct MoveableBufRef<'a> {
        buf: &'a Vec<i32>,
    }
    // Create a struct with a buffer
    let buf = MoveableBuf { buf: vec![1, 2, 3] };
    // Create two references to the struct
    let buf_ref1 = MoveableBufRef { buf: &buf.buf };
    let buf_ref2 = MoveableBufRef { buf: &buf.buf };
    // print out the content of buffer
    assert_eq!(buf_ref1.buf[0], 1);
    assert_eq!(buf_ref2.buf[0], 1);
    assert_eq!(buf_ref1.buf[1], 2);
    assert_eq!(buf_ref2.buf[1], 2);

    // Move the buffer to another reference
    let buf_ref3 = buf_ref2;
    assert_eq!(buf_ref3.buf[1], 2);
}
