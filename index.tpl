<!doctype HTML>
<html>
<head>
<meta charset="utf-8" />
<title>penguinSeven</title>
<style>

body {
color: #333;
font-family: sans-serif;
font-size: 12pt;
line-height: 170%;
padding: 0 30px 0 270px;
}

header .banner {
margin: 0 0 1em 0;
}

header .banner, nav .banner {
color: #777;
font-size: 10pt;
font-weight: bold;
}

header h1 {
background: #0c3;
border-radius: 4px;
color: #fff;
font-size: 24pt;
margin: 0;
padding: 1.2em 0;
text-align: center;
}

nav {
font-size: 10pt;
overflow-x: hidden;
overflow-y: auto;
position: fixed;
top: 0;
left: 0;
bottom: 0;
width: 240px;
}

nav .menubar {
border-bottom: solid 1px #ccc;
display: none;
height: 48px;
line-height: 48px;
padding: 0 10px;
}

nav .button {
background: #777;
border: 1px solid #333;
color: #fff;
font-size: 10pt;
font-weight: bold;
padding: 8px;
border-radius: 4px;
}

nav ul {
padding: 0 0 0 10px;
}

nav ul a {
color: #333;
text-decoration: none;
}

nav ul a:hover {
text-decoration: underline;
}

nav li {
line-height: 180%;
list-style: none;
margin: 0;
padding: 0;
}

nav .level2 {
font-size: 11pt;
font-weight: bold;
}

nav .level3 {
padding-left: 1em;
}

nav .level3:before { 
content: "» ";
}

nav .level4 {
padding-left: 2em;
}

nav .level4:before {
content: "› ";
}

article h2 {
border-bottom: dotted 1px #777;
font-size: 12pt;
line-height: 100%;
margin: 4em 0 1em 0;
padding: 0 0 0.3em 0;
}

article h3 {
font-size: 12pt;
line-height: 100%;
margin: 2em 0 1em 0;
padding: 0;
}

article h4 {
font-size: 12pt;
font-style:italic;
font-weight: normal;
line-height: 100%;
margin: 1.2em 0 1em 0;
padding: 0;
}

article p {
margin: 1em 0;
}

article p code {
background: #eee;
border: 1px solid #ccc;
}

article p strong {
color: #f00;
}

article pre {
background: #eee;
border-left: solid 2px #3c0;
font-size: 10pt;
margin: 1em 0;
padding: 0 0 0 1em;
overflow-x: auto;
overflow-y: padding;
}

article blockquote {
background: #fff;
border: dashed 1px #777;
border-left: solid 2px #777;
color: #000;
margin: 0;
padding: 0 0 0 1em;
}

article ul, article ol {
padding-left: 2em;
}

footer {
border-top: 1px solid #ccc;
font-size: 10pt;
margin-top: 4em;
}

@media (max-width: 768px) {

body {
padding: 0 10px 0 230px;
}

nav {
width: 230px;
}

}

@media (max-width: 480px) {

body {
padding: 64px 10px 0 10px;
}

header .banner {
display: none;
}

nav {
position: absolute;
width: 100%;
}

nav .menubar {
display: block;
}

nav .banner {
float: right;
}

nav ul {
background: #fff;
display: none;
font-size: 14pt;
margin: 0;
padding: 0 0 0 8px;
}

nav .level2 {
font-size: 16pt;
font-weight: bold;
}

nav li {
line-height: 240%;
}

.index nav ul {
display: block;
}

.index article {
display: none;
}

}

</style>
</head>
<body>
<header>
<x-markdown src="header.md" />
</header>
<nav>
<x-index />
</nav>
<article>
<x-markdown src="header.md" />
<x-markdown src="README.md" />
</article>
<footer>

</footer>
