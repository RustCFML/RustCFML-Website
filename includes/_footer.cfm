<cfscript>
    // The published site runs as WebAssembly on a Cloudflare Worker. CF-Ray
    // ends in the three-letter code of the colo that served the request, so
    // the footer can name where you were served from when that header reaches
    // the cgi scope, and stay quiet when it does not (a local binary, or a
    // Worker host that does not populate cgi).
    edgeColo = "";
    try {
        ray = cgi.http_cf_ray;
        if ( len( ray ) && reFind( "-[A-Z]{3}$", ray ) ) {
            edgeColo = listLast( ray, "-" );
        }
    } catch ( any e ) {
        edgeColo = "";
    }
</cfscript>
<cfoutput>
</main>
<footer class="site-footer">
  <div class="wrap">
    <div class="footer-grid">
      <div class="footer-brand">
        <a class="brand" href="/">
          <img src="/assets/crab.png" alt="" width="40" height="40">
          <span class="brand-name">Rust<span class="brand-hi">CFML</span></span>
        </a>
        <p>A CFML engine written in Rust. One native binary, from behind a reverse proxy
           to a Cloudflare Worker, running the language you already know.</p>
        <div class="footer-badges">
          <a class="badge-link" href="#( application.repo )#/blob/main/LICENSE" rel="noopener">MIT licensed</a>
          <a class="badge-link" href="#( application.latest )#" rel="noopener">#( application.version )#</a>
          <span class="badge-link">Rust 1.75+</span>
        </div>
      </div>

      <div>
        <h4>Project</h4>
        <ul>
          <li><a href="/features">Features</a></li>
          <li><a href="/performance">Performance</a></li>
          <li><a href="/about">About &amp; aims</a></li>
          <li><a href="#( application.repo )#/blob/main/docs/status.md" rel="noopener">Implementation status</a></li>
          <li><a href="#( application.releases )#" rel="noopener">Releases</a></li>
        </ul>
      </div>

      <div>
        <h4>Documentation</h4>
        <ul>
          <li><a href="#( application.docsBlob )#getting-started.md" rel="noopener">Getting started</a></li>
          <li><a href="#( application.docsBlob )#web-server.md" rel="noopener">Web server</a></li>
          <li><a href="#( application.docsBlob )#configuration.md" rel="noopener">Configuration</a></li>
          <li><a href="#( application.docsBlob )#deployment.md" rel="noopener">Deployment</a></li>
          <li><a href="#( application.docsBlob )#known-issues.md" rel="noopener">Known issues</a></li>
        </ul>
      </div>

      <div>
        <h4>Community</h4>
        <ul>
          <li><a href="#( application.repo )#" rel="noopener">Source on GitHub</a></li>
          <li><a href="#( application.issues )#" rel="noopener">Issues</a></li>
          <li><a href="/community">Contributing</a></li>
          <li><a href="#( application.contribs )#" rel="noopener">Contributors</a></li>
          <li><a href="https://github.com/bdw429s/cfml-qoq-perf-tests" rel="noopener">Benchmark suite</a></li>
        </ul>
      </div>
    </div>

    <div class="footer-bar">
      <p>
        ColdFusion&reg; is a registered trademark of Adobe Inc. RustCFML is an independent
        open-source project and is not affiliated with or endorsed by Adobe.
      </p>
      <p class="footer-meta">
        Released under the MIT License, built by people and models
        this site is a #( application.version )# application, served by RustCFML itself,
        compiled to WebAssembly on a
        <a href="https://github.com/RustCFML/RustCFML-Cloudflare-worker" rel="noopener">Cloudflare&nbsp;Worker</a><cfif len( edgeColo )>, from&nbsp;#( encodeForHTML( edgeColo ) )#</cfif>.
      </p>
    </div>
  </div>
</footer>
<script src="/assets/site.js" defer></script>
</body>
</html>
</cfoutput>
