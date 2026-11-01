#!/usr/bin/env bash
# The site answers as it did on jiji: the Code of Conduct at /, its assets, a
# missing page as a 404, the security contact, and the headers jiji's Caddy
# added. Locally (wrangler dev) unless SMOKE_URL names the live site, as
# publish.yml does after a deploy. CI and deps-factory both run this.
set -euo pipefail
cd "$(dirname "$0")/.."

url="${SMOKE_URL:-}"
if [ -z "$url" ]; then
  port=8787
  log="$(mktemp)"
  npx wrangler dev --port "$port" --ip 127.0.0.1 --show-interactive-dev-session=false >"$log" 2>&1 &
  dev=$!
  trap 'kill $dev 2>/dev/null || true; rm -f "$log"' EXIT
  url="http://127.0.0.1:$port"
  for _ in $(seq 60); do curl -sf -o /dev/null "$url/" && break; sleep 1; done
fi

fail() { echo "smoke: $1" >&2; [ -n "${log:-}" ] && tail -20 "$log" >&2; exit 1; }
status() { curl -s -o /dev/null -w '%{http_code}' "$url$1"; }
[ "$(status /)" = 200 ] || fail "/ didn't answer 200"
[ "$(status /robots.txt)" = 200 ] || fail "/robots.txt didn't answer 200"
css="$(cd public/assets && ls application.debug-*.css)"
[ "$(status "/assets/$css")" = 200 ] || fail "/assets/$css didn't answer 200"
[ "$(status /nope)" = 404 ] || fail "a missing page didn't answer 404"
[ "$(status /_headers)" = 404 ] || fail "_headers is served as a file"
curl -s "$url/" | grep "Hack Code of Conduct" >/dev/null || fail "/ is not the Code of Conduct"
curl -s "$url/.well-known/security.txt" | grep -q '^Contact: mailto:' || fail "security.txt has no contact"
head="$(curl -sI "$url/")"
for h in strict-transport-security x-content-type-options x-frame-options referrer-policy permissions-policy; do
  grep -qi "^$h:" <<< "$head" || fail "/ has no $h header"
done
echo "smoke: ok"
