FROM rust:latest

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 复制源代码
COPY . .

# 构建应用
#RUN cargo build --release

# 启动应用
CMD ["./target/release/axum-server-test"]