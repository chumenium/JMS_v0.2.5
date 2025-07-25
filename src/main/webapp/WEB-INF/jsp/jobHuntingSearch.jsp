<!--*
：：：色のテーマは緑：：：
就活情報検索画面


******教員-生徒-どちらにも表示されるページ****

許可されている権限：
・教員：teacher
・校長・教務部長：headmaster
・就職指導部：egd
・システム管理者：admin
・学生：student

▼▼▼▼
*-->

<!--KCS_JMS_PROJECT-->

<!-- 就活情報検索画面用 -->

<% 
  String username = (String) session.getAttribute("username"); 
  String role     = (String) session.getAttribute("role"); 
  
  // デバッグ用：セッション情報をコンソールに出力
  System.out.println("jobHuntingSearch.jsp - username: " + username);
  System.out.println("jobHuntingSearch.jsp - role: " + role);
  
  // nullチェック
  if (username == null) {
    username = "ゲスト";
  }
  if (role == null) {
    role = "guest";
  }
  
  // リクエストスコープから検索結果を取得
  java.util.List<java.util.Map<String, Object>> searchResults = 
    (java.util.List<java.util.Map<String, Object>>) request.getAttribute("searchResults");
  
  // エラーメッセージを取得
  String errorMessage = (String) request.getAttribute("errorMessage");
  String successMessage = (String) request.getAttribute("successMessage");
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - 就活情報検索</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">

<style>
    /* システム上見やすさを追求した就活情報検索画面デザイン */
    
    /* 全体の設定 */
    .job-hunting-search-page {
        background: #f8f9fa;
        color: #2c3e50;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        line-height: 1.6;
    }

    .job-hunting-search-container {
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

    /* 検索フォーム - 視認性と操作性の向上 */
    .search-form {
        background: white;
        border-radius: 12px;
        padding: 32px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        margin-bottom: 32px;
        position: relative;
        overflow: hidden;
    }

    .search-form::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg, #2C7744, #5CA564);
    }

    .search-form h3 {
        font-size: 20px;
        color: #2c3e50;
        margin-bottom: 24px;
        text-align: center;
        font-weight: 700;
    }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 20px;
        margin-bottom: 24px;
    }

    .form-group {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .form-group label {
        font-weight: 600;
        color: #2c3e50;
        font-size: 14px;
    }

    .form-group input,
    .form-group select {
        padding: 12px 16px;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 16px;
        transition: all 0.2s ease;
        background: #ffffff;
    }

    .form-group input:focus,
    .form-group select:focus {
        outline: none;
        border-color: #2C7744;
        box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.1);
    }

    .search-buttons {
        display: flex;
        gap: 16px;
        justify-content: center;
        flex-wrap: wrap;
    }

    .search-btn {
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
        box-shadow: 0 2px 8px rgba(44, 119, 68, 0.2);
    }

    .search-btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
        color: white;
        text-decoration: none;
    }

    .search-btn.secondary {
        background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
        box-shadow: 0 2px 8px rgba(108, 117, 125, 0.2);
    }

    .search-btn.secondary:hover {
        box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
    }

    /* 検索結果 - 視認性と操作性の向上 */
    .search-results {
        background: white;
        border-radius: 12px;
        padding: 32px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        margin-bottom: 32px;
        position: relative;
        overflow: hidden;
    }

    .search-results::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg, #2C7744, #5CA564);
    }

    .results-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
        padding-bottom: 16px;
        border-bottom: 2px solid #e9ecef;
    }

    .results-title {
        font-size: 20px;
        color: #2c3e50;
        font-weight: 700;
    }

    .results-count {
        font-size: 14px;
        color: #6c757d;
        font-weight: 600;
    }

    .results-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 16px;
    }

    .results-table th,
    .results-table td {
        padding: 16px;
        text-align: left;
        border-bottom: 1px solid #e9ecef;
    }

    .results-table th {
        background: linear-gradient(135deg, rgba(44, 119, 68, 0.1), rgba(92, 165, 100, 0.1));
        font-weight: 700;
        color: #2c3e50;
        font-size: 14px;
    }

    .results-table tr:hover {
        background: rgba(44, 119, 68, 0.05);
    }

    .action-btn {
        background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
        color: white;
        padding: 8px 16px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: 600;
        font-size: 14px;
        display: inline-block;
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

    /* メッセージ表示 */
    .message {
        padding: 16px;
        border-radius: 8px;
        margin-bottom: 24px;
        text-align: center;
        font-weight: 600;
    }

    .success-message {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }

    .error-message {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

    /* レスポンシブ対応の強化 */
    @media (max-width: 768px) {
        .job-hunting-search-container {
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
        
        .form-grid {
            grid-template-columns: 1fr;
            gap: 16px;
        }
        
        .search-form {
            padding: 24px;
        }
        
        .search-results {
            padding: 24px;
        }
        
        .results-table {
            font-size: 14px;
        }
        
        .results-table th,
        .results-table td {
            padding: 12px 8px;
        }
    }

    @media (max-width: 480px) {
        .job-hunting-search-container {
            padding: 12px;
        }
        
        .page-header {
            padding: 20px;
        }
        
        .page-title {
            font-size: 20px;
        }
        
        .search-form {
            padding: 20px;
        }
        
        .search-results {
            padding: 20px;
        }
        
        .search-buttons {
            flex-direction: column;
        }
        
        .search-btn {
            width: 100%;
            text-align: center;
        }
    }

    /* アクセシビリティの向上 */
    .search-btn:focus,
    .action-btn:focus {
        outline: 3px solid #2C7744;
        outline-offset: 2px;
    }

    .form-group input:focus,
    .form-group select:focus {
        outline: 2px solid #2C7744;
        outline-offset: 2px;
    }

    /* 高コントラストモード対応 */
    @media (prefers-contrast: high) {
        .search-form,
        .search-results {
            border: 2px solid #2c3e50;
        }
        
        .search-btn,
        .action-btn {
            border: 2px solid #2c3e50;
        }
    }

    /* ダークモード対応 */
    @media (prefers-color-scheme: dark) {
        .job-hunting-search-page {
            background: #1a1a1a;
            color: #ffffff;
        }
        
        .job-hunting-search-container {
            background: #2d2d2d;
        }
        
        .search-form,
        .search-results {
            background: #3d3d3d;
            border-color: #4d4d4d;
            color: #ffffff;
        }
        
        .form-group input,
        .form-group select {
            background: #4d4d4d;
            border-color: #5d5d5d;
            color: #ffffff;
        }
        
        .results-table th {
            background: rgba(44, 119, 68, 0.2);
            color: #ffffff;
        }
    }

    /* アニメーションの最適化 */
    .page-header,
    .search-form,
    .search-results {
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
    .job-hunting-search-page header {
        position: relative;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    }

    .job-hunting-search-page #mainimg {
        display: none;
    }

    .job-hunting-search-page main {
        margin-top: 0;
    }

    /* テキストスライドショー用の調整 */
    .job-hunting-search-page .text-slide-wrapper {
        margin-top: 0;
        margin-bottom: 0;
    }

    .job-hunting-search-page .text-slide {
        font-size: 8vw;
        opacity: 0.08;
    }
</style>

</head>
<body class="job-hunting-search-page">
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
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase">システム管理</a></li>
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
        <div class="job-hunting-search-container">
            <!-- ページヘッダー -->
            <header class="page-header" role="banner">
                <h1 class="page-title">就活情報検索</h1>
                <p class="page-subtitle">企業情報や選考状況を検索できます</p>
                <nav class="breadcrumb" aria-label="パンくずリスト">
                    <a href="${pageContext.request.contextPath}/StatusServlet?view=DashBoard">ダッシュボード</a>
                    <span class="separator" aria-hidden="true">/</span>
                    <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a>
                    <span class="separator" aria-hidden="true">/</span>
                    <span>就活情報検索</span>
                </nav>
            </header>

            <!-- メッセージ表示 -->
            <% if (successMessage != null) { %>
                <div class="message success-message">
                    ✅ <%= successMessage %>
                </div>
            <% } %>
            <% if (errorMessage != null) { %>
                <div class="message error-message">
                    ❌ <%= errorMessage %>
                </div>
            <% } %>

            <!-- 検索フォーム -->
            <section class="search-form" role="region" aria-label="検索フォーム">
                <h3>🔍 検索条件</h3>
                <form action="JobHuntingSearchServlet" method="get">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="companyName">企業名</label>
                            <input type="text" id="companyName" name="companyName" placeholder="企業名を入力">
                        </div>
                        
                        <div class="form-group">
                            <label for="jobTitle">職種</label>
                            <select id="jobTitle" name="jobTitle">
                                <option value="">全ての職種</option>
                                <option value="システムエンジニア">システムエンジニア</option>
                                <option value="プログラマー">プログラマー</option>
                                <option value="インフラエンジニア">インフラエンジニア</option>
                                <option value="システム運用保守">システム運用保守</option>
                                <option value="ITコンサルタント">ITコンサルタント</option>
                                <option value="ゲームクリエイター">ゲームクリエイター</option>
                                <option value="WEBデザイナー">WEBデザイナー</option>
                                <option value="フロントエンドエンジニア">フロントエンドエンジニア</option>
                                <option value="バックエンドエンジニア">バックエンドエンジニア</option>
                                <option value="組込開発エンジニア">組込開発エンジニア</option>
                                <option value="販売・営業">販売・営業</option>
                                <option value="事務職">事務職</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="selectionStage">選考段階</label>
                            <select id="selectionStage" name="selectionStage">
                                <option value="">全ての段階</option>
                                <option value="エントリー中">エントリー中</option>
                                <option value="書類選考">書類選考</option>
                                <option value="筆記試験">筆記試験</option>
                                <option value="適性検査">適性検査</option>
                                <option value="1次面接">1次面接</option>
                                <option value="2次面接">2次面接</option>
                                <option value="最終面接">最終面接</option>
                                <option value="内定">内定</option>
                                <option value="不採用">不採用</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="activityStatus">活動状況</label>
                            <select id="activityStatus" name="activityStatus">
                                <option value="">全ての状況</option>
                                <option value="検討中">検討中</option>
                                <option value="エントリー中">エントリー中</option>
                                <option value="選考中">選考中</option>
                                <option value="内定承諾">内定承諾</option>
                                <option value="内定保留">内定保留</option>
                                <option value="内定辞退">内定辞退</option>
                                <option value="不採用">不採用</option>
                                <option value="選考中止">選考中止</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="studentName">学生名</label>
                            <input type="text" id="studentName" name="studentName" placeholder="学生名を入力">
                        </div>
                        
                        <div class="form-group">
                            <label for="dateFrom">期間（開始）</label>
                            <input type="date" id="dateFrom" name="dateFrom">
                        </div>
                        
                        <div class="form-group">
                            <label for="dateTo">期間（終了）</label>
                            <input type="date" id="dateTo" name="dateTo">
                        </div>
                    </div>
                    
                    <div class="search-buttons">
                        <button type="submit" class="search-btn">
                            🔍 検索実行
                        </button>
                        <button type="reset" class="search-btn secondary">
                            🔄 条件クリア
                        </button>
                    </div>
                </form>
            </section>

            <!-- 検索結果 -->
            <% if (searchResults != null && !searchResults.isEmpty()) { %>
                <section class="search-results" role="region" aria-label="検索結果">
                    <div class="results-header">
                        <h3 class="results-title">📊 検索結果</h3>
                        <span class="results-count"><%= searchResults.size() %>件の結果</span>
                    </div>
                    
                    <table class="results-table">
                        <thead>
                            <tr>
                                <th>企業名</th>
                                <th>職種</th>
                                <th>学生名</th>
                                <th>選考段階</th>
                                <th>活動状況</th>
                                <th>報告日</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (java.util.Map<String, Object> result : searchResults) { %>
                                <tr>
                                    <td><%= result.get("company_name") != null ? result.get("company_name") : "-" %></td>
                                    <td><%= result.get("job_title") != null ? result.get("job_title") : "-" %></td>
                                    <td><%= result.get("student_name") != null ? result.get("student_name") : "-" %></td>
                                    <td><%= result.get("selection_stage") != null ? result.get("selection_stage") : "-" %></td>
                                    <td><%= result.get("activity_status") != null ? result.get("activity_status") : "-" %></td>
                                    <td><%= result.get("report_date") != null ? result.get("report_date") : "-" %></td>
                                    <td>
                                        <a href="StatusServlet?view=SelectionStage&companyId=<%= result.get("company_id") %>&studentId=<%= result.get("student_id") %>&companyName=<%= result.get("company_name") != null ? result.get("company_name") : "" %>&studentName=<%= result.get("student_name") != null ? result.get("student_name") : "" %>" 
                                           class="action-btn" aria-label="選考ステージ登録">
                                            選考登録
                                        </a>
                                        <a href="SelectionStageServlet?id=<%= result.get("activity_id") %>" 
                                           class="action-btn secondary" aria-label="詳細表示">
                                            詳細
                                        </a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </section>
            <% } else if (searchResults != null && searchResults.isEmpty()) { %>
                <section class="search-results" role="region" aria-label="検索結果">
                    <div class="results-header">
                        <h3 class="results-title">📊 検索結果</h3>
                        <span class="results-count">0件の結果</span>
                    </div>
                    <p style="text-align: center; padding: 40px; color: #6c757d;">
                        条件に一致する就活情報が見つかりませんでした。<br>
                        検索条件を変更して再度お試しください。
                    </p>
                </section>
            <% } %>
        </div>
    </main>

    <!--▼▼▼▼▼ここから「テキストスライドショー」-->
    <div class="text-slide-wrapper">
        <div class="text-slide">
            <span>Job Hunting Search System</span>
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
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase">システム管理</a></li>
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
// 就活情報検索画面の最適化されたJavaScript

// アクセシビリティの向上
document.addEventListener('DOMContentLoaded', () => {
    // フォームのバリデーション
    const searchForm = document.querySelector('form[action="JobHuntingSearchServlet"]');
    if (searchForm) {
        searchForm.addEventListener('submit', (e) => {
            const companyName = document.getElementById('companyName').value.trim();
            const studentName = document.getElementById('studentName').value.trim();
            const dateFrom = document.getElementById('dateFrom').value;
            const dateTo = document.getElementById('dateTo').value;
            
            // 最低1つの検索条件が必要
            if (!companyName && !studentName && !dateFrom && !dateTo) {
                e.preventDefault();
                alert('最低1つの検索条件を入力してください。');
                return false;
            }
            
            // 日付範囲の検証
            if (dateFrom && dateTo && dateFrom > dateTo) {
                e.preventDefault();
                alert('開始日は終了日より前の日付を選択してください。');
                return false;
            }
        });
    }

    // フォームのリセット機能
    const resetBtn = document.querySelector('button[type="reset"]');
    if (resetBtn) {
        resetBtn.addEventListener('click', () => {
            setTimeout(() => {
                // リセット後の処理
                console.log('検索条件をクリアしました');
            }, 100);
        });
    }

    // キーボードナビゲーションの改善
    const focusableElements = document.querySelectorAll('input, select, button, a');
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

    // 検索結果テーブルの改善
    const tableRows = document.querySelectorAll('.results-table tbody tr');
    tableRows.forEach(row => {
        row.addEventListener('click', (e) => {
            // リンク以外のクリックで行全体をハイライト
            if (!e.target.closest('a')) {
                row.style.backgroundColor = 'rgba(44, 119, 68, 0.1)';
                setTimeout(() => {
                    row.style.backgroundColor = '';
                }, 200);
            }
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
});

// エラーハンドリング
window.addEventListener('error', (e) => {
    console.error('JavaScript error:', e.error);
});

// ページの可視性変更時の処理
document.addEventListener('visibilitychange', () => {
    if (document.hidden) {
        console.log('Page hidden');
    } else {
        console.log('Page visible');
    }
});
</script>

</body>
</html> 