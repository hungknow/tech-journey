use std::{ops, sync::Arc};

pub struct ProtobufData<T>(pub T);

impl<T> ProtobufData<T> {
    pub fn into_inner(self) -> T {
        self.0
    }
}

impl<T> ops::Deref for ProtobufData<T> {
    type Target = T;

    fn deref(&self) -> &T {
        &self.0
    }
}


pub trait ProtobufConcurrent: Send + Sync {}
impl<T> ProtobufConcurrent for T where T: Send + Sync {}

pub struct ProtobufState<T: ?Sized + ProtobufConcurrent>(Arc<T>);

impl<T> ProtobufState<T>
where
  T: ProtobufConcurrent,
{
  pub fn new(data: T) -> Self {
    ProtobufState(Arc::new(data))
  }

  pub fn get_ref(&self) -> &T {
    self.0.as_ref()
  }
}


pub type DataResult<T, E> = std::result::Result<ProtobufData<T>, E>;
