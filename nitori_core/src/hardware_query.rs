use std::{collections::HashMap, fs, path::Path};

use wmi::{COMLibrary, Variant, WMIConnection};
//Win32_LogicalDisk
//Win32_Processor

const MANIFEST: [&'static str; 4] = [
    "Win32_BaseBoard",
    "Win32_Processor",
    "Win32_PhysicalMemory",
    "Win32_OperatingSystem",
];

type DATA = HashMap<&'static str, Vec<HashMap<String, Variant>>>;

pub fn generate_info_in(pathto: &str) {
    let com = COMLibrary::new().unwrap();
    let con = WMIConnection::new(com).unwrap();
    if !Path::new(pathto).is_dir() {
        fs::create_dir_all(pathto).unwrap();
    }

    for member in MANIFEST.iter() {
        make_info_in(&con, member, pathto);
    }
}

pub fn make_info_in(con: &WMIConnection, name: &str, pathto: &str) {
    let mut content: DATA = HashMap::new();
    content.insert(
        "data",
        con.raw_query(format!("SELECT * FROM {}", name)).unwrap(),
    );
    fs::write(
        format!("{}/{}.json", pathto, name),
        serde_json::to_string(&content).unwrap(),
    )
    .unwrap();
}

pub fn make_info_name_in(name: &str, pathto: &str) {
    let com = COMLibrary::new().unwrap();
    let con = WMIConnection::new(com).unwrap();
    if !Path::new(pathto).is_dir() {
        fs::create_dir_all(pathto).unwrap();
    }

    make_info_in(&con, name, pathto)
}
