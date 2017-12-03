<!doctype HTML>
<html>
<head>
<meta charset="utf-8" />
<title>吧食笔记</title>
    <link rel="stylesheet" href="/index.css">
</head>
<body>
<nav>
    <x-index />
</nav>
<article>
    <div class="nav-ul">
        <ul>
            <li><a href="/">首页</a></li>
            <x-markdown src="header.md" />
            <li><a href="javascript:history.go(-1)">返回</a></li>
        </ul>
    </div>

    <x-markdown src="README.md" />
</article>
<footer>

</footer>
