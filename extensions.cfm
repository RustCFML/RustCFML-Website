<cfscript>
request.section = "extensions";
request.title   = "Extensions: native Rust, dropped in a directory";
request.desc    = "Extensions for RustCFML, shipped as .rcx files: a headless browser and Typst document generation, plus how to build and publish your own.";

icons = new lib.Icons();
</cfscript>
<cfinclude template="includes/_head.cfm">
<cfinclude template="includes/_header.cfm">

<section class="page-hero">
  <div class="wrap">
    <cfoutput>
    <h1>The engine ends where you decide</h1>
    <p class="lead">
      An extension is Rust compiled against the engine's ABI and shipped as a single
      <code class="inline">.rcx</code> file. Drop it in a directory and its functions arrive
      as ordinary built-ins: no fork of the engine, no waiting for a release, and nothing to
      install on the host.
    </p>
    </cfoutput>
    <div class="btn-row">
      <cfoutput>
      <a class="btn btn-primary btn-lg" href="#( application.docsBlob )#extensions.md" rel="noopener">Write an extension</a>
      <a class="btn btn-secondary btn-lg" href="#( application.org )#" rel="noopener">Browse the organisation</a>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Published extensions                                                 -->
<!-- ==================================================================== -->
<section class="tint">
  <div class="wrap">
    <div class="section-head reveal">
      <h2>Published by the project</h2>
      <p class="lead">
        Maintained in the RustCFML organisation, built for every platform the engine runs
        on, and installed the same way.
      </p>
    </div>

    <div class="grid grid-2">
      <cfoutput>
      <cfloop array="#application.extensions#" item="ext">
        <div class="card reveal">
          <div class="card-ico">#( icons.get( ext.icon ) )#</div>
          <h3>#( encodeForHTML( ext.name ) )# <span class="tag">#( encodeForHTML( ext.version ) )#</span></h3>
          <p>#( encodeForHTML( ext.blurb ) )#</p>
          <p class="small muted">#( encodeForHTML( ext.note ) )#</p>
          <p style="margin:14px 0 0">
            <a class="card-more" href="#( ext.release )#" rel="noopener">Download for your platform</a>
          </p>
          <p style="margin:6px 0 0">
            <a class="card-more" href="#( ext.url )#" rel="noopener">Source and documentation</a>
          </p>
        </div>
      </cfloop>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Installing                                                           -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="split">
      <div class="split-text reveal">
        <h3>Installing one</h3>
        <p>
          Take the file for your platform from a release and install it. Each archive carries
          the library for one platform only, so the name tells you which you have.
        </p>
        <p>
          Installing with <code class="inline">--user</code> puts it alongside the engine for
          everything you run. The alternative is to drop the file in your application's
          <code class="inline">extensions/</code> directory and commit it, which keeps the
          dependency with the code that needs it.
        </p>
        <cfoutput>
        <p><a class="card-more" href="#( application.docsBlob )#extensions.md" rel="noopener">Loading, versions and troubleshooting</a></p>
        </cfoutput>
      </div>

      <div class="term reveal">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">install</span></div>
<pre class="term-body"><code><span class="tk-com"># One file, no build step, no host dependencies.</span>
$ rustcfml ext install typst-0.1.0-macos-aarch64.rcx --user
  <span class="ok">&#10003;</span> typst 0.1.0 installed

$ rustcfml ext list
  browser  0.1.0
  typst    0.1.0

<span class="tk-com">// document.cfm: now they are just functions.</span>
pdf = <span class="tk-fn">Document</span>().<span class="tk-fn">heading</span>( <span class="tk-str">"Invoice"</span> ).<span class="tk-fn">render</span>()</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Build your own                                                       -->
<!-- ==================================================================== -->
<section class="tint">
  <div class="wrap">
    <div class="split">
      <div class="split-text reveal">
        <h3>Write one, and have it listed here</h3>
        <p>
          Declaring an extension is one macro: name it, list the functions it exports, and
          build. Anything in the Rust ecosystem is then a CFML built-in away, which is how
          both extensions above exist without a line of them living in the engine.
        </p>
        <p>
          Community extensions are welcome on this page. Publish the <code class="inline">.rcx</code>
          files for each platform on a release, say which engine version you need, and open an
          issue on the website repository to have it added.
        </p>
        <cfoutput>
        <div class="btn-row">
          <a class="btn btn-secondary" href="#( application.docsBlob )#extensions.md" rel="noopener">The extension guide</a>
          <a class="btn btn-secondary" href="#( application.org )#/RustCFML-Website/issues" rel="noopener">Submit an extension</a>
        </div>
        </cfoutput>
      </div>

      <div class="term reveal">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">src/lib.rs</span></div>
<pre class="term-body"><code><span class="tk-com">// The whole declaration.</span>
<span class="tk-fn">module!</span> {
    name: <span class="tk-str">"match"</span>,
    version: <span class="tk-str">"0.1.0"</span>,
    bifs: { <span class="tk-str">"hammingDistance"</span> =&gt; hamming },
}</code></pre>
        <pre class="term-body term-out"><code>$ rustcfml ext build .
  <span class="ok">&#10003;</span> match-0.1.0-macos-aarch64.rcx</code></pre>
      </div>
    </div>
  </div>
</section>

<cfinclude template="includes/_footer.cfm">
