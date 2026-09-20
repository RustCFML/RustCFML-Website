<cfscript>
request.section = "docs";
request.title   = "Documentation: guides, reference and recipes";
request.desc    = "Everything written about RustCFML, grouped the way the docs directory is grouped: build and run, data, concurrency, observability, extending the engine and reference.";

icons = new lib.Icons();
</cfscript>
<cfinclude template="includes/_head.cfm">
<cfinclude template="includes/_header.cfm">

<section class="page-hero">
  <div class="wrap">
    <cfoutput>
    <h1>The documentation is in the repository</h1>
    <p class="lead">
      Twenty-six files live in <code class="inline">docs/</code>, versioned with the code
      they describe and reviewed in the same pull requests that change the behaviour. This
      page indexes the twenty-four that answer questions people actually ask. The rest are
      internal engineering notes, and the whole set is one click from
      <a href="#( application.repo )#/tree/main/docs" rel="noopener">the repository</a>.
    </p>
    </cfoutput>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Sixty-second start                                                    -->
<!-- ==================================================================== -->
<section class="tight">
  <div class="wrap">
    <div class="cta reveal">
      <cfoutput>
      <h2>A running site, then the docs you need</h2>
      <div class="grid grid-3" style="margin-top:22px">
        <div class="term">
          <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">1 · install</span></div>
          <pre class="term-body"><code>curl -LO #( application.latest )#/download/rustcfml-linux-x86_64
chmod +x rustcfml-linux-x86_64
sudo mv rustcfml-linux-x86_64 /usr/local/bin/rustcfml</code></pre>
        </div>
        <div class="term">
          <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">2 · a page</span></div>
          <pre class="term-body"><code>&lt;cfset name = "world"&gt;
&lt;cfoutput&gt;Hello, ##name##!&lt;/cfoutput&gt;</code></pre>
        </div>
        <div class="term">
          <div class="term-bar"><span class="dot"></span><span class="dot"></span><span class="dot"></span><span class="term-name">3 · serve</span></div>
          <pre class="term-body"><code>rustcfml --serve . --port 8500
open http://localhost:8500/index.cfm</code></pre>
        </div>
      </div>
      </cfoutput>
    </div>
  </div>
</section>

<!-- ==================================================================== -->
<!-- The grouped index                                                     -->
<!-- ==================================================================== -->
<section>
  <div class="wrap">
    <cfloop array="#application.docGroups#" item="group">
      <div class="doc-group reveal">
        <cfoutput>
        <div class="doc-group-head">
          <h3>#( group.title )#</h3>
          <span>#( group.blurb )#</span>
        </div>
        <div class="doc-list">
          <cfloop array="#group.topics#" item="topic">
            <a class="doc-item" href="#( application.docsBlob & topic.file )#" rel="noopener">
              <b>#( topic.name )#</b>
              <span>#( topic.desc )#</span>
              <code>docs/#( topic.file )#</code>
            </a>
          </cfloop>
        </div>
        </cfoutput>
      </div>
    </cfloop>
  </div>
</section>

<!-- ==================================================================== -->
<!-- Recipes                                                               -->
<!-- ==================================================================== -->
<section class="tint">
  <div class="wrap">
    <div class="section-head reveal">
      <h2>The four things everybody looks up first</h2>
      <p class="lead">Configuration is a file, not a console. Secrets come from the environment, so nothing sensitive is ever committed.</p>
    </div>

    <div class="grid grid-2">
      <cfoutput>
      <div class="card reveal">
        <span class="tag">A datasource</span>
        <p>Add it to <code class="inline">.cfconfig.json</code> beside your web root, or to
           <code class="inline">this.datasources</code> in <code class="inline">Application.cfc</code>.</p>
        <div class="term">
          <div class="term-bar"><span class="term-name">.cfconfig.json</span></div>
<pre class="term-body"><code>{
  "datasources": {
    "app": {
      "type":     "PostgreSQL",
      "host":     "db.internal",
      "port":     5432,
      "database": "appdb",
      "username": "{env:DB_USER}",
      "password": "{env:DB_PASSWORD}"
    }
  }
}</code></pre>
        </div>
      </div>

      <div class="card reveal">
        <span class="tag">Clean URLs</span>
        <p>Drop a rewrite file in the document root. Regex, backreferences, conditions and
           <code class="inline">last="true"</code> all behave the way Tuckey documented.</p>
        <div class="term">
          <div class="term-bar"><span class="term-name">urlrewrite.xml</span></div>
<pre class="term-body"><code>&lt;urlrewrite&gt;
  &lt;rule&gt;
    &lt;from&gt;^/([a-z][a-z0-9-]*)/?$&lt;/from&gt;
    &lt;to last="true"&gt;/$1.cfm&lt;/to&gt;
  &lt;/rule&gt;
&lt;/urlrewrite&gt;</code></pre>
        </div>
      </div>

      <div class="card reveal">
        <span class="tag">Sessions</span>
        <p>On by default and in process. Move them to Memcached, or let nodes discover each
           other, without touching a line of application code.</p>
        <div class="term">
          <div class="term-bar"><span class="term-name">Application.cfc</span></div>
<pre class="term-body"><code>component {
    this.name              = "MyApp";
    this.sessionManagement = true;
    this.sessionTimeout    = createTimeSpan( 0, 8, 0, 0 );
    this.sessioncookie     = {
          secure  = true
        , httpOnly = true
        , samesite = "Lax"
    };
}</code></pre>
        </div>
      </div>

      <div class="card reveal">
        <span class="tag">Deploy it</span>
        <p>Production mode plus a Unix socket behind nginx is the whole deployment story for
           most applications. Docker is a small Dockerfile away.</p>
        <div class="term">
          <div class="term-bar"><span class="term-name">entrypoint</span></div>
<pre class="term-body"><code>FROM rustcfml:latest
COPY ./webroot /srv/webroot
EXPOSE 8080
ENTRYPOINT ["rustcfml", "--serve", "/srv/webroot",
            "--production", "--socket=/run/rustcfml.sock"]</code></pre>
        </div>
      </div>
      </cfoutput>
    </div>

    <cfoutput>
    <div class="callout">
      <span class="ico">#( icons.get( "alert" ) )#</span>
      <p>
        <b>Before you plan a migration, read Known Issues.</b> It lists the silent no-ops and
        the places where behaviour diverges from Lucee by choice. It is the shortest document
        in the repository that will save you the most time.
        <a href="#( application.docsBlob )#known-issues.md" rel="noopener">docs/known-issues.md</a>
      </p>
    </div>

    <div class="btn-row">
      <a class="btn btn-primary btn-lg" href="#( application.repo )#/blob/main/README.md" rel="noopener">Read the README</a>
      <a class="btn btn-secondary btn-lg" href="#( application.repo )#/tree/main/docs" rel="noopener">Browse docs/ on GitHub</a>
      <a class="btn btn-ghost btn-lg" href="#( application.issues )#" rel="noopener">Ask a question</a>
    </div>
    </cfoutput>
  </div>
</section>

<cfinclude template="includes/_footer.cfm">
