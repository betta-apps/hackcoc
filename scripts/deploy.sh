#!/usr/bin/env bash
# Deploys public/ to the Worker. .github/workflows/publish.yml runs it on
# master, from the production environment, the one place the Cloudflare token
# lives; then scripts/smoke.sh against https://hackcodeofconduct.org.
# Wrangler attaches the hostname only when no other DNS record holds it, so
# the first deploy follows deleting the tunnel's CNAME.
set -euo pipefail
cd "$(dirname "$0")/.."
npx wrangler deploy
