# Backend Benchmark Suite

A benchmarking project comparing web framework performance: Rust (Axum & Actix-web), Go, and Python (FastAPI). Includes standardized API endpoints, automated test scripts, and performance metrics for throughput, latency, and resource usage.

## Overview

Benchmark suite for web backends across languages and frameworks, using consistent endpoints and scenarios to produce reproducible results.

### Frameworks Tested

- Rust
  - Axum
  - Actix-web
- Go (net/http or popular frameworks like Gin/Fiber)
- Python
  - FastAPI

## Features

- Standardized API endpoints across implementations
- Automated benchmarking scripts
- Multiple test scenarios (hello world, JSON serialization, database queries, etc.)
- Performance metrics: throughput (req/s), latency (p50, p95, p99), memory usage
- Dockerized environments
- Reproducible results

## Project Structure

```
backend-benchmark/
├── README.md
├── .gitignore
├── benchmark/
│   ├── scripts/              # Benchmarking scripts
│   │   ├── run_all.sh        # Run all benchmarks
│   │   ├── benchmark.py      # Main benchmark script
│   │   └── results_parser.py # Parse and format results
│   └── config/               # Test configurations
│       └── benchmark_config.json
├── rust/
│   ├── axum/                 # Rust Axum implementation
│   │   ├── Cargo.toml
│   │   └── src/
│   │       └── main.rs
│   └── actix-web/            # Rust Actix-web implementation
│       ├── Cargo.toml
│       └── src/
│           └── main.rs
├── go/
│   ├── go.mod
│   ├── go.sum
│   └── main.go
├── python/
│   └── fastapi/
│       ├── requirements.txt
│       ├── main.py
│       └── Dockerfile
├── docker/
│   ├── Dockerfile.rust-axum
│   ├── Dockerfile.rust-actix
│   ├── Dockerfile.go
│   └── Dockerfile.fastapi
├── results/                  # Test results storage
│   └── README.md
├── docs/                     # Documentation
│   ├── methodology.md        # Benchmark methodology
│   └── results_analysis.md   # Results analysis
└── docker-compose.yml        # Docker compose for running all services
```

## Prerequisites

- Rust (latest stable)
- Go (latest)
- Python 3.9+
- Docker & Docker Compose (optional)
- Benchmark tools:
  - wrk or
  - k6 or
  - Apache Bench (ab) or
  - bombardier

## Installation

### Clone the repository

```bash
git clone https://github.com/yourusername/backend-benchmark.git
cd backend-benchmark
```

### Setup Rust frameworks

```bash
# Axum
cd rust/axum
cargo build --release

# Actix-web
cd ../actix-web
cargo build --release
```

### Setup Go

```bash
cd go
go mod download
go build -o server main.go
```

### Setup FastAPI

```bash
cd python/fastapi
pip install -r requirements.txt
```

## Usage

### Running Individual Services

**Rust - Axum:**
```bash
cd rust/axum
cargo run --release
# Server runs on http://localhost:8000
```

**Rust - Actix-web:**
```bash
cd rust/actix-web
cargo run --release
# Server runs on http://localhost:8001
```

**Go:**
```bash
cd go
./server
# Server runs on http://localhost:8002
```

**Python - FastAPI:**
```bash
cd python/fastapi
uvicorn main:app --host 0.0.0.0 --port 8003
# Server runs on http://localhost:8003
```

### Running Benchmarks

#### Using wrk

```bash
# Benchmark Axum
wrk -t12 -c400 -d30s http://localhost:8000/

# Benchmark Actix-web
wrk -t12 -c400 -d30s http://localhost:8001/

# Benchmark Go
wrk -t12 -c400 -d30s http://localhost:8002/

# Benchmark FastAPI
wrk -t12 -c400 -d30s http://localhost:8003/
```

#### Using Automated Scripts

```bash
cd benchmark/scripts
python benchmark.py --all
# This will run benchmarks against all services and generate reports
```

#### Using Docker Compose

```bash
docker-compose up -d
# Wait for all services to be ready
cd benchmark/scripts
python benchmark.py --all
```

## Benchmark Scenarios

### 1. Hello World Endpoint
Simple endpoint returning a text response.

### 2. JSON Serialization
Endpoint that returns a JSON object with multiple fields.

### 3. Route Parameter Handling
Endpoint accepting route parameters and returning processed data.

### 4. Query Parameter Handling
Endpoint processing query parameters.

### 5. Request Body Parsing
POST endpoint parsing JSON request body.

## Results

Results are stored in the `results/` directory with timestamped reports.

### Metrics Collected

- Requests per second (RPS)
- Latency distribution (p50, p95, p99)
- Memory usage
- CPU usage
- Error rate

### Example Results Format

```
Framework: Rust - Axum
Requests/sec: 150,000
Latency:
  - p50: 2.5ms
  - p95: 8.1ms
  - p99: 15.3ms
Memory: 45 MB
```

## Contributing

Contributions are welcome.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Adding New Frameworks

1. Create a new directory following the existing structure
2. Implement the standard API endpoints (see `docs/endpoints.md`)
3. Add Dockerfile if using Docker
4. Update benchmark scripts to include the new framework
5. Add documentation in `docs/`

## Testing Environment

- OS: Linux/Windows/macOS
- Hardware: [Specify your test environment]
- Benchmark Tool: wrk/k6/bombardier
- Test Duration: 30 seconds
- Concurrent Connections: 400
- Threads: 12

Note: Results may vary based on hardware, OS, and system load. We recommend running benchmarks in isolated, consistent environments.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by similar benchmarking projects in the community
- Thanks to all framework maintainers

## Links

- [Methodology Documentation](docs/methodology.md)
- [Results Analysis](docs/results_analysis.md)
- [Issue Tracker](https://github.com/yourusername/backend-benchmark/issues)

---

For questions or suggestions, please open an issue on GitHub.