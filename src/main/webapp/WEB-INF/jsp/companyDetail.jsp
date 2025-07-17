

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
    <!DOCTYPE html>
    <html lang="ja">
    <head>
        <meta charset="UTF-8">
        <title>学生詳細・編集</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="css/style.css">
        <style>
            body {
                background: #f8f9fa;
                color: #2c3e50;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                line-height: 1.6;
            }
            .edit-container {
                max-width: 1400px;
                width: 96vw;
                margin: 40px auto;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 0 20px rgba(44, 119, 68, 0.08);
                padding: 40px 2vw;
                box-sizing: border-box;
            }
            @media (max-width: 1400px) {
                .edit-container {
                    padding: 32px 1vw;
                }
            }
            @media (max-width: 768px) {
                .edit-container {
                    margin: 20px 0;
                    padding: 16px 2vw;
                }
            }
            @media (max-width: 480px) {
                .edit-container {
                    margin: 8px 0;
                    padding: 8px 1vw;
                }
            }
            .edit-title {
                font-size: 28px;
                color: #2C7744;
                font-weight: 700;
                margin-bottom: 24px;
                text-align: center;
            }
            .student-info {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 24px;
                margin-bottom: 32px;
            }
            
            @media (max-width: 768px) {
                .student-info {
                    grid-template-columns: 1fr;
                    gap: 16px;
                }
                
                .edit-container {
                    margin: 20px;
                    padding: 20px;
                }
                
                .edit-title {
                    font-size: 24px;
                }
                
                .info-section {
                    padding: 16px;
                }
                
                .info-section h3 {
                    font-size: 16px;
                }
                
                .form-group input[type="text"],
                .form-group input[type="email"],
                .form-group input[type="tel"],
                .form-group select,
                .form-group textarea {
                    font-size: 16px;
                    padding: 14px 16px;
                    min-height: 52px;
                }
                
                .form-group label {
                    font-size: 16px;
                    margin-bottom: 6px;
                }
                
                .btn {
                    padding: 14px 20px;
                    font-size: 16px;
                    min-width: 100px;
                    min-height: 52px;
                    margin-bottom: 8px;
                }
            }
            
            @media (max-width: 480px) {
                .edit-container {
                    margin: 12px;
                    padding: 16px;
                }
                
                .edit-title {
                    font-size: 20px;
                }
                
                .info-section {
                    padding: 12px;
                }
                
                .info-section h3 {
                    font-size: 18px;
                }
                
                .form-group input[type="text"],
                .form-group input[type="email"],
                .form-group input[type="tel"],
                .form-group select,
                .form-group textarea {
                    font-size: 18px;
                    padding: 16px 20px;
                    min-height: 56px;
                }
                
                .form-group label {
                    font-size: 18px;
                }
                
                .btn {
                    padding: 16px 24px;
                    font-size: 18px;
                    min-height: 56px;
                }
            }
            .info-section {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                border-left: 4px solid #2C7744;
            }
            .info-section h3 {
                color: #2C7744;
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 16px;
                border-bottom: 2px solid #e9ecef;
                padding-bottom: 8px;
            }
            .form-group {
                margin-bottom: 16px;
            }
            .form-group label {
                display: block;
                margin-bottom: 6px;
                font-weight: 600;
                color: #495057;
                font-size: 14px;
            }
            .form-group input[type="text"],
            .form-group input[type="email"],
            .form-group input[type="tel"],
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 12px 16px;
                border: 1.5px solid #e9ecef;
                border-radius: 8px;
                font-size: 16px;
                background: #fff;
                transition: all 0.2s ease;
                box-sizing: border-box;
                min-height: 48px;
            }
            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
                border-color: #2C7744;
                outline: none;
                box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.1);
            }
            .form-group input[readonly] {
                background: #f8f9fa;
                color: #6c757d;
                cursor: not-allowed;
                border-color: #dee2e6;
            }
            .action-buttons {
                text-align: center;
                margin-top: 32px;
                padding-top: 24px;
                border-top: 1px solid #e9ecef;
            }
            
            @media (max-width: 768px) {
                .action-buttons {
                    margin-top: 24px;
                    padding-top: 16px;
                }
            }
            .btn {
                background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
                color: white;
                border: none;
                border-radius: 8px;
                padding: 12px 32px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
                box-shadow: 0 2px 8px rgba(44, 119, 68, 0.15);
                margin-right: 12px;
                text-decoration: none;
                display: inline-block;
                min-width: 120px;
                min-height: 48px;
            }
            
            @media (max-width: 768px) {
                .btn {
                    padding: 14px 20px;
                    font-size: 16px;
                    min-width: 100px;
                    min-height: 52px;
                    margin-bottom: 8px;
                }
            }
            .btn:hover {
                background: #388E3C;
                transform: translateY(-1px);
                box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
            }
            .btn-secondary {
                background: #6c757d;
                color: #fff;
            }
            .btn-secondary:hover {
                background: #495057;
            }
            .back-link {
                display: inline-block;
                margin-top: 24px;
                color: #2C7744;
                text-decoration: underline;
                font-weight: 600;
            }
            .back-link:hover {
                color: #388E3C;
            }
        </style>
        <style>
        @media (prefers-color-scheme: dark) {
            body {
                background: #181a1b;
                color: #f1f1f1;
            }
            .edit-container {
                background: #23272a;
                box-shadow: 0 0 20px rgba(44, 119, 68, 0.18);
            }
            .edit-title {
                color: #7fffd4;
            }
            .info-section {
                background: #2c2f33;
                border-left-color: #7fffd4;
            }
            .info-section h3 {
                color: #7fffd4;
                border-bottom-color: #40444b;
            }
            .form-group label {
                color: #dcddde;
            }
            .form-group input[type="text"],
            .form-group input[type="email"],
            .form-group input[type="tel"],
            .form-group select,
            .form-group textarea {
                background: #23272a;
                color: #f1f1f1;
                border-color: #40444b;
            }
            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
                border-color: #7fffd4;
            }
            .form-group input[readonly] {
                background: #2c2f33 !important;
                color: #72767d !important;
                border-color: #40444b;
            }
            .action-buttons {
                border-top-color: #40444b;
            }
            .back-link {
                color: #7fffd4;
            }
            .back-link:hover {
                color: #fff;
            }
        }
        @media (max-width: 768px) {
            .student-info {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            .edit-container {
                margin: 20px;
                padding: 20px;
            }
        }
        </style>
    </head>
    <body>
        <div class="edit-container">
            <h2 class="edit-title">企業詳細・編集</h2>
            <form class="edit-form" action="StudentDetailServlet" method="post">
                <div class="student-info">
                    <div class="info-section">
                        <div class="form-group">
                          <!-- <li>企業ID : <textarea><%= companys_id %></textarea></li>
                          <li>企業名 : <textarea><%= companys_name %></textarea></li>
                          <li>郵便番号 : <textarea><%= post_code %></textarea></li>
                          <li>住所 : <textarea><%= address %></textarea></li>
                          <li>電話番号 : <textarea><%= tel %></textarea></li>
                          <li>メールアドレス : <textarea><%= mail_address %></textarea></li>
                          <li>担当者名 : <textarea><%= manager_name %></textarea></li>
                          <li>採用実績 : <textarea><%= recruit_results %></textarea></li>
                          <li>勤務地 : <textarea><%= work_place_id %></textarea></li>
                          <li>職種 : <textarea><%= occupation_id %></textarea></li> -->
                            <label for="companyId">企業ID</label>
                            <input type="text" id="companyId" name="companyId" value="<%= company != null ? company.getCompanyId() : "" %>" readonly>
                        </div>
                        <div class="form-group">
                            <label for="companyName">企業名</label>
                            <input type="text" id="companyName" name="companyName" value="<%= company != null ? company.getCompanyName() : "" %>" readonly>
                        </div>
                        <div class="form-group">
                            <label for="postCode">郵便番号</label>
                            <input type="text" id="postCode" name="postCode" value="<%= company != null ? company.getPostCode() : "" %>" >
                        </div>
                        <div class="form-group">
                            <label for="address">住所</label>
                            <input type="text" id="address" name="address" value="<%= company != null ? company.getAddress() : "" %>" >
                        </div>
                        <div class="form-group">
                            <label for="tel">電話番号</label>
                            <input type="text" id="tel" name="tel" value="<%= company != null ? company.getTel() : "" %>" >
                        </div>
                        <div class="form-group">
                            <label for="mailAddress">メールアドレス</label>
                            <input type="text" id="mailAddress" name="mailAddress" value="<%= company != null ? company.getMailAddress() : "" %>" >
                        </div>
                        <div class="form-group">
                            <label for="managerName">担当者名</label>
                            <input type="text" id="managerName" name="managerName" value="<%= company != null ? company.getManagerName() : "" %>" >
                        </div>
                        <div class="form-group">
                            <label for="recruitmentResults">採用実績</label>
                            <input type="text" id="recruitmentResults" name="recruitmentResults" value="<%= company != null && company.getRecruitmentResults() ? "あり" : "なし" %>" readonly>
                        </div>
                        <div class="form-group">
                            <label for="workPlace">勤務地</label>
                            <input type="text" id="workPlace" name="workPlace" value="<%= request.getAttribute("workPlaceName") != null ? request.getAttribute("workPlaceName") : "" %>" readonly>
                        </div>
                        <div class="form-group">
                            <label for="occupation">職種</label>
                            <input type="text" id="occupation" name="occupation" value="<%= request.getAttribute("occupationName") != null ? request.getAttribute("occupationName") : "" %>" readonly>
                        </div>
                    </div>
<!--     
                    <div class="info-section">
                        <h3>職種・勤務地</h3>
                        <div class="form-group">
                            <label for="desiredJobType1">職種</label>
                            <select id="desiredJobType1" name="desiredJobType1">
                                <option value="0">選択してください</option>
                                <% java.util.List<String> jobtypes = (java.util.List<String>) request.getAttribute("jobtypes");
                                   String selected1 = student != null ? student.getDesiredJobType1() : "";
                                   if (jobtypes != null) {
                                     int i = 1;
                                     for (String jobtype : jobtypes) { %>
                                        <option value="<%= i %>" <%= jobtype.equals(selected1) ? "selected" : "" %>><%= jobtype %></option>
                                        
                                <%  i+=1; } } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="desiredWorkPlace">希望勤務地</label>
                            <% int l = 0 ;%>
                            <% if(student != null && student.getDesiredWorkPlace() != null) { %>
                                <% for(String selectedWp1 : student.getDesiredWorkPlace()) { %>
                                    <select id="<%= "desiredWorkPlace"+String.valueOf(l)%>" name="desiredWorkPlace<%= l %>">
                                        <option value="<%= selectedWp1 %>"><%= selectedWp1 %></option>
                                        <option value="">未設定</option>
                                        <% java.util.List<String> workplaces = (java.util.List<String>) request.getAttribute("workplaces");
                                        
                                        if (workplaces != null) {
                                            for (String wp : workplaces) { %>
                                                <option value="<%= wp %>" ><%= wp %></option>
                                        <%   } } %>
                                    </select>
                                <% l+=1;%>
                            <% } }%>
                            <div id="workplace-container">
                                <select id="<%= "desiredWorkPlace"+String.valueOf(l)%>" name="desiredWorkPlace<%= l %>">
                                    <% l+=1; %>
                                    <option value="">未設定</option>
                                    <% java.util.List<String> workplaces = (java.util.List<String>) request.getAttribute("workplaces");
                                    
                                    if (workplaces != null) {
                                        for (String wp : workplaces) { %>
                                            <option value="<%= wp %>" ><%= wp %></option>
                                    <%   } } %>
                                </select>
                            </div>
                            <button type="button" id="add-workplace-btn">希望勤務地を増やす＋</button>
                        </div>
                    </div> -->
                    
                  </div>
                </div>
    
                <div class="action-buttons">
                    <input type="hidden" id="maxWorkPlaceIndex" name="number99" value="<%= l-1 %>">
                    <div id="updating-indicator" style="display:none; margin-top:10px; color:#007bff; font-weight:bold;">
                        <span class="spinner"></span> 更新中...
                    </div>
                    <button type="submit" class="btn" id="updateBtn">更新</button>
                    <a href="CompanyListServlet" class="btn btn-secondary">一覧に戻る</a>
                </div>
            </form>
        </div>
        <style>
          .spinner {
            display: inline-block;
            width: 18px;
            height: 18px;
            border: 3px solid #cce3ff;
            border-top: 3px solid #007bff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-right: 8px;
            vertical-align: middle;
          }
          @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
          }
        </style>
        <script>
            document.getElementById('add-workplace-btn').addEventListener('click', function() {
                var container = document.getElementById('workplace-container');
                var maxIndexInput = document.getElementById('maxWorkPlaceIndex');
                var currentIndex = parseInt(maxIndexInput.value, 10);
    
                var newIndex = currentIndex + 1;
                var selects = container.getElementsByTagName('select');
                var maxIndex = -1;
                for (var i = 0; i < selects.length; i++) {
                    var id = selects[i].id;
                    var match = id.match(/^desiredWorkPlace(\d+)$/);
                    if (match) {
                        var num = parseInt(match[1], 10);
                        if (num > maxIndex) maxIndex = num;
                    }
                }
                // 新しいselectを追加
                var newIndex = maxIndex + 1;
                var newSelect = selects[selects.length - 1].cloneNode(true);
                newSelect.id = "desiredWorkPlace" + newIndex;
                newSelect.name = "desiredWorkPlace" + newIndex;
                newSelect.selectedIndex = 0;
                container.appendChild(newSelect);
                // hiddenの値を「新しい最大連番」に更新
                maxIndexInput.value = newIndex;
                console.log(maxIndexInput.value);
            });
            // 更新ボタン押下時にアニメーション表示
            document.getElementById('updateBtn').addEventListener('click', function() {
              document.getElementById('updating-indicator').style.display = 'block';
            });
        </script>
    </body>
    </html> 
<!-- <!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>temp</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">
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
ここまで
</head>
<body>
<div id="container">
▼▼▼▼▼ここから「ヘッダー」
<header>
▼▼▼▼ 画面上部アイコン
<h1 id="logo"><a href="index.html"><img src="images/logo.png" alt="jms"></a></h1>
▲▲▲▲

ヘッダー上部分のリスト

<nav>
<ul>
  <%-- ユーザ名・権限表示 --%>
  <% if (username != null) { %>
    <li>こんにちは、<%= username %>さん</li>
    <li><%= username %>さんの権限は<%= role %>です</li>
  <% } else { %>
    <li><a href="login.html">ログイン</a></li>
  <% } %>

  * 画面：学生管理画面
        	
   許可されている権限：
        	
   ・教員：teacher
   ・校長・教務部長：headmaster
   ・システム管理者：admin
        	
    ▼▼▼▼
    *
  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">
        📚 学生管理画面
      </a>
    </li>
  <% } %>

  <% if ("egd".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">
        🏢 企業管理画面
      </a>
    </li>
  <% } %>

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

</header>

<div id="mainimg">
<div>

<div class="text">
<p>あなたのベストな、<br>
ワンランク上の<br>
就職先を提案します。</p>
</div>


<div class="btn">
<p><a href="extension.html"><i class="fa-regular fa-envelope"></i>お問い合わせ</a></p>
<p><a href="extension.html"><i class="fa-regular fa-file-lines"></i>資料請求</a></p>
</div>

</div>
</div>






<main>
<section class="bg3 bg-pattern3" id="main">
    <div class="dashboard">
        <h1>企業詳細情報</h1>
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

        <div style="margin-top: 30px; text-align: center;">
            <a href="${pageContext.request.contextPath}/CompanyManagementServlet?action=edit&id=<%= companys_id %>" 
               class="btn btn-primary" style="margin-right: 10px;">編集</a>
            <a href="${pageContext.request.contextPath}/InterviewExamViewServlet?companyId=<%= companys_id %>" 
               class="btn btn-info" style="margin-right: 10px;">情報を見る</a>
            <a href="${pageContext.request.contextPath}/InterviewExamInputServlet" 
               class="btn btn-success" style="margin-right: 10px;">試験・面接内容登録</a>
            <a href="${pageContext.request.contextPath}/CompanyListServlet" 
               class="btn btn-secondary">企業一覧へ戻る</a>
        </div>
    </div>
</section>
</main>





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

  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">
        📚 学生管理画面
      </a>
    </li>
  <% } %>

  <% if ("egd".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">
        🏢 企業管理画面
      </a>
    </li>
  <% } %>

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


</div>

<div id="loading">
<img src="images/logo.png" alt="Loading">
<div class="progress-container">
<div class="progress-bar"></div>
</div>
</div>


<div id="menubar_hdr">
<span></span><span></span><span></span>
</div>
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

  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">
        📚 学生管理画面
      </a>
    </li>
  <% } %>


  <% if ("egd".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">
        🏢 企業管理画面
      </a>
    </li>
  <% } %>



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

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="js/main.js"></script>

</body>
</html> -->
