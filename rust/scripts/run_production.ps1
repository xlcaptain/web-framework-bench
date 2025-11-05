# 生产环境启动脚本 (PowerShell)

$ErrorActionPreference = "Stop"

# 配置
$BINARY_NAME = "axum-server-test.exe"
$BINARY_PATH = "target\release\$BINARY_NAME"

# 环境变量（如果未设置，使用默认值）
if (-not $env:WORKER_THREADS) {
    $env:WORKER_THREADS = (Get-WmiObject -Class Win32_Processor | Measure-Object -Property NumberOfCores -Sum).Sum
}
if (-not $env:RUST_LOG) {
    $env:RUST_LOG = "info"
}
if (-not $env:HOST) {
    $env:HOST = "0.0.0.0"
}
if (-not $env:PORT) {
    $env:PORT = "3000"
}

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "生产环境启动脚本" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 检查二进制文件是否存在
if (-not (Test-Path $BINARY_PATH)) {
    Write-Host "错误: 未找到二进制文件: $BINARY_PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "请先编译 release 版本:" -ForegroundColor Yellow
    Write-Host "  cargo build --release"
    Write-Host ""
    exit 1
}

# 显示配置
Write-Host "配置信息:"
Write-Host "  二进制文件: $BINARY_PATH"
Write-Host "  Worker Threads: $env:WORKER_THREADS"
Write-Host "  日志级别: $env:RUST_LOG"
Write-Host "  监听地址: $env:HOST`:$env:PORT"
Write-Host ""

# 启动服务
Write-Host "启动服务..." -ForegroundColor Green
Write-Host ""

& $BINARY_PATH

