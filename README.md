# RustCFML project website

A small brochure site for [RustCFML](https://github.com/RustCFML/RustCFML), written in
CFML and served by RustCFML itself. No build step, no framework, no generator: templates,
one stylesheet, one script, and a rewrite file.

## Run it

```bash
rustcfml --serve . --port 8517            # development, picks up edits as you save
rustcfml --serve . --production           # warm caches, restart to reload
```

Then open <http://localhost:8517>. Add `?reload` to any URL to rebuild the application
scope without restarting the server.

```bash
./tools/lint.py                            # hash/interpolation lint, must say "clean"
./tools/check.sh 8517                      # fetches every page and asserts it rendered
./tools/layout.sh 8517                     # headless Chrome: overflow, reveals, menu, theme
./tools/import-examples.py                 # re-port /try's examples from the engine repo
./tools/set-version.py                     # bump to GitHub's latest release
./tools/set-version.py --check             # exit 1 if the site is a release behind
```

All three should pass before committing. `lint.py` catches the mistakes specific to this
engine; the other two need a server running on the port you pass them. `layout.sh` needs
Chrome and needs to sit in the web root for the duration, so it copies itself in and out
again. It is the only reason `zz-render-probe.html` ever appears.

They have earned their place. Between them they found: a code sample interpolating its own
variable, an `href="#anchor"` that swallowed the rest of its page, inline SVG icons with no
intrinsic size filling a phone screen with orange, `1fr` grid tracks letting one long
`curl` URL make the whole page horizontally scrollable, and a reveal animation that left
content invisible with JavaScript switched off.

`layout.sh` also reports `CLIPPED`: a panel narrower than the content inside it. Page-level
overflow is only the loudest symptom of a fixed minimum in a flexible track. The quiet
version hides the end of a line and leaves the document measuring clean. That check found
seventeen page/width combinations at once, including a `--serve` command showing 213 of the
687 pixels it needed. Anything that is *meant* to scroll is listed in `MAY_CLIP` at the top
of `tools/layout.html`; everything else that clips is a bug.

## Deploying to Cloudflare Workers

The site runs at <https://rustcfml.org> as a Worker: the engine compiled to WebAssembly,
with the templates embedded in the binary and the stylesheet, scripts and images served
as static assets. The wiring follows the reference host,
[RustCFML-Cloudflare-worker](https://github.com/RustCFML/RustCFML-Cloudflare-worker).

```bash
npm install                                # postgres/mysql2 for the JSPI snippet, esbuild
rustup target add wasm32-unknown-unknown
wrangler deploy                            # runs scripts/stage-assets.sh, then worker-build
```

`wrangler dev` previews the same build locally. Neither needs a `rustcfml` binary: the
engine arrives as the `cfml-worker` crate, pinned by tag in `Cargo.toml`.

**Two halves, split deliberately.** `cfml_worker::handle_fetch` runs every file it
resolves through the CFML VM, so a stylesheet embedded alongside the templates would be
*executed* rather than served, and `#` in the CSS would be read as interpolation. So
`build.rs` embeds only `.cfm` and `.cfc`, and `scripts/stage-assets.sh` copies `assets/`,
`robots.txt` and `sitemap.xml` into a generated `public/` that Workers Static Assets
serves. A request matching a static file never invokes the Worker; everything else falls
through to it.

**`urlrewrite.xml` is not read by the Worker host.** Its rules are ported into `resolve`
in `src/lib.rs`: `/features` and `/features/` map to `features.cfm`, `Application.cfc`
and the `includes/`, `lib/`, `logs/` and `tools/` directories are refused, and anything
unresolvable renders `404.cfm` (which sets its own 404 status). Keep the two in step —
the native server reads the XML, the Worker reads the Rust.

**Before deploying,** put the engine's browser build in `assets/wasm/`. It is 16 MB, it
is gitignored, and `/try` is a dead page without it:

```bash
# in the engine repo
wasm-pack build crates/wasm --target web
cp -R crates/wasm/pkg/* /path/to/rustcfml-site/assets/wasm/
```

A single asset may be up to 25 MiB, so it is served as a static file like anything else.
Worth automating in CI against the engine's latest release rather than copying by hand.

## Layout

```
Application.cfc        project facts, nav, docs index, platforms, FAQ; one file to bump
                       (`this.version` drives every download link and asset name;
                       set it with tools/set-version.py, never by hand at release time)
urlrewrite.xml         /features -> features.cfm, plus the rule that hides the plumbing
index.cfm              home
features.cfm           capability tour, with code
performance.cfm        benchmarks and methodology
docs.cfm               an index of the repo's docs/ directory, plus recipes
download.cfm           per-platform binaries, WASM demo, build from source
community.cfm          how contributing works, and the projects this one stands on
about.cfm              background, aims, architecture, FAQ
404.cfm                rendered for a missing template, with a 404 status
includes/_head.cfm     <head>, theme bootstrap, meta
includes/_header.cfm   sticky nav, active state from request.section
includes/_footer.cfm   four-column footer, trademark note, closes the document
lib/Icons.cfc          the inline SVG icon set, so an icon is one call, not a paste
assets/site.css        the whole design system, both themes
assets/site.js         theme switch, mobile nav, copy buttons, reveals, star count
assets/crab.png        the mark: the project crab, trimmed and squared to 96px
assets/crab-mark.svg   the earlier line-drawn mark, kept but no longer referenced
tools/                 lint and smoke test (blocked from HTTP by urlrewrite.xml)
assets/wasm/           the engine's WASM build, gitignored; 16 MB, copied from the
                       engine repo's crates/wasm/pkg, powers /try
assets/try-examples.js generated by tools/import-examples.py; the demo's own
                       examples, ported verbatim rather than rewritten

Cargo.toml             the Cloudflare Worker crate; pins the cfml-worker engine version
build.rs               embeds every .cfm/.cfc into the Worker at build time
src/lib.rs             Worker entry: urlrewrite.xml's rules, in Rust
wrangler.toml          bindings, custom domain, static assets, build command
scripts/stage-assets.sh stages assets/ into public/ for Workers Static Assets
scripts/esbuild-wrapper.sh, jspi-patch.mjs, package.json
                       carried over verbatim from the reference worker host
```

Pages set `request.section`, `request.title` and `request.desc` at the top, include
`_head` and `_header`, write their markup, and include `_footer`. Nothing else is shared.

## Notes on writing for RustCFML

Two rules cost more time than everything else combined, because the engine does not behave
like a JVM CFML server here:

1. **There is no implicit output.** `#variable#` in markup is *literal text*; it renders
   as source rather than interpolating. Every interpolation must be inside
   `<cfoutput>`/`</cfoutput>`.
2. **Inside `<cfoutput>`, `#` always starts something.** `href="#pricing"` interpolates a
   variable called `pricing…`, and a code sample containing `#name#` quietly evaluates it.
   Literal hashes need `##`.

The house style this repo follows to stay safe: interpolate only with `#( … )#`, because the
opening `#(` must always be closed by `)#`, otherwise everything up to the next `)#` in the
file is swallowed and the parse error points somewhere else entirely. Code samples that
contain hashes live outside output blocks; if one has to sit inside, its hashes are doubled.
`tools/lint.py` enforces both rules, including the odd-hash-count case in tag attributes.

Two more things worth knowing, both measured rather than remembered:

* `onMissingTemplate` is not called for URLs that resolve to no file; the server answers
  those with its own 404 page. `404.cfm` is reached through `urlrewrite.xml`, and sets its
  own status so it is correct either way.
* `<cfinclude>` inside `<cfoutput>` works and does not duplicate output, so includes can
  wrap themselves in their own output block. That is why every include here starts with one.

## Refreshing the project facts

The numbers, links and release version live at the top of `Application.cfc`. To refresh
them from the repository:

```bash
curl -s https://api.github.com/repos/RustCFML/RustCFML/releases/latest | jq -r .tag_name
curl -s https://raw.githubusercontent.com/RustCFML/RustCFML/main/README.md | less
```

Bump `this.version`, and every download URL, changelog link and footer badge follows.
Benchmark figures come from the project README. If they change there, change them here,
and keep the methodology note that says where they came from.

## Design

Dark by default with a light theme on request, remembered in `localStorage` and applied
before first paint by a three-line inline script so the page cannot flash. One accent
colour, a rust-to-ember gradient, on a slate ground; Inter for prose, JetBrains Mono for
everything that is code. Everything is legible and navigable without JavaScript, so the
script only adds the theme button, the mobile menu, copy buttons and scroll reveals.

Three CSS habits keep it from breaking, all of them enforced by `layout.sh`:

* every grid track is `minmax(0, 1fr)`, never `1fr`, because an `auto` minimum lets one unwrapped
  URL widen the whole page past the width of the screen, and where the page cannot widen it
  starves the track next door instead. The hero was the one grid left on a bare `fr`: the
  install bar's `curl` URL is a single 869px token, so the text column claimed all 869 and
  the code window rendered at 159px. It read as a cramped sample; it was a starved track
* every inline SVG gets a size in CSS, because an SVG with only a `viewBox` has no
  intrinsic size and will take the width of whatever it is dropped into
* the nav collapses to a hamburger at 1060px, where six links and a button stop fitting,
  rather than at a rounder number that looks tidier in the stylesheet
* a fixed minimum width is opt-in, never global. `table` carries no `min-width`; the wide
  benchmark tables ask for one with `.table-wrap.wide`, so a three-column table in a
  half-width track keeps its last column instead of scrolling it out of sight
* code samples wrap (`pre-wrap` plus `break-word`) rather than scroll. A horizontal
  scrollbar inside a panel is invisible until you look for it, so a clipped line reads as
  broken rather than scrollable; wrapping cannot hide anything, and the copy buttons are
  unaffected because `innerText` reports required line breaks, never soft ones
* a grid of terminals reflows on the width a shell line needs (`420px`), not the width that
  suits cards. Three-up inside a padded CTA left each one about 34 characters wide


## Licence

Same as the project it documents: MIT. The wording about ColdFusion being Adobe's
trademark, and RustCFML not being affiliated with it, is kept in the footer of every page
and again on the About page.
