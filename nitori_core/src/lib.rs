use std::ffi::{c_char, CStr};

pub mod hardware_query;

#[no_mangle]
pub extern "C" fn generate_info() {
    hardware_query::generate_info()
}

#[no_mangle]
pub extern "C" fn make_info_name(name: *const c_char) {
    hardware_query::make_info_name(unsafe {
        CStr::from_ptr(name).to_string_lossy().to_string().as_str()
    })
}
