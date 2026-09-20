<cfscript>
request.section = "home";
request.title   = "An AI native development platform";
request.desc    = "A rapid development platform built by AI in Rust. Everything a modern application needs in one binary: databases, websockets, real threads, tracing and a profiler, deploying from a reverse proxy to a Cloudflare Worker.";

icons = new lib.Icons();
</cfscript>
<cfinclude template="includes/_head.cfm">
<cfinclude template="includes/_header.cfm">

<!-- ==================================================================== -->
<!-- Hero                                                                 -->
<!-- ==================================================================== -->
<section class="hero">
  <div class="wrap">
    <div class="hero-grid">
      <cfoutput>
      <div>
        <h1>Rapid development platform <span class="hi">built by AI</span></h1>
        <p class="lead">
          <span class="hi">The brief:</span> take the fastest way to build a web application and bring it completely
          up to date. The answer is an opinionated platform pairing CFML, which humans can easily understand with
          Rust, which agents verify and machines run at lightning speed with minimal footprint. 
        </p>
        <p class="lead">
          Everything a modern application needs is already included. Less to install and for an agent to get wrong.
        </p>

        <div class="btn-row">
          <a class="btn btn-primary btn-lg" href="/download">#( icons.get( "download" ) )# Download a binary</a>
          <a class="btn btn-secondary btn-lg" href="/try">Run it in your browser</a>
        </div>

        <div class="hero-badges">
          <a class="badge-link" href="#( application.repo )#/blob/main/LICENSE" rel="noopener">MIT License</a>
          <span class="badge-link">Linux &middot; macOS &middot; Windows &middot; Docker &middot; WebAssembly</span>
        </div>
      </div>
      </cfoutput>

      <cfoutput>
      <!-- The binary, as an object. Six capability bands on one prism, in CSS
           3D rather than a WebGL library: the labels stay real text, the page
           stays dependency-free, and the medium agrees with the message. -->
      <div class="mono" id="mono">
        <div class="mono-stage" id="monoStage">
          <div class="mono-obj" id="monoObj">
            <cfloop from="1" to="#( arrayLen( application.layers ) )#" index="i">
              <cfset layer = application.layers[ i ]>
              <button type="button" class="mono-band" style="--i:#( i - 1 )#"
                      data-face="#( encodeForHTMLAttribute( layer.face ) )#"
                      data-detail="#( encodeForHTMLAttribute( layer.detail ) )#"
                      aria-label="#( encodeForHTMLAttribute( layer.face & ". " & layer.edgeA & ", " & layer.edgeB & ". " & layer.detail ) )#">
                <span class="mf mf-fr" aria-hidden="true">#( encodeForHTML( layer.face ) )#</span>
                <span class="mf mf-bk" aria-hidden="true">#( encodeForHTML( layer.face ) )#</span>
                <span class="mf mf-lf" aria-hidden="true">#( encodeForHTML( layer.edgeA ) )#</span>
                <span class="mf mf-rt" aria-hidden="true">#( encodeForHTML( layer.edgeB ) )#</span>
              </button>
            </cfloop>
            <div class="mono-cap mono-cap-top" aria-hidden="true">
              <img class="mono-crab" src="/assets/crab.svg" alt="" width="1296" height="800">
              <span>rustcfml</span>
            </div>
            <div class="mono-cap mono-cap-bot" aria-hidden="true"></div>
          </div>
        </div>

        <div class="mono-read">
          <b id="monoTitle">One file</b>
          <p id="monoBody">Every layer above is already inside the binary you download. Extend capabilities with native Rust or .rcx extensions</p>
        </div>
      </div>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Headline numbers                                                     -->
<!-- ==================================================================== -->
<section class="tight">
  <div class="wrap">
    <div class="stats reveal">
      <cfoutput>
      <cfloop array="#application.stats#" item="stat">
        <div class="stat">
          <b>#( stat.value )#</b>
          <span>#( stat.label )#</span>
        </div>
      </cfloop>
      </cfoutput>
    </div>

  </div>
</section>

<!-- ==================================================================== -->
<!-- Deployment, including the edge                                       -->
<!-- ==================================================================== -->
<section class="tint">
  <div class="wrap">
    <div class="section-head reveal">
      <h2>5 ways to deploy including Cloudflare edge</h2>
    </div>

    <div class="deploy-ways reveal">
      <cfoutput>
      <cfloop array="#application.deploy#" item="shape">
        <a class="deploy-way" href="#( application.docsBlob & shape.doc )#" rel="noopener">
          <span class="deploy-ico">#( icons.get( shape.icon ) )#</span>
          <span class="deploy-name">#( shape.name )#</span>
        </a>
      </cfloop>
      </cfoutput>
    </div>

    <p class="small muted" style="margin-top:20px">
      The WASM target has its own limits: databases go through Hyperdrive, and some of
      the standard library is unavailable.
    </p>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Where this sits, and what built it                                   -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="section-head reveal">
      <h2>A second CFML runtime, written by AI</h2>
      <p class="lead">
        Lucee is the open-source CFML engine most people run, and it is the reference here:
        every test has to pass on Lucee first. BoxLang went the other way, onto the JVM. This
        is the CFML you already write with no virtual machine under it, in one binary that
        starts instantly and holds around 60&nbsp;MB under load. Where it runs short you write
        the missing piece in Rust: an <code class="inline">.rcx</code> file dropped in a
        directory arrives as an ordinary function, or compiles into the binary itself.
      </p>
      <p class="lead">
        Almost all of it was written by AI, which works better than it sounds. Rust will not
        compile the kind of code a generator gets wrong, and CFML is small enough to have one
        obvious way to do most things. Between them an agent gets to a right answer and stays
        there. You are reading a page it served.
      </p>
      <p><a class="card-more" href="/about">How it was built</a></p>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- MCP                                                                  -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="split">
      <div class="split-text reveal">
        <h3>A component is an MCP server</h3>
        <p>
          One CFC under <code class="inline">/mcp/</code> is a server that Claude Code, or any
          other agent runtime, can discover and call. It is served from the same process and
          port as your pages, or launched over stdio as a subprocess. No sidecar, no SDK, no
          second runtime to keep alive.
        </p>
        <p>
          Annotate a method with <code class="inline">tool=</code> and the JSON Schema is read
          off the CFML signature: types, defaults, which arguments are genuinely required, and
          descriptions from the doc comment. Results are shaped on the way out too, so a query
          arrives as an array of row objects rather than the
          <code class="inline">{COLUMNS, DATA}</code> envelope no MCP client understands.
        </p>
        <p>
          Resources, prompts, progress and logging over SSE are all there, and
          <code class="inline">secured</code> gates a tool on the same contract that gates a
          WebSocket handler. A tool can also call back:
          <code class="inline">mcp().sample()</code> borrows the client's own model, so no API
          key of yours is involved. In the other direction,
          <code class="inline">mcpConnect()</code> makes anyone else's MCP server callable from
          a page.
        </p>
        <cfoutput>
        <p><a class="card-more" href="#( application.docsBlob )#mcp.md" rel="noopener">Tools, resources and the client</a></p>
        </cfoutput>
      </div>

      <div class="term reveal">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">mcp/crm.cfc</span></div>
<pre class="term-body"><code><span class="tk-com">// One CFC under /mcp/ is one server. There is no other configuration.</span>
<span class="tk-tag">component</span> <span class="tk-att">mcp</span>=<span class="tk-str">"crm"</span> <span class="tk-att">description</span>=<span class="tk-str">"Deal lookups for agents"</span> {

    <span class="tk-com">/** @region.description Sales region to report on */</span>
    <span class="tk-tag">function</span> <span class="tk-fn">topDeals</span>( <span class="tk-tag">required string</span> region, <span class="tk-tag">numeric</span> limit = 10 )
        <span class="tk-att">tool</span>        = <span class="tk-str">"top_deals"</span>
        <span class="tk-att">description</span> = <span class="tk-str">"Highest value open deals in a region"</span>
        <span class="tk-att">readOnly</span>    = <span class="tk-tag">true</span>
    {
        <span class="tk-tag">return</span> <span class="tk-fn">queryExecute</span>(
              <span class="tk-str">"select name, value from deals where region = :region limit :limit"</span>
            , { region = arguments.region, limit = arguments.limit }
        );
    }
}</code></pre>
        <pre class="term-body term-out"><code>$ rustcfml --serve ./webroot   <span class="tk-com"># http://localhost:8500/mcp/crm</span>
$ rustcfml mcp crm ./webroot   <span class="tk-com"># …or over stdio, as a subprocess</span></code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Realtime                                                             -->
<!-- ==================================================================== -->
<section class="tint">
  <div class="wrap">
    <div class="split">
      <div class="split-text reveal">
        <h3>Realtime on the same port as your pages</h3>
        <p>
          No Node sidecar, no separate container, no broker to run. A component with a
          <code class="inline">socket</code> attribute is a channel, and the lifecycle
          methods are the whole API: rooms, presence, auth at the handshake,
          <code class="inline">lastEventId</code> resumability and multi-node fan-out.
          A return value from <code class="inline">onMessage</code> becomes the client's
          ack.
        </p>
        <p>
          Both transports are served: raw WebSocket and socket.io, so an existing
          socket.io client connects without changes. Underneath it, <code class="inline">cfthread</code>
          runs on real OS threads rather than a green-thread pool.
        </p>
        <cfoutput>
        <p><a class="card-more" href="#( application.docsBlob )#websockets.md" rel="noopener">Channels, rooms and fan-out</a></p>
        </cfoutput>
      </div>

      <div class="term reveal">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">websockets/chat.cfc</span></div>
<pre class="term-body"><code><span class="tk-com">// The whole channel. There is no other configuration.</span>
<span class="tk-tag">component</span> <span class="tk-att">socket</span>=<span class="tk-str">"/chat"</span> <span class="tk-att">encoding</span>=<span class="tk-str">"json"</span> {

    <span class="tk-tag">function</span> <span class="tk-fn">onConnect</span>( socket ) {
        socket.<span class="tk-fn">join</span>( <span class="tk-str">"lobby"</span> );
        socket.<span class="tk-fn">emit</span>( <span class="tk-str">"welcome"</span>, { id = socket.<span class="tk-fn">id</span>() } );
    }

    <span class="tk-tag">function</span> <span class="tk-fn">onMessage</span>( socket, message ) {
        <span class="tk-fn">io</span>().<span class="tk-fn">to</span>( <span class="tk-str">"lobby"</span> ).<span class="tk-fn">emit</span>( <span class="tk-str">"message"</span>, {
              from = socket.<span class="tk-fn">id</span>()
            , text = message.text
        } );
        <span class="tk-tag">return</span> { delivered = <span class="tk-tag">true</span> };   <span class="tk-com">// the client's ack</span>
    }
}</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Java                                                                 -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="split">
      <div class="split-text reveal">
        <h3>The Java you forgot you depended on</h3>
        <p>
          Applications reach into Java more than their authors remember: a
          <code class="inline">StringBuilder</code> in a loop, a
          <code class="inline">ConcurrentHashMap</code> behind a cache. There is no JVM here
          to answer them, so over a hundred classes are shimmed instead. There are enough
          of them that <strong>CFWheels</strong> configures itself from an adapter it ships
          upstream, and
          <strong>Preside</strong> runs with no application changes.
        </p>
        <cfoutput>
        <p><a class="card-more" href="#( application.docsBlob )#java-shims.md" rel="noopener">Every shimmed class, and where they stop</a></p>
        </cfoutput>
      </div>

      <div class="term reveal">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">legacy.cfm</span></div>
<pre class="term-body"><code><span class="tk-com">// The Java already in your codebase, unchanged.</span>
sb = <span class="tk-fn">createObject</span>( <span class="tk-str">"java"</span>, <span class="tk-str">"java.lang.StringBuilder"</span> ).<span class="tk-fn">init</span>();

<span class="tk-tag">for</span> ( row <span class="tk-tag">in</span> leads ) {
    sb.<span class="tk-fn">append</span>( row.region ).<span class="tk-fn">append</span>( <span class="tk-str">", "</span> );
}

id = <span class="tk-fn">createObject</span>( <span class="tk-str">"java"</span>, <span class="tk-str">"java.util.UUID"</span> )
         .<span class="tk-fn">randomUUID</span>().<span class="tk-fn">toString</span>();

<span class="tk-com">// A real pool, from the library you already know.</span>
pool = <span class="tk-fn">createObject</span>( <span class="tk-str">"java"</span>
     , <span class="tk-str">"java.util.concurrent.Executors"</span> )
         .<span class="tk-fn">newFixedThreadPool</span>( 4 );</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Extensions                                                           -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="split">
      <div class="split-text reveal">
        <h3>Drop to Rust for the hot path. Keep writing CFML.</h3>
        <p>
          Every high-level language needs an escape hatch, and the quality of that hatch
          decides how far the language gets. Declare your functions in one macro, build, and
          drop an <code class="inline">.rcx</code> file in a directory: a stock binary loads
          it at start-up and they arrive as ordinary built-ins.
        </p>
        <cfoutput>
        <p><a class="card-more" href="#( application.docsBlob )#extensions.md" rel="noopener">Writing an extension</a></p>
        </cfoutput>
      </div>

      <div class="term reveal">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">src/lib.rs</span></div>
<pre class="term-body"><code><span class="tk-com">// One macro is the whole declaration.</span>
<span class="tk-fn">module!</span> {
    name: <span class="tk-str">"match"</span>,
    version: <span class="tk-str">"0.1.0"</span>,
    bifs: { <span class="tk-str">"hammingDistance"</span> =&gt; hamming },
}

<span class="tk-tag">fn</span> <span class="tk-fn">hamming</span>&lt;<span class="tk-att">'a</span>&gt;( ctx: &amp;<span class="tk-att">'a</span> Ctx, args: &amp;[ Value&lt;<span class="tk-att">'a</span>&gt; ] )
    -&gt; Result&lt;Value&lt;<span class="tk-att">'a</span>&gt;&gt; { <span class="tk-com">/* … */</span> }</code></pre>
        <pre class="term-body term-out"><code>$ rustcfml ext build .
  <span class="ok">&#10003;</span> match-0.1.0-macos-aarch64.rcx

<span class="tk-com">// match.cfm: now it is just a function.</span>
score = hammingDistance( left, right )</code></pre>
      </div>
    </div>
  </div>
</section>


<!-- ==================================================================== -->
<!-- Observability                                                        -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="h2-row">
      <div class="section-head reveal">
        <h2>You can see inside it in production</h2>
        <p class="lead">
          Four layers of tooling, every one of them off until you ask, and costing
          nothing at all while it is off.
        </p>
      </div>
      <cfoutput><a class="btn btn-secondary" href="#( application.docsBlob )#debugging.md" rel="noopener">Debugging &amp; observability</a></cfoutput>
    </div>

    <div class="split">
      <div class="split-text reveal">
        <p>
          The classic debug footer is still there: queries, template times, exceptions
          and scopes, gated four ways so it never leaks to the public. Above it sits a
          threshold-gated <strong>sampling profiler</strong> in the FusionReactor mould,
          which only starts snapshotting a request's CFML call stack once that request
          has already run too long. A request that stays under the threshold costs one
          relaxed atomic load per line.
        </p>
        <p>
          Above that, <strong>OpenTelemetry</strong> traces over OTLP and Prometheus RED
          metrics, so a slow request in production lands in Tempo, Jaeger, Honeycomb or
          Datadog like anything else on your estate. Export runs on a background batch
          thread and never sits on the request path.
        </p>
        <p class="small muted">
          The footer and the profiler are in every build. Traces, metrics and the
          <code class="inline">--profile</code> flamegraph come from a build with the
          <code class="inline">obs-otel</code> and <code class="inline">obs-pprof</code>
          features, and neither is available in the WebAssembly target.
        </p>
      </div>

      <div class="reveal">
        <figure class="trace">
          <figcaption>One request, decomposed into spans</figcaption>
          <div class="trace-row">
            <span class="trace-name">GET /api/deals</span>
            <span class="trace-track"><i style="--o:0%;--w:100%"></i></span>
            <span class="trace-ms">42.1ms</span>
          </div>
          <div class="trace-row">
            <span class="trace-name">render api/deals.cfm</span>
            <span class="trace-track"><i style="--o:4%;--w:94%"></i></span>
            <span class="trace-ms">39.6ms</span>
          </div>
          <div class="trace-row">
            <span class="trace-name">DealReport.valueByRegion</span>
            <span class="trace-track"><i style="--o:10%;--w:76%"></i></span>
            <span class="trace-ms">32.0ms</span>
          </div>
          <div class="trace-row">
            <span class="trace-name">SELECT crm.leads</span>
            <span class="trace-track"><i class="db" style="--o:16%;--w:48%"></i></span>
            <span class="trace-ms">20.2ms</span>
          </div>
          <div class="trace-row">
            <span class="trace-name">SELECT crm.regions</span>
            <span class="trace-track"><i class="db" style="--o:66%;--w:18%"></i></span>
            <span class="trace-ms">7.6ms</span>
          </div>
        </figure>

        <div class="term" style="margin-top:16px">
          <div class="term-bar"><span class="term-name">command</span></div>
<pre class="term-body"><code><span class="tk-com"># RED metrics, scraped straight off the engine.</span>
$ curl -s localhost:8500/__rustcfml/metrics | head -3
rustcfml_http_requests_total{route="/api/deals"} 12841
rustcfml_http_request_duration_seconds_bucket{le="0.05"} 12604
rustcfml_db_query_duration_seconds_sum 41.907</code></pre>
        </div>
      </div>
    </div>
  </div>
</section>





<!-- ==================================================================== -->
<!-- ==================================================================== -->
<!-- CTA                                                                  -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <cfoutput>
    <div class="cta reveal">
      <h2>Run a page in the next two minutes</h2>
      <p>
        No trial, no account, no administrator to log into. Point one flag at a directory of
        templates and it serves them.
      </p>
      <div class="btn-row">
        <a class="btn btn-primary btn-lg" href="/download">Download #( application.version )#</a>
        <a class="btn btn-secondary btn-lg" href="/docs">Browse the docs</a>
        <a class="btn btn-ghost btn-lg" href="#( application.issues )#" rel="noopener">Ask a question</a>
      </div>
    </div>
    </cfoutput>
  </div>
</section>

<script src="/assets/monolith.js" defer></script>
<cfinclude template="includes/_footer.cfm">
