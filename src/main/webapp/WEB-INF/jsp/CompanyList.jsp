<!--*
：：：色のテーマは緑：：：
企業管理画面

**********

<!--* 画面：企業管理画面
        	
許可されている権限：
・就職指導部：egd
・システム管理者：admin
 
▼▼▼▼
*-->

<!--確認まだ-->

<!--KCS_JMS_PROJECT-->

<!-- 企業管理画面用 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="beans.CompanyBean,java.util.List" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null) username = "ゲスト";
    if (role == null) role = "guest";
    List<CompanyBean> companies = (List<CompanyBean>) request.getAttribute("companies");
    Integer totalCompanies = (Integer) request.getAttribute("totalCompanies");
    Integer recruitmentCompanies = (Integer) request.getAttribute("recruitmentCompanies");
    java.util.List<java.util.List<String>> workPlacesList = (java.util.List<java.util.List<String>>) request.getAttribute("workPlacesList");
    java.util.List<java.util.List<String>> occupationsList = (java.util.List<java.util.List<String>>) request.getAttribute("occupationsList");
%>
<!--▲▲▲▲▲-->
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - 企業一覧</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">

<style>
    /* システム上見やすさを追求した企業一覧管理画面デザイン */
    
    /* 全体の設定 */
    .company-list-page {
        background: #f8f9fa;
        color: #2c3e50;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        line-height: 1.6;
    }

    .company-list-container {
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

    /* ダッシュボード用ヘッダー調整 */
    .company-list-page header {
        position: relative;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    }

    .company-list-page #mainimg {
        display: none;
    }

    .company-list-page main {
        margin-top: 0;
    }

    /* テキストスライドショー用の調整 */
    .company-list-page .text-slide-wrapper {
        margin-top: 0;
        margin-bottom: 0;
    }

    .company-list-page .text-slide {
        font-size: 8vw;
        opacity: 0.08;
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
    .search-bar {
        background: white;
        border-radius: 12px;
        padding: 24px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        margin-bottom: 24px;
        display: flex;
        gap: 12px;
        align-items: center;
    }

    .search-bar input[type="text"] {
        flex: 1;
        padding: 12px 16px;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        font-size: 16px;
        transition: all 0.2s ease;
    }

    .search-bar input[type="text"]:focus {
        outline: none;
        border-color: #2C7744;
        box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.1);
    }

    .search-bar button {
        background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
        color: white;
        border: none;
        border-radius: 8px;
        padding: 12px 24px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
        box-shadow: 0 2px 8px rgba(44, 119, 68, 0.2);
    }

    .search-bar button:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
    }
    
    /* すべて表示ボタン */
    .show-all-btn {
        background: linear-gradient(135deg, #6c757d 0%, #495057 100%) !important;
        box-shadow: 0 2px 8px rgba(108, 117, 125, 0.2) !important;
        color: white !important;
        text-decoration: none !important;
        padding: 12px 24px !important;
        border-radius: 8px !important;
        font-size: 16px !important;
        font-weight: 600 !important;
        display: inline-block !important;
        transition: all 0.2s ease !important;
    }
    
    .show-all-btn:hover {
        box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3) !important;
        color: white !important;
        text-decoration: none !important;
        transform: translateY(-1px) !important;
    }
    
    /* 検索中アニメーション */
    .search-loading {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        padding: 20px;
        background: rgba(255, 255, 255, 0.9);
        border-radius: 8px;
        margin: 16px 0;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        border: 1px solid #e9ecef;
    }
    
    .loading-spinner {
        width: 20px;
        height: 20px;
        border: 2px solid #f3f3f3;
        border-top: 2px solid #2C7744;
        border-radius: 50%;
        animation: spin 1s linear infinite;
    }
    
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
    
    .search-loading span {
        color: #2C7744;
        font-weight: 600;
        font-size: 16px;
    }

    /* 企業一覧表 - 視認性と操作性の向上 */
    .company-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        margin-bottom: 24px;
        border: 1px solid #e9ecef;
    }

    .company-table th, .company-table td {
        padding: 16px 12px;
        text-align: left;
        border-bottom: 1px solid #e9ecef;
    }

    .company-table th {
        background: linear-gradient(135deg, #e9f5ee 0%, #f1f8f5 100%);
        color: #2C7744;
        font-size: 16px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .company-table tr:last-child td {
        border-bottom: none;
    }

    .company-table tr:hover {
        background: linear-gradient(135deg, #f1f8f5 0%, #e9f5ee 100%);
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(44, 119, 68, 0.1);
    }

    .company-table tr {
        transition: all 0.2s ease;
    }

    /* ステータスバッジ */
    .status-badge {
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
    }

    .status-badge.success {
        background-color: #d4edda;
        color: #155724;
    }

    .status-badge.warning {
        background-color: #fff3cd;
        color: #856404;
    }

    /* 操作ボタン */
    .action-btn {
        background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
        color: white;
        padding: 6px 12px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: 600;
        font-size: 14px;
        display: inline-block;
        margin-right: 8px;
        transition: all 0.2s ease;
        border: none;
        cursor: pointer;
        box-shadow: 0 2px 4px rgba(44, 119, 68, 0.2);
    }

    .action-btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(44, 119, 68, 0.3);
        color: white;
        text-decoration: none;
    }

    .action-btn.secondary {
        background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
        box-shadow: 0 2px 4px rgba(108, 117, 125, 0.2);
    }

    .action-btn.secondary:hover {
        box-shadow: 0 4px 8px rgba(108, 117, 125, 0.3);
    }

    /* ページネーション - 視認性と操作性の向上 */
    .pagination {
        display: flex;
        justify-content: center;
        gap: 8px;
        margin-top: 24px;
        flex-wrap: wrap;
    }

    .pagination form {
        margin: 0;
    }

    .pagination button {
        background: white;
        border: 2px solid #2C7744;
        color: #2C7744;
        border-radius: 8px;
        padding: 10px 16px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
        min-width: 44px;
        box-shadow: 0 2px 4px rgba(44, 119, 68, 0.1);
    }

    .pagination button.active, .pagination button:hover {
        background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
        color: white;
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(44, 119, 68, 0.3);
    }

    /* レスポンシブ対応の強化 */
    @media (max-width: 768px) {
        .company-list-container {
            padding: 16px;
        }
        
        .page-header {
            padding: 24px;
        }
        
        .page-title {
            font-size: 24px;
        }
        
        .search-bar {
            flex-direction: column;
            gap: 12px;
            padding: 20px;
        }
        
        .company-table th, .company-table td {
            padding: 12px 8px;
            font-size: 14px;
        }
        
        .action-btn {
            padding: 4px 8px;
            font-size: 12px;
            margin-right: 4px;
        }
        
        .pagination button {
            padding: 8px 12px;
            font-size: 14px;
            min-width: 40px;
        }
    }

    @media (max-width: 480px) {
        .company-list-container {
            padding: 12px;
        }
        
        .page-header {
            padding: 20px;
        }
        
        .page-title {
            font-size: 20px;
        }
        
        .search-bar {
            padding: 16px;
        }
        
        .company-table th, .company-table td {
            padding: 8px 6px;
            font-size: 12px;
        }
    }

    /* アクセシビリティの向上 */
    .search-bar input[type="text"]:focus,
    .search-bar button:focus,
    .action-btn:focus,
    .pagination button:focus {
        outline: 3px solid #2C7744;
        outline-offset: 2px;
    }

    /* 高コントラストモード対応 */
    @media (prefers-contrast: high) {
        .company-table {
            border: 2px solid #2c3e50;
        }
        
        .action-btn,
        .pagination button {
            border: 2px solid #2c3e50;
        }
    }

    /* ダークモード対応 */
    @media (prefers-color-scheme: dark) {
        .company-list-page {
            background: #1a1a1a;
            color: #ffffff;
        }
        
        .company-list-container {
            background: #2d2d2d;
            color: #ffffff;
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
        
        .search-bar {
            background: #3d3d3d;
            border-color: #4d4d4d;
            color: #ffffff;
        }
        
        .search-bar input[type="text"] {
            background: #4d4d4d;
            border-color: #5d5d5d;
            color: #ffffff;
        }
        
        .search-bar input[type="text"]::placeholder {
            color: #aaaaaa;
        }
        
        .search-bar input[type="text"]:focus {
            border-color: #2C7744;
            box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.3);
        }
        
        .search-loading {
            background: rgba(45, 45, 45, 0.9);
            border-color: #4d4d4d;
            color: #ffffff;
        }
        
        .search-loading span {
            color: #2C7744;
        }
        
        .company-table {
            background: #3d3d3d;
            color: #ffffff;
            border-color: #4d4d4d;
        }
        
        .company-table th {
            background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
            color: #ffffff;
        }
        
        .company-table td {
            color: #ffffff;
            border-bottom-color: #4d4d4d;
        }
        
        .company-table tr:hover {
            background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
            color: #ffffff;
        }
        
        .company-table tr:last-child td {
            border-bottom: none;
        }
        
        .status-badge.success {
            background-color: #2C7744;
            color: #ffffff;
        }
        
        .status-badge.warning {
            background-color: #856404;
            color: #ffffff;
        }
        
        .action-btn {
            background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
            color: #ffffff;
        }
        
        .action-btn:hover {
            background: linear-gradient(135deg, #1e5a2f 0%, #4a8a52 100%);
            color: #ffffff;
        }
        
        .action-btn.secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: #ffffff;
        }
        
        .action-btn.secondary:hover {
            background: linear-gradient(135deg, #5a6268 0%, #3d4449 100%);
            color: #ffffff;
        }
        
        .pagination button {
            background: #3d3d3d;
            border-color: #2C7744;
            color: #ffffff;
        }
        
        .pagination button.active, .pagination button:hover {
            background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
            color: #ffffff;
        }
        
        .show-all-btn {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%) !important;
            color: #ffffff !important;
        }
        
        .show-all-btn:hover {
            background: linear-gradient(135deg, #5a6268 0%, #3d4449 100%) !important;
            color: #ffffff !important;
        }
        
        /* テーブル内の文字色を強制的に白に */
        .company-table td span {
            color: #ffffff !important;
        }
        
        .company-table td span[style*="color:#aaa"] {
            color: #aaaaaa !important;
        }
        
        /* 空の状態のメッセージ */
        .company-table td[colspan] {
            color: #aaaaaa !important;
        }
        
        /* フッターの調整 */
        footer {
            background: #2d2d2d;
            color: #ffffff;
        }
        
        footer ul li a {
            color: #ffffff;
        }
        
        footer .logo {
            color: #ffffff;
        }
        
        footer small {
            color: #aaaaaa;
        }
        
        /* テキストスライドショーの調整 */
        .text-slide {
            color: #ffffff;
            opacity: 0.1;
        }
        
        /* ローディング画面の調整 */
        #loading {
            background: #1a1a1a;
            color: #ffffff;
        }
        
        /* ハンバーガーメニューの調整 */
        #menubar {
            background: #2d2d2d;
            color: #ffffff;
        }
        
        #menubar nav ul li a {
            color: #ffffff;
        }
        
        #menubar .logo {
            color: #ffffff;
        }
        
        /* フォーカス時のアウトライン調整 */
        .search-bar input[type="text"]:focus,
        .search-bar button:focus,
        .action-btn:focus,
        .pagination button:focus {
            outline: 3px solid #2C7744;
            outline-offset: 2px;
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
        body.company-list-page {
            background: #1a1a1a !important;
        }
        
        /* ヘッダーの背景色を強制的にダークに */
        .company-list-page header {
            background: #2d2d2d !important;
            backdrop-filter: none !important;
        }
        
        /* メインコンテンツエリアの背景色を強制的にダークに */
        .company-list-page .custom-section {
            background-color: #2d2d2d !important;
        }
        
        /* テーブルコンテナの背景色を統一 */
        .company-list-page .company-list-container {
            background: #2d2d2d !important;
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
<body class="company-list-page">

<div id="container">
    <!-- ヘッダー -->
    <header>
        <h1 id="logo"><a href="javascript:void(0);" onclick="location.reload();"><img src="images/logo.png" alt="jms"></a></h1>
        <nav>
            <ul>
                <li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
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
                <% if (username != null) { %>
                    <li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
                <% } %>
            </ul>
        </nav>
    </header>

    <main style="padding-top: 70px; padding-bottom: 100px;">
    <section class="custom-section" role="main" aria-label="幅調整用">
	        <div class="company-list-container">
	            <!-- ページヘッダー -->
	            <header class="page-header" role="banner">
	                <h1 class="page-title">企業一覧</h1>
	                <nav class="breadcrumb" aria-label="パンくずリスト">
	                    <a href="${pageContext.request.contextPath}/StatusServlet?view=DashBoard">ダッシュボード</a>
	                    <span class="separator" aria-hidden="true">/</span>
	                    <a href="CompanyManagementServlet">企業管理</a>
	                    <span class="separator" aria-hidden="true">/</span>
	                    <span>企業一覧</span>
	                </nav>
	            </header>

	            <!-- 検索バー -->
	            <form class="search-bar" method="post" action="CompanyListServlet" id="searchForm">
	                <input type="hidden" name="action" value="search">
	                <input type="text" name="keyword" placeholder="企業名・職種・勤務地などで検索..." aria-label="検索キーワード" value="${keyword != null ? keyword : ''}" id="searchInput">
	                <button type="submit" aria-label="検索" id="searchButton">🔍 検索</button>
	                <a href="CompanyListServlet" class="show-all-btn" id="showAllButton" aria-label="すべて表示">📋 すべて表示</a>
	            </form>
	            
	            <!-- 検索中アニメーション -->
	            <div id="searchLoading" class="search-loading" style="display: none;">
	                <div class="loading-spinner"></div>
	                <span>検索中...</span>
	            </div>

	            <!-- 企業一覧表 -->
	            <table class="company-table" aria-label="企業一覧">
	                <thead>
	                    <tr>
	                        <th>企業名</th>
	                        <th>職種</th>
	                        <th>勤務地</th>
	                        <th>採用実績</th>
                            <%if(!role.equals("student")){%>
	                        <th>操作</th>
                            <%}%>
	                    </tr>
	                </thead>
	                <tbody>
	                    <% if (companies != null && !companies.isEmpty()) { %>
	                        <% for (int i = 0; i < companies.size(); i++) {
	                            beans.CompanyBean company = companies.get(i);
	                            List<String> occupations = company.getOccupations();
	                            List<String> workPlaces = company.getWorkPlaces();
	                        %>
	                        <tr>
	                          <td style="color: #000000"><%= company.getCompanyName() %></td>
	                          <td style="color: #000000">
	                            <% if (occupations != null && !occupations.isEmpty()) { %>
	                                <% for (int j = 0; j < occupations.size(); j++) { %>
	                                    <span><%= occupations.get(j) %></span><% if (j != occupations.size()-1) { %>, <% } %>
	                                <% } %>
	                            <% } else { %>
	                                <span style="color:#aaa;">未設定</span>
	                            <% } %>
	                          </td>
	                          <td style="color: #000000">
	                            <% if (workPlaces != null && !workPlaces.isEmpty()) { %>
	                                <% for (int j = 0; j < workPlaces.size(); j++) { %>
	                                    <span><%= workPlaces.get(j) %></span><% if (j != workPlaces.size()-1) { %>, <% } %>
	                                <% } %>
	                            <% } else { %>
	                                <span style="color:#aaa;">未設定</span>
	                            <% } %>
	                          </td>
	                          <td style="color: #000000">
	                            <% if (company.getRecruitmentResults()) { %>
	                              <span class="status-badge success">あり</span>
	                            <% } else { %>
	                              <span class="status-badge warning">なし</span>
	                            <% } %>
	                          </td>
                              <%if(!role.equals("student")){%>
	                          <td>
	                            <a href="CompanyDetailServlet?companyId=<%= company.getCompanyId() %>" class="action-btn" aria-label="企業詳細を表示">詳細</a>
	                            <a href="CompanyDetailServlet?companyId=<%= company.getCompanyId() %>&mode=edit" class="action-btn secondary" aria-label="企業情報を編集">編集</a>
	                          </td>
                              <%}%>
	                        </tr>
	                        <% } %>
	                    <% } else { %>
	                        <tr>
	                            <td colspan="<%= role.equals("student") ? 4 : 5 %>" style="text-align:center; padding: 40px; color: #6c757d; font-style: italic;">
	                                該当する企業がありません
	                            </td>
	                        </tr>
	                    <% } %>
	                </tbody>
	            </table>
	            
	            <!-- ページネーション -->
	            <nav class="pagination" aria-label="ページネーション">
	                <c:if test="${totalPages gt 1}">
	                    <c:forEach var="p" begin="1" end="${totalPages}">
	                        <form method="get" action="CompanyListServlet" style="display:inline;">
	                            <input type="hidden" name="page" value="${p}">
	                            <c:if test="${not empty keyword}">
	                                <input type="hidden" name="keyword" value="${keyword}">
	                            </c:if>
	                            <button type="submit" class="${p == currentPage ? 'active' : ''}" aria-label="ページ ${p} に移動">${p}</button>
	                        </form>
	                    </c:forEach>
	                </c:if>
	            </nav>
	        </div>
	    </section>
    </main>

    <!--▼▼▼▼▼ここから「テキストスライドショー」-->
    <div class="text-slide-wrapper">
        <div class="text-slide">
            <span>Company List System</span>
        </div>
    </div>
    <!--▲▲▲▲▲ここまで「テキストスライドショー」-->

    <!-- フッター -->
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

    <span class="pr"><a href="" target="_blank">@ 2025 Job Management System</a></span>
</div>

<!-- ローディング -->
<div id="loading">
    <img src="images/logo.png" alt="Loading">
    <div class="progress-container">
        <div class="progress-bar"></div>
    </div>
</div>

<!-- ハンバーガーメニュー -->
<div id="menubar_hdr">
    <span></span><span></span><span></span>
</div>

<div id="menubar">
    <p class="logo"><img src="images/logo.png" alt="Job Management System"></p>
    <nav>
        <ul>
            <li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
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
            <% if (username != null) { %>
                <li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
            <% } %>
        </ul>
    </nav>
</div>

<!-- スクリプト -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/protonet-jquery.inview/1.1.2/jquery.inview.min.js"></script>
<script src="js/jquery.inview_set.js"></script>
<script src="js/main.js"></script>

<script>
// 企業一覧画面の最適化されたJavaScript

// アクセシビリティの向上
document.addEventListener('DOMContentLoaded', () => {
    // キーボードナビゲーションの改善
    const actionButtons = document.querySelectorAll('.action-btn');
    actionButtons.forEach(button => {
        button.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                button.click();
            }
        });
    });

    // 検索フォームの改善
    const searchForm = document.getElementById('searchForm');
    const searchInput = document.getElementById('searchInput');
    const searchButton = document.getElementById('searchButton');
    const showAllButton = document.getElementById('showAllButton');
    const searchLoading = document.getElementById('searchLoading');
    
    if (searchForm && searchInput) {
        // 検索ボタンのキーボード操作
        if (searchButton) {
            searchButton.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    searchForm.submit();
                }
            });
        }
        
        // 検索中のアニメーション表示
        searchForm.addEventListener('submit', () => {
            if (searchInput.value.trim() !== '') {
                searchLoading.style.display = 'flex';
                searchButton.disabled = true;
                showAllButton.disabled = true;
            }
        });
        
        // すべて表示ボタンの機能
        if (showAllButton) {
            showAllButton.addEventListener('click', (e) => {
                // 検索中アニメーション表示
                searchLoading.style.display = 'flex';
                searchButton.disabled = true;
                showAllButton.style.pointerEvents = 'none';
                showAllButton.style.opacity = '0.6';
            });
            
            // すべて表示ボタンのキーボード操作
            showAllButton.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    showAllButton.click();
                }
            });
        }

        // 検索入力フィールドの改善
        searchInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                searchForm.submit();
            }
        });
    }

    // ページネーションボタンのキーボード操作
    const paginationButtons = document.querySelectorAll('.pagination button');
    paginationButtons.forEach(button => {
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
    const tableRows = document.querySelectorAll('.company-table tbody tr');
    tableRows.forEach(row => {
        row.addEventListener('mouseenter', () => {
            row.style.transform = 'translateY(-1px)';
        });
        
        row.addEventListener('mouseleave', () => {
            row.style.transform = 'translateY(0)';
        });
    });
});

// パフォーマンス最適化
window.addEventListener('load', () => {
    // 画像の遅延読み込み
    const images = document.querySelectorAll('img[data-src]');
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
                observer.unobserve(img);
            }
        });
    });

    images.forEach(img => imageObserver.observe(img));

    // スムーズスクロール
    const smoothScrollLinks = document.querySelectorAll('a[href^="#"]');
    smoothScrollLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const targetId = link.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});

// エラーハンドリング
window.addEventListener('error', (e) => {
    console.error('JavaScript error:', e.error);
    // エラーが発生した場合のフォールバック処理
});

// ページの可視性変更時の処理
document.addEventListener('visibilitychange', () => {
    if (document.hidden) {
        // ページが非表示になった時の処理
        console.log('Page hidden');
    } else {
        // ページが表示された時の処理
        console.log('Page visible');
    }
});

function deleteCompany(companyId) {
    if (confirm('企業ID: ' + companyId + ' の企業を削除しますか？\nこの操作は取り消せません。')) {
        // 削除処理
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'CompanyManagementServlet';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'delete';
        
        const companyIdInput = document.createElement('input');
        companyIdInput.type = 'hidden';
        companyIdInput.name = 'company_id';
        companyIdInput.value = companyId;
        
        form.appendChild(actionInput);
        form.appendChild(companyIdInput);
        document.body.appendChild(form);
        form.submit();
    }
}
</script>

</body>
</html>
