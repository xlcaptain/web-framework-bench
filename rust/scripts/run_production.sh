#!/bin/bash

# 生产环境启动脚本

set -e

# 配置
BINARY_NAME="axum-server-test"
BINARY_PATH="target/release/${BINARY_NAME}"
WORKER_THREADS=${WORKER_THREADS:-$(nproc)}
RUST_LOG=${RUST_LOG:-info}
HOST=${HOST:-0.0.0.0}
PORT=${PORT:-3000}

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=========================================="
echo "生产环境启动脚本"
echo "=========================================="
echo ""

# 检查二进制文件是否存在
if [ ! -f "${BINARY_PATH}" ]; then
    echo -e "${RED}错误: 未找到二进制文件: ${BINARY_PATH}${NC}"
    echo ""
    echo "请先编译 release 版本:"
    echo "  cargo build --release"
    echo ""
    exit 1
fi

# 显示配置
echo "配置信息:"
echo "  二进制文件: ${BINARY_PATH}"
echo "  Worker Threads: ${WORKER_THREADS}"
echo "  日志级别: ${RUST_LOG}"
echo "  监听地址: ${HOST}:${PORT}"
echo ""

# 设置环境变量
export WORKER_THREADS
export RUST_LOG

# 启动服务
echo -e "${GREEN}启动服务...${NC}"
echo ""

exec "${BINARY_PATH}"

