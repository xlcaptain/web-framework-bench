mod user;

use axum::{Router, routing::get};

pub fn create_api_router() -> Router {
    Router::new()
        .nest("/users", user::create_user_router())
        .route("/health", get(health_check))
}

async fn health_check() -> &'static str {
    "OK"
}
