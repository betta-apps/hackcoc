# hackcodeofconduct.org

The Hack Code of Conduct, served by the Cloudflare Worker `hackcoc`. See
[README.md](README.md).

## Invariants: these hold after every change

1. **No code runs.** `wrangler.jsonc` has no `main` and no `run_worker_first`:
   static assets alone are free and unlimited, and a script would make every
   request billed.
2. **Only its own hostname.** `workers_dev` stays false, and the one route is
   hackcodeofconduct.org as a custom domain.
3. **The headers stay.** `public/_headers` keeps HSTS, nosniff,
   `X-Frame-Options`, `Referrer-Policy` and `Permissions-Policy`, and
   `public/.well-known/security.txt` stays (`scripts/smoke.sh` checks both).
4. **The Cloudflare token stays in the production environment**, named only
   by publish.yml's Deploy step. Pull requests check the site against
   `wrangler dev`, never Cloudflare.

## How to work

- `npm ci`, then `scripts/check.sh` and `scripts/smoke.sh` before pushing.
- Work on a branch and open a pull request; a push to `master` deploys.
