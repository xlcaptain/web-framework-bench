pub mod router;

use axum::Router;

pub fn create_router() -> Router {
    Router::new()
        .nest("/api", router::create_api_router())
}
