<cfscript>
request.section = "about";
request.title   = "About: background, aims and architecture";
request.desc    = "Why RustCFML exists, what it refuses to become, how it is put together, and honest answers about compatibility with the CFML you already know.";

icons = new lib.Icons();
</cfscript>
<cfinclude template="includes/_head.cfm">
<cfinclude template="includes/_header.cfm">

<section class="page-hero">
  <div class="wrap">
    <cfoutput>
    <h1>A language runtime, rewritten once</h1>
    <p class="lead">
      CFML is still being written, still being maintained, and until recently had only JVM
      runtimes to run on. RustCFML is an attempt at the other option: the same language, a
      native binary, and documentation that says where it does not work.
    </p>
    </cfoutput>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Story                                                                 -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="split">
      <cfoutput>
      <div class="split-text">
        <h3>It began as a question about models</h3>
        <p>
          <a href="#( application.repo )#" rel="noopener">RustCFML</a> started as a proof of
          how capable AI models had become, begun by
          <a href="https://github.com/alexskinner" rel="noopener">Alex Skinner</a>. 
          The engine has been written almost entirely by AI, predominantly Claude Opus, with research and
          test synthesis assisted by local models.
        </p>
        <p>
          Rust was not an arbitrary choice of host language. Its compiler rejects unsound
          code immediately and specifically, which is what makes it a good substrate for
          AI-assisted work: a stochastic generator becomes something that converges, because
          every wrong turn comes back as an error a model can act on. CFML sits at the other end of the same idea: a powerful,
          forgiving language with one obvious way to do most things, which is why models emit
          it correctly and why people learn it quickly.
        </p>
        <p>
          There is a test suite
          that has to pass against Lucee, a compatibility target published in cfdocs, a
          licence that is genuinely permissive, and a written account of everything that does
          not work yet. 
        </p>

      </div>
      </cfoutput>

      <div class="term reveal">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">the pipeline</span></div>
<pre class="term-body"><code><span class="tk-com">// CFML source, all the way down to native code.</span>
.cfm / .cfc
  &rarr; tag preprocessor
  &rarr; CFScript
  &rarr; lexer
  &rarr; parser
  &rarr; AST
  &rarr; compiler
  &rarr; bytecode
  &rarr; VM  <span class="tk-com">( bytecode cached per template )</span>

<span class="tk-com">// A Cargo workspace of focused crates:</span>
cfml-common    cfml-compiler  cfml-codegen
cfml-vm        cfml-stdlib    cli
cfml-qoq       wasm</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Aims                                                                  -->
<!-- ==================================================================== -->
<section class="tint">
  <div class="wrap">
    <div class="section-head reveal">
      <h2>Five opinions, held deliberately</h2>
      <p class="lead">These are the reasons the engine is smaller than you might expect.</p>
    </div>

    <div class="grid grid-2">
      <cfoutput>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "shield" ) )#</div>
        <h3>A lean, stable core</h3>
        <p>Nothing gets added to the core that doesn't belong or is prone to constant churn in the wider ecosystem. Think of it as an LTS-style engine: reliability first, and already fast enough that speed is not the constraint.</p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "package" ) )#</div>
        <h3>Libraries over built-ins</h3>
        <p>Where a capability is better served by a library, it stays out of the core. What the engine does is make sure it is compatible enough to <em>run</em> those libraries.</p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "grid" ) )#</div>
        <h3>No administrator, ever</h3>
        <p>There is no web console and there never will be. Configuration is a file, <code class="inline">.cfconfig.json</code>, with environment-variable substitution for secrets, so your settings live in version control and your deploy pipeline.</p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "refresh" ) )#</div>
        <h3>Inspired by real apps</h3>
        <p>Features are driven by applications people are trying to run, and by modern deployment practice.</p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "info" ) )#</div>
        <h3>Honest about Java</h3>
        <p>There is no JVM under the hood, so the classes applications actually reach for are hand-written shims instead: over a hundred of them, across <code class="inline">java.lang</code>, <code class="inline">java.util</code>, <code class="inline">java.util.concurrent</code>, <code class="inline">java.security</code>, <code class="inline">java.text</code> and <code class="inline">java.time</code>, plus the third-party libraries frameworks depend on. Enough that CFWheels and Preside run without application changes. They are emulations rather than the JDK, though: the goal is to run the libraries, not to reimplement Java. Every gap is written down.</p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "check" ) )#</div>
        <h3>Compatible, verifiably</h3>
        <p>The target is cfdocs.org with Lucee as the reference implementation, and a suite that runs against both. Compatibility is something the project checks, not something it claims.</p>
      </div>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Architecture                                                          -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="section-head reveal">
      <h2>Where the speed comes from</h2>
      <p class="lead">A preprocessor, a compiler and a bytecode VM: the same shape every serious language runtime has, minus the host virtual machine underneath it.</p>
    </div>

    <cfoutput>
    <div class="pipeline reveal">
      <span>.cfm / .cfc</span><em>&rarr;</em>
      <span class="hi">tag preprocessor</span><em>&rarr;</em>
      <span>CFScript</span><em>&rarr;</em>
      <span>lexer</span><em>&rarr;</em>
      <span>parser</span><em>&rarr;</em>
      <span>AST</span><em>&rarr;</em>
      <span class="hi">compiler</span><em>&rarr;</em>
      <span>bytecode</span><em>&rarr;</em>
      <span class="hi">VM</span>
    </div>

    <div class="grid grid-3" style="margin-top:32px">
      <div class="card reveal">
        <span class="tag">crates/cfml-common</span>
        <h3>Shared ground</h3>
        <p>The types, scopes and utilities every other crate needs, so the parser and the VM never disagree about what a query is.</p>
      </div>
      <div class="card reveal">
        <span class="tag">crates/cfml-compiler</span>
        <h3>Front end</h3>
        <p>Tag preprocessing, lexing, parsing and AST construction. Fifty-plus tags become CFScript before anything is compiled.</p>
      </div>
      <div class="card reveal">
        <span class="tag">crates/cfml-codegen</span>
        <h3>To bytecode</h3>
        <p>AST to stack-based bytecode, cached per template so an unchanged file is never compiled a second time.</p>
      </div>
      <div class="card reveal">
        <span class="tag">crates/cfml-vm</span>
        <h3>Execution</h3>
        <p>The interpreter, the component model, threading and the async runtime that serves your requests.</p>
      </div>
      <div class="card reveal">
        <span class="tag">crates/cfml-stdlib</span>
        <h3>Four hundred functions</h3>
        <p>The built-in library: strings, dates, JSON, hashing, database, mail, HTTP, spreadsheets and images.</p>
      </div>
      <div class="card reveal">
        <span class="tag">crates/cfml-qoq</span>
        <h3>SQL for queries</h3>
        <p>Query-of-queries on a pure-Rust SQL engine, parallelised with rayon. No JDBC, no embedded Java database.</p>
      </div>
    </div>
    <p class="small muted" style="margin-top:22px">
      Deeper, including the memory model and the extension ABI:
      <a href="#( application.docsBlob )#architecture.md" rel="noopener">docs/architecture.md</a>.
    </p>
    </cfoutput>
  </div>
</section>

<!-- ==================================================================== -->
<!-- FAQ                                                                   -->
<!-- ==================================================================== -->
<section class="tint">
  <div class="wrap">
    <div class="section-head reveal">
      <h2>The ones that come up every time</h2>
    </div>

    <cfoutput>
    <cfloop array="#application.faq#" item="entry">
      <details class="faq-item reveal">
        <summary>#( entry.q )#</summary>
        <div class="faq-body"><p>#( entry.a )#</p></div>
      </details>
    </cfloop>
    </cfoutput>
  </div>
</section>

<!-- ==================================================================== -->
<!-- CTA                                                                   -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <cfoutput>
    <div class="cta reveal">
      <h2>Read the source, it is only Rust</h2>
      <p>
        Everything is in one repository: the interpreter, the documentation, the tests that
        run against Lucee, and the issue tracker where the hard decisions get made in public.
      </p>
      <div class="btn-row">
        <a class="btn btn-primary btn-lg" href="#( application.repo )#" rel="noopener">#( icons.get( "github" ) )# RustCFML on GitHub</a>
        <a class="btn btn-secondary btn-lg" href="/download">Download #( application.version )#</a>
        <a class="btn btn-ghost btn-lg" href="/features">See what it does</a>
      </div>
    </div>
    </cfoutput>
  </div>
</section>

<cfinclude template="includes/_footer.cfm">
