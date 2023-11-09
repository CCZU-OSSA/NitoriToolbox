use std::{collections::HashMap, fs, path::Path};

use wmi::{COMLibrary, Variant, WMIConnection};
//Win32_LogicalDisk
//Win32_Processor

const DIR_NAME: &'static str = ".win32info";
const MANIFEST: [&'static str; 4] = [
    "Win32_BaseBoard",
    "Win32_Processor",
    "Win32_PhysicalMemory",
    "Win32_OperatingSystem",
];

pub fn generate_info() {
    let com = COMLibrary::new().unwrap();
    let con = WMIConnection::new(com).unwrap();
    if !Path::new(DIR_NAME).is_dir() {
        fs::create_dir(DIR_NAME).unwrap();
    }

    for member in MANIFEST.iter() {
        make_info(&con, member);
    }
}

pub fn make_info(con: &WMIConnection, name: &str) {
    let mut content: HashMap<&'static str, Vec<HashMap<String, Variant>>> = HashMap::new();
    content.insert(
        "data",
        con.raw_query(format!("SELECT * FROM {}", name)).unwrap(),
    );
    fs::write(
        format!("{}/{}.json", DIR_NAME, name),
        serde_json::to_string(&content).unwrap(),
    )
    .unwrap();
}

pub fn make_info_name(name: &str) {
    let com = COMLibrary::new().unwrap();
    let con = WMIConnection::new(com).unwrap();
    if !Path::new(DIR_NAME).is_dir() {
        fs::create_dir(DIR_NAME).unwrap();
    }

    make_info(&con, name)
}
