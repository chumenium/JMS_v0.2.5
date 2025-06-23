

<!--*
：：：色のテーマは緑：：：
【】画面


**********

<!--* 画面：【】
        	
許可されている権限：
・教員：teacher
・校長・教務部長：headmaster
・システム管理者：admin
 
▼▼▼▼
*-->


<!--確認まだ-->

<!--KCS_JMS_PROJECT-->


<!-- 【】画面用 -->



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
<title>temp</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">
<!--dashboard用CSS-->
<style>
    .dashboard {
        max-width: 800px; /* ダッシュボード全体の幅を制限 */
        margin: 50px auto; /* 中央に配置 */
        padding: 20px; /* 内側の余白 */
        background: #f9f9f9; /* 背景色を明るく */
        border-radius: 10px; /* 角を丸める */
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 柔らかい影を追加 */
        text-align: center; /* 中央揃え */
    }

    .dashboard h1 {
        font-size: 28px; /* タイトルのフォントサイズ */
        margin-bottom: 20px; /* タイトル下の余白 */
        color: #333; /* タイトルの文字色 */
    }

    .dashboard p {
        font-size: 18px; /* メッセージのフォントサイズ */
        color: #555; /* メッセージの文字色 */
        margin-bottom: 30px; /* メッセージ下の余白 */
    }

    .dashboard ul {
        display: flex; /* 横並び配置 */
        flex-wrap: wrap; /* アイテムが画面幅に収まらない場合は折り返し */
        list-style: none; /* リストの箇条書きスタイルを削除 */
        padding: 0; /* リストの余白を削除 */
        margin: 0 auto; /* 中央揃え */
        justify-content: center; /* アイテムを中央寄せ */
        gap: 15px; /* アイテム間の余白 */
    }

    .dashboard ul li {
        background: #fff; /* ボタンの背景色 */
        padding: 15px 20px; /* 内側の余白 */
        border-radius: 8px; /* ボタンの角を丸める */
        box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1); /* ボタンに影を追加 */
        transition: transform 0.2s ease, box-shadow 0.2s ease; /* ホバー時のアニメーション */
    }

    .dashboard ul li a {
        text-decoration: none; /* アンダーラインを削除 */
        color: #333; /* 文字の色 */
        font-weight: bold; /* 文字を太字 */
        font-size: 16px; /* 文字サイズ */
        display: block; /* 全体をクリック可能にする */
    }

    .dashboard ul li:hover {
        transform: translateY(-5px); /* ボタンが浮き上がるアニメーション */
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2); /* ホバー時の影を強調 */
    }
</style>
<!--ここまで-->
</head>
<body>
<div id="container">
<!--▼▼▼▼▼ここから「ヘッダー」-->
<header>
<!-- ▼▼▼▼ 画面上部アイコン-->
<h1 id="logo"><a href="index.html"><img src="images/logo.png" alt="jms"></a></h1>
<!-- ▲▲▲▲ -->

<!--ヘッダー上部分のリスト-->

<nav>
<ul>
  <%-- ユーザ名・権限表示 --%>
  <% if (username != null) { %>
    <li>こんにちは、<%= username %>さん</li>
    <li><%= username %>さんの権限は<%= role %>です</li>
  <% } else { %>
    <li><a href="login.html">ログイン</a></li>
  <% } %>

  <!--* 画面：学生管理画面
        	
   許可されている権限：
        	
   ・教員：teacher
   ・校長・教務部長：headmaster
   ・システム管理者：admin
        	
    ▼▼▼▼
    *-->
  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=studentManagement">
        📚 学生管理画面
      </a>
    </li>
  <% } %>

  <!--* 画面：企業管理画面
        	
  許可されている権限：
        	
  ・就職指導部：egd
  ・システム管理者：admin
        	
   ▼▼▼▼
   *-->

  <% if ("egd".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=CompanyManagement">
        🏢 企業管理画面
      </a>
    </li>
  <% } %>

   <!--* 画面：就職管理画面
        	
     許可されている権限：
        	
     ・教員：teacher
     ・校長・教務部長：headmaster
     ・就職指導部：egd
     ・システム管理者：admin
    ・学生： student
        	
        	
   ▼▼▼▼
   *-->

  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "egd".equals(role) 
         || "admin".equals(role) 
         || "student".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=jobHunting">
        📄 就職管理画面
      </a>
    </li>
  <% } %>

  <!--* 画面：受験者一覧画面
        	
  許可されている権限：
        	
  ・教員：teacher
  ・校長・教務部長：headmaster
  ・就職指導部：egd
  ・システム管理者：admin
        	
        	
   ▼▼▼▼
   *-->

  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "egd".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=applicantList">
        📊 受験者一覧画面
      </a>
    </li>
  <% } %>



  <!--* 画面：受験者一覧画面
        	
   許可されている権限：
        	
   ・システム管理者：admin
        	
        	
   ▼▼▼▼
   *-->


  <% if ("admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=adminDatabase.jsp">
        🛠 管理者DB
      </a>
    </li>
  <% } %>
  
  
    <%-- 想定外の role／未定義の権限チェック --%>
  <% if (username != null
         && !("teacher".equals(role)
           || "headmaster".equals(role)
           || "egd".equals(role)
           || "admin".equals(role)
           || "student".equals(role))) { %>
    <li>アクセスできません</li>
  <% } %>

  <%-- ログアウト --%>
  <% if (username != null) { %>
    <li><a href="LogoutServlet">ログアウト</a></li>
  <% } %>
</ul>
</nav>
<!-- ▲▲▲ヘッダー上部分のリスト-->
</header>
<!--▲▲▲▲▲ここまで「ヘッダー」-->


<!--▼▼▼▼▼ここから「メイン画像」-->
<div id="mainimg">
<div>

<div class="text">
<p>あなたのベストな、<br>
ワンランク上の<br>
就職先を提案します。</p>
</div>

<!--▼【拡張機能　現状】-->
<div class="btn">
<p><a href="extension.html"><i class="fa-regular fa-envelope"></i>お問い合わせ</a></p>
<p><a href="extension.html"><i class="fa-regular fa-file-lines"></i>資料請求</a></p>
</div>

</div>
</div>
<!--▲▲▲▲▲ここまで「メイン画像」-->




<!-- ここから機能部分を記述 -->
<main>
<section class="bg3 bg-pattern3" id="main">












</section>
</main>
<!-- ここまで機能部分を記述 -->




<!--▼▼▼▼▼ここから「フッター」-->
<footer>
<div>
<p class="logo"><img src="images/logo.png" alt="Job Management System"></p>
<small>Copyright&copy; @ 2025 Job Management System All Rights Reserved.</small>
</div>
<div>
<ul>
  <%-- ユーザ名・権限表示 --%>
  <% if (username != null) { %>
    <li>こんにちは、<%= username %>さん</li>
    <li><%= username %>さんの権限は<%= role %>です</li>
  <% } else { %>
    <li><a href="login.html">ログイン</a></li>
  <% } %>

  <!--* 画面：学生管理画面
        	
   許可されている権限：
        	
   ・教員：teacher
   ・校長・教務部長：headmaster
   ・システム管理者：admin
        	
    ▼▼▼▼
    *-->
  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=studentManagement">
        📚 学生管理画面
      </a>
    </li>
  <% } %>

  <!--* 画面：企業管理画面
        	
  許可されている権限：
        	
  ・就職指導部：egd
  ・システム管理者：admin
        	
   ▼▼▼▼
   *-->

  <% if ("egd".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=CompanyManagement">
        🏢 企業管理画面
      </a>
    </li>
  <% } %>

   <!--* 画面：就職管理画面
        	
     許可されている権限：
        	
     ・教員：teacher
     ・校長・教務部長：headmaster
     ・就職指導部：egd
     ・システム管理者：admin
    ・学生： student
        	
        	
   ▼▼▼▼
   *-->

  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "egd".equals(role) 
         || "admin".equals(role) 
         || "student".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=jobHunting">
        📄 就職管理画面
      </a>
    </li>
  <% } %>

  <!--* 画面：受験者一覧画面
        	
  許可されている権限：
        	
  ・教員：teacher
  ・校長・教務部長：headmaster
  ・就職指導部：egd
  ・システム管理者：admin
        	
        	
   ▼▼▼▼
   *-->

  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "egd".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=applicantList">
        📊 受験者一覧画面
      </a>
    </li>
  <% } %>



  <!--* 画面：受験者一覧画面
        	
   許可されている権限：
        	
   ・システム管理者：admin
        	
        	
   ▼▼▼▼
   *-->


  <% if ("admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=adminDatabase.jsp">
        🛠 管理者DB
      </a>
    </li>
  <% } %>
  
  
    <%-- 想定外の role／未定義の権限チェック --%>
  <% if (username != null
         && !("teacher".equals(role)
           || "headmaster".equals(role)
           || "egd".equals(role)
           || "admin".equals(role)
           || "student".equals(role))) { %>
    <li>アクセスできません</li>
  <% } %>

  <%-- ログアウト --%>
  <% if (username != null) { %>
    <li><a href="LogoutServlet">ログアウト</a></li>
  <% } %>
</ul>
</div>
</footer>
<!--▲▲▲▲▲ここまで「フッター」-->


</div>
<!--/#container-->


<!--ローディング-->
<div id="loading">
<img src="images/logo.png" alt="Loading">
<div class="progress-container">
<div class="progress-bar"></div>
</div>
</div>


<!--開閉ボタン（ハンバーガーアイコン）【画面右上部分のハンバーガー】-->
<div id="menubar_hdr">
<span></span><span></span><span></span>
</div>
<!--開閉ブロック-->
<div id="menubar">
<p class="logo"><img src="images/logo.png" alt="Job Management System"></p>
<nav>
<ul>
  <%-- ユーザ名・権限表示 --%>
  <% if (username != null) { %>
    <li>こんにちは、<%= username %>さん</li>
    <li><%= username %>さんの権限は<%= role %>です</li>
  <% } else { %>
    <li><a href="login.html">ログイン</a></li>
  <% } %>

  <!--* 画面：学生管理画面
        	
   許可されている権限：
        	
   ・教員：teacher
   ・校長・教務部長：headmaster
   ・システム管理者：admin
        	
    ▼▼▼▼
    *-->
  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=studentManagement">
        📚 学生管理画面
      </a>
    </li>
  <% } %>

  <!--* 画面：企業管理画面
        	
  許可されている権限：
        	
  ・就職指導部：egd
  ・システム管理者：admin
        	
   ▼▼▼▼
   *-->

  <% if ("egd".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=CompanyManagement">
        🏢 企業管理画面
      </a>
    </li>
  <% } %>

   <!--* 画面：就職管理画面
        	
     許可されている権限：
        	
     ・教員：teacher
     ・校長・教務部長：headmaster
     ・就職指導部：egd
     ・システム管理者：admin
    ・学生： student
        	
        	
   ▼▼▼▼
   *-->

  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "egd".equals(role) 
         || "admin".equals(role) 
         || "student".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=jobHunting">
        📄 就職管理画面
      </a>
    </li>
  <% } %>

  <!--* 画面：受験者一覧画面
        	
  許可されている権限：
        	
  ・教員：teacher
  ・校長・教務部長：headmaster
  ・就職指導部：egd
  ・システム管理者：admin
        	
        	
   ▼▼▼▼
   *-->

  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "egd".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=applicantList">
        📊 受験者一覧画面
      </a>
    </li>
  <% } %>



  <!--* 画面：受験者一覧画面
        	
   許可されている権限：
        	
   ・システム管理者：admin
        	
        	
   ▼▼▼▼
   *-->


  <% if ("admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=adminDatabase.jsp">
        🛠 管理者DB
      </a>
    </li>
  <% } %>
  
  
    <%-- 想定外の role／未定義の権限チェック --%>
  <% if (username != null
         && !("teacher".equals(role)
           || "headmaster".equals(role)
           || "egd".equals(role)
           || "admin".equals(role)
           || "student".equals(role))) { %>
    <li>アクセスできません</li>
  <% } %>

  <%-- ログアウト --%>
  <% if (username != null) { %>
    <li><a href="LogoutServlet">ログアウト</a></li>
  <% } %>
</ul>
</nav>
</div>
<!--/#menubar-->



<!--jQueryの読み込み-->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="js/main.js"></script>

</body>
</html>