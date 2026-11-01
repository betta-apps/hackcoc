#!/usr/bin/env bash
# What "green" means for the site: every local link and asset in public/
# resolves the way Cloudflare serves it, the files fit a Worker's limits, and
# wrangler can build the upload. CI (.github/workflows/ci.yml) and
# deps-factory both run this.
set -euo pipefail
cd "$(dirname "$0")/.."

python3 scripts/check-links.py public --known scripts/known-broken-links.txt \
  hackcodeofconduct.org www.hackcodeofconduct.org
scripts/limits.sh public
npx wrangler deploy --dry-run --outdir dist >/dev/null
echo "check: ok"
