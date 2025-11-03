use axum_server_test::create_router;

#[tokio::main]
async fn main() {
    // 初始化日志（如果需要）
    tracing_subscriber::fmt::init();

    // 创建路由
    let app = create_router();

    // 监听地址
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000")
        .await
        .unwrap();

    println!("Server listening on http://0.0.0.0:3000");

    // 启动服务器
    axum::serve(listener, app).await.unwrap();
}
