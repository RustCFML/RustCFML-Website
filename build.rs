//! Walks the site for CFML templates and emits a `CFML_FILES` table that
//! `src/lib.rs` hands to `cfml_worker` as the Worker's virtual filesystem.
//!
//! Only `.cfm` and `.cfc` are embedded. Everything under `assets/` is served
//! by Workers Static Assets instead (see `scripts/stage-assets.sh`), because
//! `cfml_worker::handle_fetch` runs *every* file it resolves through the VM:
//! a stylesheet embedded here would be executed as a template, not served.

use std::env;
use std::fs;
use std::path::{Path, PathBuf};

/// Directories that never contain site templates.
const SKIP_DIRS: &[&str] = &[
    ".git",
    ".wrangler",
    "assets",
    "build",
    "node_modules",
    "public",
    "scripts",
    "src",
    "target",
];

fn main() {
    println!("cargo:rerun-if-changed=.");

    let out_dir = env::var("OUT_DIR").expect("OUT_DIR");
    let root = env::current_dir().expect("cwd");

    let mut entries: Vec<(String, PathBuf)> = Vec::new();
    walk(&root, &root, &mut entries);
    entries.sort_by(|a, b| a.0.cmp(&b.0));

    assert!(
        entries.iter().any(|(rel, _)| rel == "index.cfm"),
        "no index.cfm found in {}: build.rs must run from the site root",
        root.display()
    );

    let mut src = String::from("pub static CFML_FILES: &[(&str, &[u8])] = &[\n");
    for (rel, abs) in &entries {
        let abs = abs.to_string_lossy().replace('\\', "/");
        src.push_str(&format!("    ({rel:?}, include_bytes!({abs:?})),\n"));
    }
    src.push_str("];\n");

    fs::write(Path::new(&out_dir).join("embedded_files.rs"), src).expect("write embedded_files.rs");
}

fn walk(base: &Path, dir: &Path, out: &mut Vec<(String, PathBuf)>) {
    let Ok(rd) = fs::read_dir(dir) else { return };
    for entry in rd.flatten() {
        let path = entry.path();
        let name = entry.file_name().to_string_lossy().to_string();

        if path.is_dir() {
            if !SKIP_DIRS.contains(&name.as_str()) {
                walk(base, &path, out);
            }
        } else if matches!(
            path.extension().and_then(|e| e.to_str()),
            Some("cfm") | Some("cfc")
        ) {
            let rel = path
                .strip_prefix(base)
                .unwrap_or(&path)
                .to_string_lossy()
                .replace('\\', "/");
            out.push((rel, path));
        }
    }
}
