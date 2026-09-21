<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>#( encodeForHTML( request.title ) )# · RustCFML</title>
<meta name="description" content="#( encodeForHTML( request.desc ) )#">
<meta property="og:type" content="website">
<meta property="og:title" content="#( encodeForHTML( request.title ) )# · RustCFML">
<meta property="og:description" content="#( encodeForHTML( request.desc ) )#">
<meta property="og:image" content="#( application.repo )#/raw/main/crab.svg">
<meta name="twitter:card" content="summary">
<meta name="theme-color" content="##0b0f14">
<link rel="icon" type="image/png" sizes="96x96" href="/assets/crab.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/assets/site.css">
<script>
// Paint the theme before the first frame, or every page load flashes the
// wrong colours. Inline here rather than in site.js, which is deferred and
// would run too late.
//
// A stored choice wins; failing that the OS decides. The test is for light
// rather than dark so that "no preference", an ancient browser and a blocked
// localStorage all land on dark, which is this site's default.
(function () {
  document.documentElement.className += " js";
  var stored = null;
  try { stored = localStorage.getItem( "rc-theme" ); } catch ( e ) {}
  var light = window.matchMedia
    && window.matchMedia( "(prefers-color-scheme: light)" ).matches;
  document.documentElement.setAttribute(
    "data-theme", stored || ( light ? "light" : "dark" ) );
})();
</script>
</head>
<body class="page-#( encodeForHTML( request.section ) )#">
<a class="skip" href="##main">Skip to content</a>
</cfoutput>
