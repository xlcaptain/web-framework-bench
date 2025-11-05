#!/usr/bin/env bash
set -u

# 目标服务
RUST_SERVER="http://localhost:3000"
FASTAPI_SERVER="http://localhost:3030"

RESULT_DIR="benchmark/results"
mkdir -p "${RESULT_DIR}"

# 常量到达率参数（可通过环境变量覆盖）
TIME_UNIT="${TIME_UNIT:-1s}"         # 每秒为单位
DURATION="${DURATION:-30s}"          # 每档持续时长
VUS="${VUS:-200}"                    # 预分配 VUs（不够会扩到 MAX_VUS）
MAX_VUS="${MAX_VUS:-5000}"           # 最大 VUs（高目标 RPS 时适当调大）

# 目标吞吐列表（可通过 RATE_LIST 覆盖，逗号分隔）
RATE_LIST="${RATE_LIST:-1000,5000,10000,20000,50000}"

echo "=========================================="
echo "k6 固定到达率压测（constant-arrival-rate）+ Web 控制台"
echo "TIME_UNIT=${TIME_UNIT}  DURATION=${DURATION}  VUS=${VUS}  MAX_VUS=${MAX_VUS}"
echo "RATE_LIST=${RATE_LIST}"
echo "Web 控制台：http://127.0.0.1:5665"
echo "=========================================="
echo ""

run_one() {
  local name="$1"    # rust | fastapi
  local base_url="$2"
  local rate="$3"

  echo "目标: ${name} -> ${base_url}/api/users   RATE=${rate}/${TIME_UNIT}  DUR=${DURATION}"
  K6_WEB_DASHBOARD=${K6_WEB_DASHBOARD:-true} \
  k6 run \
    -e TARGET_URL="${base_url}/api/users" \
    -e NAME="${name}_rate_${rate}" \
    -e RATE="${rate}" \
    -e TIME_UNIT="${TIME_UNIT}" \
    -e DURATION="${DURATION}" \
    -e VUS="${VUS}" \
    -e MAX_VUS="${MAX_VUS}" \
    benchmark/k6/rate_test.js
  echo ""
}

# 健康检查（可选）
if ! curl -s "${RUST_SERVER}/api/health" > /dev/null; then
  echo "WARN: Rust 服务不可达：${RUST_SERVER}/api/health"
fi
if ! curl -s "${FASTAPI_SERVER}/api/health" > /dev/null; then
  echo "WARN: FastAPI 服务不可达：${FASTAPI_SERVER}/api/health"
fi

# 循环执行各个 RATE
IFS=',' read -r -a RATES <<< "${RATE_LIST}"

echo "----- Rust (constant-arrival-rate) -----"
for r in "${RATES[@]}"; do
  run_one "rust" "${RUST_SERVER}" "${r}"
done

echo "----- FastAPI (constant-arrival-rate) -----"
for r in "${RATES[@]}"; do
  run_one "fastapi" "${FASTAPI_SERVER}" "${r}"
done

echo "=========================================="
echo "完成。结果 JSON 在 ${RESULT_DIR}/k6_summary_*.json"
echo "Web 控制台（运行时可查看）默认 http://127.0.0.1:5665"
echo "=========================================="


k6 run -e TARGET_URL=http://localhost:3000/api/users \
       -e NAME=rust_rate_20000 \
       -e RATE=20000 -e TIME_UNIT=1s \
       -e DURATION=60s \
       -e VUS=500 -e MAX_VUS=5000 \
       benchmark/k6/rate_test.js