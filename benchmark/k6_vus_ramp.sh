#!/usr/bin/env bash
set -u

RUST_SERVER="http://localhost:3000"
FASTAPI_SERVER="http://localhost:3030"
RESULT_DIR="benchmark/results"; mkdir -p "${RESULT_DIR}"

# 并发台阶（可用环境变量覆盖）
VUS_START="${VUS_START:-100}"
VUS_END="${VUS_END:-1200}"
VUS_STEP="${VUS_STEP:-100}"
RAMP="${RAMP:-10s}"   # 每个台阶从上一个目标爬升的时间
HOLD="${HOLD:-30s}"   # 每个台阶维持的时间

build_stages() {
  local start="$1" end="$2" step="$3" ramp="$4" hold="$5"
  local s="["
  local v="$start"
  while [ "$v" -le "$end" ]; do
    s="$s{\"duration\":\"$ramp\",\"target\":$v},"
    s="$s{\"duration\":\"$hold\",\"target\":$v},"
    v=$((v+step))
  done
  s="$s{\"duration\":\"$ramp\",\"target\":0}]"
  # 去掉可能的多余逗号（已经保证结构无尾逗号，这里仅防御）
  echo "$s" | sed 's/,]/]/'
}

STAGES_JSON="$(build_stages "$VUS_START" "$VUS_END" "$VUS_STEP" "$RAMP" "$HOLD")"

echo "=========================================="
echo "k6 ramping-vus 并发扫描（${VUS_START}→${VUS_END} step ${VUS_STEP}，hold=${HOLD})"
echo "Web 控制台：http://127.0.0.1:5665"
echo "=========================================="
echo ""

run_one() {
  local name="$1" base="$2"
  echo "目标: ${name} -> ${base}/api/users"
  K6_WEB_DASHBOARD=${K6_WEB_DASHBOARD:-true} \
  k6 run \
    -e TARGET_URL="${base}/api/users" \
    -e NAME="${name}_vus_${VUS_START}_${VUS_END}" \
    -e STAGES="${STAGES_JSON}" \
    benchmark/k6/ramp_vus.js
  echo ""
}

# 健康检查（可选）
curl -s "${RUST_SERVER}/api/health" >/dev/null || echo "WARN: Rust 健康检查失败"
curl -s "${FASTAPI_SERVER}/api/health" >/dev/null || echo "WARN: FastAPI 健康检查失败"

run_one "rust" "${RUST_SERVER}"
run_one "fastapi" "${FASTAPI_SERVER}"

echo "完成。JSON 摘要在 ${RESULT_DIR}/k6_summary_*.json"