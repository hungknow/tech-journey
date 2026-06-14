use crux_core::{Core, bridge::Bridge};
use wasm_bindgen::prelude::*;
use lazy_static::lazy_static;

use crate::counter::{self, Counter, CounterCapabilities};

lazy_static! {
    static ref COUNTER: Bridge<counter::CounterEffect, Counter> = Bridge::new(Core::new::<CounterCapabilities>());
}

#[wasm_bindgen]
pub fn counter_process_event(data: &[u8]) -> Vec<u8> {
    COUNTER.process_event(data)
}

#[wasm_bindgen]
pub fn counter_handle_response(uuid: &[u8], data: &[u8]) -> Vec<u8> {
    COUNTER.handle_response(uuid, data) 
}

#[wasm_bindgen]
pub fn counter_view() -> Vec<u8> {
    COUNTER.view()
}