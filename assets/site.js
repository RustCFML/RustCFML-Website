/* RustCFML site: progressive enhancement only.
   Every page renders and reads correctly with JavaScript switched off; this
   file adds the theme switch, the mobile menu, copy buttons, scroll reveals
   and a live GitHub star count. */
(function () {
  "use strict";

  var root = document.documentElement;

  /* ---- Theme ------------------------------------------------------------ */
  var btn = document.getElementById( "themeBtn" );

  function syncThemeButton() {
    if ( !btn ) return;
    var dark = root.getAttribute( "data-theme" ) !== "light";
    btn.title = dark ? "Switch to light theme" : "Switch to dark theme";
    btn.setAttribute( "aria-label", btn.title );
  }

  if ( btn ) {
    btn.addEventListener( "click", function () {
      var next = root.getAttribute( "data-theme" ) === "light" ? "dark" : "light";
      root.setAttribute( "data-theme", next );
      try { localStorage.setItem( "rc-theme", next ); } catch ( e ) {}
      syncThemeButton();
    } );
    syncThemeButton();
  }

  /* ---- Mobile navigation ------------------------------------------------ */
  var menuBtn = document.getElementById( "menuBtn" );
  var nav     = document.getElementById( "siteNav" );

  if ( menuBtn && nav ) {
    menuBtn.addEventListener( "click", function () {
      var open = nav.classList.toggle( "is-open" );
      menuBtn.setAttribute( "aria-expanded", open ? "true" : "false" );
    } );
    nav.addEventListener( "click", function ( e ) {
      if ( e.target.tagName === "A" ) {
        nav.classList.remove( "is-open" );
        menuBtn.setAttribute( "aria-expanded", "false" );
      }
    } );
  }

  /* ---- Header shadow on scroll ------------------------------------------ */
  var header = document.getElementById( "siteHeader" );
  if ( header ) {
    var onScroll = function () {
      header.classList.toggle( "is-scrolled", window.scrollY > 8 );
    };
    window.addEventListener( "scroll", onScroll, { passive: true } );
    onScroll();
  }

  /* ---- Copy buttons ----------------------------------------------------- */
  function copyText( text, button ) {
    var done = function ( ok ) {
      var was = button.textContent;
      button.textContent = ok ? "Copied" : "Press ⌘C";
      button.disabled = true;
      setTimeout( function () {
        button.textContent = was;
        button.disabled = false;
      }, 1600 );
    };

    if ( navigator.clipboard && navigator.clipboard.writeText ) {
      navigator.clipboard.writeText( text ).then(
        function () { done( true ); },
        function () { done( false ); }
      );
      return;
    }
    // Older or non-secure contexts: fall back to a throwaway textarea.
    var ta = document.createElement( "textarea" );
    ta.value = text;
    ta.style.position = "fixed";
    ta.style.opacity = "0";
    document.body.appendChild( ta );
    ta.select();
    var ok = false;
    try { ok = document.execCommand( "copy" ); } catch ( e ) {}
    document.body.removeChild( ta );
    done( ok );
  }

  // The command shown is the command copied, so a sample that has been
  // reflowed for the page cannot quietly differ from what lands on the CLI.
  Array.prototype.forEach.call( document.querySelectorAll( ".term" ), function ( term ) {
    var body = term.querySelector( ".term-body" );
    var slot = term.querySelector( ".term-bar" );
    if ( !body || !slot ) return;
    var button = document.createElement( "button" );
    button.type = "button";
    button.className = "term-copy";
    button.textContent = "Copy";
    button.addEventListener( "click", function () {
      copyText( body.innerText.replace( /\n\$ /g, "\n" ).trim(), button );
    } );
    slot.appendChild( button );
  } );

  /* ---- Scroll reveals --------------------------------------------------- */
  // A rect check on scroll, not an IntersectionObserver. Both look the same in
  // a browser you are sitting in front of, but the observer's callback only
  // arrives when the engine decides to compute an intersection, and in an
  // off-screen iframe, a backgrounded tab or a headless run it can quietly
  // never come, leaving the page blank. A sweep cannot: the first one runs
  // immediately, so anything already in view is visible without any event.
  var reveals = document.querySelectorAll( ".reveal" );
  if ( reveals.length ) {
    var pending = Array.prototype.slice.call( reveals );
    var ticking = false;

    function sweep() {
      ticking = false;
      var limit  = ( window.innerHeight || 800 ) * 0.92;
      var left   = [];
      for ( var i = 0; i < pending.length; i++ ) {
        var el = pending[ i ];
        var r  = el.getBoundingClientRect();
        if ( r.top < limit && r.bottom > -limit ) {
          // Stagger by position in the batch so a grid arrives as a row.
          el.style.transitionDelay = ( ( i % 6 ) * 45 ) + "ms";
          el.classList.add( "in" );
        } else {
          left.push( el );
        }
      }
      pending = left;
      if ( !pending.length ) {
        window.removeEventListener( "scroll", onScroll );
        window.removeEventListener( "resize", onScroll );
      }
    }

    function onScroll() {
      if ( !ticking ) {
        ticking = true;
        ( window.requestAnimationFrame || sweep )( sweep );
      }
    }

    window.addEventListener( "scroll", onScroll, { passive: true } );
    window.addEventListener( "resize", onScroll );
    sweep();
  }

  /* ---- Live GitHub counts ----------------------------------------------- */
  // Polite, cached by the browser, and silent when it fails: the page ships a
  // plausible static number so the button never renders empty.
  var repo = "RustCFML/RustCFML";
  Array.prototype.forEach.call( document.querySelectorAll( ".js-gh" ), function ( link ) {
    fetch( "https://api.github.com/repos/" + repo, { headers: { Accept: "application/vnd.github+json" } } )
      .then( function ( r ) { return r.ok ? r.json() : null; } )
      .then( function ( data ) {
        if ( !data || typeof data.stargazers_count === "undefined" ) return;
        Array.prototype.forEach.call( link.querySelectorAll( ".js-stars" ), function ( pill ) {
          pill.textContent = "★ " + data.stargazers_count;
          pill.title = data.stargazers_count + " stars, " + ( data.forks_count || 0 ) + " forks";
        } );
      } )
      .catch( function () {} );
  } );
} )();
