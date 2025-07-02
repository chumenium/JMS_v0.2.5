<!--*
：：：色のテーマは緑：：：
選考ステージを登録する画面


******教員-生徒-どちらにも表示されるページ****



**

*-->

<!--確認まだ-->

<!--KCS_JMS_PROJECT-->


<!-- 試験・面接情報入力画面用 -->



<!--▼▼▼▼▼スコープから取得する情報　これをもとに判定をしていく -->



<% 
  String username = (String) session.getAttribute("username"); 
  String role     = (String) session.getAttribute("role"); 
%>

<!--▲▲▲▲▲-->



<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">
</head>

<body>


 
<div id="container">



<!--▼▼▼▼▼ここから「ヘッダー」-->
<header>

<h1 id="logo"><a href="index.html"><img src="images/logo.png" alt="jms"></a></h1>

<nav>
<ul>
<% if (username != null) { %>
	<li>こんにちは、<%= username %>さん</li>
<% } else { %>
	<li><a href="login.html">ログイン</a></li>
<% } %>

<li><a href="">1</a></li>
<li><a href="">2</a></li>
<li><a href="">3</a></li>
<li><a href="">4</a></li>
</ul>
</nav>

</header>
<!--▲▲▲▲▲ここまで「ヘッダー」-->









<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>

<body>
<h2>試験・面接情報入力</h2>

<form action="InterviewExamInputController" method="post">

    <div class="section">
        <label>企業名：</label>
        <input type="text" name="companyName" required>
    </div>

    <div class="section">
        <label>職種：</label>
        <select name="jobTitle">
            <option value="">選択してください</option>
            <option>インフラエンジニア</option>
            <option>アプリ開発エンジニア</option>
            <option>セキュリティエンジニア</option>
            <option>ネットワークエンジニア</option>
            <option>PM補佐</option>
            <option>サーバーエンジニア</option>
            <option>データベース管理者</option>
            <option>ITサポート</option>
            <option>ヘルプデスク</option>
            <option>品質管理／テスト</option>
        </select>
    </div>

    <div class="section">
        <label>試験種別：</label>
        <div class="btn-group">
            <button type="button" class="examType-btn" id="examType-筆記" onclick="selectButton('examType','筆記')">筆記</button>
            <button type="button" class="examType-btn" id="examType-適性" onclick="selectButton('examType','適性')">適性</button>
            <button type="button" class="examType-btn" id="examType-なし" onclick="selectButton('examType','なし')">なし</button>
        </div>
        <input type="hidden" name="examType" id="examTypeInput" required>
    </div>

    <div class="section">
        <label>試験日：</label>
        <input type="date" name="examDate">
    </div>

    <div class="section">
        <label>試験会場：</label>
        <select name="examVenue">
            <option value="">選択してください</option>
            <option>校内</option>
            <option>企業本社</option>
            <option>オンライン</option>
        </select>
    </div>

    <div class="section">
        <label>試験時間：</label>
        <input type="time" name="examStartTime"> ～ 
        <input type="time" name="examEndTime">
    </div>

    <div class="section">
        <label>面接日：</label>
        <input type="date" name="interviewDate">
    </div>

    <div class="section">
        <label>面接会場：</label>
        <select name="interviewVenue">
            <option value="">選択してください</option>
            <option>校内</option>
            <option>企業本社</option>
            <option>オンライン</option>
        </select>
    </div>

    <div class="section">
        <label>面接形式：</label>
        <div class="btn-group">
            <button type="button" class="interviewFormat-btn" id="interviewFormat-個人" onclick="selectButton('interviewFormat','個人')">個人</button>
            <button type="button" class="interviewFormat-btn" id="interviewFormat-集団" onclick="selectButton('interviewFormat','集団')">集団</button>
            <button type="button" class="interviewFormat-btn" id="interviewFormat-オンライン" onclick="selectButton('interviewFormat','オンライン')">オンライン</button>
        </div>
        <input type="hidden" name="interviewFormat" id="interviewFormatInput" required>
    </div>

    <div class="section">
        <label>面接官人数：</label>
        <select name="interviewerCount">
            <option value="">選択してください</option>
            <option>1</option>
            <option>2</option>
            <option>3</option>
            <option>4</option>
            <option>5名以上</option>
        </select>
    </div>

    <div class="section">
        <button type="submit">登録</button>
    </div>
</form>

<!--▼▼▼▼▼ここから「フッター」-->
<footer>

<div>
<p class="logo"><img src="images/logo.png" alt="Job Management System"></p>
<ul class="icons">
<li><a href="#"><i class="fa-brands fa-x-twitter"></i></a></li>
<li><a href="#"><i class="fab fa-line"></i></a></li>
<li><a href="#"><i class="fab fa-youtube"></i></a></li>
<li><a href="#"><i class="fab fa-instagram"></i></a></li>
</ul>

<small>Copyright&copy; @ 2025 Job Management System All Rights Reserved.</small>
</div>

<div>

<ul>
<li><a href="">1</a></li>
<li><a href="">2</a></li>
<li><a href="">3</a></li>
<li><a href="">4</a></li>
</ul>

</div>

</footer>
<!--▲▲▲▲▲ここまで「フッター」-->



<!--▼▼最下部-->
<span class="pr"><a href="" target="_blank">@ 2025 Job Management System</a></span>
<!--▲▲ここまで最下部-->


</div>
<!--/#container-->



<!--ローディング-->
<div id="loading">
<img src="images/logo.png" alt="Loading">
<div class="progress-container">
<div class="progress-bar"></div>
</div>
</div>



<!--開閉ボタン（ハンバーガーアイコン）-->
<div id="menubar_hdr">
<span></span><span></span><span></span>
</div>


<!--▼▼▼右上のブロック -->

<!--開閉ブロック-->
<div id="menubar">

<p class="logo"><img src="images/logo.png" alt="Job Management System"></p>

<nav>
<ul>
<li><a href="">ホーム</a></li>
<li><a href="">ログイン</a></li>
<li><a href="">在校生の声</a></li>
<li><a href="">よく頂く質問</a></li>
<li><a href="">就職活動の流れ</a></li>
<li><a href="">お問い合わせ</a></li>
</ul>
</nav>


</div>
<!--/#menubar-->



<!--jQueryの読み込み-->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!--パララックス（inview）-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/protonet-jquery.inview/1.1.2/jquery.inview.min.js"></script>
<script src="js/jquery.inview_set.js"></script>

<!--このテンプレート専用のスクリプト-->
<script src="js/main.js"></script>
</body>
</html>