# rustcfml.org

The website for [RustCFML](https://github.com/RustCFML/RustCFML), written in CFML and
served by RustCFML itself — on a Cloudflare Worker, compiled to WebAssembly.

## Run it

```bash
rustcfml --serve . --port 8517
```

Then <http://localhost:8517>. Edits are picked up as you save; add `?reload` to any URL
after changing `Application.cfc`, which is cached in the application scope.

To run the deployed shape instead — the real Worker, in Cloudflare's runtime:

```bash
npm install
npx wrangler dev --port 8788 --local
```

That one recompiles the engine on every change, so it is for checking deployment
behaviour (clean URLs, static assets, redirects), not for writing content.

## Contributing

Pull requests are welcome. Fork, branch, open a PR against `main`.

Worth knowing before you write CFML here, because the engine is stricter than a JVM
one and both rules bite silently:

- **Nothing interpolates outside `<cfoutput>`.** `#variable#` in plain markup renders as
  literal text.
- **Inside `<cfoutput>`, `#` always starts something.** `href="#pricing"` is read as a
  variable. Literal hashes must be doubled: `##pricing`.

House style is to interpolate only as `#( … )#`, and to keep code samples containing
hashes outside output blocks.

Pages are flat: each one sets `request.section`, `request.title` and `request.desc`,
includes `_head` and `_header`, writes its markup, and includes `_footer`. Content that
is quoted in more than one place — nav, stats, FAQ, docs index — lives in
`Application.cfc`.

## Deploying

Pushing to `main` deploys. An hourly job also follows the engine's stable releases and
rebuilds when one lands.

One number drives the build: the `cfml-worker` tag in `Cargo.toml`. The Worker compiles
against it, `/try`'s browser engine is built from it, and `Application.cfc` quotes it, so
the three cannot drift apart.

Deploying needs two repository secrets, `CLOUDFLARE_API_TOKEN` (from the *Edit Cloudflare
Workers* template) and `CLOUDFLARE_ACCOUNT_ID`.

Two things that are less obvious than they look, if you touch the Worker:

- Only `.cfm` and `.cfc` are embedded in it. Everything under `assets/` is served by
  Workers Static Assets, because the engine runs *every* file it resolves through the VM —
  an embedded stylesheet would be executed rather than served.
- `urlrewrite.xml` is read by the native server only. The Worker has its own copy of those
  rules in `src/lib.rs`. Change one, change the other.

## Licence

MIT. ColdFusion is a registered trademark of Adobe Inc.; RustCFML is an independent
project and is not affiliated with or endorsed by Adobe.
