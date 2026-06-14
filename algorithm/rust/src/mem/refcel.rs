use std::{rc::Rc, cell::RefCell};

enum List {
    Cons(i32, RefCell<Rc<List>>),
    Nil,
}
// use crate::List::{Cons, Nil};

// impl List {
//     fn tail(&self) -> Option(&RefCell<Rc<List>>) {
//         match *self {
//             Cons(_, ref item) => Some(item),
//             Nil => None,
//         }
//     }
// }

// #[test]
// fn RuNTest() {
//     let a = Rc::new(Cons(5, RefCell::new(Rc::new(Nil))));
// }