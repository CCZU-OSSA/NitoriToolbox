use std::collections::HashMap;

use wmi::{COMLibrary, WMIConnection};

use crate::protocol::{QueryArg, QueryResult, DATAMAP};

pub fn query(target: &'static str) -> String {
    let con = COMLibrary::new().unwrap();
    let wmi = WMIConnection::new(con).unwrap();
    let mut data: DATAMAP = HashMap::new();
    for t in serde_json::from_str::<QueryArg>(target)
        .unwrap()
        .target
        .iter()
    {
        data.insert(t, wmi.raw_query(format!("SELECT * FROM {}", t)).unwrap());
    }

    let mut result: QueryResult = HashMap::new();
    result.insert("data", data);
    serde_json::to_string(&result).unwrap()
}
