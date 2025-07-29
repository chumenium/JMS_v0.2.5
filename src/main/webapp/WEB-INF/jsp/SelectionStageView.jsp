<!--*
：：：色のテーマは緑：：：
選考ステージ確認画面


**********

<!--* 画面：選考ステージ確認画面
        	
許可されている権限：
・就職指導部：egd
・システム管理者：admin
・教員：teacher
・教務部長・校長：headmaster
・学生：student
 
▼▼▼▼
*-->


<!--確認まだ-->

<!--KCS_JMS_PROJECT-->


<!-- 選考ステージ確認画面用 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% 
  String username = (String) session.getAttribute("id"); 
  String role     = (String) session.getAttribute("role"); 
  

  
  // nullチェック
  if (username == null) {
    username = "ゲスト";
  }
  if (role == null) {
    role = "guest";
  }
  
  // エラーメッセージを取得
  String errorMessage = (String) request.getAttribute("errorMessage");
  String successMessage = (String) request.getAttribute("successMessage");
  java.util.List<Object> selectionStages = (java.util.List<Object>)request.getAttribute("selectionStages");
  java.util.List<beans.CompanyBean> companies = (java.util.List<beans.CompanyBean>)request.getAttribute("companies");
  java.util.List<beans.ExamineeBean> students = (java.util.List<beans.ExamineeBean>)request.getAttribute("students");
  java.util.List<java.util.Map<String, Object>> selectionTypes = (java.util.List<java.util.Map<String, Object>>)request.getAttribute("selectionTypes");
%>


<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - 選考ステージ確認</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">
<style>


/* 全体コンテナ */
.selection-container {
    max-width: 3000px;
    margin: 0 auto;
    padding: 20px;
    background: #f8f9fa;
    min-height: 100vh;
}

/* ヘッダー */
.selection-header {
    background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
    color: white;
    padding: 30px;
    border-radius: 10px;
    margin-bottom: 30px;
    text-align: center;
}

/* 検索セクション */
.search-section {
    background: white;
    border-radius: 10px;
    padding: 25px;
    margin-bottom: 30px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

/* 検索フィールドグリッド */
.search-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
    margin-bottom: 20px;
}

/* フォームグループ */
.form-group {
    display: flex;
    flex-direction: column;
}

.form-group label {
    margin-bottom: 5px;
    font-weight: 600;
    color: #333;
}

.form-group input,
.form-group select {
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
    font-size: 14px;
}

/* 検索入力グループ */
.search-input-group {
    display: flex;
    gap: 10px;
    align-items: center;
}

.search-input-group input {
    flex: 1;
}

.search-input-group button {
    white-space: nowrap;
    padding: 10px 15px;
}

/* 検索ボタン */
.search-buttons {
    display: flex;
    gap: 10px;
    align-items: center;
}

.search-buttons button {
    padding: 10px 20px;
}

/* プライマリボタン */
.btn-primary {
    background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
    color: white;
    padding: 12px 24px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 14px;
    margin: 5px;
    text-decoration: none;
    display: inline-block;
    transition: all 0.3s ease;
    box-shadow: 0 2px 8px rgba(44, 119, 68, 0.2);
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
    color: white;
    text-decoration: none;
}

/* 選考ステージテーブル全体 */
.selection-table {
    background: white;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.table-header {
    background: #2C7744;
    color: white;
    padding: 20px;
}

.table-responsive {
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th, td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #ddd;
}

th {
    background: #f8f9fa;
    font-weight: 600;
    color: #333;
    position: sticky;
    top: 0;
}

tr:hover {
    background: #f8f9fa;
}

/* 状態バッジ */
.status-badge {
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    text-align: center;
    display: inline-block;
    min-width: 80px;
}

.status-considering {
    background: #fff3cd;
    color: #856404;
}

.status-selection {
    background: #d4edda;
    color: #155724;
}

.status-offer {
    background: #d1ecf1;
    color: #0c5460;
}

.status-accepted {
    background: #d4edda;
    color: #155724;
}

.status-rejected {
    background: #f8d7da;
    color: #721c24;
}

/* 概要カード */
.summary-cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 30px;
}

.summary-card {
    background: white;
    border-radius: 10px;
    padding: 20px;
    text-align: center;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    border-left: 4px solid #2C7744;
}

.summary-number {
    font-size: 2em;
    font-weight: bold;
    color: #2C7744;
    margin-bottom: 10px;
}

/* データなし時の表示 */
.no-data {
    text-align: center;
    padding: 50px;
    color: #666;
    font-style: italic;
}

/* 幅間調整用 */
	.custom-section {
    width: 100vw;           /* ビューポート全体の横幅を使用 */
    max-width: none;        /* 最大幅の制限を解除 */
    margin: 0;
    padding: 40px 32px;
    margin-top: 50px; /* ← ヘッダーとの距離をここで確保 */
    margin-bottom: 30px; /* ← 例えば60pxで広めに */
    box-sizing: border-box;
    background-color: #fff;
    color: #fff;
	}
	
	
	
	@media (max-width: 768px) {
	    .custom-section {
	        padding: 32px 16px;
	    }
	}

	@media (max-width: 480px) {
	    .custom-section {
	        padding: 24px 12px;
	    }
	}


</style>
</head>

<body>

<% 
  // 権限名を日本語に変換
  String roleDisplay = "";
  switch(role) {
    case "teacher": roleDisplay = "教員"; break;
    case "headmaster": roleDisplay = "教務部長・校長"; break;
    case "egd": roleDisplay = "就職指導部"; break;
    case "admin": roleDisplay = "システム管理者"; break;
    case "student": roleDisplay = "学生"; break;
    default: roleDisplay = role; break;
  }
%>
<div id="container">
    <!--▼▼▼▼▼ここから「ヘッダー」-->
    <header>
        <h1 id="logo"><a href="${pageContext.request.contextPath}/DashboardServlet"><img src="images/logo.png" alt="jms"></a></h1>
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/DashboardServlet">ホーム</a></li>
                <% if ("teacher".equals(role) || "headmaster".equals(role) || "admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
                <% } %>
                <% if ("egd".equals(role) || "admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
                <% } %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
                <li><a href="extension.html">お問い合わせ</a></li>
                <% if (username != null && !username.equals("ゲスト")) { %>
                    <li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
                <% } %>
            </ul>
        </nav>
    </header>
    <!--▲▲▲▲▲ここまで「ヘッダー」-->

    <main>
    <section class="custom-section" role="main" aria-label="幅調整用">
	        <div class="selection-container">
	            <div class="selection-header">
	                <h1>📊 選考ステージ確認</h1>
	                <p>企業の選考ステージと進捗状況の確認</p>
	            </div>
	
	            <!-- 統計サマリー -->
	            <div class="summary-cards">
	                <div class="summary-card">
	                    <div class="summary-number">0</div>
	                    <div style="color: #000000">総選考ステージ数</div>
	                </div>
	                <div class="summary-card">
	                    <div class="summary-number">0</div>
	                    <div style="color: #000000">選考中</div>
	                </div>
	                <div class="summary-card">
	                    <div class="summary-number">0</div>
	                    <div style="color: #000000">内定者数</div>
	                </div>
	                <div class="summary-card">
	                    <div class="summary-number">0</div>
	                    <div style="color: #000000">不合格者数</div>
	                </div>
	            </div>
	
	            	            <!-- 検索フィルター -->
	            <div class="search-section">
	                <h3>🔍 検索・フィルター</h3>
	                <% if (!"student".equals(role)) { %>
	                <form method="get" action="${pageContext.request.contextPath}/SelectionStageViewServlet">
	                    <div class="search-grid">
	                        <!-- 企業検索 -->
	                        <div class="form-group">
	                            <label for="companySearch">企業検索</label>
	                            <div class="search-input-group">
	                                <input type="text" id="companySearch" name="companySearch" 
	                                       placeholder="企業名を入力してください" 
	                                       value="<%= request.getParameter("companySearch") != null ? request.getParameter("companySearch") : "" %>">
	                                <button type="button" class="btn-primary" onclick="searchCompany()">検索</button>
	                            </div>
	                            <input type="hidden" id="companyId" name="companyId" 
	                                   value="<%= request.getParameter("companyId") != null ? request.getParameter("companyId") : "" %>">
	                            <input type="hidden" id="companyName" name="companyName" 
	                                   value="<%= request.getParameter("companyName") != null ? request.getParameter("companyName") : "" %>">
	                        </div>
	                        
	                        <!-- 学生検索 -->
	                        <div class="form-group">
	                            <label for="studentSearch">学生検索</label>
	                            <div class="search-input-group">
	                                <input type="text" id="studentSearch" name="studentSearch" 
	                                       placeholder="学生名を入力してください" 
	                                       value="<%= request.getParameter("studentSearch") != null ? request.getParameter("studentSearch") : "" %>">
	                                <button type="button" class="btn-primary" onclick="searchStudent()">検索</button>
	                            </div>
	                            <input type="hidden" id="studentId" name="studentId" 
	                                   value="<%= request.getParameter("studentId") != null ? request.getParameter("studentId") : "" %>">
	                            <input type="hidden" id="studentName" name="studentName" 
	                                   value="<%= request.getParameter("studentName") != null ? request.getParameter("studentName") : "" %>">
	                        </div>
	                        
	                        <!-- 選考ステージ検索 -->
	                        <div class="form-group">
	                            <label for="selectionType">選考ステージ</label>
	                            <select id="selectionType" name="selectionType" onchange="this.form.submit()">
	                                <option value="">すべての選考ステージ</option>
	                                <% if (selectionTypes != null) { %>
	                                    <% for (java.util.Map<String, Object> selectionType : selectionTypes) { %>
	                                        <option value="<%= selectionType.get("selection_name") %>" 
	                                            <% if (request.getParameter("selectionType") != null && 
	                                                   request.getParameter("selectionType").equals(selectionType.get("selection_name"))) { %>selected<% } %>>
	                                            <%= selectionType.get("selection_name") %>
	                                        </option>
	                                    <% } %>
	                                <% } %>
	                            </select>
	                        </div>
	                        
	                        <!-- 検索ボタン -->
	                        <div class="form-group">
	                            <label>&nbsp;</label>
	                            <div class="search-buttons">
	                                <button type="submit" class="btn-primary">🔍 検索実行</button>
	                                <button type="button" class="btn-primary" onclick="clearSearch()">🔄 クリア</button>
	                            </div>
	                        </div>
	                    </div>
	                </form>
	                <% } %>
	            </div>
	
	            <!-- 選考ステージ一覧テーブル -->
	            <div class="selection-table">
	                <div class="table-header">
	                    <h3>📋 選考ステージ一覧</h3>
	                </div>
	                <div class="table-responsive">
	                    <table>
	                        <thead>
	                            <tr>
	                                <th>学生名</th>
	                                <th>企業名</th>
	                                <th>選考ステージ</th>
	                                <th>日付</th>
	                                <th>時間</th>
	                                <th>場所</th>
	                                <th>備考</th>
	                                <th>操作</th>
	                            </tr>
	                        </thead>
	                        <tbody>
	                            <% if (selectionStages != null && !selectionStages.isEmpty()) { %>
	                                <% for (Object stage : selectionStages) { %>
	                                    <% java.util.Map<String, Object> stageMap = (java.util.Map<String, Object>) stage; %>
	                                    <tr style="color: #000000">
	                                        <td><%= stageMap.get("student_name") != null ? stageMap.get("student_name") : "" %></td>
	                                        <td><%= stageMap.get("company_name") != null ? stageMap.get("company_name") : "" %></td>
	                                        <td><span class="status-badge status-selection"><%= stageMap.get("selection_name") != null ? stageMap.get("selection_name") : "" %></span></td>
	                                        <td><%= stageMap.get("date") != null ? stageMap.get("date") : "" %></td>
	                                        <td><%= stageMap.get("time") != null ? stageMap.get("time") : "" %></td>
	                                        <td><%= stageMap.get("venue") != null ? stageMap.get("venue") : "" %></td>
	                                        <td><%= stageMap.get("remarks") != null ? stageMap.get("remarks") : "" %></td>
	                                        <td>
	                                            <a href="${pageContext.request.contextPath}/StudentDetailServlet?id=<%= stageMap.get("student_id") %>" class="btn-primary" style="font-size: 12px; padding: 6px 12px;">詳細</a>
	                                            <a href="${pageContext.request.contextPath}/SelectionStageViewServlet?action=edit&studentId=<%= stageMap.get("student_id") %>&companyId=<%= stageMap.get("companys_id") %>" class="btn-primary" style="font-size: 12px; padding: 6px 12px; margin-left: 5px;">編集</a>
	                                        </td>
	                                    </tr>
	                                <% } %>
	                            <% } else { %>
	                                <tr>
	                                    <td colspan="8" class="no-data">
	                                        <p>📝 現在、選考ステージデータがありません。</p>
	                                        <p>選考ステージが登録されると、ここに表示されます。</p>
	                                    </td>
	                                </tr>
	                            <% } %>
	                        </tbody>
	                    </table>
	                </div>
	            </div>
	        </div>
	    </section>
    </main>
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
                <li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
                <!-- 権限に応じた機能リンク -->
                <% if ("teacher".equals(role) || "headmaster".equals(role) || "admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
                <% } %>
                <% if ("egd".equals(role) || "admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
                <% } %>
                <% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role) || "student".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
                <% } %>
                <% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=applicantList">受験者一覧</a></li>
                <% } %>
                <% if ("admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase">システム管理</a></li>
                <% } %>
                <li><a href="extension.html">お問い合わせ</a></li>
            </ul>
        </div>
    </footer>
    <!--▲▲▲▲▲ここまで「フッター」-->

    <!--▼▼最下部-->
    <span class="pr"><a href="" target="_blank">@ 2025 Job Management System</a></span>
    <!--▲▲ここまで最下部-->
    
</div>

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

<!--開閉ブロック-->
<div id="menubar">
    <p class="logo"><img src="images/logo.png" alt="Job Management System"></p>
    <nav>
        <ul>
            <li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
            <!-- 権限に応じた機能リンク -->
            <% if ("teacher".equals(role) || "headmaster".equals(role) || "admin".equals(role)) { %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
            <% } %>
            <% if ("egd".equals(role) || "admin".equals(role)) { %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
            <% } %>
            <% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role) || "student".equals(role)) { %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
            <% } %>
            <% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role)) { %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=applicantList">受験者一覧</a></li>
            <% } %>
            <% if ("admin".equals(role)) { %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase">システム管理</a></li>
            <% } %>
            <li><a href="extension.html">お問い合わせ</a></li>
            <% if (username != null && !username.equals("ゲスト")) { %>
                <li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
            <% } %>
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


<script>
// ページ読み込み時の処理
document.addEventListener('DOMContentLoaded', function() {
    console.log('選考ステージ確認画面が読み込まれました');
    
    // 統計数値の更新（実際の実装では動的に計算）
    updateSummaryCards();
});

function updateSummaryCards() {
    // 実際の実装では、サーバーサイドからデータを取得して更新
    const totalStages = document.querySelectorAll('tbody tr').length;
    const summaryNumbers = document.querySelectorAll('.summary-number');
    
    if (summaryNumbers.length >= 4) {
        summaryNumbers[0].textContent = totalStages;
        
        // 選考中の数をカウント
        const inProgress = document.querySelectorAll('.status-selection, .status-considering').length;
        summaryNumbers[1].textContent = inProgress;
        
        // 内定者数をカウント
        const passed = document.querySelectorAll('.status-accepted').length;
        summaryNumbers[2].textContent = passed;
        
        // 不合格者数をカウント
        const failed = document.querySelectorAll('.status-rejected').length;
        summaryNumbers[3].textContent = failed;
    }
}

// 企業検索機能
function searchCompany() {
    const searchTerm = document.getElementById('companySearch').value;
    if (searchTerm.trim() === '') {
        alert('企業名を入力してください。');
        return;
    }
    
    // 検索結果画面に遷移
    window.open('${pageContext.request.contextPath}/SearchServlet?type=company&term=' + encodeURIComponent(searchTerm), 
                'searchWindow', 'width=600,height=400,scrollbars=yes,resizable=yes');
}

// 学生検索機能
function searchStudent() {
    const searchTerm = document.getElementById('studentSearch').value;
    if (searchTerm.trim() === '') {
        alert('学生名を入力してください。');
        return;
    }
    
    // 検索結果画面に遷移
    window.open('${pageContext.request.contextPath}/SearchServlet?type=student&term=' + encodeURIComponent(searchTerm), 
                'searchWindow', 'width=600,height=400,scrollbars=yes,resizable=yes');
}

// 企業選択関数（検索結果から呼び出される）
function selectCompany(companyId, companyName) {
    document.getElementById('companyId').value = companyId;
    document.getElementById('companyName').value = companyName;
    document.getElementById('companySearch').value = companyName;
    
    // 自動的にフォームを送信
    setTimeout(() => {
        document.querySelector('form').submit();
    }, 100);
}

// 学生選択関数（検索結果から呼び出される）
function selectStudent(studentId, studentName) {
    document.getElementById('studentId').value = studentId;
    document.getElementById('studentName').value = studentName;
    document.getElementById('studentSearch').value = studentName;
    
    // 自動的にフォームを送信
    setTimeout(() => {
        document.querySelector('form').submit();
    }, 100);
}

// 検索結果を受け取る関数
function setSearchResult(id, name, type) {
    if (type === 'company') {
        document.getElementById('companyId').value = id;
        document.getElementById('companyName').value = name;
        document.getElementById('companySearch').value = name;
    } else if (type === 'student') {
        document.getElementById('studentId').value = id;
        document.getElementById('studentName').value = name;
        document.getElementById('studentSearch').value = name;
    }
}

// 検索結果から企業を選択
function selectCompany(companyId, companyName) {
    document.getElementById('companyId').value = companyId;
    document.getElementById('companyName').value = companyName;
    document.getElementById('companySearch').value = companyName;
    window.close();
}

// 検索結果から学生を選択
function selectStudent(studentId, studentName) {
    document.getElementById('studentId').value = studentId;
    document.getElementById('studentName').value = studentName;
    document.getElementById('studentSearch').value = studentName;
    window.close();
}

// 検索条件をクリア
function clearSearch() {
    document.getElementById('companySearch').value = '';
    document.getElementById('companyId').value = '';
    document.getElementById('companyName').value = '';
    document.getElementById('studentSearch').value = '';
    document.getElementById('studentId').value = '';
    document.getElementById('studentName').value = '';
    document.getElementById('selectionType').value = '';
    
    // フォームを送信
    document.querySelector('form').submit();
}
</script>

</body>
</html> 