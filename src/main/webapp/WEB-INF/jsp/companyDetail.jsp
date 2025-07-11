<<<<<<< HEAD
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
=======


<!--*
：：：色のテーマは緑：：：
【企業詳細】画面


**********

<!--* 画面：【企業詳細】
        	
許可されている権限：
・教員：teacher
・校長・教務部長：headmaster
・システム管理者：admin
 
▼▼▼▼
*-->


<!--確認まだ-->

<!--KCS_JMS_PROJECT-->


<!-- 【企業詳細】画面用 -->



<!--▼▼▼▼▼スコープから取得する情報　これをもとに判定をしていく -->
<% 
  int companys_id = (Integer) session.getAttribute("companys_id");
  String companys_name = (String) session.getAttribute("companys_name");
  String post_code = (String) session.getAttribute("post_code");
  String address = (String) session.getAttribute("address");
  String tel = (String) session.getAttribute("tel");
  String mail_address = (String) session.getAttribute("mail_address");
  String manager_name = (String) session.getAttribute("manager_name");
  boolean recruit_results = (Boolean) session.getAttribute("recruit_results");
  int work_place_id = (Integer) session.getAttribute("work_place_id");
  int occupation_id = (Integer) session.getAttribute("occupation_id");
%>
<!--▲▲▲▲▲-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
>>>>>>> edc6913df04cde7f03b5c6047a04d911a07a3a83
<!DOCTYPE html>
<html>
<head>
<<<<<<< HEAD
    <meta charset="UTF-8">
    <title>企業詳細</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .button-group {
            margin-top: 20px;
            text-align: center;
        }
        .btn {
            padding: 10px 20px;
            margin: 0 5px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .readonly {
            background-color: #f8f9fa;
            color: #6c757d;
        }
        .error-message {
            color: #dc3545;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>企業詳細</h1>
        
        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>
        
        <form method="post" action="${pageContext.request.contextPath}/CompanyDetailServlet">
            <input type="hidden" name="companyId" value="${company.companyId}">
            
            <div class="form-group">
                <label for="companyName">企業名:</label>
                <input type="text" id="companyName" name="companyName" 
                       value="${company.companyName}" 
                       ${isEditMode ? '' : 'readonly class="readonly"'} required>
            </div>
            
            <div class="form-group">
                <label for="postCode">郵便番号:</label>
                <input type="text" id="postCode" name="postCode" 
                       value="${company.postCode}" 
                       ${isEditMode ? '' : 'readonly class="readonly"'}>
            </div>
            
            <div class="form-group">
                <label for="address">住所:</label>
                <input type="text" id="address" name="address" 
                       value="${company.address}" 
                       ${isEditMode ? '' : 'readonly class="readonly"'}>
            </div>
            
            <div class="form-group">
                <label for="tel">電話番号:</label>
                <input type="text" id="tel" name="tel" 
                       value="${company.tel}" 
                       ${isEditMode ? '' : 'readonly class="readonly"'}>
            </div>
            
            <div class="form-group">
                <label for="mailAddress">メールアドレス:</label>
                <input type="email" id="mailAddress" name="mailAddress" 
                       value="${company.mailAddress}" 
                       ${isEditMode ? '' : 'readonly class="readonly"'}>
            </div>
            
            <div class="form-group">
                <label for="managerName">担当者名:</label>
                <input type="text" id="managerName" name="managerName" 
                       value="${company.managerName}" 
                       ${isEditMode ? '' : 'readonly class="readonly"'}>
            </div>
            
            <div class="form-group">
                <label for="workPlace">勤務地:</label>
                <c:choose>
                    <c:when test="${isEditMode}">
                        <select id="workPlace" name="workPlace">
                            <c:forEach items="${workPlaces}" var="place">
                                <option value="${place}" ${place eq workPlaceName ? 'selected' : ''}>${place}</option>
                            </c:forEach>
                        </select>
                    </c:when>
                    <c:otherwise>
                        <input type="text" value="${workPlaceName}" readonly class="readonly">
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="form-group">
                <label for="occupation">職種:</label>
                <c:choose>
                    <c:when test="${isEditMode}">
                        <select id="occupation" name="occupation">
                            <c:forEach items="${occupations}" var="occ">
                                <option value="${occ}" ${occ eq occupationName ? 'selected' : ''}>${occ}</option>
                            </c:forEach>
                        </select>
                    </c:when>
                    <c:otherwise>
                        <input type="text" value="${occupationName}" readonly class="readonly">
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="form-group">
                <label>
                    <input type="checkbox" name="recruitmentResults" value="true" 
                           ${company.recruitmentResults ? 'checked' : ''} 
                           ${isEditMode ? '' : 'disabled'}>
                    採用実績あり
                </label>
            </div>
            
            <div class="button-group">
                <c:choose>
                    <c:when test="${isEditMode}">
                        <button type="submit" class="btn btn-primary">更新</button>
                        <a href="${pageContext.request.contextPath}/CompanyDetailServlet?companyId=${company.companyId}" 
                           class="btn btn-secondary">キャンセル</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/CompanyDetailServlet?companyId=${company.companyId}&mode=edit" 
                           class="btn btn-primary">編集</a>
                        <button type="button" class="btn btn-danger" id="btn-delete">削除</button>
                        <a href="${pageContext.request.contextPath}/CompanyListServlet" 
                           class="btn btn-secondary">一覧に戻る</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </form>
        
        <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/CompanyDetailServlet" style="display: none;">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="companyId" value="${company.companyId}">
        </form>
        
        <!-- 削除確認ポップアップ -->
        <div id="delete-confirm-modal" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.35); z-index:9999; align-items:center; justify-content:center;">
            <div style="background:#fff; color:#222; border-radius:10px; padding:32px 24px; min-width:280px; max-width:90vw; box-shadow:0 4px 24px rgba(0,0,0,0.18); text-align:center;">
                <div style="font-size:18px; font-weight:600; margin-bottom:18px;">本当に削除しますか？</div>
                <div style="margin-bottom:24px; color:#c42f2f; font-size:15px;">この操作は元に戻せません。</div>
                <button id="confirm-delete-btn" class="btn btn-danger" style="margin-right:12px;">削除</button>
                <button id="cancel-delete-btn" class="btn btn-secondary">キャンセル</button>
            </div>
        </div>
    </div>
    
    <script>
        var delete_btn = document.getElementById('btn-delete');
        var modal = document.getElementById('delete-confirm-modal');
        var confirmBtn = document.getElementById('confirm-delete-btn');
        var cancelBtn = document.getElementById('cancel-delete-btn');

        if (delete_btn) {
            delete_btn.addEventListener('click', function() {
                modal.style.display = 'flex';
            });
        }
        
        if (cancelBtn) {
            cancelBtn.addEventListener('click', function() {
                modal.style.display = 'none';
            });
        }
        
        if (confirmBtn) {
            confirmBtn.addEventListener('click', function() {
                modal.style.display = 'none';
                document.getElementById('deleteForm').submit();
            });
        }
    </script>
=======
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=applicantList">
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">
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
    <li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
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
    <ul aria-colcount="2">
        <li>企業ID : <textarea><%= companys_id %></textarea></li>
        <li>企業名 : <textarea><%= companys_name %></textarea></li>
        <li>郵便番号 : <textarea><%= post_code %></textarea></li>
        <li>住所 : <textarea><%= address %></textarea></li>
        <li>電話番号 : <textarea><%= tel %></textarea></li>
        <li>メールアドレス : <textarea><%= mail_address %></textarea></li>
        <li>担当者名 : <textarea><%= manager_name %></textarea></li>
        <li>採用実績 : <textarea><%= recruit_results %></textarea></li>
        <li>勤務地 : <textarea><%= work_place_id %></textarea></li>
        <li>職種 : <textarea><%= occupation_id %></textarea></li>
    </ul>
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=applicantList">
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">
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
    <li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=applicantList">
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
      <a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">
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
    <li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
  <% } %>
</ul>
</nav>
</div>
<!--/#menubar-->



<!--jQueryの読み込み-->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="js/main.js"></script>

>>>>>>> edc6913df04cde7f03b5c6047a04d911a07a3a83
</body>
</html> 