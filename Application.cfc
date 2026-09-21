component {

    this.name              = "RustCFMLSite";
    this.applicationTimeout = createTimeSpan( 1, 0, 0, 0 );

    // ---------------------------------------------------------------------
    // Everything the templates quote about the project, in one place.
    // A release bumps `version` and every download link, asset name and
    // changelog URL follows from it. Nothing here is a secret, so there is no
    // environment substitution: this is a brochure site for an open repo.
    // ---------------------------------------------------------------------
    this.version = "v0.685.5";
    this.repo    = "https://github.com/RustCFML/RustCFML";

    // Top navigation. `section` is what each page sets request.section to, so
    // the header can highlight itself without sniffing CGI.
    this.nav = [
          { label = "Try it",      href = "/try",         section = "try" }
        , { label = "Features",    href = "/features",    section = "features" }
        , { label = "Performance", href = "/performance", section = "performance" }
        , { label = "Docs",        href = "/docs",        section = "docs" }
        , { label = "Community",   href = "/community",   section = "community" }
        , { label = "Extensions",  href = "/extensions",  section = "extensions" }
        , { label = "About",       href = "/about",       section = "about" }
    ];
    // Download is deliberately not in the list above: the header renders it as
    // a button rather than a link, so it reads as the one thing to do.

    // Headline numbers on the home page. Kept honest: these are the figures
    // published in the project README, with their provenance stated on the
    // page that shows them.
    this.stats = [
          { value = "2–3.5×", label = "throughput vs Lucee 7" }
        , { value = "~60 MB", label = "memory under load"}
        , { value = "instant", label = "startup"}
    ];

    // The binary shapes RustCFML deploys as.
    this.deploy = [
          { name = "Web application", icon = "server", doc = "deployment.md##web-application",
            body = "One flag at a directory of .cfm files. Application.cfc lifecycle, sessions, rewriting and uploads included.",
            code = "rustcfml --serve ./webroot --production" }
        , { name = "Container", icon = "package", doc = "deployment.md##docker",
            body = "A multi-arch image on Chainguard Wolfi: about 36 MB, non-root, extension-aware, and it stops cleanly on docker stop.",
            code = "docker run -p 8500:8500 -v $PWD:/app ghcr.io/rustcfml/rustcfml" }
        , { name = "Edge / Cloudflare", icon = "globe", doc = "deployment.md##cloudflare-workers",
            body = "The same templates compiled to WebAssembly and shipped with wrangler. The worker host adds Hyperdrive datasources, sessions in KV and an application scope backed by a Durable Object.",
            code = "wrangler deploy",
            link = "https://github.com/RustCFML/RustCFML-Cloudflare-worker",
            linkText = "The worker host, and how to wire it up" }
        , { name = "Single-file app", icon = "cube", doc = "deployment.md##self-contained-web-binaries",
            body = "Your application and the engine compiled into one executable, shipped with no dependencies.",
            code = "rustcfml --build ./myapp --output myapp" }
        , { name = "CLI tool", icon = "terminal", doc = "deployment.md##cli-tools",
            body = "CFML as a scripting language: real binaries, shebang scripts and a REPL.",
            code = "rustcfml --build ./mytool -o mytool --mode cli" }
    ];

    // The six capability layers on the home-page hero object. `face` is what
    // the front and back of a band read, and repeating it is deliberate: it is
    // the label you should be able to catch from any angle. The two sides each
    // carry their own sub-heading, `edgeA` and `edgeB`, so a full turn of the
    // object spells out three things per layer rather than two. `detail` is the
    // line that appears underneath it. The argument the object makes is that
    // all six are in the one file, so there is nothing here to choose.
    this.layers = [
          { face = "Language"
          , edgeA = "Lucee compatible", edgeB = "Java shims"
          , detail = "Lucee compatible extended with core functions, broad Java class shims to cover most common use cases." }
        , { face = "Data"
          , edgeA = "Databases", edgeB = "Web services / APIs"
          , detail = "SQLite, MySQL, PostgreSQL and MSSQL with pooling and transactions, Query-of-Queries, S3 support, Web Sevices and MCP." }
        , { face = "Realtime"
          , edgeA = "WebSockets + MCP", edgeB = "Native threads"
          , detail = "WebSockets on the same port as HTTP with rooms, presence and auth, Cfthread on real OS threads. MCP Publish & Client" }
        , { face = "Observe"
          , edgeA = "Debugger + flamegraph", edgeB = "OTLP"
          , detail = "Inbuilt debugging and a threshold-gated sampling profiler, with OpenTelemetry traces, Prometheus RED metrics." }
        , { face = "Extend"
          , edgeA = "Native Rust .rcx", edgeB = "CFML libraries"
          , detail = "Drop an .rcx file in a directory and Rust functions arrive as ordinary built-ins, or link them statically. Over a hundred Java classes are shimmed." }
        , { face = "Deploy"
          , edgeA = "CLI or native binary", edgeB = "Server or edge"
          , detail = "Behind a reverse proxy, as a single-file application, as a CLI , or on a Cloudflare Worker through WebAssembly." }
    ];

    // Published .rcx extensions: Rust compiled against the engine's ABI, which
    // a stock binary loads at start-up. `repo` is a repository name under the
    // RustCFML organisation, not a full URL — onApplicationStart builds those.
    this.extensions = [
          { name = "Browser", icon = "globe", repo = "RustCFML-Extension-Browser", version = "v0.1.0"
          , blurb = "A real headless browser inside the engine. JavaScript executes, CSS lays out, and you get screenshots and PDFs back, with no Chrome, no Selenium and no JVM. Built on Obscura, an independent browser engine written in Rust."
          , note = "About 40 MB, because it carries V8 and a complete layout and paint engine. Needs the engine at v0.685.5 or newer." }
        , { name = "Typst", icon = "book", repo = "RustCFML-Extension-Typst", version = "v0.1.0"
          , blurb = "Document generation backed by Typst, the modern answer to LaTeX. A fluent Document() builder covers page setup, rich text, tables from a query, footnotes and a table of contents, or a designer owns a .typ template and CFML supplies only the data."
          , note = "A library rather than a subprocess: roughly 6 ms to compile a two-page invoice and 2 ms to export the PDF. Apache-2.0 throughout." }
    ];

    // Documentation index, mirroring the docs/ directory in the repository.
    this.docGroups = [
          { title = "Build & run", blurb = "From a downloaded binary to a running web app.", topics = [
                { name = "Getting Started", file = "getting-started.md", desc = "Prebuilt binaries, running files, REPL, shebang scripts, building from source" }
              , { name = "Web Server",      file = "web-server.md",      desc = "Serve mode, Application.cfc lifecycle, URL rewriting, distributed sessions" }
              , { name = "Configuration",   file = "configuration.md",   desc = ".cfconfig.json: datasources, mappings, mail, security, caches, env vars" }
              , { name = "Sessions",        file = "sessions.md",        desc = "The session scope, the CFID cookie, storage backends and expiry" }
          ] }
        , { title = "Data", blurb = "Queries, object storage and documents without a JVM.", topics = [
                { name = "Database",        file = "database.md",     desc = "queryExecute, datasources, cfqueryparam and engine specifics" }
              , { name = "Object Storage",  file = "s3.md",           desc = "S3, R2 and MinIO, via the S3* functions and transparent s3:// paths" }
              , { name = "Spreadsheets",    file = "spreadsheets.md", desc = "Native .xlsx read, edit and write, including charts and styling" }
          ] }
        , { title = "Concurrency & realtime", blurb = "Real threads, and sockets on the same port as HTTP.", topics = [
                { name = "Threading",   file = "threads.md",     desc = "cfthread on real OS threads: shared scopes, join, terminate, caveats" }
              , { name = "WebSockets",  file = "websockets.md",  desc = "Realtime channels, rooms, presence, auth, resumability and fan-out" }
              , { name = "MCP",         file = "mcp.md",         desc = "A CFC as an MCP server: tools, resources, prompts, and calling other servers" }
          ] }
        , { title = "Debug & observe", blurb = "FusionReactor-class tooling, zero-cost when switched off.", topics = [
                { name = "Debugging & observability", file = "debugging.md",       desc = "Debug footer, sampling profiler, OpenTelemetry traces and Prometheus metrics" }
              , { name = "Observability ops",         file = "observability-ops.md", desc = "Tail sampling, Collector to Tempo to Grafana, in one command" }
              , { name = "Performance",               file = "performance.md",     desc = "Benchmarks and production-mode caching" }
              , { name = "Profile-guided optimisation", file = "pgo.md",           desc = "How the shipped binaries are built, and why cargo build --release is not the same thing" }
              , { name = "Deployment",                file = "deployment.md",      desc = "Web app, Docker, CLI tools and Cloudflare Workers" }
          ] }
        , { title = "Extend & embed", blurb = "Grow the engine without waiting for a release.", topics = [
                { name = "Extensions",      file = "extensions.md",       desc = ".rcx files: precompiled Rust a stock binary loads at start-up" }
              , { name = "Native Modules",  file = "native-modules.md",   desc = "Statically link Rust built-ins into a self-contained binary" }
              , { name = "Java Shims",      file = "java-shims.md",       desc = "The 100+ shimmed Java classes for createObject, and where they stop" }
              , { name = "Embedding",       file = "embedding.md",        desc = "Use the CFML engine from your own Rust code" }
              , { name = "WebAssembly",     file = "wasm.md",             desc = "Compile to WASM, and Cloudflare Workers notes" }
          ] }
        , { title = "Reference", blurb = "How it is put together, and how much of it works.", topics = [
                { name = "Architecture",   file = "architecture.md",  desc = "Compilation pipeline and crate layout" }
              , { name = "Testing",        file = "testing.md",       desc = "Running the suites and writing tests that pass on Lucee too" }
              , { name = "Status",         file = "status.md",        desc = "Implementation status and remaining work" }
              , { name = "Known Issues",   file = "known-issues.md",  desc = "Documented gaps, silent no-ops and Lucee divergences" }
              , { name = "Engine Differences", file = "lucee-differences.md", desc = "The assertions that differ between engines, and the ones wrapped in isRustCFML()" }
          ] }
    ];

    // What the hero object claims, spelled out. Grouped to match the six
    // bands so the page and the object agree, and kept to things that are in
    // the binary you download rather than the roadmap.
    this.inbox = [
          { group = "Language & runtime", items = [
                "Full CFScript and 50+ tags"
              , "400+ built-in functions"
              , "Components, interfaces, closures"
              , "cfthread on real OS threads"
              , "100+ Java classes shimmed"
          ] }
        , { group = "Data", items = [
                "SQLite, MySQL, PostgreSQL, MSSQL"
              , "Pooling, cfqueryparam, transactions"
              , "Query-of-queries in pure Rust"
              , "S3, R2 and MinIO object storage"
              , "Native .xlsx read, edit and write"
          ] }
        , { group = "Web & realtime", items = [
                "Application.cfc lifecycle"
              , "Sessions: memory, Memcached, cluster, SQL"
              , "URL rewriting and file uploads"
              , "WebSockets and socket.io"
              , "cfhttp, cfmail, cfzip"
          ] }
        , { group = "Debug & observe", items = [
                "Classic CF debug footer"
              , "Threshold-gated sampling profiler"
              , "OpenTelemetry traces over OTLP"
              , "Prometheus RED metrics"
              , "CPU flamegraph and pprof output"
          ]
          , note = "The footer and the profiler are in every build. Traces, metrics and the flamegraph come from a build with the obs-otel and obs-pprof features." }
        , { group = "Extend", items = [
                ".rcx extensions, loaded at start-up"
              , "Statically linked native modules"
              , "Embed the engine in your own Rust"
              , "Custom tags and taglibs"
              , "CFWheels and Preside run on it"
          ] }
        , { group = "Ship", items = [
                "One binary, no installer"
              , "--production warm caching"
              , "Unix socket behind a proxy"
              , "Self-contained single-file apps"
              , "WebAssembly for Cloudflare Workers"
          ] }
    ];

    // Release assets, per platform. `unix` drives whether the chmod line shows.
    this.platforms = [
          { os = "macOS",   arch = "Apple Silicon", file = "rustcfml-macos-aarch64",   unix = true  }
        , { os = "Linux",   arch = "x86_64",        file = "rustcfml-linux-x86_64",    unix = true  }
        , { os = "Linux",   arch = "ARM64",         file = "rustcfml-linux-aarch64",   unix = true  }
        , { os = "Windows", arch = "x86_64",        file = "rustcfml-windows-x86_64.exe", unix = false }
    ];

    this.faq = [
          { q = "Is CFML not a dead language?"
          , a = "No. It is a maintained one. Lucee has carried an open-source engine for over a decade and ships on a current Java baseline; BoxLang added a modern JVM dialect with enterprise adoption in its first year; CFCamp and Into the Box still run every year. What died is the tag-soup reputation: most CFML written today is script, with closures, arrow functions, null coalescing and member methods. RustCFML adds a runtime." }
        , { q = "Is this ColdFusion?"
          , a = "No. CFML is the language; ColdFusion is Adobe's implementation of it. RustCFML is an independent, MIT-licensed engine that runs the same markup and script. ColdFusion is a registered trademark of Adobe Inc. and RustCFML is not affiliated with or endorsed by Adobe." }
        , { q = "Is there a JVM under the hood?"
          , a = "No. RustCFML is a native binary with its own compiler, bytecode and VM, so it starts instantly, sits at roughly a tenth of the memory of a warmed JVM engine, and compiles to WebAssembly, which is what lets the same templates run on a Cloudflare Worker. Java is handled by shims rather than a JVM: over a hundred classes, enough that frameworks like CFWheels and Preside run unchanged, though they are emulations, so expect differences at the edges." }
        , { q = "Will my Lucee application run on it?"
          , a = "Many do, unchanged, including applications on frameworks. CFWheels ships a RustCFML adapter upstream and Preside runs with no application changes, helped by broad Java shims for the classes CFML code reaches into. RustCFML targets cfdocs.org with Lucee as the primary compatibility reference, and every test in the suite runs against both engines. It is not a complete engine, though: no ORM, no SOAP/WSDL, no PDF, no LDAP, and image functions are partial. Check Known Issues before you commit to a migration." }
        , { q = "Why is there no administrator?"
          , a = "There never will be. Configuration is file-based through .cfconfig.json, with environment-variable substitution for secrets, so your settings live in version control and your deploy pipeline rather than in a web UI on the server." }
        , { q = "Is it production ready?"
          , a = "Yes. It is stable, it is fast, and it runs real applications. The core moves deliberately slowly, aiming to be an LTS-style engine rather than the fastest-moving thing in the ecosystem, and every change has to pass the suite on Lucee as well as here. It is not a complete engine, and the gaps are written down rather than left to be discovered: no ORM, no SOAP/WSDL, no PDF, no LDAP, and image functions are partial. Read Status and Known Issues first, so what is missing is a decision rather than a surprise." }
        , { q = "Why write a CFML engine in Rust?"
          , a = "For what Rust gives the engine (a run-anywhere single binary, real OS threads, memory safety in the interpreter itself, and a WebAssembly target) and for what it gives the people writing it. The Rust compiler rejects unsound code immediately and specifically, which is why AI coding agents converge on it, and this engine is largely AI-written. Fast, verifiable code underneath; readable, quick-to-write code on top." }
        , { q = "Can I use it from my own Rust project?"
          , a = "Yes. The engine is a Cargo workspace of focused crates and there is a documented embedding path for driving CFML from Rust. You can also extend a stock binary with .rcx native extensions rather than forking the engine." }
        , { q = "How is it maintained?"
          , a = "It began as a proof of what AI models could do, written almost entirely by AI with human research and direction, and is maintained as an open-source project under MIT. Pull requests are the preferred contribution route, and the bar is that a test must pass on Lucee." }
    ];

    function onApplicationStart() {
        application.version    = this.version;
        application.repo       = this.repo;
        application.nav        = this.nav;
        application.stats      = this.stats;
        application.deploy     = this.deploy;
        application.layers     = this.layers;
        application.inbox      = this.inbox;
        application.docGroups  = this.docGroups;
        application.platforms  = this.platforms;
        application.faq        = this.faq;

        // Each extension carries a repository name; the URLs follow from it.
        application.org = "https://github.com/RustCFML";
        application.extensions = this.extensions.map( function ( ext ) {
            ext.url     = application.org & "/" & ext.repo;
            ext.release = ext.url & "/releases/latest";
            return ext;
        } );

        // Derived once, at start-up, rather than concatenated on every page.
        var repo              = this.repo;
        application.releases  = repo & "/releases";
        application.latest    = repo & "/releases/latest";
        application.issues    = repo & "/issues";
        application.compare   = repo & "/compare";
        application.contribs  = repo & "/graphs/contributors";
        application.docsBlob  = repo & "/blob/main/docs/";
        application.download  = repo & "/releases/download/" & this.version & "/";
        application.demo       = "https://rustcfml.github.io/RustCFML/demo/";
        application.trycf       = "https://trycf.com/home";
        application.cfdocs     = "https://cfdocs.org";
        application.discord    = "https://discord.com";

        return true;
    }

    function onRequestStart( required string template ) {
        // ?reload on any page rebuilds the application scope, so a changed
        // Application.cfc can be picked up without restarting the server.
        if ( structKeyExists( url, "reload" ) ) {
            applicationStop();
            location( url = cgi.script_name, addToken = false );
        }

        // A page that forgets to say who it is should not crash the request;
        // it just gets a header with nothing highlighted and the default
        // description in the meta tags.
        if ( !structKeyExists( request, "section" ) ) {
            request.section = "home";
        }
        if ( !structKeyExists( request, "title" ) ) {
            request.title = "RustCFML";
        }
        if ( !structKeyExists( request, "desc" ) ) {
            request.desc = "A CFML interpreter written in Rust - a single, fast, run-anywhere binary with a tiny memory footprint.";
        }
        return true;
    }
}
