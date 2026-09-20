<cfscript>
request.section = "try";
request.title   = "Try it: RustCFML in your browser";
request.desc    = "Run CFML in your browser on the real RustCFML engine, compiled to WebAssembly. It is the same target that runs on a Cloudflare Worker.";

icons = new lib.Icons();
</cfscript>
<cfinclude template="includes/_head.cfm">
<cfinclude template="includes/_header.cfm">

<section class="page-hero">
  <div class="wrap">
    <cfoutput>
    <h1>The engine, running in this tab</h1>
    <p class="lead">
      RustCFML compiled to WebAssembly, executing in your browser. It is the same target that runs on a
      Cloudflare Worker.
    </p>
    </cfoutput>
  </div>
</section>

<section class="tight">
  <div class="wrap">
    <div class="try-bar">
      <div class="try-samples" id="try-samples"></div>
      <button class="btn btn-primary" id="try-run" type="button">Run</button>
    </div>

    <div class="try-grid">
      <div class="term">
        <div class="term-bar">
          <span class="dot"></span><span class="dot"></span><span class="dot"></span>
          <span class="term-name">scratch.cfm</span>
          <span class="term-hint">&#8984;&#8629; to run</span>
        </div>
        <textarea id="try-code" class="try-editor" spellcheck="false" aria-label="CFML source"></textarea>
      </div>

      <div class="term">
        <div class="term-bar">
          <span class="term-name">output</span>
          <span class="term-hint"><span id="try-timing"></span> engine <span id="try-version">&hellip;</span></span>
        </div>
        <pre class="term-body try-out"><code id="try-out">Press Run.</code></pre>
      </div>
    </div>

    <p class="small muted" style="margin-top:18px">
      The WebAssembly build is about 16&nbsp;MB and is fetched on your first Run, not on
      page load. It is the browser target, so there is no filesystem, no datasource and no
      web server in here. Those need
      <a href="/download">the binary</a>. For a scratchpad that can also run Lucee, Adobe
      and BoxLang side by side, the community has
      <cfoutput><a href="#( application.trycf )#" rel="noopener">TryCF</a></cfoutput>.
    </p>
  </div>
</section>

<section class="tint">
  <div class="wrap">
    <div class="grid grid-3">
      <cfoutput>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "globe" ) )#</div>
        <h3>The same build runs at the edge</h3>
        <p>What executed your code just now is the WebAssembly target. Put it on a Cloudflare Worker and it serves pages from every location Cloudflare has, with no server to keep alive.</p>
        <p><a class="card-more" href="/features##everywhere">What runs where</a></p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "download" ) )#</div>
        <h3>The binary does the rest</h3>
        <p>Templates, a datasource, sessions, uploads, real OS threads and WebSockets: the parts a browser sandbox cannot offer. One file, no installer.</p>
        <p><a class="card-more" href="/download">Download a binary</a></p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "book" ) )#</div>
        <h3>Then read the docs you know</h3>
        <p>The compatibility target is cfdocs.org with Lucee as the reference. Most of what you already know about CFML applies unchanged.</p>
        <p><a class="card-more" href="/docs">Documentation index</a></p>
      </div>
      </cfoutput>
    </div>
  </div>
</section>

<script src="/assets/try-examples.js" defer></script>
<script src="/assets/try.js" defer></script>

<cfinclude template="includes/_footer.cfm">
