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
    /* システム上見やすさを追求した選考ステージ確認画面デザイン */
    
    /* 全体の設定 */
    .selection-stage-page {
        background: #f8f9fa;
        color: #2c3e50;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        line-height: 1.6;
    }

    .selection-stage-container {
        position: relative;
        max-width: 3000px;
        margin: 0 auto;
        padding: 24px;
        min-height: calc(100vh - 300px);
        background: #ffffff;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
    }

    footer {
        padding: 40px 20px;
        clear: both;
        margin-top: 150px;
    }

    /* ページヘッダー - 視認性向上 */
    .page-header {
        background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
        border-radius: 12px;
        padding: 32px;
        margin-bottom: 32px;
        box-shadow: 0 4px 20px rgba(44, 119, 68, 0.15);
        color: #000000;
        text-align: center;
        position: relative;
        overflow: hidden;
    }

    .page-title {
        font-size: 32px;
        color: #000000;
        margin-bottom: 12px;
        font-weight: 700;
        text-shadow: 0 1px 2px rgba(255, 255, 255, 0.3);
    }

    .breadcrumb {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 12px;
        font-size: 14px;
        color: #000000;
        margin-top: 16px;
    }

    .breadcrumb a {
        color: #000000;
        text-decoration: none;
        transition: all 0.2s ease;
        padding: 6px 12px;
        border-radius: 6px;
        background: rgba(255, 255, 255, 0.3);
        border: 1px solid rgba(255, 255, 255, 0.4);
        font-weight: 600;
    }

    .breadcrumb a:hover {
        background: rgba(255, 255, 255, 0.5);
        transform: translateY(-1px);
        color: #000000;
    }

    .breadcrumb .separator {
        color: #000000;
        font-weight: 600;
    }

    /* 検索バー - 視認性と操作性の向上 */
    .search-section {
        background: white;
        border-radius: 12px;
        padding: 24px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        margin-bottom: 24px;
    }

    .search-section h3 {
        margin-bottom: 20px;
        color: #2C7744;
        font-size: 18px;
        font-weight: 600;
    }

    .search-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 20px;
    }

    .form-group {
        display: flex;
        flex-direction: column;
    }

    .form-group label {
        margin-bottom: 8px;
        font-weight: 600;
        color: #2c3e50;
        font-size: 14px;
    }

    .form-group input,
    .form-group select {
        padding: 12px 16px;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        font-size: 16px;
        transition: all 0.2s ease;
        background: #ffffff;
        color: #2c3e50;
    }

    .form-group input:focus,
    .form-group select:focus {
        outline: none;
        border-color: #2C7744;
        box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.1);
    }

    .search-input-group {
        display: flex;
        gap: 12px;
        align-items: center;
    }

    .search-input-group input {
        flex: 1;
    }

    .search-buttons {
        display: flex;
        gap: 12px;
        align-items: center;
    }

    /* ボタンスタイル */
    .btn-primary {
        background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
        color: white;
        padding: 12px 24px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        display: inline-block;
        transition: all 0.2s ease;
        box-shadow: 0 2px 8px rgba(44, 119, 68, 0.2);
    }

    .btn-primary:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
        color: white;
        text-decoration: none;
    }

    /* 選考ステージテーブル - 視認性と操作性の向上 */
    .selection-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        margin-bottom: 24px;
        border: 1px solid #e9ecef;
    }

    .selection-table th, .selection-table td {
        padding: 16px 12px;
        text-align: left;
        border-bottom: 1px solid #e9ecef;
    }

    .selection-table th {
        background: linear-gradient(135deg, #e9f5ee 0%, #f1f8f5 100%);
        color: #2C7744;
        font-size: 16px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .selection-table tr:last-child td {
        border-bottom: none;
    }

    .selection-table tr:hover {
        background: linear-gradient(135deg, #f1f8f5 0%, #e9f5ee 100%);
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(44, 119, 68, 0.1);
    }

    .selection-table tr {
        transition: all 0.2s ease;
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
        border-radius: 12px;
        padding: 20px;
        text-align: center;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        transition: all 0.2s ease;
    }

    .summary-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 20px rgba(44, 119, 68, 0.15);
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
        color: #6c757d;
        font-style: italic;
    }

    /* レスポンシブ対応の強化 */
    @media (max-width: 768px) {
        .selection-stage-container {
            padding: 16px;
        }
        
        .page-header {
            padding: 24px;
        }
        
        .page-title {
            font-size: 24px;
        }
        
        .search-grid {
            grid-template-columns: 1fr;
            gap: 16px;
        }
        
        .selection-table th, .selection-table td {
            padding: 12px 8px;
            font-size: 14px;
        }
        
        .btn-primary {
            padding: 8px 16px;
            font-size: 12px;
        }
        
        .summary-cards {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media (max-width: 480px) {
        .selection-stage-container {
            padding: 12px;
        }
        
        .page-header {
            padding: 20px;
        }
        
        .page-title {
            font-size: 20px;
        }
        
        .selection-table th, .selection-table td {
            padding: 8px 6px;
            font-size: 12px;
        }
        
        .summary-cards {
            grid-template-columns: 1fr;
        }
    }

    /* アクセシビリティの向上 */
    .form-group input:focus,
    .form-group select:focus,
    .btn-primary:focus {
        outline: 3px solid #2C7744;
        outline-offset: 2px;
    }

    /* 高コントラストモード対応 */
    @media (prefers-contrast: high) {
        .selection-table {
            border: 2px solid #2c3e50;
        }
        
        .btn-primary {
            border: 2px solid #2c3e50;
        }
    }

    /* ダークモード対応 */
    @media (prefers-color-scheme: dark) {
        .selection-stage-page {
            background: #1a1a1a;
            color: #ffffff;
        }
        
        .selection-stage-container {
            background: #2d2d2d;
            color: #ffffff;
        }
        
        .page-header {
            background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
            color: #ffffff;
        }
        
        .page-title {
            color: #ffffff;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
        }
        
        .breadcrumb {
            color: #ffffff;
        }
        
        .breadcrumb a {
            color: #ffffff;
            background: rgba(255, 255, 255, 0.2);
            border-color: rgba(255, 255, 255, 0.3);
        }
        
        .breadcrumb a:hover {
            background: rgba(255, 255, 255, 0.3);
            color: #ffffff;
        }
        
        .breadcrumb .separator {
            color: #ffffff;
        }
        
        .search-section {
            background: #3d3d3d;
            border-color: #4d4d4d;
            color: #ffffff;
        }
        
        .search-section h3 {
            color: #2C7744;
        }
        
        .form-group label {
            color: #ffffff;
        }
        
        .form-group input,
        .form-group select {
            background: #4d4d4d;
            border-color: #5d5d5d;
            color: #ffffff;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            border-color: #2C7744;
            box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.3);
        }
        
        .selection-table {
            background: #3d3d3d;
            color: #ffffff;
            border-color: #4d4d4d;
        }
        
        .selection-table th {
            background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
            color: #ffffff;
        }
        
        .selection-table td {
            color: #ffffff;
            border-bottom-color: #4d4d4d;
        }
        
        .selection-table tr:hover {
            background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
            color: #ffffff;
        }
        
        .summary-card {
            background: #3d3d3d;
            border-color: #4d4d4d;
            color: #ffffff;
        }
        
        .summary-number {
            color: #2C7744;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
            color: #ffffff;
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #1e5a2f 0%, #4a8a52 100%);
            color: #ffffff;
        }
        
        .no-data {
            color: #aaaaaa;
        }
        
        /* ヘッダーの完全なダークテーマ対応 */
        header {
            background: #2d2d2d !important;
            color: #ffffff !important;
            border-bottom: 1px solid #4d4d4d !important;
        }
        
        header h1#logo a {
            color: #ffffff !important;
        }
        
        header nav ul li a {
            color: #ffffff !important;
            background: transparent !important;
        }
        
        header nav ul li a:hover {
            color: #2C7744 !important;
            background: rgba(44, 119, 68, 0.1) !important;
        }
        
        /* メインコンテンツエリアの背景色修正 */
        .custom-section {
            background-color: #2d2d2d !important;
            color: #ffffff !important;
        }
        
        /* メインエリアの背景色を強制的にダークに */
        main {
            background: #1a1a1a !important;
        }
        
        /* コンテナ全体の背景色を統一 */
        #container {
            background: #1a1a1a !important;
        }
        
        /* ページ全体の背景色を統一 */
        body.selection-stage-page {
            background: #1a1a1a !important;
        }
        
        /* ヘッダーの背景色を強制的にダークに */
        .selection-stage-page header {
            background: #2d2d2d !important;
            backdrop-filter: none !important;
        }
        
        /* メインコンテンツエリアの背景色を強制的にダークに */
        .selection-stage-page .custom-section {
            background-color: #2d2d2d !important;
        }
        
        /* テーブルコンテナの背景色を統一 */
        .selection-stage-page .selection-stage-container {
            background: #2d2d2d !important;
        }
        
        /* フォーカス時のアウトライン調整 */
        .form-group input:focus,
        .form-group select:focus,
        .btn-primary:focus {
            outline: 3px solid #2C7744;
            outline-offset: 2px;
        }
    }
    
    /* 幅間調整用 */
	.custom-section {
    width: 100vw;           /* ビューポート全体の横幅を使用 */
    max-width: none;        /* 最大幅の制限を解除 */
    margin: 0;
    padding: 40px 32px;
    margin-top: 50px; /* ← ヘッダーとの距離をここで確保 */
    margin-bottom: 60px; /* ← 例えば60pxで広めに */
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

<body class="selection-stage-page">

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

    <main style="padding-top: 70px; padding-bottom: 100px;">
    <section class="custom-section" role="main" aria-label="幅調整用">
	        <div class="selection-stage-container">
	            <!-- ページヘッダー -->
	            <header class="page-header" role="banner">
	                <h1 class="page-title">選考ステージ確認</h1>
	                <nav class="breadcrumb" aria-label="パンくずリスト">
	                    <a href="${pageContext.request.contextPath}/DashboardServlet">ダッシュボード</a>
	                    <span class="separator" aria-hidden="true">/</span>
	                    <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a>
	                    <span class="separator" aria-hidden="true">/</span>
	                    <span>選考ステージ確認</span>
	                </nav>
	            </header>

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
	            <table class="selection-table" aria-label="選考ステージ一覧">
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
	                            <tr>
	                                <td style="color: #000000"><%= stageMap.get("student_name") != null ? stageMap.get("student_name") : "" %></td>
	                                <td style="color: #000000"><%= stageMap.get("company_name") != null ? stageMap.get("company_name") : "" %></td>
	                                <td><span class="status-badge status-selection"><%= stageMap.get("selection_name") != null ? stageMap.get("selection_name") : "" %></span></td>
	                                <td style="color: #000000"><%= stageMap.get("date") != null ? stageMap.get("date") : "" %></td>
	                                <td style="color: #000000"><%= stageMap.get("time") != null ? stageMap.get("time") : "" %></td>
	                                <td style="color: #000000"><%= stageMap.get("venue") != null ? stageMap.get("venue") : "" %></td>
	                                <td style="color: #000000"><%= stageMap.get("remarks") != null ? stageMap.get("remarks") : "" %></td>
	                                <td>
	                                    <a href="${pageContext.request.contextPath}/StudentDetailServlet?id=<%= stageMap.get("student_id") %>" class="btn-primary" aria-label="学生詳細を表示">詳細</a>
	                                    <a href="${pageContext.request.contextPath}/SelectionStageViewServlet?action=edit&studentId=<%= stageMap.get("student_id") %>&companyId=<%= stageMap.get("companys_id") %>" class="btn-primary" aria-label="選考ステージを編集">編集</a>
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
                <li><a href="${pageContext.request.contextPath}/DashboardServlet">ホーム</a></li>
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
            <li><a href="${pageContext.request.contextPath}/DashboardServlet">ホーム</a></li>
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
// 選考ステージ確認画面の最適化されたJavaScript

// アクセシビリティの向上
document.addEventListener('DOMContentLoaded', () => {
    // キーボードナビゲーションの改善
    const actionButtons = document.querySelectorAll('.btn-primary');
    actionButtons.forEach(button => {
        button.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                button.click();
            }
        });
    });

    // フォーカス管理の改善
    const focusableElements = document.querySelectorAll('a, button, input, select, textarea, [tabindex]:not([tabindex="-1"])');
    focusableElements.forEach(element => {
        element.addEventListener('focus', () => {
            element.style.outline = '2px solid #2C7744';
            element.style.outlineOffset = '2px';
        });
        
        element.addEventListener('blur', () => {
            element.style.outline = '';
            element.style.outlineOffset = '';
        });
    });

    // テーブル行のホバー効果の改善
    const tableRows = document.querySelectorAll('.selection-table tbody tr');
    tableRows.forEach(row => {
        row.addEventListener('mouseenter', () => {
            row.style.transform = 'translateY(-1px)';
        });
        
        row.addEventListener('mouseleave', () => {
            row.style.transform = 'translateY(0)';
        });
    });
    
    // 統計数値の更新
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