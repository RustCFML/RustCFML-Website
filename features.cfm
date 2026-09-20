<cfscript>
request.section = "features";
request.title   = "Features: what ships in the binary";
request.desc    = "The complete CFML language, 400+ built-in functions, a batteries-included web server, real OS threads, native WebSockets, observability and native extensions, all in one run-anywhere binary.";

icons = new lib.Icons();
</cfscript>
<cfinclude template="includes/_head.cfm">
<cfinclude template="includes/_header.cfm">

<section class="page-hero">
  <div class="wrap">
    <cfoutput>
    <h1>Everything in the file you downloaded</h1>
    <p class="lead">
      RustCFML is deliberately opinionated about what belongs in a language runtime: a
      lean, stable core, with the rest handled by libraries and by
      <a href="#( application.docsBlob )#extensions.md" rel="noopener">native extensions</a>.
      What is in the core is the part that applications cannot do without.
    </p>
    </cfoutput>
  </div>
</section>

<section class="tight">
  <div class="wrap">
    <cfoutput>
    <div class="hero-badges" style="margin:0 0 8px">
      <a class="badge-link" href="##language">Language</a>
      <a class="badge-link" href="##functions">Built-ins</a>
      <a class="badge-link" href="##web-server">Web server</a>
      <a class="badge-link" href="##data">Data</a>
      <a class="badge-link" href="##threads">Threads</a>
      <a class="badge-link" href="##sockets">WebSockets</a>
      <a class="badge-link" href="##observability">Observability</a>
      <a class="badge-link" href="##extending">Extensions</a>
      <a class="badge-link" href="##everywhere">Portability</a>
    </div>
    </cfoutput>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Language                                                              -->
<!-- ==================================================================== -->
<section id="language" class="anchor">
  <div class="wrap">
    <div class="split">
      <cfoutput>
      <div class="split-text">
        <h3>Script first. Tags when you want them.</h3>
        <p>
          Most CFML written today is script, and it reads like it. The tags are still there:
          a preprocessor turns fifty-plus of them into CFScript, and everything after that is
          one pipeline: lexer, parser, AST, bytecode, VM. The two syntaxes are not modes
          bolted onto each other; by the time it runs, they are the same program.
        </p>
        <ul class="tick">
          <li>Arrow functions, closures and first-class functions</li>
          <li><code class="inline">??</code>, <code class="inline">?:</code> and <code class="inline">?.</code> for null coalescing, elvis and safe navigation</li>
          <li>Member methods on arrays, structs, queries, lists and strings</li>
          <li>Higher-order <code class="inline">map()</code>, <code class="inline">filter()</code>, <code class="inline">reduce()</code>, <code class="inline">some()</code>, <code class="inline">every()</code></li>
          <li>Components with single inheritance, interfaces and implicit accessors</li>
          <li>Spread, <code class="inline">for &hellip; in</code>, <code class="inline">try</code>/<code class="inline">catch</code>/<code class="inline">finally</code> and rethrow</li>
          <li>And the tags: custom tags, tag files, and <code class="inline">.cfm</code> includes with their own output rules</li>
        </ul>
        <p class="small muted">
          Compilation pipeline and crate layout:
          <a href="#( application.docsBlob )#architecture.md" rel="noopener">Architecture</a>.
        </p>
      </div>
      </cfoutput>

      <div class="term">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">lib/Slack.cfc</span></div>
<pre class="term-body"><code>component implements="Notifier" accessors="true" {

    property name="webhook" type="string";

    function init( required string webhook ) {
        variables.webhook = arguments.webhook;
        return this;
    }

    // Arrow functions and chained member methods.
    public string function notifyAll( required array people, required string text ) {
        return arguments.people
            .filter( ( p ) =&gt; p.active ?: false )
            .map( ( p ) =&gt; "@#p.handle#" )
            .toList( " " ) &amp; " #text#";
    }

    private string function truncate( required string body ) {
        return arguments.body.len() &gt; 3000
             ? arguments.body.left( 2997 ) &amp; "..."
             : arguments.body;
    }
}</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Built-in functions                                                    -->
<!-- ==================================================================== -->
<section id="functions" class="anchor tint">
  <div class="wrap">
    <div class="split flip">
      <cfoutput>
      <div class="split-text">
        <h3>Four hundred of them, including the ones you would expect to install</h3>
        <p>
          Strings, arrays, structs, dates, maths, lists, queries, JSON, XML, regex,
          encoding and hashing, with the modern password algorithms included rather than
          left to a library. Where a built-in would duplicate something better served by a
          library, the project leaves it out and makes sure the engine can run the library.
        </p>
        <div class="kv">
          <div><dt>Password hashing</dt><dd>bcrypt, scrypt and argon2, with <code class="inline">hashPassword()</code> and <code class="inline">verifyPassword()</code></dd></div>
          <div><dt>Documents</dt><dd>Native <code class="inline">.xlsx</code> read, edit and write including charts, styling and formulas</dd></div>
          <div><dt>Images</dt><dd>Resize, scale, crop, rotate, flip and base64, in pure Rust, native and WASM</dd></div>
          <div><dt>Crypto</dt><dd>HMAC, AES via <code class="inline">encrypt()</code>, and every hash from MD5 to SHA-512</dd></div>
        </div>
        <p class="small muted">
          Partial surfaces and known divergences are listed under
          <a href="#( application.docsBlob )#known-issues.md" rel="noopener">Known Issues</a>.
        </p>
      </div>
      </cfoutput>

      <div class="term">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">register.cfm</span></div>
<pre class="term-body"><code>&lt;<span class="tk-tag">cfscript</span>&gt;
    hash   = <span class="tk-fn">hashPassword</span>( form.password, <span class="tk-str">"bcrypt"</span>)
    digest = <span class="tk-fn">hash</span>( form.email, <span class="tk-str">"SHA-256"</span> )
    token  = <span class="tk-fn">hmac</span>( digest, application.secret, <span class="tk-str">"SHA-256"</span> )

    payload = {
          id    = digest
        , roles = [ <span class="tk-str">"editor"</span>, <span class="tk-str">"reviewer"</span> ]
        , seen  = now()
    }
    body = <span class="tk-fn">serializeJSON</span>( payload )

    <span class="tk-com">// Structs behave like structs, including in the debugger.</span>
    payload.roles
        .map( ( r ) =&gt; uCase( r ) )
        .each( ( r ) =&gt; writeLog( r ) )
&lt;/<span class="tk-tag">cfscript</span>&gt;</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Web server                                                            -->
<!-- ==================================================================== -->
<section id="web-server" class="anchor">
  <div class="wrap">
    <div class="split">
      <cfoutput>
      <div class="split-text">
        <h3>The application you already wrote, served by one flag</h3>
        <p>
          <code class="inline">--serve</code> gives you a real web server: the
          <code class="inline">Application.cfc</code> lifecycle in the order you expect,
          sessions that can live in process, in Memcached or across a cluster, cookies,
          multipart uploads and Tuckey-compatible URL rewriting. This site is that feature
          working: a plain CFML application with includes and a rewrite file.
        </p>
        <ul class="tick">
          <li>Full hook set: <code class="inline">onApplicationStart</code> through <code class="inline">onSessionEnd</code>, plus <code class="inline">onError</code> and <code class="inline">onMissingTemplate</code></li>
          <li><code class="inline">urlrewrite.xml</code> with regex backreferences, conditions and <code class="inline">last="true"</code> chaining</li>
          <li>Session storage in process, Memcached or clustered, with <code class="inline">this.sessioncookie</code> control</li>
          <li>Datasources, mappings and mail from <code class="inline">.cfconfig.json</code>, with environment-variable substitution for secrets</li>
          <li>Optional sandbox: isolate the filesystem the engine can see, or embed files in the binary</li>
        </ul>
      </div>
      </cfoutput>

      <div class="term">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">urlrewrite.xml</span></div>
<pre class="term-body"><code>&lt;<span class="tk-tag">?xml</span> version=<span class="tk-str">"1.0"</span> encoding=<span class="tk-str">"utf-8"</span>?&gt;
&lt;<span class="tk-tag">urlrewrite</span>&gt;
  &lt;<span class="tk-tag">rule</span>&gt;
    &lt;<span class="tk-tag">from</span>&gt;^/([a-z][a-z0-9-]*)/?$&lt;/<span class="tk-tag">from</span>&gt;
    &lt;<span class="tk-tag">to</span> last=<span class="tk-str">"true"</span>&gt;/$1.cfm&lt;/<span class="tk-tag">to</span>&gt;
  &lt;/<span class="tk-tag">rule</span>&gt;
  &lt;<span class="tk-tag">rule</span>&gt;
    &lt;<span class="tk-tag">from</span>&gt;^/old-page$&lt;/<span class="tk-tag">from</span>&gt;
    &lt;<span class="tk-tag">to</span> type=<span class="tk-str">"permanent-redirect"</span>&gt;/new-page&lt;/<span class="tk-tag">to</span>&gt;
  &lt;/<span class="tk-tag">rule</span>&gt;
  &lt;<span class="tk-tag">rule</span>&gt;
    &lt;<span class="tk-tag">condition</span> type=<span class="tk-str">"method"</span>&gt;POST&lt;/<span class="tk-tag">condition</span>&gt;
    &lt;<span class="tk-tag">from</span>&gt;^/api/(.*)$&lt;/<span class="tk-tag">from</span>&gt;
    &lt;<span class="tk-tag">to</span>&gt;/api.cfm/$1&lt;/<span class="tk-tag">to</span>&gt;
  &lt;/<span class="tk-tag">rule</span>&gt;
&lt;/<span class="tk-tag">urlrewrite</span>&gt;</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Data                                                                  -->
<!-- ==================================================================== -->
<section id="data" class="anchor tint">
  <div class="wrap">
    <div class="split flip">
      <cfoutput>
      <div class="split-text">
        <h3>Four databases, object storage, and SQL over queries</h3>
        <p>
          <code class="inline">queryExecute</code> and <code class="inline">cfquery</code> run
          over SQLite, MySQL, PostgreSQL and MSSQL with connection pooling and
          <code class="inline">cftransaction</code>. Query-of-queries runs on a pure-Rust SQL
          engine parallelised across cores with rayon, with no JDBC and no HSQLDB in sight,
          which is why it leaves Lucee more than seven times behind on the standard
          benchmark suite.
        </p>
        <div class="kv">
          <div><dt>Engines</dt><dd>SQLite &middot; MySQL &middot; PostgreSQL &middot; MSSQL, configured per <code class="inline">.cfconfig.json</code></dd></div>
          <div><dt>Object storage</dt><dd>S3, R2 and MinIO, via the <code class="inline">S3*</code> functions and transparent <code class="inline">s3://</code> paths</dd></div>
          <div><dt>Query-of-queries</dt><dd>7.1&times; faster than Lucee 7.0.4 on a 1M-row in-memory table</dd></div>
          <div><dt>Also</dt><dd><code class="inline">cfhttp</code>, <code class="inline">cfmail</code>, and fluent <code class="inline">Spreadsheet()</code> builders</dd></div>
        </div>
      </div>
      </cfoutput>

      <div class="term">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">nightly.cfm</span></div>
<pre class="term-body"><code>&lt;<span class="tk-tag">cftransaction</span>&gt;
  &lt;<span class="tk-tag">cfquery</span> <span class="tk-att">datasource</span>=<span class="tk-str">"app"</span>&gt;
    UPDATE leads SET scored = 1
    WHERE  id = &lt;<span class="tk-tag">cfqueryparam</span> <span class="tk-att">value</span>=<span class="tk-str">"#row.id#"</span> <span class="tk-att">cfsqltype</span>=<span class="tk-str">"cf_sql_integer"</span>&gt;
  &lt;/<span class="tk-tag">cfquery</span>&gt;
&lt;/<span class="tk-tag">cftransaction</span>&gt;

<span class="tk-com">// No connection needed to ask a query a question.</span>
&lt;<span class="tk-tag">cfquery</span> <span class="tk-att">dbtype</span>=<span class="tk-str">"query"</span> <span class="tk-att">name</span>=<span class="tk-str">"hot"</span>&gt;
  SELECT region, count(*) AS n
  FROM   leads
  WHERE  scored = 1
  GROUP  BY region
  HAVING n &gt; 40
&lt;/<span class="tk-tag">cfquery</span>&gt;

<span class="tk-com">// And the artefact lands in object storage.</span>
<span class="tk-fn">fileWrite</span>( <span class="tk-str">"s3://reports/#dateFormat( now(), 'yyyymmdd' )#.csv"</span>, csv )</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Threads                                                               -->
<!-- ==================================================================== -->
<section id="threads" class="anchor">
  <div class="wrap">
    <div class="split">
      <cfoutput>
      <div class="split-text">
        <h3>Threads that are actually threads</h3>
        <p>
          A <code class="inline">cfthread</code> body runs concurrently on a real OS thread,
          on a separate core, not sequentially inline. <code class="inline">application</code>,
          <code class="inline">server</code>, <code class="inline">session</code> and
          <code class="inline">request</code> are shared live across them, which is what makes
          fan-out useful and <code class="inline">cflock</code> necessary.
        </p>
        <p>
          Two differences from Lucee are deliberate, and both come from doing threading
          safely in Rust: <code class="inline">terminate</code> is cooperative rather than
          forceful, because killing a thread mid-instruction can leave locks held; and a
          <code class="inline">cftransaction</code> cannot span the parent-to-child boundary,
          because its connection cannot be used from another thread.
        </p>
      </div>
      </cfoutput>

      <div class="term">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">fanout.cfm</span></div>
<pre class="term-body"><code>&lt;<span class="tk-tag">cfthread</span> <span class="tk-att">action</span>=<span class="tk-str">"spawn"</span> <span class="tk-att">name</span>=<span class="tk-str">"t#i#"</span> <span class="tk-att">tenant</span>=<span class="tk-str">"#tenant#"</span>&gt;
  &lt;<span class="tk-tag">cfset</span> <span class="tk-att">result</span> = runReport( attributes.tenant )&gt;
  &lt;<span class="tk-tag">cflock</span> <span class="tk-att">name</span>=<span class="tk-str">"reportCache"</span> <span class="tk-att">type</span>=<span class="tk-str">"exclusive"</span> <span class="tk-att">timeout</span>=<span class="tk-str">"5"</span>&gt;
    &lt;<span class="tk-tag">cfset</span> <span class="tk-att">application.cache</span>[ attributes.tenant ] = result&gt;
  &lt;/<span class="tk-tag">cflock</span>&gt;
&lt;/<span class="tk-tag">cfthread</span>&gt;

&lt;<span class="tk-tag">cfthread</span> <span class="tk-att">action</span>=<span class="tk-str">"join"</span> <span class="tk-att">jointimeout</span>=<span class="tk-str">"20"</span>&gt;
&lt;<span class="tk-tag">cfoutput</span>&gt;
  &lt;cfloop struct="#cfthread#" item="done"&gt;
    #done.name#: #done.status# in #done.elapsedtime# ms
  &lt;/cfloop&gt;
&lt;/<span class="tk-tag">cfoutput</span>&gt;</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- WebSockets                                                            -->
<!-- ==================================================================== -->
<section id="sockets" class="anchor tint">
  <div class="wrap">
    <div class="split flip">
      <cfoutput>
      <div class="split-text">
        <h3>WebSockets on the same port as your pages</h3>
        <p>
          One CFC per channel with lifecycle methods found by convention: authenticate on
          connect, subscribe to rooms, presence in and out, and
          <code class="inline">lastEventId</code> resumability so a reconnect does not lose
          what happened while the tab was closed. Fan-out works across nodes, and any
          template can emit with <code class="inline">wsPublish()</code>.
        </p>
        <ul class="tick">
          <li>Raw WebSocket transport and socket.io, both supported</li>
          <li>Rooms, presence, per-connection auth and ack-by-return</li>
          <li>An imperative, socket.io-compatible API via <code class="inline">new SocketIoServer()</code></li>
          <li>Live from a single binary, with no Redis adapter to stand up to get started</li>
        </ul>
      </div>
      </cfoutput>

      <div class="term">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">channels/RoomChannel.cfc</span></div>
<pre class="term-body"><code>component {

    // Checked before the socket is accepted.
    function onAuth( required string token ) {
        return accountService.verify( token );
    }

    function onSubscribe( required string room, required struct connection ) {
        return len( room );
    }

    function onMessage( required string room, required string body, required struct connection ) {
        wsPublish( room, { from = connection.id, text = body } )
        return { delivered = true };   <span class="tk-com">// ack-by-return</span>
    }

    function onPresence( required string kind, required string room ) {
        return kind;  <span class="tk-com">// "join" | "leave"</span>
    }
}</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Observability                                                         -->
<!-- ==================================================================== -->
<section id="observability" class="anchor">
  <div class="wrap">
    <div class="split">
      <cfoutput>
      <div class="split-text">
        <h3>Profiler tooling, zero-cost when switched off</h3>
        <p>
          All of it is off by default and costs nothing until you ask for it: a Lucee-style
          debug footer with queries, template times and scopes; a threshold-gated sampling
          profiler that only records the requests slow enough to be worth recording;
          OpenTelemetry traces over OTLP; Prometheus RED metrics; and a native CPU profiler
          behind a command-line flag.
        </p>
        <div class="kv">
          <div><dt>Per request</dt><dd><code class="inline">getDebugData()</code>, <code class="inline">isDebugMode()</code>, <code class="inline">debugAdd()</code></dd></div>
          <div><dt>Per slow request</dt><dd><code class="inline">profileNow()</code> and <code class="inline">getRequestProfile()</code></dd></div>
          <div><dt>Per process</dt><dd><code class="inline">--profile</code> for a flamegraph or pprof output</dd></div>
          <div><dt>Per fleet</dt><dd>OTLP to a collector, tail sampling, Tempo and Grafana</dd></div>
        </div>
      </div>
      </cfoutput>

      <div class="term">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">shell &amp; .cfconfig.json</span></div>
<pre class="term-body"><code># a flamegraph of the running binary
rustcfml --serve ./webroot --production --profile=30

# the baseline config, with secrets from the environment
{
  "datasources": {
    "app": {
      "type": "PostgreSQL",
      "host": "db.internal",
      "username": "{env:DB_USER}",
      "password": "{env:DB_PASSWORD}"
    }
  },
  "otlp": { "endpoint": "{env:OTEL_EXPORTER_OTLP_ENDPOINT}" }
}</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Extending                                                             -->
<!-- ==================================================================== -->
<section id="extending" class="anchor tint">
  <div class="wrap">
    <div class="grid grid-3">
      <cfoutput>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "package" ) )#</div>
        <span class="tag">.rcx extensions</span>
        <h3>Precompiled Rust, loaded at start-up</h3>
        <p>Drop a file in <code class="inline">extensions/</code> and a stock, unmodified binary gains new built-in functions and classes. That is how this site&rsquo;s sibling applications get a browser and a protocol monitor.</p>
        <p><a class="card-more" href="#( application.docsBlob )#extensions.md" rel="noopener">Extensions</a></p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "cube" ) )#</div>
        <span class="tag">Native modules</span>
        <h3>Statically linked into your binary</h3>
        <p>Building your own artifact? Link Rust built-ins and classes straight in, and ship one executable that contains the engine, your code and your extensions.</p>
        <p><a class="card-more" href="#( application.docsBlob )#native-modules.md" rel="noopener">Native modules</a></p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "layers" ) )#</div>
        <span class="tag">Embedding</span>
        <h3>CFML inside a Rust program</h3>
        <p>The engine is a workspace of focused crates. Use <code class="inline">cfml-compiler</code> and <code class="inline">cfml-vm</code> as libraries and expose a scripting layer to your own application.</p>
        <p><a class="card-more" href="#( application.docsBlob )#embedding.md" rel="noopener">Embedding</a></p>
      </div>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Portability                                                           -->
<!-- ==================================================================== -->
<section id="everywhere" class="anchor">
  <div class="wrap">
    <cfoutput>
    <div class="section-head center reveal">
      <h2>The same templates, everywhere you can put a binary</h2>
      <p class="lead">Static binaries for Linux and macOS, a Windows build, single-file applications, containers and a WebAssembly target that runs on Cloudflare Workers.</p>
    </div>


    <div class="cta reveal" style="margin-top:36px">
      <h2>Start with one page</h2>
      <p>Download a binary, save a <code class="inline">.cfm</code> file, and be serving in under two minutes. Nothing to install, nothing to administer.</p>
      <div class="btn-row">
        <a class="btn btn-primary btn-lg" href="/download">Download #( application.version )#</a>
        <a class="btn btn-secondary btn-lg" href="/docs">Documentation index</a>
      </div>
    </div>
    </cfoutput>
  </div>
</section>

<cfinclude template="includes/_footer.cfm">
