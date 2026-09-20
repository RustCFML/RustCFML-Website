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
// Paint the stored theme before the first frame, or every page load flashes
// the wrong colours. Inline here rather than in site.js, which is deferred and
// would run too late.
(function () {
  document.documentElement.className += " js";
  try {
    document.documentElement.setAttribute(
      "data-theme", localStorage.getItem( "rc-theme" ) || "dark" );
  } catch ( e ) {
    document.documentElement.setAttribute( "data-theme", "dark" );
  }
})();
</script>
</head>
<body class="page-#( encodeForHTML( request.section ) )#">
<a class="skip" href="##main">Skip to content</a>
</cfoutput>
