<cfscript>
request.section = "community";
request.title   = "Community & contributing";
request.desc    = "How contributing to RustCFML works: open an issue before a pull request, write a CFML test that passes on Lucee, and the projects this engine stands on.";

icons = new lib.Icons();
</cfscript>
<cfinclude template="includes/_head.cfm">
<cfinclude template="includes/_header.cfm">

<section class="page-hero">
  <div class="wrap">
    <cfoutput>
    <h1>Pull requests are welcome. Tests first.</h1>
    <p class="lead">
      RustCFML is MIT-licensed and developed in the open. The bar for a change is simple to
      state and hard to game: your test has to pass on Lucee. That single rule is what keeps a
      volunteer-built engine from drifting into a dialect.
    </p>
    </cfoutput>
    <div class="btn-row">
      <cfoutput>
      <a class="btn btn-primary btn-lg" href="#( application.issues )#" rel="noopener">Open an issue</a>
      <a class="btn btn-secondary btn-lg" href="#( application.repo )#/pulls" rel="noopener">Open pull requests</a>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Ground rules                                                          -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="section-head reveal">
      <h2>Four things worth knowing before you start</h2>
    </div>

    <div class="steps">
      <div class="step reveal">
        <h3>Open an issue before a pull request</h3>
        <p>Especially if you have not contributed here before. A minimal reproducible CFML snippet, what you expected and what actually happened is worth more than a diff. It turns a guess into a shared understanding of the bug.</p>
      </div>
      <div class="step reveal">
        <h3>The test is the contribution</h3>
        <p>The preferred fix is a CFML-based test that demonstrates the behaviour. Once the engine passes it, the fix is usually small, and the test is what stops the bug coming back in the next refactor.</p>
      </div>
      <div class="step reveal">
        <h3>It must pass on Lucee</h3>
        <p>Lucee is the reference implementation and <a href="https://cfdocs.org" rel="noopener">cfdocs.org</a> is the compatibility target. If your test does not pass on Lucee, it will not be accepted, with rare exceptions where Lucee allows something genuinely unreasonable.</p>
      </div>
      <div class="step reveal">
        <h3>The core stays lean</h3>
        <p>Features that churn in the wider ecosystem belong in libraries, and features that belong in your pipeline do not belong in a runtime. If a proposal is really a CI/CD feature, the answer will be a friendly no and a pointer to <code class="inline">.rcx</code> extensions.</p>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Writing a test                                                        -->
<!-- ==================================================================== -->
<section class="tint">
  <div class="wrap">
    <div class="split">
      <cfoutput>
      <div class="split-text">
        <h3>A test that reads like a bug report</h3>
        <p>
          Tests are written in CFML, which means anyone who can write a template can write a
          regression test, and the same suite is run against Lucee so compatibility is a
          measured claim rather than a badge. There is no test framework to install and
          nothing to learn: a small harness in the repository gives you
          <code class="inline">suiteBegin()</code>, <code class="inline">assert()</code>,
          <code class="inline">assertTrue()</code>, <code class="inline">assertFalse()</code>,
          <code class="inline">assertNull()</code>, <code class="inline">assertThrows()</code>
          and <code class="inline">suiteEnd()</code>, and the rest is ordinary CFML.
        </p>
        <ul class="tick">
          <li>Reproduce the gap first, in the smallest template that shows it</li>
          <li>Name it <code class="inline">tests/&lt;category&gt;/test_&lt;feature&gt;.cfm</code> and
              register it in <code class="inline">tests/runner.cfm</code> with
              <code class="inline">&lt;cf_runtest&gt;</code></li>
          <li>Run <code class="inline">cargo run -- tests/runner.cfm</code>, then the same
              runner against Lucee over HTTP</li>
          <li>Reference the cfdocs page if the function is documented there</li>
          <li>If you touched a dependency, regenerate the licence attribution</li>
        </ul>
        <p class="small muted">
          Full instructions in
          <a href="#( application.docsBlob )#testing.md" rel="noopener">docs/testing.md</a>.
        </p>
      </div>
      </cfoutput>

      <div class="term">
        <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">tests/stdlib/test_reduce_empty_array.cfm</span></div>
<pre class="term-body"><code><span class="tk-com">&lt;!--- reduce() over an empty array with no initial value
      should throw, not return an empty string.
      cfdocs.org/reduce &middot; measured on Lucee 7.1.0.204. ---&gt;</span>
&lt;<span class="tk-tag">cfscript</span>&gt;
<span class="tk-fn">suiteBegin</span>( <span class="tk-str">"stdlib: reduce over an empty array"</span> );

_nums = [ 1, 2, 3 ];

<span class="tk-fn">assertThrows</span>( <span class="tk-str">"no initial value on an empty array"</span>, <span class="tk-tag">function</span> () {
    <span class="tk-tag">return</span> [].<span class="tk-fn">reduce</span>( ( acc, n ) =&gt; acc + n );
} );

<span class="tk-com">// assert( label, actual, expected )</span>
<span class="tk-fn">assert</span>( <span class="tk-str">"an initial value comes back untouched"</span>
    , [].<span class="tk-fn">reduce</span>( ( acc, n ) =&gt; acc + n, 10 ), 10 );

<span class="tk-com">// And the happy path is unchanged.</span>
<span class="tk-fn">assert</span>( <span class="tk-str">"sums from an initial value"</span>
    , _nums.<span class="tk-fn">reduce</span>( ( acc, n ) =&gt; acc + n, 10 ), 16 );

<span class="tk-fn">suiteEnd</span>();
&lt;/<span class="tk-tag">cfscript</span>&gt;</code></pre>
      </div>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Other ways to help                                                    -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="section-head reveal">
      <h2>The engine is not the only thing that needs work</h2>
    </div>
    <div class="grid grid-4">
      <cfoutput>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "book" ) )#</div>
        <h3>Documentation</h3>
        <p>The docs live beside the code. A page that says exactly where a feature stops working saves the next person an afternoon, and needs no build step.</p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "alert" ) )#</div>
        <h3>Reproducible issues</h3>
        <p>The fastest issues to close are the ones with a twelve-line template, an expected result and an actual result. Divergences from Lucee are especially useful.</p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "branch" ) )#</div>
        <h3>Port an application</h3>
        <p>Take a real CFML application you own, run it on RustCFML, and report what broke. Migration reports are how compatibility gaps get prioritised.</p>
      </div>
      <div class="card reveal">
        <div class="card-ico">#( icons.get( "cpu" ) )#</div>
        <h3>Benchmarks</h3>
        <p>Numbers from someone else&rsquo;s machine are a hypothesis. Pull the benchmark suite, run it on your hardware and open an issue when you beat us.</p>
      </div>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- People                                                                -->
<!-- ==================================================================== -->
<section class="tint">
  <div class="wrap">
    <div class="split">
      <cfoutput>
      <div class="split-text">
        <h3>Who is in here</h3>
        <p>
          RustCFML started as one person&rsquo;s experiment in what models could build, and
          it is now an open repository with contributors filing issues, writing tests and
          sending patches. Avatars are generated from the GitHub contributor graph, so this
          list is never out of date.
        </p>
        <div class="btn-row">
          <a class="btn btn-secondary" href="#( application.contribs )#" rel="noopener">Contributor graph</a>
          <a class="btn btn-ghost" href="#( application.repo )#/discussions" rel="noopener">Discussions</a>
        </div>
      </div>
      </cfoutput>

      <cfoutput>
      <div class="card reveal" style="text-align:center">
        <a href="#( application.contribs )#" rel="noopener">
          <img src="https://contrib.rocks/image?repo=RustCFML/RustCFML" alt="RustCFML contributors" style="max-width:100%">
        </a>
        <p class="small muted" style="margin-top:16px">Avatars from the <a href="#( application.contribs )#" rel="noopener">GitHub contributor graph</a>, generated by contrib.rocks.</p>
      </div>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Inspiration                                                           -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <div class="section-head reveal">
      <h2>Three projects this would not exist without</h2>
      <p class="lead">None of their code is in this binary. All of their decisions are.</p>
    </div>
    <div class="grid grid-3">
      <cfoutput>
      <div class="card reveal">
        <span class="tag">Reference implementation</span>
        <h3><a href="https://github.com/lucee/Lucee" rel="noopener">Lucee</a></h3>
        <p>The open-source CFML engine in Java, and the compatibility target every test here is run against. Where behaviour is in doubt, Lucee decides.</p>
      </div>
      <div class="card reveal">
        <span class="tag">Contemporary</span>
        <h3><a href="https://github.com/ortus-boxlang/boxlang" rel="noopener">BoxLang</a></h3>
        <p>A modern CFML+ runtime on the JVM, and the honest second entry in the query-of-queries benchmark table.</p>
      </div>
      <div class="card reveal">
        <span class="tag">Architectural</span>
        <h3><a href="https://github.com/RustPython/RustPython" rel="noopener">RustPython</a></h3>
        <p>A Python interpreter in Rust, and the shape this project took: same language, new plumbing, no host VM.</p>
      </div>
      </cfoutput>
    </div>

    <cfoutput>
    <div class="callout">
      <span class="ico">#( icons.get( "info" ) )#</span>
      <p>
        ColdFusion&reg; is a
        registered trademark of Adobe Inc. RustCFML is an independent implementation, is not
        affiliated with or endorsed by Adobe, and ships no Adobe code.
      </p>
    </div>

    <div class="cta reveal" style="margin-top:32px">
      <h2>Start with an issue, not a fork</h2>
      <p>Tell us what you expected and what happened, with the smallest template that shows it. That is the contribution that starts everything else.</p>
      <div class="btn-row">
        <a class="btn btn-primary btn-lg" href="#( application.issues )#/new" rel="noopener">Open an issue</a>
        <a class="btn btn-secondary btn-lg" href="#( application.docsBlob )#testing.md" rel="noopener">How the tests work</a>
      </div>
    </div>
    </cfoutput>
  </div>
</section>

<cfinclude template="includes/_footer.cfm">
