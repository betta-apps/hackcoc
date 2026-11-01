# The Hack Code of Conduct

See [hackcodeofconduct.org](https://hackcodeofconduct.org)

## Hosting

The site is plain files in `public/`, served straight from Cloudflare's edge
by the Worker `hackcoc` (`wrangler.jsonc`): static assets only, no code, so
it's free. `public/_headers` sets the security headers, and
`www.hackcodeofconduct.org` redirects to the bare domain with a Cloudflare
redirect rule.

A push to `master` runs `.github/workflows/publish.yml`: CI, then
`scripts/deploy.sh` (`wrangler deploy`), then `scripts/smoke.sh` against the
live site. `scripts/check.sh` checks every local link resolves and the files
fit a Worker's limits; `scripts/smoke.sh` runs the site under `wrangler dev`
and checks what it answers. Both need `npm ci` first.
