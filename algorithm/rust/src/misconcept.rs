// https://github.com/pretzelhammer/rust-blog/blob/master/posts/common-rust-lifetime-misconceptions.md#2-if-t-static-then-t-must-be-valid-for-the-entire-program

trait GeneralT {}
// impl<T> GeneralT for T {}
// T is a superset of both &T and &mut T
// So we cannot implement "for T" and "for &T" at the same time
impl<T> GeneralT for &T {}
impl<T> GeneralT for &mut T {}

