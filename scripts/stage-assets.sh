#!/bin/sh
# Stages everything Workers Static Assets should serve into public/.
#
# The URL space has to match the site: /assets/site.css must be public/assets/
# site.css, so the files are copied under public/ rather than pointing wrangler
# at assets/ directly. public/ is generated and gitignored.
#
# The CFML templates are NOT staged here: build.rs embeds them in the Worker.

set -e

HERE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$HERE"

rm -rf public
mkdir -p public

cp -R assets public/assets
for file in robots.txt sitemap.xml; do
    [ -f "$file" ] && cp "$file" public/
done

# The /try playground loads the browser engine from here. It is a 16 MB build
# artefact copied in from the engine repo, gitignored, so a fresh clone will
# not have it: warn rather than fail, since every other page works without it.
if [ ! -f public/assets/wasm/rustcfml_wasm_bg.wasm ]; then
    echo "stage-assets: warning — assets/wasm/ is missing, so /try will not run."
    echo "              Copy crates/wasm/pkg from the engine repo before deploying."
fi

find public -name '.DS_Store' -delete

echo "stage-assets: staged $(find public -type f | wc -l | tr -d ' ') files into public/"
