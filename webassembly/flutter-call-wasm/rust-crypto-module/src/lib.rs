use rand::rngs::OsRng;
use rsa::{PaddingScheme, PublicKey, RsaPrivateKey, RsaPublicKey};

use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn sign(data: String) -> Vec<u8> {
    let mut rng = OsRng;
    let bits = 2048;
    let priv_key = RsaPrivateKey::new(&mut rng, bits).expect("failed to generate a key");
    let pub_key = RsaPublicKey::from(&priv_key);

    // Encrypt
    let enc_data = pub_key
        .encrypt(&mut rng, PaddingScheme::PKCS1v15Encrypt, &data.as_bytes())
        .expect("failed to encrypt");

    return enc_data;
}