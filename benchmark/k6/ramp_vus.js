import http from "k6/http";
import { check } from "k6";

const URL = __ENV.TARGET_URL || "http://localhost:3000/api/users";
const NAME = __ENV.NAME || "vus_ramp";
const STAGES = __ENV.STAGES
  ? JSON.parse(__ENV.STAGES)
  : [
      { duration: "10s", target: 100 },
      { duration: "30s", target: 100 },
      { duration: "10s", target: 200 },
      { duration: "30s", target: 200 },
      { duration: "10s", target: 300 },
      { duration: "30s", target: 300 },
      { duration: "10s", target: 0 },
    ];

export const options = {
  scenarios: {
    ramp: {
      executor: "ramping-vus",
      startVUs: 0,
      stages: STAGES,
      gracefulRampDown: "0s",
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
  const m = data.metrics || {};
  const httpReqs = m.http_reqs?.count || 0;
  const p95_ms = m.http_req_duration?.values?.['p(95)'];
  const avg_ms = m.http_req_duration?.values?.avg;
  const secs =
    (data.state && (data.state.testRunDurationMs || data.state.testDurationMs)
      ? (data.state.testRunDurationMs || data.state.testDurationMs) / 1000
      : null);
  const rps = secs ? (httpReqs / secs) : undefined;
  const c_est_p95 = (rps && p95_ms) ? rps * (p95_ms / 1000) : undefined;
  const c_est_avg = (rps && avg_ms) ? rps * (avg_ms / 1000) : undefined;

  const ts = new Date().toISOString().replace(/[:.]/g, "-");
  const name = NAME;
  const outDir = "benchmark/results";

  const txt =
    `\n== Derived summary ==\n` +
    `Requests: ${httpReqs}\n` +
    (secs ? `Duration(s): ${secs}\n` : ``) +
    (rps ? `Throughput (RPS): ${rps.toFixed(2)}\n` : ``) +
    (avg_ms ? `avg latency: ${avg_ms.toFixed(3)} ms\n` : ``) +
    (p95_ms ? `p95 latency: ${p95_ms.toFixed(3)} ms\n` : ``) +
    (c_est_avg ? `Estimated concurrency (avg): ${c_est_avg.toFixed(2)}\n` : ``) +
    (c_est_p95 ? `Estimated concurrency (p95): ${c_est_p95.toFixed(2)}\n` : ``);

  return {
    [`${outDir}/k6_summary_${name}_${ts}.json`]: JSON.stringify(data, null, 2),
    stdout: txt,
  };
}