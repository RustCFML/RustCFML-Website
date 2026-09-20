<cfscript>
request.section = "performance";
request.title   = "Performance: benchmarks, methodology and production mode";
request.desc    = "RustCFML serves roughly 2 to 3.5 times the throughput of a warmed Lucee 7 at about a tenth of the memory. Here are the numbers, the methodology and the caveats.";

icons = new lib.Icons();
</cfscript>
<cfinclude template="includes/_head.cfm">
<cfinclude template="includes/_header.cfm">

<section class="page-hero">
  <div class="wrap">
    <cfoutput>
    <h1>Fast because it is native</h1>
    <p class="lead">
      Templates compile to bytecode and run on a VM written in Rust, cached per template,
      so a cold request costs the same as a warm one. There is no host VM to boot, no
      bytecode to warm and no garbage collector to tune. The whole engine, under load,
      fits in about sixty megabytes.
    </p>
    </cfoutput>
  </div>
</section>

<section class="tight">
  <div class="wrap">
    <div class="stats reveal">
      <cfoutput>
      <div class="stat"><b>2&ndash;3.5&times;</b><span>throughput vs Lucee 7</span><i>Apache Bench, 8s runs</i></div>
      <div class="stat"><b>~60 MB</b><span>resident under load</span><i>vs ~560 MB warmed</i></div>
      <div class="stat"><b>instant</b><span>cold start</span><i>vs roughly 15s for Lucee</i></div>
      <div class="stat"><b>25,855</b><span>req/s sustained</span><i>100 clients, keep-alive</i></div>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Hello World                                                           -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="section-head reveal">
      <h2>&ldquo;Hello World&rdquo;, one page, one machine</h2>
      <p class="lead">
        A single <code class="inline">.cfm</code> page in
        <code class="inline">--production</code> mode against a warmed Lucee&nbsp;7 on the
        same machine (Apple M-series), same page, Apache Bench, eight-second runs. Requests per
        second, higher is better.
      </p>
    </div>

    <div class="table-wrap wide reveal">
      <table>
        <caption>Requests per second, RustCFML and Lucee 7.0</caption>
        <thead>
          <tr>
            <th>Concurrency</th>
            <th class="num">RustCFML</th>
            <th class="num">Lucee 7.0</th>
            <th>Gap</th>
            <th class="num">RustCFML keep-alive</th>
            <th class="num">Lucee keep-alive</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><code class="inline">-c 1</code></td>
            <td class="num">1,908</td><td class="num">1,205</td>
            <td><span class="bar"><i style="width:57%"></i></span></td>
            <td class="num">3,118</td><td class="num">1,625</td>
          </tr>
          <tr>
            <td><code class="inline">-c 10</code></td>
            <td class="num">5,466</td><td class="num">2,648</td>
            <td><span class="bar"><i style="width:100%"></i></span></td>
            <td class="num">21,716</td><td class="num">8,125</td>
          </tr>
          <tr>
            <td><code class="inline">-c 50</code></td>
            <td class="num">6,983</td><td class="num">3,503</td>
            <td><span class="bar"><i style="width:99%"></i></span></td>
            <td class="num">25,833</td><td class="num">8,085</td>
          </tr>
          <tr>
            <td><code class="inline">-c 100</code></td>
            <td class="num">7,528</td><td class="num">3,107</td>
            <td><span class="bar"><i style="width:100%"></i></span></td>
            <td class="num">25,855</td><td class="num">7,419</td>
          </tr>
        </tbody>
      </table>
    </div>

    <cfoutput>
    <div class="callout brandline">
      <span class="ico">#( icons.get( "info" ) )#</span>
      <p>
        <b>Keep-alive is where the gap widens.</b> Both engines improve with persistent
        connections, but RustCFML keeps scaling: at one hundred concurrent clients it holds
        around 25,800 requests per second while Lucee falls back to roughly 7,400. If your
        traffic arrives through a reverse proxy with an upstream keep-alive pool, this is
        the column that describes your production traffic.
      </p>
    </div>
    </cfoutput>

    <div class="grid grid-2" style="margin-top:18px">
      <cfoutput>
      <div class="table-wrap reveal">
        <table>
          <caption>Footprint and start-up</caption>
          <thead><tr><th></th><th class="num">RustCFML</th><th class="num">Lucee 7.0</th></tr></thead>
          <tbody>
            <tr><td>Memory (RSS, under load)</td><td class="num">~60 MB</td><td class="num">~560 MB</td></tr>
            <tr><td>Time to first request</td><td class="num">instant</td><td class="num">~15 s</td></tr>
            <tr><td>Artifact</td><td class="num">1 binary</td><td class="num">JVM + runtime</td></tr>
          </tbody>
        </table>
      </div>

      <div class="table-wrap reveal">
        <table>
          <caption>Query-of-queries: 1M rows, ms (lower is better)</caption>
          <thead><tr><th>Engine</th><th class="num">Total</th><th class="num">Speedup</th></tr></thead>
          <tbody>
            <tr class="ours"><td>RustCFML</td><td class="num">1,116</td><td class="num">baseline</td></tr>
            <tr><td>BoxLang 1.14</td><td class="num">1,368</td><td class="num">1.23&times;</td></tr>
            <tr><td>Lucee 7.0.4</td><td class="num">7,884</td><td class="num">7.1&times;</td></tr>
          </tbody>
        </table>
      </div>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Why                                                                   -->
<!-- ==================================================================== -->
<section class="tint">
  <div class="wrap">
    <div class="section-head reveal">
      <h2>Built for performance</h2>
    </div>
    <div class="grid grid-4">
      <cfoutput>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "bolt" ) )#</div>
        <h3>Compile, then run</h3>
        <p>Tags are preprocessed to CFScript, then lexed, parsed and compiled to stack-based bytecode. The bytecode is cached per template, so the second request for a page runs no compiler at all.</p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "cpu" ) )#</div>
        <h3>No VM under the VM</h3>
        <p>There is no JVM, so no warm-up, no garbage-collection pauses and no container startup. The process is the runtime, and it is tens of megabytes.</p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "layers" ) )#</div>
        <h3>Warm caches in production mode</h3>
        <p><code class="inline">--production</code> caches the Application.cfc resolution, URL-to-file resolution and bytecode permanently instead of checking modification times per request. Worth 3&ndash;4&times;.</p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "database" ) )#</div>
        <h3>Parallel SQL in Rust</h3>
        <p>Query-of-queries is a real SQL engine in <code class="inline">crates/cfml-qoq</code>, parallelised across cores with rayon, not an embedded HSQLDB doing string work.</p>
      </div>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Methodology + how to reproduce                                        -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="split">
      <cfoutput>
      <div class="split-text">
        <h3>Performance testing</h3>
        <p>
          They are the project&rsquo;s own, published in the README, on one Apple M-series
          machine, on a page that does almost nothing. That makes them a good comparison of
          engine overhead and a poor predictor of your application, where the database is
          usually the floor. Treat them as a reason to benchmark your own workload, and
          nothing more.
        </p>
        <ul class="tick">
          <li>Page: a &ldquo;Hello World&rdquo; <code class="inline">.cfm</code>, served from a directory with an <code class="inline">Application.cfc</code></li>
          <li>RustCFML: <code class="inline">--serve --production</code>, current release</li>
          <li>Lucee: version 7.0, warmed before the run; the QoQ table uses 7.0.4</li>
          <li>Tool: Apache Bench, eight-second runs, median of five for the QoQ suite</li>
          <li>Shipped binaries are built with profile-guided optimisation (fat LTO plus profile data); the <code class="inline">cargo build --release</code> you run yourself is not, and will be slower</li>
          <li>Query-of-queries: the public <code class="inline">cfml-qoq-perf-tests</code> suite, 10 SELECTs over 1M in-memory rows</li>
        </ul>
        <p class="small muted">
          The QoQ figures were published against an earlier RustCFML (v0.112) and have not
          been restated since. The full write-up lives in
          <a href="#( application.docsBlob )#performance.md" rel="noopener">docs/performance.md</a>.
        </p>
      </div>
      </cfoutput>

      <div class="term">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">benchmark it yourself</span></div>
<pre class="term-body"><code><span class="tk-com"># 1. start the engine the way you would ship it</span>
rustcfml --serve ./webroot --production &amp;

<span class="tk-com"># 2. warm it, then measure</span>
ab -n 2000 -c 10  http://127.0.0.1:8500/index.cfm
ab -n 5000 -c 50 -k http://127.0.0.1:8500/index.cfm

<span class="tk-com"># 3. watch where the time actually goes</span>
rustcfml --serve ./webroot --production --profile=30

<span class="tk-com"># 4. compare a single template without the server at all</span>
rustcfml ./webroot/index.cfm</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Production mode detail                                                -->
<!-- ==================================================================== -->
<section class="tint">
  <div class="wrap">
    <div class="grid grid-2">
      <cfoutput>
      <div class="card reveal">
        <span class="tag">Production mode</span>
        <h3>What <code class="inline">--production</code> actually changes</h3>
        <p>
          Development mode checks that files have not changed on every request so edits are
          picked up instantly. Production mode caches three lookups permanently (the
          <code class="inline">Application.cfc</code> resolution, URL-to-file resolution and
          compiled bytecode) and drops the per-request <code class="inline">readdir</code>.
          You reload by restarting. It is also honoured as
          <code class="inline">RUSTCFML_PRODUCTION=1</code>.
        </p>
        <p class="small muted">
          Detail in <a href="#( application.docsBlob )#deployment.md" rel="noopener">Deployment</a>.
        </p>
      </div>

      <div class="card reveal">
        <span class="tag">Tuning flags</span>
        <h3>Small switches with real effects</h3>
        <div class="kv">
          <div><dt>--single-threaded</dt><dd>Lower memory and lower concurrency, for a tiny instance</dd></div>
          <div><dt>--socket</dt><dd>Bind a Unix socket beside your proxy; about 40% more throughput than TCP loopback at high concurrency</dd></div>
        </div>
        <div class="term" style="margin-top:14px">
          <div class="term-bar"><span class="term-name">nginx + unix socket</span></div>
<pre class="term-body"><code>upstream rustcfml {
    server unix:/run/rustcfml.sock;
    keepalive 32;
}</code></pre>
        </div>
      </div>
      </cfoutput>
    </div>

    <cfoutput>
    <div class="cta reveal" style="margin-top:36px">
      <h2>Benchmark it on your own workload</h2>
      <p>Grab the binary, point it at a real page and measure. If your numbers are worse than these, open an issue with the template. That is how the engine got faster.</p>
      <div class="btn-row">
        <a class="btn btn-primary btn-lg" href="/download">Download #( application.version )#</a>
        <a class="btn btn-secondary btn-lg" href="#( application.issues )#" rel="noopener">Report a regression</a>
      </div>
    </div>
    </cfoutput>
  </div>
</section>

<cfinclude template="includes/_footer.cfm">
