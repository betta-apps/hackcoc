#!/usr/bin/env bash
# A static site's files fit one Worker on Cloudflare's free plan: at most
# 20,000 files and 25 MiB a file (docs/specs/static-on-cloudflare.md). Fails
# at 90% of either, so a site is moved or split before a deploy is refused.
# find -size with a c suffix counts bytes the same with GNU and BSD find.
#
#   scripts/static/limits.sh <dir>
set -euo pipefail
dir="${1:?usage: limits.sh <dir>}"
files="$(find "$dir" -type f ! -name _headers ! -name _redirects | wc -l | tr -d ' ')"
big="$(find "$dir" -type f -size +23592960c)"
[ "$files" -le 18000 ] || { echo "limits: $files files in $dir; a Worker takes 20,000" >&2; exit 1; }
[ -z "$big" ] || { echo "limits: over 22.5 MiB, and a Worker takes 25 MiB a file:" >&2; echo "$big" >&2; exit 1; }
echo "limits: $files files, none over 22.5 MiB"
