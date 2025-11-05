import http from "k6/http";
import { check } from "k6";
import { textSummary } from "https://jslib.k6.io/k6-summary/0.0.4/index.js";

// 目标与参数（均可用 -e 覆盖）
const URL = __ENV.TARGET_URL || "http://localhost:3000/api/users";
const NAME = __ENV.NAME || "rate";
const RATE = Number(__ENV.RATE || "1000");            // 每 timeUnit 多少请求
const TIME_UNIT = __ENV.TIME_UNIT || "1s";            // "1s" 代表每秒 RATE 个请求
const DURATION = __ENV.DURATION || "30s";             // 压测时长
const VUS = Number(__ENV.VUS || "200");               // 预分配 VUs
const MAX_VUS = Number(__ENV.MAX_VUS || "2000");      // 最大 VUs

export const options = {
  scenarios: {
    constant_rate: {
      executor: "constant-arrival-rate",
      rate: RATE,
      timeUnit: TIME_UNIT,
      duration: DURATION,
      preAllocatedVUs: VUS,
      maxVUs: MAX_VUS,
      tags: { name: NAME },
    },
  },
  thresholds: JSON.parse(
    __ENV.THRESHOLDS ||
      '{"http_req_duration":["p(95)<2000","p(99)<5000"],"http_req_failed":["rate<0.001"]}'
  ),
};

export default function () {
  const res = http.get(URL, { tags: { name: NAME } });
  check(res, { "status 200": (r) => r.status === 200 });
}

export function handleSummary(data) {
  const ts = new Date().toISOString().replace(/[:.]/g, "-");
  const baseName = `${NAME}_${ts}`;
  return {
    [`benchmark/results/k6_summary_${baseName}.json`]: JSON.stringify(data, null, 2),
    stdout: textSummary(data, { indent: " ", enableColors: true }),
  };
}