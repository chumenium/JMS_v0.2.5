<!--*
：：：色のテーマは緑：：：
選考ステージを登録する画面


******教員-生徒-どちらにも表示されるページ****



**

*-->

<!--確認まだ-->

<!--KCS_JMS_PROJECT-->


<!-- 選考ステージ登録画面用 -->



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



<body>
    <h2>選考ステージ登録</h2>

    <form id="selectionStageForm" action="SelectionStageController" method="post">
        <div class="stage-section">
            <label>会社名：</label>
            <input type="text" name="companyName" required><br>

            <label>職種：</label>
            <input type="text" name="jobTitle"><br>

            <label>応募日：</label>
            <input type="date" name="applyDate"><br>
        </div>

        <div class="stage-section">
            <p><strong>現在の選考ステージ：</strong></p>

            <!-- 書類 -->
            <input type="radio" name="stage" value="document_before" id="document_before">
            <label for="document_before">書類選考提出前</label><br>

            <input type="radio" name="stage" value="document_result" id="document_result">
            <label for="document_result">書類選考結果待ち</label><br>

            <!-- 一次 -->
            <input type="radio" name="stage" value="interview1_before" id="interview1_before">
            <label for="interview1_before">一次面接選考前</label><br>

            <input type="radio" name="stage" value="interview1_result" id="interview1_result">
            <label for="interview1_result">一次面接結果待ち</label><br>

            <!-- 二次 -->
            <input type="radio" name="stage" value="interview2_before" id="interview2_before">
            <label for="interview2_before">二次面接選考前</label><br>

            <input type="radio" name="stage" value="interview2_result" id="interview2_result">
            <label for="interview2_result">二次面接結果待ち</label><br>

            <!-- 三次 -->
            <input type="radio" name="stage" value="interview3_before" id="interview3_before">
            <label for="interview3_before">三次面接選考前</label><br>

            <input type="radio" name="stage" value="interview3_result" id="interview3_result">
            <label for="interview3_result">三次面接結果待ち</label><br>

            <!-- 最終 -->
            <input type="radio" name="stage" value="final_before" id="final_before">
            <label for="final_before">最終面接選考前</label><br>

            <input type="radio" name="stage" value="final_result" id="final_result">
            <label for="final_result">最終面接結果待ち</label><br>

            <input type="radio" name="stage" value="final_done" id="final_done" onclick="checkFinalInterview()">
            <label for="final_done">最終面接終了</label><br>
        </div>

        <!-- 面接追加 -->
        <div class="stage-section">
            <button type="button" onclick="showMoreInterviews()">三次以上の面接を登録する</button>
            <div id="moreInterviewButtons" class="interview-buttons hidden">
                <c:forEach begin="4" end="10" var="i">
                    <input type="radio" name="stage" value="interview${i}_before" id="interview${i}_before">
                    <label for="interview${i}_before">${i}次面接選考前</label><br>

                    <input type="radio" name="stage" value="interview${i}_result" id="interview${i}_result">
                    <label for="interview${i}_result">${i}次面接結果待ち</label><br>
                </c:forEach>
            </div>
        </div>

        <div class="stage-section">
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
<li><a href=""></a></li>
<li><a href=""></a></li>
<li><a href=""></a></li>
<li><a href=""></a></li>
<li><a href=""></a></li>
<li><a href=""></a></li>
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
