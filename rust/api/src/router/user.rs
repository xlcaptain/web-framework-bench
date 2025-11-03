use axum::{
    extract::Path,
    routing::{get, post},
    Json, Router,
};
use serde::{Deserialize, Serialize};
use core::response::ApiResponse;

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct User {
    pub id: u64,
    pub name: String,
    pub email: String,
}

#[derive(Deserialize)]
pub struct CreateUserRequest {
    pub name: String,
    pub email: String,
}

pub fn create_user_router() -> Router {
    Router::new()
        .route("/", get(get_users))
        .route("/:id", get(get_user_by_id))
        .route("/", post(create_user))
}

/// 获取用户列表
async fn get_users() -> Json<ApiResponse<Vec<User>>> {
    let users = vec![
        User {
            id: 1,
            name: "Alice".to_string(),
            email: "alice@example.com".to_string(),
        },
        User {
            id: 2,
            name: "Bob".to_string(),
            email: "bob@example.com".to_string(),
        },
    ];

    Json(ApiResponse::ok(Some(users), "获取用户列表成功"))
}

/// 根据 ID 获取用户
async fn get_user_by_id(Path(id): Path<u64>) -> Json<ApiResponse<User>> {
    let user = User {
        id,
        name: format!("User {}", id),
        email: format!("user{}@example.com", id),
    };

    Json(ApiResponse::ok(Some(user), "获取用户成功"))
}

/// 创建用户
async fn create_user(Json(payload): Json<CreateUserRequest>) -> Json<ApiResponse<User>> {
    let user = User {
        id: 100, // 实际应用中应该从数据库生成
        name: payload.name,
        email: payload.email,
    };

    Json(ApiResponse::ok(Some(user), "创建用户成功"))
}
