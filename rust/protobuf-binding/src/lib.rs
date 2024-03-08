use std::{
    any::{Any, TypeId},
    collections::HashMap,
    fmt::{Debug, Display},
    future::{ready, Future, Ready},
    hash::Hash,
    marker::PhantomData,
    sync::{Arc, Weak},
};

use models::{
    auth::SignUpPayloadPB, errors::FlowyError, event_map::UserEvent, user::UserProfilePB,
};
use traits::{DataResult, ProtobufConcurrent, ProtobufData, ProtobufState};
use user_manager::UserManager;

mod models;
pub mod traits;
pub mod user_manager;

type AFBox = Box<dyn Any + Send + Sync>;
struct AFPluginStateMap(HashMap<TypeId, AFBox>);
pub type AFStateMap = std::sync::Arc<AFPluginStateMap>;

struct PluginContainer {
    state: AFStateMap,
}

impl PluginContainer {
    pub fn new() -> Self {
        Self {
            state: Arc::new(AFPluginStateMap(HashMap::new())),
        }
    }
    pub fn add_state<T>(mut self, value: T) -> Self
    where
        T: Send + Sync + 'static,
    {
        Arc::get_mut(&mut self.state)
            .unwrap()
            .0
            .insert(TypeId::of::<T>(), Box::new(value));
        self
    }
}

pub async fn sign_up(
    data: ProtobufData<SignUpPayloadPB>,
    manager: ProtobufState<Weak<UserManager>>,
) -> DataResult<UserProfilePB, FlowyError> {
    panic!("Not implemented")
}

pub fn init() {
    Plugin::new().event(UserEvent::SignUp, sign_up);
}

// impl<Func> Handler for Func
// where
//     Func: Fn(i32, i32) -> Res + Clone + 'static + ProtobufConcurrent,
//     Res: Future + ProtobufConcurrent,
// {
// }

// pub trait AFPluginResponder {
//     fn respond_to(self, req: &AFPluginEventRequest) -> AFPluginEventResponse;
// }

/// A closure that is run every time for the specified plugin event
pub trait AFPluginHandler<T, R>: Clone + ProtobufConcurrent + 'static
where
    R: Future + ProtobufConcurrent,
{
    fn call(&self, param: T) -> R;
}

impl<Func, A, B, Res> AFPluginHandler<(A, B), Res> for Func
where
    Func: Fn(A, B) -> Res + Clone + 'static + ProtobufConcurrent,
    Res: Future + ProtobufConcurrent,
{
    #[allow(non_snake_case)]
    fn call(&self, (A, B): (A, B)) -> Res {
        (self)(A, B)
    }
}

// Container for the plugin event handler
pub struct AFPluginHandlerService<H, T, R>
where
    H: AFPluginHandler<T, R>,
    //   T: FromAFPluginRequest,
    R: Future + ProtobufConcurrent,
    //   R::Output: AFPluginResponder,
{
    handler: H,
    _phantom: PhantomData<(T, R)>,
}

impl<H, T, R> AFPluginHandlerService<H, T, R>
where
    H: AFPluginHandler<T, R>,
    //   T: FromAFPluginRequest,
    R: Future + ProtobufConcurrent,
    //   R::Output: AFPluginResponder,
{
    pub fn new(handler: H) -> Self {
        Self {
            handler,
            _phantom: PhantomData,
        }
    }
}

impl<H, T, R> Clone for AFPluginHandlerService<H, T, R>
where
    H: AFPluginHandler<T, R>,
    //   T: FromAFPluginRequest,
    R: Future + ProtobufConcurrent,
    //   R::Output: AFPluginResponder,
{
    fn clone(&self) -> Self {
        Self {
            handler: self.handler.clone(),
            _phantom: PhantomData,
        }
    }
}

impl<F, T, R> AFPluginServiceFactory<ServiceRequest> for AFPluginHandlerService<F, T, R>
where
    F: AFPluginHandler<T, R>,
    // T: FromAFPluginRequest,
    R: Future + ProtobufConcurrent,
    // R::Output: AFPluginResponder,
{
    type Response = ServiceResponse;
    type Error = DispatchError;
    type Service = ();//Self;
    type Context = ();
    type Future = Ready<Result<Self::Service, Self::Error>>;
    fn new_service(&self, _: ()) -> Self::Future {
        ready(Ok(()))//self.clone()))
    }
}

// impl<H, T, R> Service<ServiceRequest> for AFPluginHandlerService<H, T, R>
// where
//     H: AFPluginHandler<T, R>,
//     // T: FromAFPluginRequest,
//     R: Future + ProtobufConcurrent,
//     // R::Output: AFPluginResponder,
// {
//     type Response = ServiceResponse;
//     type Error = DispatchError;
//     type Future = ();//HandlerServiceFuture<H, T, R>;
//     fn call(&self, req: ServiceRequest) -> Self::Future {
//         let (req, mut payload) = req.into_parts();
//         let fut = T::from_request(&req, &mut payload);
//         // HandlerServiceFuture::Extract(fut, Some(req), self.handler.clone())
//     }
// }

pub trait Service<Request> {
    type Response;
    type Error;
    type Future: Future<Output = Result<Self::Response, Self::Error>>;
    fn call(&self, req: Request) -> Self::Future;
}
pub trait AFPluginServiceFactory<Request> {
    type Response;
    type Error;
    type Service; //: Service<Request, Response = Self::Response, Error = Self::Error>;
    type Context;
    type Future: Future<Output = Result<Self::Service, Self::Error>>;

    fn new_service(&self, cfg: Self::Context) -> Self::Future;
}

struct ServiceRequest {}
struct ServiceResponse {}
struct DispatchError {}

macro_rules! factory_tuple ({ $($param:ident)* } => {
    impl<Func, $($param,)* Res> AFPluginHandler<($($param,)*), Res> for Func
    where Func: Fn($($param),*) -> Res + Clone + 'static + ProtobufConcurrent,
          Res: Future + ProtobufConcurrent,
        //   Res::Output: AFPluginResponder,
    {
        #[allow(non_snake_case)]
        fn call(&self, ($($param,)*): ($($param,)*)) -> Res {
            (self)($($param,)*)
        }
    }
});

// factory_tuple! {}
// factory_tuple! { A }
// factory_tuple! { A B }
// factory_tuple! { A B C }
// factory_tuple! { A B C D }
// factory_tuple! { A B C D E }

#[derive(PartialEq, Eq, Hash, Debug, Clone)]
pub struct AFPluginEvent(pub String);

impl<T: Display> std::convert::From<T> for AFPluginEvent {
    fn from(t: T) -> Self {
        AFPluginEvent(format!("{}", t))
    }
}

// pub trait Handler {}

struct HandlerContainer {
    // h: Box<AFPluginHandlerService>,
}

impl HandlerContainer {
    // pub fn new(h: Box<dyn Handler>) -> Self {
    //     Self { h }
    // }
}

type AFPluginServiceFactoryBox<Cfg, Req, Res, Err> = Box<
    dyn AFPluginServiceFactory<
        Req,
        Response = Res,
        Error = Err,
        Context = Cfg,
        Service = (),
        Future = std::future::Ready<Result<(), Err>>,
    >,
>;
struct BoxServiceFactory<Cfg, Req, Res, Err>(AFPluginServiceFactoryBox<Cfg, Req, Res, Err>);
// type FuncA<A, B, Res> = Box<dyn Fn(A, B) -> Res + 'static + ProtobufConcurrent>;
// type ResA = Future + ProtobufConcurrent;
struct Plugin {
    event_service_factory: Arc<
        HashMap<
            AFPluginEvent,
            // HandlerContainer,
            BoxServiceFactory<(), ServiceRequest, ServiceResponse, DispatchError>,
            // dyn AFPluginHandler<(A, B), Res>
            // AFPluginHandlerService<
            //     Box<dyn AFPluginHandler<(), ()>>,
            //     (),
            //     ()>,
        >,
    >,
}

impl Plugin {
    fn new() -> Self {
        Plugin {
            event_service_factory: Arc::new(HashMap::new()),
        }
    }

    pub fn event<E, H, T, R>(mut self, event: E, handler: H) -> Self
    where
        H: AFPluginHandler<T, R>,
        T: 'static,
        // T: FromAFPluginRequest + 'static + ProtobufConcurrent,
        // <T as FromAFPluginRequest>::Future: ProtobufConcurrent,
        R: Future + ProtobufConcurrent + 'static,
        // R::Output: AFPluginResponder + 'static,
        E: Eq + Hash + Debug + Clone, // + Display,
    {
        let event_name = format!("{:?}", event);
        let event: AFPluginEvent = AFPluginEvent(event_name);
        if self.event_service_factory.contains_key(&event) {
            panic!("Same event already exists: {:?}", event);
        } else {
            Arc::get_mut(&mut self.event_service_factory)
                .unwrap()
                .insert(
                    event,
                    BoxServiceFactory(Box::new(AFPluginHandlerService::new(handler))),
                );
        }
        self
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_plugin() {
        let plugin = Plugin::new();
        let plugin = plugin.event(UserEvent::SignUp, sign_up);
    }
}
