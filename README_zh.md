
# Web 框架性能对比测试套件

<div align="right">
  <strong>Language / 语言:</strong>
  <a href="README.md">English</a> |
  <a href="README_zh.md">中文</a>
</div>

一个对比 Web 框架性能的基准测试项目：Rust (Axum) 和 Python (FastAPI)。包含标准化的 API 端点、自动化测试脚本，以及吞吐量、延迟和资源使用等性能指标。

## 🚀 性能总结

### 核心发现

**Rust (Axum) 在所有指标上都显著优于 FastAPI：**

- **吞吐量提升 44.6%**：123,715 RPS vs 85,536 RPS
- **平均延迟降低 2.5 倍**：12.64ms vs 32.16ms
- **P95 延迟降低 2.6 倍**：26.79ms vs 69.37ms
- **内存使用降低 6 倍**：202.1 MiB vs 1,244 MiB (1.215 GiB)
- **错误率为 0%**：两个框架在测试负载下均无错误

![性能对比](https://github.com/xlcaptain/web-framework-bench/blob/main/static/performance_comparison.png)

*综合性能指标对比，展示吞吐量、平均延迟和 P95 延迟的对比*

### 详细性能指标

#### 吞吐量与延迟

| 指标 | FastAPI | Rust (Axum) | 提升幅度 |
|------|---------|-------------|----------|
| **吞吐量 (RPS)** | 85,536 | 123,715 | **1.45 倍** |
| **平均延迟** | 32.16 ms | 12.64 ms | **快 2.55 倍** |
| **P50 延迟** | 28.12 ms | 11.61 ms | **快 2.42 倍** |
| **P90 延迟** | 57.95 ms | 22.47 ms | **快 2.58 倍** |
| **P95 延迟** | 69.37 ms | 26.79 ms | **快 2.59 倍** |
| **最大延迟** | 278.81 ms | 238.91 ms | **快 1.17 倍** |
| **错误率** | 0.00% | 0.00% | 相同 |

![延迟百分位数](https://github.com/xlcaptain/web-framework-bench/blob/main/static/latency_percentiles.png)

*延迟分布对比（P50、P90、P95、P99），显示 Rust 在所有百分位上持续优于 FastAPI*

#### 资源效率

| 指标 | FastAPI | Rust (Axum) | 效率提升 |
|------|---------|-------------|----------|
| **内存使用** | 1,244 MiB | 202.1 MiB | **减少 6.15 倍** |
| **进程数** | 100 | 33 | **减少 3 倍** |
| **每 RPS 内存** | 14.5 KB/RPS | 1.63 KB/RPS | **效率提升 8.9 倍** |
| **每 MiB RPS** | 68.8 RPS/MiB | 612.3 RPS/MiB | **提升 8.9 倍** |

![资源对比](https://github.com/xlcaptain/web-framework-bench/blob/main/static/resource_comparison.png)

*资源使用对比，展示内存效率、进程数和每 RPS 内存消耗指标*

![性能提升倍数](https://github.com/xlcaptain/web-framework-bench/blob/main/static/performance_improvement.png)

*性能提升倍数对比，展示 Rust 在所有指标上的优势*

### 测试配置

- **测试时长**：60 秒
- **虚拟用户数 (VUs)**：3,000
- **总请求数**：510 万 (FastAPI) / 740 万 (Rust)
- **测试工具**：k6
- **测试场景**：固定虚拟用户数（稳态测试）

### 性能雷达图分析

![性能雷达图](https://github.com/xlcaptain/web-framework-bench/blob/main/static/performance_radar.png)

*多维度性能对比，展示 Rust 在吞吐量、延迟和效率指标上的卓越表现*

### 结论

在相同的负载条件下（3,000 并发虚拟用户，持续 60 秒），**Rust (Axum) 实现了：**
- **吞吐量提升 44.6%**，同时**延迟降低 2.5 倍**
- **内存消耗减少 83.8%**（从 1.215 GiB 降至 202.1 MiB）
- **进程数减少 3 倍**，降低系统开销

这些结果表明，Rust 能够以**显著更低的资源消耗提供更高的性能**，使其成为高吞吐量、资源受限环境的理想选择。

---

## 项目概述

跨语言和框架的 Web 后端基准测试套件，使用一致的端点和场景来产生可复现的结果。

### 已测试框架

- **Rust**
  - ✅ Axum (已完成)
  - ⏳ Actix-web (计划中)
- **Python**
  - ✅ FastAPI (已完成)
- **Go** (计划中)
  - ⏳ net/http 或流行框架如 Gin/Fiber

## 特性

- 跨实现的标准化 API 端点
- 使用 k6 的自动化基准测试脚本
- 多种测试场景（Hello World、JSON 序列化、数据库查询等）
- 性能指标：吞吐量（req/s）、延迟（p50、p95、p99）、内存使用
- 容器化环境，确保测试一致性
- 可复现的结果与详细指标

## 项目结构

```
web-framework-bench/
├── README.md
├── README.zh.md
├── benchmark/
│   └── k6/
│       ├── steady_vus.js        # 固定虚拟用户数测试脚本
│       ├── ramp_vus.js          # 递增虚拟用户数测试脚本
│       └── rate_test.js          # 固定到达率测试脚本
├── rust/
│   ├── Cargo.toml
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── src/
│   │   ├── main.rs
│   │   └── lib.rs
│   ├── api/                      # API 路由
│   ├── core/                     # 核心功能
│   └── service/                  # 业务逻辑
├── python/
│   └── fastapi/
│       ├── main.py
│       ├── Dockerfile
│       ├── docker-compose.yml
│       └── pyproject.toml
└── static/                       # 性能图表
    ├── performance_comparison.png
    ├── latency_percentiles.png
    ├── resource_comparison.png
    ├── performance_improvement.png
    └── performance_radar.png
```

## 前置要求

- Rust (最新稳定版) - 用于 Axum 实现
- Python 3.9+ - 用于 FastAPI 实现
- Docker & Docker Compose (推荐)
- k6 (用于基准测试)
  - 安装：`brew install k6` (macOS) 或参考 [k6 安装指南](https://k6.io/docs/getting-started/installation/)

## 安装

### 克隆仓库

```bash
git clone https://github.com/xlcaptain/web-framework-bench.git
cd web-framework-bench
```

### 设置 Rust (Axum)

```bash
cd rust
cargo build --release
```

### 设置 FastAPI

```bash
cd python/fastapi
pip install -r requirements.txt
# 或使用 uv
uv sync
```

### 使用 Docker (推荐)

```bash
# Rust (Axum)
cd rust
docker-compose up -d

# FastAPI
cd python/fastapi
docker-compose up -d
```

## 使用方法

### 运行单个服务

**Rust - Axum:**
```bash
cd rust
cargo run --release
# 服务运行在 http://localhost:8080
```

**Python - FastAPI:**
```bash
cd python/fastapi
uvicorn main:app --host 0.0.0.0 --port 8000
# 服务运行在 http://localhost:8000
```

### 运行基准测试

#### 使用 k6 (推荐)

**固定虚拟用户数测试 (60 秒，3000 个虚拟用户):**
```bash
k6 run --vus 3000 --duration 60s benchmark/k6/steady_vus.js
```

**固定迭代次数:**
```bash
k6 run --iterations=100000 --vus=3000 benchmark/k6/steady_vus.js
```

**固定到达率测试 (用于延迟对比):**
```bash
# 通过环境变量设置目标 RPS
TARGET=http://localhost:8080 RPS=80000 k6 run benchmark/k6/rate_test.js
```

**RPS 扫描测试 (查找饱和点):**
```bash
TARGET=http://localhost:8080 k6 run benchmark/k6/ramp_vus.js
```

#### 基准测试脚本

```bash
# 运行所有基准测试
cd benchmark
./k6_vus_ramp.sh    # 递增虚拟用户数测试
./k6_rate_sweep.sh  # 速率扫描测试
```

## 基准测试场景

### 1. Hello World 端点
返回文本响应的简单端点 - 基准性能测试。

### 2. JSON 序列化
返回包含多个字段的 JSON 对象的端点 - 测试序列化性能。

### 3. 路由参数处理
接受路由参数并返回处理数据的端点。

### 4. 查询参数处理
处理查询参数的端点。

### 5. 请求体解析
解析 JSON 请求体的 POST 端点。

## 测试结果

### 收集的性能指标

- **吞吐量**：每秒请求数 (RPS)
- **延迟分布**：
  - 平均延迟
  - 百分位数：p50（中位数）、p90、p95、p99
  - 最小/最大延迟
- **资源使用**：
  - 内存消耗 (MiB/GiB)
  - 进程数
  - CPU 使用率（测试期间）
- **可靠性**：
  - 错误率
  - 失败请求数

### 测试结果摘要

| 框架 | 吞吐量 | 平均延迟 | P95 延迟 | 内存 | 错误率 |
|------|--------|----------|----------|------|--------|
| **Rust (Axum)** | 123,715 RPS | 12.64 ms | 26.79 ms | 202.1 MiB | 0.00% |
| **FastAPI** | 85,536 RPS | 32.16 ms | 69.37 ms | 1,244 MiB | 0.00% |

*测试条件：3,000 个虚拟用户，60 秒持续时间*

### 完整结果表格

![性能表格](https://github.com/xlcaptain/web-framework-bench/blob/main/static/performance_table.png)

*包含所有收集数据点的综合性能指标表格*

## 测试环境

- **操作系统**：Ubuntu Linux
- **硬件配置**：
  - CPU：[您的 CPU 规格]
  - 内存：125.4 GiB 可用
  - 网络：[您的网络配置]
- **基准测试工具**：k6 (最新版本)
- **测试时长**：60 秒
- **并发用户数**：3,000 个虚拟用户
- **容器运行时**：Docker

**注意**：结果可能因硬件、操作系统和系统负载而异。我们建议在隔离、一致且具有相似硬件规格的环境中运行基准测试。

## 测试方法论

### 测试方法

1. **固定虚拟用户数测试**：在 60 秒内维持 3,000 个虚拟用户，测量稳态性能
2. **资源监控**：在测试执行期间收集 Docker 统计信息
3. **多次运行**：测试运行多次以确保一致性
4. **隔离环境**：每个框架在单独的 Docker 容器中运行

### 指标说明

- **吞吐量 (RPS)**：每秒完成的成功请求数
- **延迟百分位数**：
  - **P50**：中位数延迟 - 50% 的请求更快
  - **P90**：90% 的请求在此时间内完成
  - **P95**：95% 的请求在此时间内完成（常见的 SLO 目标）
  - **P99**：99% 的请求在此时间内完成
- **内存效率**：相对于吞吐量的内存使用（每 RPS 的 KB 数）

## 贡献

欢迎贡献！本项目旨在提供公平、可复现的基准测试。

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交您的更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

### 添加新框架

1. 按照现有结构创建新目录
2. 实现标准 API 端点
3. 添加 Dockerfile 和 docker-compose.yml 以进行容器化
4. 更新基准测试脚本以包含新框架
5. 添加文档和结果

### 报告问题

如果您发现结果存在差异或有改进建议，请提交 issue，包含：
- 测试环境详情
- 使用的测试配置
- 可复现的步骤
- 预期结果与实际结果

## 许可证

本项目采用 MIT 许可证 - 详见 LICENSE 文件。

## 致谢

- 受到社区中类似基准测试项目的启发
- 感谢所有框架维护者（Axum、FastAPI 团队）
- 感谢 k6 团队提供的优秀基准测试工具

---

**如有问题或建议，请在 GitHub 上提交 issue。**
```

## 总结

1. 英文 README.md：在开头添加了语言切换入口（右上角），默认显示英文。
2. 中文 README.zh.md：完整中文版本，包含所有性能数据、表格和说明。

两个文件都包含：
- 右上角的语言切换链接
- 完整的性能对比数据
- 所有图表引用
- 详细的项目说明和使用指南

将这两个文件保存到项目根目录即可。在 GitHub 上，用户可以通过右上角的链接切换语言。