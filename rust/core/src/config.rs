use serde::Deserialize;
use config;

#[derive(Debug, Deserialize, Clone)]
pub struct Settings {
    pub server: Server,
    pub database: Database,
}

#[derive(Debug, Deserialize, Clone)]
pub struct Server {
    pub host: String,
    pub port: u16,
}

#[derive(Debug, Deserialize, Clone)]
pub struct Database {
    pub url: String,
    pub pool_size: u32,
}

pub fn load_settings() -> Result<Settings, config::ConfigError> {
    let builder = config::Config::builder()
        .add_source(config::File::with_name("config"))
        .add_source(config::File::with_name("config/local").required(false))
        .add_source(config::Environment::with_prefix("APP").separator("__"));

    builder.build()?.try_deserialize()
}