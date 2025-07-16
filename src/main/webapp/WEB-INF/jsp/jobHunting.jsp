<!--*
：：：色のテーマは緑：：：
就職管理画面


**********

<!--* 画面：就職管理画面
        	
許可されている権限：
・教員：teacher
・校長・教務部長：headmaster
・システム管理者：admin
 
▼▼▼▼
*-->


<!--確認まだ-->

<!--KCS_JMS_PROJECT-->


<!-- 就職管理画面用 -->



<!--▼▼▼▼▼スコープから取得する情報　これをもとに判定をしていく -->
<% 
  String username = (String) session.getAttribute("username"); 
  String role     = (String) session.getAttribute("role"); 
  
  // デバッグ用：セッション情報をコンソールに出力
  System.out.println("StudentManagement.jsp - username: " + username);
  System.out.println("StudentManagement.jsp - role: " + role);
  
  // nullチェック
  if (username == null) {
    username = "ゲスト";
  }
  if (role == null) {
    role = "guest";
  }
  
  // リクエストスコープからプルダウン用データを取得
  java.util.List<String> classList = (java.util.List<String>) request.getAttribute("classList");
  java.util.List<String> enrollmentStatusList = (java.util.List<String>) request.getAttribute("enrollmentStatusList");
  java.util.List<String> assistanceList = (java.util.List<String>) request.getAttribute("assistanceList");
  java.util.List<String> firstChoiceIndustryList = (java.util.List<String>) request.getAttribute("firstChoiceIndustryList");
  java.util.List<Integer> graduationYearList = (java.util.List<Integer>) request.getAttribute("graduationYearList");
  
  // エラーメッセージを取得
  String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!--▲▲▲▲▲-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - 就職管理画面</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">

<style>
    /* システム上見やすさを追求した学生管理画面デザイン */
    
    /* 全体の設定 */
    .student-management-page {
        background: #f8f9fa;
        color: #2c3e50;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        line-height: 1.6;
    }

    .student-management-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 24px;
        min-height: 100vh;
        background: #ffffff;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
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

    .page-subtitle {
        font-size: 18px;
        color: #000000;
        margin-bottom: 24px;
        line-height: 1.6;
        font-weight: 600;
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

    /* クイックアクション - 視認性と操作性の向上 */
    .quick-actions {
        background: white;
        border-radius: 12px;
        padding: 32px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        margin-bottom: 32px;
        position: relative;
        overflow: hidden;
    }

    .quick-actions::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg, #2C7744, #5CA564);
    }

    .quick-actions h3 {
        font-size: 20px;
        color: #2c3e50;
        margin-bottom: 24px;
        text-align: center;
        font-weight: 700;
    }

    .action-buttons {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 16px;
    }

    .action-btn {
        background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
        color: white;
        padding: 16px 24px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        transition: all 0.2s ease;
        border: none;
        cursor: pointer;
        font-size: 16px;
        box-shadow: 0 2px 8px rgba(44, 119, 68, 0.2);
        position: relative;
        overflow: hidden;
    }

    .action-btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
        color: white;
        text-decoration: none;
    }

    .action-btn.secondary {
        background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
        box-shadow: 0 2px 8px rgba(108, 117, 125, 0.2);
    }

    .action-btn.secondary:hover {
        box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
    }

    /* メインコンテンツ - 情報階層の改善 */
    .management-main {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
        gap: 24px;
        margin-bottom: 32px;
        max-width: 1200px;
        margin-left: auto;
        margin-right: auto;
    }

    /* 機能カード - 視認性と操作性の向上 */
    .management-card {
        background: white;
        border-radius: 12px;
        padding: 32px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        transition: all 0.2s ease;
        position: relative;
        overflow: hidden;
        text-align: center;
    }

    .management-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg, #2C7744, #5CA564);
    }

    .management-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
        border-color: #2C7744;
    }

    .card-icon {
        font-size: 48px;
        margin-bottom: 20px;
        display: block;
        opacity: 0.9;
    }

    .card-title {
        font-size: 20px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 12px;
        line-height: 1.3;
    }

    .card-description {
        color: #6c757d;
        margin-bottom: 24px;
        line-height: 1.6;
        font-size: 16px;
    }

    .card-stats {
        display: flex;
        justify-content: space-around;
        margin-bottom: 24px;
        padding: 20px;
        background: linear-gradient(135deg, rgba(44, 119, 68, 0.05), rgba(92, 165, 100, 0.05));
        border-radius: 8px;
        border: 1px solid rgba(44, 119, 68, 0.1);
    }

    .stat-item {
        text-align: center;
        position: relative;
    }

    .stat-item:not(:last-child)::after {
        content: '';
        position: absolute;
        right: -50%;
        top: 50%;
        transform: translateY(-50%);
        width: 1px;
        height: 30px;
        background: linear-gradient(to bottom, transparent, rgba(44, 119, 68, 0.3), transparent);
    }

    .stat-number {
        font-size: 24px;
        font-weight: 700;
        color: #2C7744;
        display: block;
    }

    .stat-label {
        font-size: 14px;
        color: #6c757d;
        margin-top: 6px;
        font-weight: 500;
    }

    .card-link {
        background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
        color: white;
        padding: 14px 28px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        font-size: 16px;
        display: inline-block;
        transition: all 0.2s ease;
        border: none;
        cursor: pointer;
        width: 100%;
        text-align: center;
        box-sizing: border-box;
        box-shadow: 0 2px 8px rgba(44, 119, 68, 0.2);
    }

    .card-link:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
        color: white;
        text-decoration: none;
    }

    /* レスポンシブ対応の強化 */
    @media (max-width: 768px) {
        .student-management-container {
            padding: 16px;
        }
        
        .page-header {
            padding: 24px;
        }
        
        .page-title {
            font-size: 24px;
        }
        
        .page-subtitle {
            font-size: 16px;
        }
        
        .management-main {
            grid-template-columns: 1fr;
            gap: 16px;
        }
        
        .action-buttons {
            grid-template-columns: 1fr;
        }
        
        .quick-actions {
            padding: 24px;
        }
        
        .management-card {
            padding: 24px;
        }
        
        .card-stats {
            flex-direction: column;
            gap: 12px;
        }
        
        .stat-item:not(:last-child)::after {
            display: none;
        }
    }

    @media (max-width: 480px) {
        .student-management-container {
            padding: 12px;
        }
        
        .page-header {
            padding: 20px;
        }
        
        .page-title {
            font-size: 20px;
        }
        
        .quick-actions {
            padding: 20px;
        }
        
        .management-card {
            padding: 20px;
        }
        
        .card-title {
            font-size: 18px;
        }
    }

    /* アクセシビリティの向上 */
    .action-btn:focus,
    .card-link:focus {
        outline: 3px solid #2C7744;
        outline-offset: 2px;
    }

    .management-card:focus-within {
        outline: 2px solid #2C7744;
        outline-offset: 2px;
    }

    /* 高コントラストモード対応 */
    @media (prefers-contrast: high) {
        .management-card {
            border: 2px solid #2c3e50;
        }
        
        .action-btn,
        .card-link {
            border: 2px solid #2c3e50;
        }
    }

    /* ダークモード対応 */
    @media (prefers-color-scheme: dark) {
        .student-management-page {
            background: #1a1a1a;
            color: #ffffff;
        }
        
        .student-management-container {
            background: #2d2d2d;
        }
        
        .quick-actions,
        .management-card {
            background: #3d3d3d;
            border-color: #4d4d4d;
            color: #ffffff;
        }
        
        .card-title {
            color: #ffffff;
        }
        
        .card-description {
            color: #cccccc;
        }
    }

    /* アニメーションの最適化 */
    .page-header,
    .quick-actions,
    .management-card {
        animation: fadeInUp 0.4s ease forwards;
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* ダッシュボード用ヘッダー調整 */
    .student-management-page header {
        position: relative;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    }

    .student-management-page #mainimg {
        display: none;
    }

    .student-management-page main {
        margin-top: 0;
    }

    /* テキストスライドショー用の調整 */
    .student-management-page .text-slide-wrapper {
        margin-top: 0;
        margin-bottom: 0;
    }

    .student-management-page .text-slide {
        font-size: 8vw;
        opacity: 0.08;
    }

    /* ナビゲーションメニューの文字色修正 */
    .student-management-page header nav ul li a {
        color: #2c3e50 !important;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s ease;
    }

    .student-management-page header nav ul li a:hover {
        color: #2C7744 !important;
        text-decoration: underline;
    }

    .student-management-page header nav ul li {
        color: #2c3e50 !important;
        font-weight: 600;
    }

    /* ダークモード対応 */
    @media (prefers-color-scheme: dark) {
        .student-management-page header nav ul li a {
            color: #ffffff !important;
        }
        
        .student-management-page header nav ul li a:hover {
            color: #5CA564 !important;
        }
        
        .student-management-page header nav ul li {
            color: #ffffff !important;
        }
    }
</style>

</head>
<body class="student-management-page">
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
        <h1 id="logo"><a href="javascript:void(0);" onclick="location.reload();"><img src="images/logo.png" alt="jms"></a></h1>
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
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">システム管理</a></li>
                <% } %>
                <li><a href="extension.html">お問い合わせ</a></li>
                <% if (username != null) { %>
                    <li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
                <% } %>
            </ul>
        </nav>
    </header>
    <!--▲▲▲▲▲ここまで「ヘッダー」-->

    <main>
        <div class="student-management-container">
            <!-- ページヘッダー -->
            <header class="page-header" role="banner">
                <h1 class="page-title">就活管理</h1>
                <p class="page-subtitle">就活の選考ステージ登録や試験面接情報の入力、書類チェック、<br>受験予定者抽出、活動報告自動出力などの画面に遷移できます。</p>
                <nav class="breadcrumb" aria-label="パンくずリスト">
                    <a href="${pageContext.request.contextPath}/StatusServlet?view=DashBoard">ダッシュボード</a>
                    <span class="separator" aria-hidden="true">/</span>
                    <span>就活管理</span>
                </nav>
            </header>

            <!-- メッセージ表示 -->
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="message success-message" style="background: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 8px; padding: 16px; margin-bottom: 24px; text-align: center; font-weight: 600;">
                    ✅ <%= request.getAttribute("successMessage") %>
                </div>
            <% } %>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="message error-message" style="background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; border-radius: 8px; padding: 16px; margin-bottom: 24px; text-align: center; font-weight: 600;">
                    ❌ <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <!-- 操作一覧 -->
            <section class="quick-actions" role="region" aria-label="操作一覧">
                <h2>🚀 操作一覧</h2>
                <div class="action-buttons">
                    <a href="CompanyServlet" class="action-btn" aria-label="企業一覧画面へ">
                        <i class="fas fa-list" aria-hidden="true"></i>企業一覧を表示
                    </a>
                    <a href="JobHuntingSearchServlet" class="action-btn" aria-label="就活情報検索画面へ">
                        <i class="fas fa-search" aria-hidden="true"></i>就活情報検索
                    </a>
                    <a href="StatusServlet?view=SelectionStage" class="action-btn secondary" aria-label="選考ステージ登録画面へ">
                        <i class="fas fa-edit" aria-hidden="true"></i>選考ステージ登録
                    </a>
                    <a href="StatusServlet?view=         " class="action-btn secondary" aria-label="試験面接情報入力画面へ">
                        <i class="fas fa-exam" aria-hidden="true"></i>試験面接情報入力
                    </a>
                    <a href="StatusServlet?view=       " class="action-btn secondary" aria-label="書類提出チェック画面へ">
                        <i class="fas fa-Document submission" aria-hidden="true"></i>書類提出チェック
                    </a>
                     <a href="StatusServlet?view=      " class="action-btn secondary" aria-label="受験予定者抽出画面へ">
                        <i class="fas fa-Examination" aria-hidden="true"></i>受験予定者抽出
                    </a>
                     <a href="StatusServlet?view=        " class="action-btn secondary" aria-label="活動報告自動出力画面へ">
                        <i class="fas fa-Activity Report" aria-hidden="true"></i>活動報告自動出力画面
                    </a>
                </div>
            </section>

            <!-- メインコンテンツ -->
            <section class="management-main" role="region" aria-label="管理機能">
                
                <!-- 企業一覧管理 -->
                <article class="management-card" role="article">
                    <span class="card-icon" aria-hidden="true">📋</span>
                    <h3 class="card-title">企業一覧管理</h3>
                    <p class="card-description">
                        登録されている企業の一覧を表示し、詳細情報の確認を行えます。
                    </p>
                    <div class="card-stats" role="group" aria-label="学生統計">
                        <div class="stat-item">
                            <span class="stat-number">250</span>
                            <span class="stat-label">総企業数</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number">67</span>
                            <span class="stat-label">募集中企業</span>
                        </div>
                    </div>
                    <a href="CompanyServlet" class="card-link" aria-label="学生一覧を表示">
                        企業一覧を表示
                    </a>
                </article>

                <!-- 選考ステージ登録 -->
                <article class="management-card" role="article">
                    <span class="card-icon" aria-hidden="true">🚶‍♂️‍➡️</span>
                    <h3 class="card-title">選考ステージ登録</h3>
                    <p class="card-description">
                        選考ステージを登録し、企業情報を追加できます。
                    </p>
                    <div class="card-stats" role="group" aria-label="登録統計">
                        <div class="stat-item">
                            <span class="stat-number">43</span>
                            <span class="stat-label">今月登録</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number">5</span>
                            <span class="stat-label">未完了</span>
                        </div>
                    </div>
                    <a href="StatusServlet?view=SelectionStage" class="card-link" aria-label="選考ステージを登録">
                        選考ステージを登録
                    </a>
                </article>
            </section>
        </div>
    </main>

    <!--▼▼▼▼▼ここから「テキストスライドショー」-->
    <div class="text-slide-wrapper">
        <div class="text-slide">
            <span>Student Management System</span>
        </div>
    </div>
    <!--▲▲▲▲▲ここまで「テキストスライドショー」-->

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
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">システム管理</a></li>
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
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">システム管理</a></li>
            <% } %>
            <li><a href="extension.html">お問い合わせ</a></li>
            <% if (username != null) { %>
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
// 学生管理画面の最適化されたJavaScript

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

    // カードリンクのキーボード操作
    const cardLinks = document.querySelectorAll('.card-link');
    cardLinks.forEach(link => {
        link.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                link.click();
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

    // 統計データのアニメーション
    const statNumbers = document.querySelectorAll('.stat-number');
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const target = entry.target;
                const finalValue = parseInt(target.textContent);
                animateNumber(target, 0, finalValue, 1000);
                observer.unobserve(target);
            }
        });
    });

    statNumbers.forEach(stat => observer.observe(stat));
});

// 数値アニメーション関数
function animateNumber(element, start, end, duration) {
    const startTime = performance.now();
    
    function updateNumber(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        
        const current = Math.floor(start + (end - start) * progress);
        element.textContent = current;
        
        if (progress < 1) {
            requestAnimationFrame(updateNumber);
        }
    }
    
    requestAnimationFrame(updateNumber);
}

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
</script>

</body>
</html>