use axum::{
    http::StatusCode,
    response::{IntoResponse, Response},
    Json,
};
use serde::Serialize;

#[derive(Serialize)]
pub struct ApiResponse<T>
where
    T: Serialize,
{
    pub code: i32,
    pub message: String,
    pub result: Option<T>,
}

impl<T> ApiResponse<T>
where
    T: Serialize,
{
    pub fn ok(result: Option<T>, message: impl Into<String>) -> Self {
        Self {
            code: 200,
            message: message.into(),
            result,
        }
    }

    pub fn fail(code: i32, message: impl Into<String>) -> Self {
        Self {
            code,
            message: message.into(),
            result: None,
        }
    }
}

impl<T> IntoResponse for ApiResponse<T>
where
    T: Serialize,
{
    fn into_response(self) -> Response {
        let status = if self.code == 200 {
            StatusCode::OK
        } else {
            StatusCode::from_u16(self.code as u16).unwrap_or(StatusCode::INTERNAL_SERVER_ERROR)
        };
        (status, Json(self)).into_response()
    }
}