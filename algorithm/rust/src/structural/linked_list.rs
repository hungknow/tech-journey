use std::rc::Rc;

enum Element {
    Conn(i32, Rc<Element>),
    Nil,
}


use Element::{Conn, Nil};

#[test]
fn test_element() {
    let con1 = Rc::new(Conn(1, Rc::new(Nil)));
    let con2 = Conn(2, con1.clone());
    let con3 = Conn(3, con1.clone());
}
