use core::panic;
use std::{
    ops::Deref,
    rc::Rc,
    sync::{PoisonError, RwLock, RwLockReadGuard, RwLockWriteGuard},
};

#[test]
fn test_rw_lock() {
    struct sharedData {
        data: RwLock<Option<Box<i32>>>,
    }

    let shared = sharedData {
        data: RwLock::new(None),
    };

    {
        assert_eq!(*Rc::new(10), 10);
    }
    {
        let inner_data = shared.data.read().unwrap();
        assert_eq!(*inner_data, None);
    }
    {
        let mut data_write = shared.data.write().unwrap();
        *data_write = Some(Box::new(1));
    }
    {
        let inner_data = shared.data.read().unwrap();
        assert_eq!(*inner_data, Some(Box::new(1)));
    }

    let rw_option_rc_i32 = RwLock::new(Some(Rc::new(10)));
    let rw_option_rc_i32_read: RwLockReadGuard<'_, Option<Rc<i32>>> =
        rw_option_rc_i32.read().unwrap();

    let inner = rw_option_rc_i32_read.as_ref().cloned();
    match inner {
        Some(e) => {
            assert_eq!(*e, 10i32);
        }
        _ => {
            panic!("Error reading data");
        }
    }
}
