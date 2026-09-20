<cfoutput>
<header class="site-header" id="siteHeader">
  <div class="wrap header-inner">
    <a class="brand" href="/" aria-label="RustCFML home">
      <img src="/assets/crab.png" alt="" width="44" height="44">
      <span class="brand-name">Rust<span class="brand-hi">CFML</span></span>
    </a>

    <nav class="nav" id="siteNav" aria-label="Main">
      <cfloop array="#application.nav#" item="item">
        <a href="#( item.href )#"
           class="nav-link#( item.section eq request.section ? ' is-active' : '' )#"
           #( item.section eq request.section ? 'aria-current="page"' : '' )#>#( item.label )#</a>
      </cfloop>
      <a class="nav-link nav-mobile-only" href="#( application.releases )#">Releases</a>
    </nav>

    <div class="header-actions">
      <a class="btn btn-ghost btn-sm js-gh" href="#( application.repo )#" rel="noopener">
        <svg viewBox="0 0 16 16" width="15" height="15" aria-hidden="true" fill="currentColor">
          <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27s1.36.09 2 .27c1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.01 8.01 0 0 0 16 8c0-4.42-3.58-8-8-8Z"/>
        </svg>
        <span>GitHub</span>
        <span class="pill js-stars" title="Stars">★ 29</span>
      </a>
      <button class="theme-btn" id="themeBtn" type="button" aria-label="Toggle colour theme" title="Toggle theme">
        <svg class="ico-sun" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/></svg>
        <svg class="ico-moon" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8Z"/></svg>
      </button>
      <button class="menu-btn" id="menuBtn" type="button" aria-expanded="false" aria-controls="siteNav" aria-label="Toggle navigation">
        <span></span><span></span><span></span>
      </button>
    </div>
  </div>
</header>
<main id="main">
</cfoutput>
