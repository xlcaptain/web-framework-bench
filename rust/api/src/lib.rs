pub mod router;

use axum::Router;

use tower::limit::ConcurrencyLimitLayer;

pub fn create_router() -> Router {
    Router::new()
        .nest("/api", router::create_api_router())
        .layer(ConcurrencyLimitLayer::new(10_000)) // 调整为你的机器上限
}

