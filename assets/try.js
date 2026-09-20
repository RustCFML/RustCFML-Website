/* ---------------------------------------------------------------------------
   /try: the real engine, compiled to WebAssembly, running in the page.

   The examples are the project's own, ported verbatim from the interactive
   demo by tools/import-examples.py and loaded from try-examples.js. Two are
   added here rather than replacing anything: `modern`, which shows the null
   handling the demo set does not cover, and `sql`, because query-of-queries
   survives the WASM build and a browser running GROUP BY is worth showing.

   The module is 16 MB uncompressed, so nothing is fetched until the visitor
   asks for it: the first Run triggers the import, and the button says so while
   it happens. Loading it on page load would make a brochure page cost more
   than the binary it is advertising.
   --------------------------------------------------------------------------- */
( function () {
  "use strict";

  var ADDED = {
    modern:
      '// Null handling and chained member methods\n' +
      'deals = [\n' +
      '      { region = "EMEA", value = 4200, stage = "won"  }\n' +
      '    , { region = "AMER", value = 8800, stage = "won"  }\n' +
      '    , { region = "EMEA", value = 1500, stage = "lost" }\n' +
      '    , { region = "APAC",               stage = "won"  }\n' +
      '];\n' +
      '\n' +
      '// ?: supplies a missing key, ?? a null, ?. navigates safely.\n' +
      'live = deals\n' +
      '    .filter( ( d ) => d.stage != "lost" )\n' +
      '    .map( ( d ) => { return { region = d.region ?: "unknown", value = d.value ?? 0 }; } );\n' +
      '\n' +
      'writeOutput( "kept    : " & live.len() & " of " & deals.len() & chr(10) );\n' +
      'writeOutput( "total   : " & live.reduce( ( t, d ) => t + d.value, 0 ) & chr(10) );\n' +
      'writeOutput( "regions : " & live.map( ( d ) => d.region ).toList( ", " ) & chr(10) );\n' +
      'writeOutput( "missing : " & ( deals[ 4 ]?.value ?: "no value" ) );',

    sql:
      '// Query-of-queries: a pure-Rust SQL engine, in a browser tab\n' +
      'deals = queryNew( "region,value", "varchar,integer", [\n' +
      '      [ "EMEA", 4200 ]\n' +
      '    , [ "AMER", 8800 ]\n' +
      '    , [ "EMEA", 1500 ]\n' +
      '    , [ "APAC", 2600 ]\n' +
      '] );\n' +
      '\n' +
      '// ORDER BY on a select alias is not supported yet, hence sum( value ).\n' +
      'byRegion = queryExecute(\n' +
      '      "SELECT     region, sum( value ) AS total\n' +
      '         FROM     deals\n' +
      '     GROUP BY     region\n' +
      '     ORDER BY     sum( value ) DESC"\n' +
      '    , {}\n' +
      '    , { dbtype = "query" }\n' +
      ');\n' +
      '\n' +
      'writeOutput( "region   total" & chr(10) );\n' +
      'for ( row in byRegion ) {\n' +
      '    writeOutput( row.region & "     " & numberFormat( row.total, "9,999" ) & chr(10) );\n' +
      '}'
  };

  var LABELS = {
    hello: "hello", variables: "variables", arrays: "arrays", structs: "structs",
    closures: "closures", fibonacci: "fibonacci", strings: "strings", tags: "tags",
    component: "component", fizzbuzz: "fizzbuzz", modern: "null handling", sql: "SQL"
  };

  var samples = {}, order = [];
  var ported     = window.RC_EXAMPLES || {};
  var portedKeys = window.RC_EXAMPLE_ORDER || Object.keys( ported );

  portedKeys.forEach( function ( k ) { samples[ k ] = ported[ k ]; order.push( k ); } );
  Object.keys( ADDED ).forEach( function ( k ) {
    if ( !samples.hasOwnProperty( k ) ) { samples[ k ] = ADDED[ k ]; order.push( k ); }
  } );

  var editor = document.getElementById( "try-code" );
  var outEl  = document.getElementById( "try-out" );
  var runBtn = document.getElementById( "try-run" );
  var verEl  = document.getElementById( "try-version" );
  var timeEl = document.getElementById( "try-timing" );
  var chipsEl = document.getElementById( "try-samples" );
  if ( !editor || !runBtn || !chipsEl ) return;

  var mod = null, pending = null;

  function loadEngine() {
    if ( mod )     return Promise.resolve( mod );
    if ( pending ) return pending;
    pending = import( "/assets/wasm/rustcfml_wasm.js" ).then( function ( m ) {
      return m.default( { module_or_path: "/assets/wasm/rustcfml_wasm_bg.wasm" } ).then( function () {
        mod = m;
        try { if ( verEl ) verEl.textContent = m.version(); } catch ( e ) {}
        return m;
      } );
    } ).catch( function ( err ) { pending = null; throw err; } );
    return pending;
  }

  function show( text, isError ) {
    outEl.textContent = text;
    // The stylesheet keys off .term.is-error, so the flag belongs on the panel,
    // not on the <pre> inside it.
    var panel = outEl.closest( ".term" );
    if ( panel ) panel.classList.toggle( "is-error", !!isError );
  }

  function run() {
    var first = !mod;
    runBtn.disabled = true;
    runBtn.textContent = first ? "Loading the engine…" : "Running…";
    if ( first ) show( "Fetching the WebAssembly build, about 16 MB, once per visit.", false );

    loadEngine().then( function ( m ) {
      // A fresh engine per run, so one example cannot leave state behind for
      // the next: a playground that remembers is a playground that confuses.
      var engine = new m.CfmlEngine(), t0 = performance.now(), result;
      try {
        result = engine.execute( editor.value );
        if ( !result || !result.length ) result = engine.get_output();
        // Some failures throw and some come back written into the output. A
        // missing component reports itself this way. Either has to look like an
        // error, or a broken example reads as a working one.
        show( result && result.length ? result : "( no output )",
              /^\s*(Runtime Error|Parse Error|Compile Error|Error)\s*:/.test( result || "" ) );
      } catch ( e ) {
        show( String( e && e.message ? e.message : e ), true );
      }
      if ( timeEl ) timeEl.textContent = ( performance.now() - t0 ).toFixed( 1 ) + " ms";
      try { engine.free(); } catch ( e ) {}
    } ).catch( function ( err ) {
      show( "The engine could not be loaded.\n\n" + String( err && err.message ? err.message : err ), true );
    } ).then( function () {
      runBtn.disabled = false;
      runBtn.textContent = "Run";
    } );
  }

  function select( key, btn ) {
    editor.value = samples[ key ];
    Array.prototype.forEach.call( chipsEl.querySelectorAll( ".chip" ), function ( b ) {
      b.classList.toggle( "is-active", b === btn );
    } );
    show( "Press Run.", false );
    if ( timeEl ) timeEl.textContent = "";
  }

  // Chips are built from the example set, so importing a new example into
  // try-examples.js puts a button on the page without touching the template.
  order.forEach( function ( key, i ) {
    var btn = document.createElement( "button" );
    btn.type = "button";
    btn.className = "chip" + ( i === 0 ? " is-active" : "" );
    btn.textContent = LABELS[ key ] || key;
    btn.addEventListener( "click", function () { select( key, btn ); } );
    chipsEl.appendChild( btn );
  } );

  runBtn.addEventListener( "click", run );
  editor.addEventListener( "keydown", function ( e ) {
    if ( ( e.metaKey || e.ctrlKey ) && e.key === "Enter" ) { e.preventDefault(); run(); }
  } );

  if ( order.length ) editor.value = samples[ order[ 0 ] ];
} )();
