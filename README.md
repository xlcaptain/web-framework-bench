
# Backend Benchmark Suite

A benchmarking project comparing web framework performance: Rust (Axum) and Python (FastAPI). Includes standardized API endpoints, automated test scripts, and performance metrics for throughput, latency, and resource usage.

## 🚀 Performance Summary

### Key Findings

**Rust (Axum) demonstrates significantly better performance than FastAPI across all metrics:**

- **44.6% higher throughput**: 123,715 RPS vs 85,536 RPS
- **2.5x faster average latency**: 12.64ms vs 32.16ms
- **2.6x better p95 latency**: 26.79ms vs 69.37ms
- **6x lower memory usage**: 202.1 MiB vs 1,244 MiB (1.215 GiB)
- **Zero error rate** for both frameworks under test load

![Performance Comparison](https://github.com/xlcaptain/web-framework-bench/blob/main/static/performance_comparison.png)

*Comprehensive performance metrics showing throughput, average latency, and p95 latency comparison*

### Detailed Performance Metrics

#### Throughput & Latency

| Metric | FastAPI | Rust (Axum) | Improvement |
|--------|---------|-------------|-------------|
| **Throughput (RPS)** | 85,536 | 123,715 | **1.45x** |
| **Average Latency** | 32.16 ms | 12.64 ms | **2.55x faster** |
| **P50 Latency** | 28.12 ms | 11.61 ms | **2.42x faster** |
| **P90 Latency** | 57.95 ms | 22.47 ms | **2.58x faster** |
| **P95 Latency** | 69.37 ms | 26.79 ms | **2.59x faster** |
| **Max Latency** | 278.81 ms | 238.91 ms | **1.17x faster** |
| **Error Rate** | 0.00% | 0.00% | Equal |

![Latency Percentiles](https://github.com/xlcaptain/web-framework-bench/blob/main/static/latency_percentiles.png)

*Latency distribution across percentiles (P50, P90, P95, P99) showing Rust consistently outperforms FastAPI*

#### Resource Efficiency

| Metric | FastAPI | Rust (Axum) | Efficiency Gain |
|--------|---------|-------------|-----------------|
| **Memory Usage** | 1,244 MiB | 202.1 MiB | **6.15x less** |
| **Process Count** | 100 | 33 | **3x fewer** |
| **Memory per RPS** | 14.5 KB/RPS | 1.63 KB/RPS | **8.9x more efficient** |
| **RPS per MiB** | 68.8 RPS/MiB | 612.3 RPS/MiB | **8.9x better** |

![Resource Comparison](https://github.com/xlcaptain/web-framework-bench/blob/main/static/resource_comparison.png)

*Resource usage comparison showing memory efficiency, process count, and memory-per-RPS metrics*

![Performance Improvement](https://github.com/xlcaptain/web-framework-bench/blob/main/static/performance_improvement.png)

*Performance improvement multipliers showing Rust's advantage across all metrics*

### Test Configuration

- **Test Duration**: 60 seconds
- **Virtual Users (VUs)**: 3,000
- **Total Requests**: 5.1M (FastAPI) / 7.4M (Rust)
- **Tool**: k6
- **Scenario**: Constant VUs (steady state)

### Performance Radar Analysis

![Performance Radar](https://github.com/xlcaptain/web-framework-bench/blob/main/static/performance_radar.png)

*Multi-dimensional performance comparison showing Rust's superior performance across throughput, latency, and efficiency metrics*

### Conclusion

Under the same load conditions (3,000 concurrent VUs for 60 seconds), **Rust (Axum) achieves:**
- **44.6% higher throughput** with **2.5x lower latency**
- **83.8% less memory consumption** (1.215 GiB → 202.1 MiB)
- **3x fewer processes**, reducing system overhead

These results demonstrate Rust's ability to deliver **higher performance with significantly lower resource consumption**, making it an excellent choice for high-throughput, resource-constrained environments.

---

## Overview

Benchmark suite for web backends across languages and frameworks, using consistent endpoints and scenarios to produce reproducible results.

### Frameworks Tested

- **Rust**
  - ✅ Axum (completed)
  - ⏳ Actix-web (planned)
- **Python**
  - ✅ FastAPI (completed)
- **Go** (planned)
  - ⏳ net/http or popular frameworks like Gin/Fiber

## Features

- Standardized API endpoints across implementations
- Automated benchmarking scripts using k6
- Multiple test scenarios (hello world, JSON serialization, database queries, etc.)
- Performance metrics: throughput (req/s), latency (p50, p95, p99), memory usage
- Dockerized environments for consistent testing
- Reproducible results with detailed metrics

## Project Structure

```
web-framework-bench/
├── README.md
├── benchmark/
│   └── k6/
│       ├── steady_vus.js        # Constant VUs test script
│       ├── ramp_vus.js          # Ramping VUs test script
│       └── rate_test.js         # Constant arrival rate test
├── rust/
│   ├── Cargo.toml
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── src/
│   │   ├── main.rs
│   │   └── lib.rs
│   ├── api/                      # API routes
│   ├── core/                     # Core functionality
│   └── service/                  # Business logic
├── python/
│   └── fastapi/
│       ├── main.py
│       ├── Dockerfile
│       ├── docker-compose.yml
│       └── pyproject.toml
└── [Performance Charts]
    ├── performance_comparison.png
    ├── latency_percentiles.png
    ├── resource_comparison.png
    ├── performance_improvement.png
    └── performance_radar.png
```

## Prerequisites

- Rust (latest stable) - for Axum implementation
- Python 3.9+ - for FastAPI implementation
- Docker & Docker Compose (recommended)
- k6 (for benchmarking)
  - Installation: `brew install k6` (macOS) or follow [k6 installation guide](https://k6.io/docs/getting-started/installation/)

## Installation

### Clone the repository

```bash
git clone https://github.com/yourusername/web-framework-bench.git
cd web-framework-bench
```

### Setup Rust (Axum)

```bash
cd rust
cargo build --release
```

### Setup FastAPI

```bash
cd python/fastapi
pip install -r requirements.txt
# or with uv
uv sync
```

### Using Docker (Recommended)

```bash
# Rust (Axum)
cd rust
docker-compose up -d

# FastAPI
cd python/fastapi
docker-compose up -d
```

## Usage

### Running Individual Services

**Rust - Axum:**
```bash
cd rust
cargo run --release
# Server runs on http://localhost:8080
```

**Python - FastAPI:**
```bash
cd python/fastapi
uvicorn main:app --host 0.0.0.0 --port 8000
# Server runs on http://localhost:8000
```

### Running Benchmarks

#### Using k6 (Recommended)

**Constant VUs Test (60 seconds, 3000 VUs):**
```bash
k6 run --vus 3000 --duration 60s benchmark/k6/steady_vus.js
```

**Fixed Iterations:**
```bash
k6 run --iterations=100000 --vus=3000 benchmark/k6/steady_vus.js
```

**Constant Arrival Rate (for latency comparison):**
```bash
# Set target RPS via environment variable
TARGET=http://localhost:8080 RPS=80000 k6 run benchmark/k6/rate_test.js
```

**RPS Sweep (to find saturation point):**
```bash
TARGET=http://localhost:8080 k6 run benchmark/k6/ramp_vus.js
```

#### Benchmark Scripts

```bash
# Run all benchmarks
cd benchmark
./k6_vus_ramp.sh    # Ramping VUs test
./k6_rate_sweep.sh  # Rate sweep test
```

## Benchmark Scenarios

### 1. Hello World Endpoint
Simple endpoint returning a text response - baseline performance test.

### 2. JSON Serialization
Endpoint that returns a JSON object with multiple fields - tests serialization performance.

### 3. Route Parameter Handling
Endpoint accepting route parameters and returning processed data.

### 4. Query Parameter Handling
Endpoint processing query parameters.

### 5. Request Body Parsing
POST endpoint parsing JSON request body.

## Results

### Performance Metrics Collected

- **Throughput**: Requests per second (RPS)
- **Latency Distribution**: 
  - Average latency
  - Percentiles: p50 (median), p90, p95, p99
  - Min/Max latency
- **Resource Usage**:
  - Memory consumption (MiB/GiB)
  - Process count
  - CPU usage (during test)
- **Reliability**:
  - Error rate
  - Failed requests count

### Test Results Summary

| Framework | Throughput | Avg Latency | P95 Latency | Memory | Error Rate |
|-----------|-----------|-------------|-------------|--------|------------|
| **Rust (Axum)** | 123,715 RPS | 12.64 ms | 26.79 ms | 202.1 MiB | 0.00% |
| **FastAPI** | 85,536 RPS | 32.16 ms | 69.37 ms | 1,244 MiB | 0.00% |

*Test conditions: 3,000 VUs, 60s duration*

### Complete Results Table

![Performance Table](https://github.com/xlcaptain/web-framework-bench/blob/main/static/performance_table.png)

*Comprehensive performance metrics table with all collected data points*

## Testing Environment

- **OS**: Ubuntu Linux
- **Hardware**: 
  - CPU: [Your CPU specs]
  - Memory: 125.4 GiB available
  - Network: [Your network configuration]
- **Benchmark Tool**: k6 (latest version)
- **Test Duration**: 60 seconds
- **Concurrent Users**: 3,000 VUs
- **Container Runtime**: Docker

**Note**: Results may vary based on hardware, OS, and system load. We recommend running benchmarks in isolated, consistent environments with similar hardware specifications.

## Methodology

### Test Approach

1. **Constant VUs Test**: Maintains 3,000 virtual users for 60 seconds to measure steady-state performance
2. **Resource Monitoring**: Docker stats collected during test execution
3. **Multiple Runs**: Tests run multiple times to ensure consistency
4. **Isolated Environment**: Each framework runs in separate Docker containers

### Metrics Explanation

- **Throughput (RPS)**: The number of successful requests completed per second
- **Latency Percentiles**: 
  - **P50**: Median latency - 50% of requests are faster
  - **P90**: 90% of requests complete within this time
  - **P95**: 95% of requests complete within this time (common SLO target)
  - **P99**: 99% of requests complete within this time
- **Memory Efficiency**: Memory usage relative to throughput (KB per RPS)

## Contributing

Contributions are welcome! This project aims to provide fair, reproducible benchmarks.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Adding New Frameworks

1. Create a new directory following the existing structure
2. Implement the standard API endpoints
3. Add Dockerfile and docker-compose.yml for containerization
4. Update benchmark scripts to include the new framework
5. Add documentation and results

### Reporting Issues

If you find discrepancies in results or have suggestions for improvement, please open an issue with:
- Test environment details
- Test configuration used
- Reproducible steps
- Expected vs actual results

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by similar benchmarking projects in the community
- Thanks to all framework maintainers (Axum, FastAPI teams)
- k6 team for the excellent benchmarking tool

---