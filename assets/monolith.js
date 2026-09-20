/* RustCFML site: the home-page hero object.
   The prism itself is CSS; this file only supplies the angle. Everything here
   is enhancement: with the script absent the prism still renders, still reads
   its six labels, and the readout still carries the default line. */
(function () {
  "use strict";

  var mono = document.getElementById( "mono" );
  if ( !mono ) return;

  var stage = document.getElementById( "monoStage" );
  var obj   = document.getElementById( "monoObj" );
  var title = document.getElementById( "monoTitle" );
  var body  = document.getElementById( "monoBody" );
  var bands = [].slice.call( mono.querySelectorAll( ".mono-band" ) );

  if ( !stage || !obj || !bands.length ) return;

  var defTitle = title.textContent;
  var defBody  = body.textContent;

  var reduced = window.matchMedia
    && window.matchMedia( "(prefers-reduced-motion: reduce)" ).matches;

  /* Degrees per frame when nobody is touching it. Slow enough to read a face
     before it leaves, fast enough that the object is obviously alive. */
  var SPIN = reduced ? 0 : 0.16;

  var ry      = -26;   /* current angle          */
  var vel     = SPIN;  /* current angular speed  */
  var dragging = false;
  var held     = false; /* pointer or focus is on a band: hold still to read  */
  var lastX    = 0;
  var running  = false;

  function paint() {
    obj.style.setProperty( "--ry", ry.toFixed( 2 ) + "deg" );
  }

  function frame() {
    if ( !dragging ) {
      var target = held ? 0 : SPIN;
      vel += ( target - vel ) * 0.07;   /* ease into and out of the idle spin */
      ry  += vel;
      paint();
    }
    if ( running ) requestAnimationFrame( frame );
  }

  function start() { if ( !running ) { running = true; requestAnimationFrame( frame ); } }
  function stop()  { running = false; }

  /* ---- Drag ------------------------------------------------------------- */
  stage.addEventListener( "pointerdown", function ( e ) {
    dragging = true;
    lastX = e.clientX;
    stage.classList.add( "is-drag" );
    if ( stage.setPointerCapture ) stage.setPointerCapture( e.pointerId );
  } );

  stage.addEventListener( "pointermove", function ( e ) {
    if ( !dragging ) return;
    var d = ( e.clientX - lastX ) * 0.45;
    lastX = e.clientX;
    ry  += d;
    vel  = d;                            /* let go and it keeps that momentum */
    paint();
  } );

  function release() {
    if ( !dragging ) return;
    dragging = false;
    stage.classList.remove( "is-drag" );
  }
  stage.addEventListener( "pointerup", release );
  stage.addEventListener( "pointercancel", release );

  /* ---- Selecting a band -------------------------------------------------- */
  function select( band ) {
    held = true;
    for ( var i = 0; i < bands.length; i++ ) {
      bands[ i ].classList.toggle( "is-on", bands[ i ] === band );
    }
    title.textContent = band.getAttribute( "data-face" );
    body.textContent  = band.getAttribute( "data-detail" );
  }

  function clear() {
    held = false;
    for ( var i = 0; i < bands.length; i++ ) bands[ i ].classList.remove( "is-on" );
    title.textContent = defTitle;
    body.textContent  = defBody;
  }

  bands.forEach( function ( band ) {
    /* pointerenter per band and one leave on the stage, rather than a leave
       per band: moving between two touching faces must not flicker back to
       the default copy on the way. */
    band.addEventListener( "pointerenter", function () { select( band ); } );
    band.addEventListener( "focus", function () { select( band ); } );
    band.addEventListener( "blur",  clear );
    band.addEventListener( "click", function () { select( band ); } );
  } );

  stage.addEventListener( "pointerleave", function () {
    if ( !document.activeElement || !document.activeElement.classList
      || !document.activeElement.classList.contains( "mono-band" ) ) clear();
  } );

  /* ---- Only animate while it is on screen -------------------------------- */
  paint();

  if ( "IntersectionObserver" in window ) {
    new IntersectionObserver( function ( entries ) {
      if ( entries[ 0 ].isIntersecting ) start(); else stop();
    }, { threshold: 0.05 } ).observe( mono );
  } else {
    start();
  }
})();
