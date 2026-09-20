<cfscript>
request.section = "404";
request.title   = "Page not found";
request.desc    = "That page is not in this site. The documentation index, the release list and the repository are.";

icons = new lib.Icons();

// Set the status here as well as in onMissingTemplate, so the page is correct
// whether it was reached by rewrite, by include or typed in directly.
header name="Status" statusCode="404" statusText="Not Found";
</cfscript>
<cfinclude template="includes/_head.cfm">
<cfinclude template="includes/_header.cfm">

<section class="hero">
  <div class="wrap">
    <div class="hero-grid">
      <cfoutput>
      <div>
        <h1>That template is not here.</h1>
        <p class="lead">
          Either the page moved, or the request was for something this site deliberately does
          not serve. If you followed a link from somewhere inside the project, that is a bug
          worth reporting, and it is usually a one-line fix.
        </p>
        <div class="btn-row">
          <a class="btn btn-primary btn-lg" href="/">#( icons.get( "arrow" ) )# Back to the home page</a>
          <a class="btn btn-secondary btn-lg" href="/docs">Documentation index</a>
          <a class="btn btn-ghost btn-lg" href="#( application.releases )#" rel="noopener">Releases</a>
        </div>
        <p class="small muted" style="margin-top:26px">
          Looking for something specific? Try
          <a href="#( application.repo )#/search?q=repo%3ARustCFML%2FRustCFML&amp;type=code" rel="noopener">searching the repository</a>
          or the
          <a href="#( application.repo )#/discussions" rel="noopener">discussions</a>.
        </p>
      </div>
      </cfoutput>

      <div class="term">
        <div class="term-bar">
          <span class="dot"></span><span class="dot"></span><span class="dot"></span>
          <span class="term-name">urlrewrite.xml, the rule that leads here</span>
        </div>
<pre class="term-body"><code><span class="tk-com">&lt;!-- Do not serve the application's own plumbing. --&gt;</span>
&lt;<span class="tk-tag">rule</span>&gt;
  &lt;<span class="tk-tag">from</span>&gt;^/(Application\.cfc|urlrewrite\.xml|includes/.*)$&lt;/<span class="tk-tag">from</span>&gt;
  &lt;<span class="tk-tag">to</span> last=<span class="tk-str">"true"</span>&gt;/404.cfm&lt;/<span class="tk-tag">to</span>&gt;
&lt;/<span class="tk-tag">rule</span>&gt;</code></pre>
        <pre class="term-body term-out"><code>GET #encodeForHTML( cgi.script_name )#  &rarr;  <span class="tk-str">404 Not Found</span></code></pre>
      </div>
    </div>
  </div>
</section>

<cfinclude template="includes/_footer.cfm">
