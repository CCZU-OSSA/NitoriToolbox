use serde::{Deserialize, Serialize};
use std::collections::HashMap;

pub type DATA = Vec<HashMap<String, wmi::Variant>>;
pub type DATAMAP<'a> = HashMap<&'a str, DATA>;
pub type QueryResult<'a> = HashMap<&'static str, DATAMAP<'a>>;

#[derive(Serialize, Deserialize)]
pub struct QueryArg {
    #[serde(borrow)]
    pub target: Vec<&'static str>,
}
