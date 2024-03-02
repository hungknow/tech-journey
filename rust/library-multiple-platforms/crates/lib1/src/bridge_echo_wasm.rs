use crux_core::{Core, bridge::Bridge};
use wasm_bindgen::prelude::*;
use lazy_static::lazy_static;

use crate::bridge_echo::{self, BridgeEcho, BridgeEchoCapabilities};

lazy_static! {
    static ref BRIDGEECHO: Bridge<bridge_echo::BridgeEchoEffect, BridgeEcho> = Bridge::new(Core::new::<BridgeEchoCapabilities>());
}

#[wasm_bindgen]
pub fn bridgeecho_process_event(data: &[u8]) -> Vec<u8> {
    BRIDGEECHO.process_event(data)
}

#[wasm_bindgen]
pub fn bridgeecho_handle_response(uuid: &[u8], data: &[u8]) -> Vec<u8> {
    BRIDGEECHO.handle_response(uuid, data) 
}

#[wasm_bindgen]
pub fn bridgeecho_view() -> Vec<u8> {
    BRIDGEECHO.view()
}