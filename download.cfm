<cfscript>
request.section = "download";
request.title   = "Download: get the binary";
request.desc    = "Download RustCFML as a single binary for macOS, Linux or Windows, run the interactive WASM demo in your browser, or build the latest main from source.";

icons = new lib.Icons();
</cfscript>
<cfinclude template="includes/_head.cfm">
<cfinclude template="includes/_header.cfm">

<section class="page-hero">
  <div class="wrap">
    <cfoutput>
    <h1>One file. No installer.</h1>
    <p class="lead">
      Release #( application.version )# carries a static binary per platform, plus the licence and the full
      third-party attribution for the roughly 560 crates linked into it. Download, make it
      executable, put it on your path.
    </p>
    </cfoutput>
    <div class="btn-row">
      <cfoutput>
      <a class="btn btn-primary btn-lg" href="#( application.latest )#" rel="noopener">#( icons.get( "download" ) )# Latest release</a>
      <a class="btn btn-secondary btn-lg" href="#( application.releases )#" rel="noopener">All releases and changelogs</a>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Platforms                                                             -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="section-head reveal">
      <h2>Pick yours</h2>
      <p class="lead">Static binaries, no runtime to install alongside. Windows builds are released too, though macOS and Linux are where the engine is developed and measured.</p>
    </div>

    <div class="grid grid-4">
      <cfoutput>
      <cfloop array="#application.platforms#" item="platform">
        <div class="card plat reveal">
          <span class="tag">binary</span>
          <h3>#( platform.os )#</h3>
          <div class="arch">#( platform.arch )#</div>
          <div class="term">
            <div class="term-bar"><span class="term-name">#( platform.file )#</span></div>
            <pre class="term-body"><code>curl -LO \
  #( application.download & platform.file )#
chmod +x #( platform.file )#
sudo mv #( platform.file )# /usr/local/bin/rustcfml

rustcfml --version</code></pre>
          </div>
          <div class="btn-row" style="margin-top:16px">
            <a class="btn btn-ghost btn-sm" href="#( application.download & platform.file )#" rel="noopener">Direct asset</a>
            <a class="btn btn-ghost btn-sm" href="#( application.releases )#" rel="noopener">Notes</a>
          </div>
        </div>
      </cfloop>
      </cfoutput>
    </div>

    <cfoutput>
    <div class="callout warn">
      <span class="ico">#( icons.get( "alert" ) )#</span>
      <p>
        <b>The first run may need a nudge on macOS.</b> Binaries downloaded from a release are
        quarantined by Gatekeeper, so a fresh download can be refused until you clear the
        attribute: <code class="inline">xattr -d com.apple.quarantine rustcfml</code>. Linux
        and Windows builds need nothing but the executable bit.
      </p>
    </div>
    </cfoutput>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Other ways in                                                         -->
<!-- ==================================================================== -->
<section class="tint">
  <div class="wrap">
    <div class="grid grid-3">
      <cfoutput>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "globe" ) )#</div>
        <h3>Run it in your browser</h3>
        <p>The engine compiled to WebAssembly: the real interpreter, in your tab. It is the same target that runs on a Cloudflare Worker, so it doubles as a preview of the edge build.</p>
        <p><a class="card-more" href="#( application.demo )#" rel="noopener">Open the WASM demo</a></p>
        <p><a class="card-more" href="#( application.trycf )#" rel="noopener">Or run a snippet on TryCF</a></p>
      </div>

      <div class="card reveal">
        <div class="card-ico">#( icons.get( "terminal" ) )#</div>
        <h3>From source</h3>
        <p>Rust stable 1.75 or newer. A Cargo workspace of focused crates, so you can build only what you need and read the pipeline in the order it runs.</p>
        <div class="term" style="margin-top:14px">
          <div class="term-bar"><span class="term-name">build</span></div>
<pre class="term-body"><code>git clone https://github.com/RustCFML/RustCFML.git
cd RustCFML
cargo build --release
cargo install --path crates/cli</code></pre>
        </div>
      </div>

      <div class="card reveal">
        <div class="card-ico">#( icons.get( "package" ) )#</div>
        <h3>Your own artifact</h3>
        <p>Compile an application and the engine into a single executable, so shipping means copying one file rather than provisioning a server.</p>
        <div class="term" style="margin-top:14px">
          <div class="term-bar"><span class="term-name">build</span></div>
<pre class="term-body"><code>rustcfml --build ./myapp --output myapp
## CLI mode instead of a server:
rustcfml --build ./mytool --mode cli --entry main.cfm</code></pre>
        </div>
      </div>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Verifying / what's inside                                             -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="split">
      <cfoutput>
      <div class="split-text">
        <h3>Check what you have, and what is in it</h3>
        <p>
          The binary can tell you its version, print the licences of every crate statically
          linked into it, and describe its own capabilities. That last one matters: it is a
          v0.x engine, and the project would rather you found out from a flag than from a
          stack trace.
        </p>
        <ul class="tick">
          <li><code class="inline">rustcfml --version</code> prints the exact build you are running</li>
          <li><code class="inline">rustcfml --licenses</code> lists MIT plus every third-party attribution</li>
          <li><code class="inline">rustcfml -r</code> opens a REPL, for trying things at a prompt</li>
          <li><code class="inline">rustcfml -c 'writeOutput( now() )'</code> runs one line, no file</li>
          <li>Shebang scripts: a <code class="inline">.cfm</code> file with a <code class="inline">##!/usr/bin/env rustcfml</code> line is an executable</li>
        </ul>
      </div>
      </cfoutput>

      <div class="term">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">shell</span></div>
<pre class="term-body"><code>$ rustcfml --version
<span class="tk-str">RustCFML v0.653.14</span>

$ rustcfml -r
<span class="tk-com"># a REPL over real CFML</span>
&gt; arrayNew( 5 ).map( ( i ) -&gt; i * i )
[ 1, 4, 9, 16, 25 ]
&gt; hashPassword( "hunter2", "argon2" )
$argon2id$v=19$m=65536,t=3,p=4$...

$ rustcfml ./script.cfm          <span class="tk-com"># one template</span>
$ rustcfml --code 'writeOutput( 6*7 )'</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Support                                                               -->
<!-- ==================================================================== -->
<section class="tint">
  <div class="wrap">
    <cfoutput>
    <div class="cta reveal">
      <h2>Something missing from your platform?</h2>
      <p>
        Building for another target, packaging it for a distribution, or wanting a Docker
        image before the official one lands, open an issue. Platform gaps are treated as
        bugs, and releases are frequent.
      </p>
      <div class="btn-row">
        <a class="btn btn-primary btn-lg" href="#( application.issues )#" rel="noopener">Open an issue</a>
        <a class="btn btn-secondary btn-lg" href="/docs">Read the docs</a>
        <a class="btn btn-ghost btn-lg" href="/community">How contributing works</a>
      </div>
    </div>
    </cfoutput>
  </div>
</section>

<cfinclude template="includes/_footer.cfm">
