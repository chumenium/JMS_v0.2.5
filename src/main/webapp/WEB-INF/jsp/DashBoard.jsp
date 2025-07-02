<!--*
：：：色のテーマは緑：：：
ダッシュボード用画面

******教員-生徒-どちらにも表示されるページ****
******権限によって表示されるボタンが変わる****

:::権限一覧:::

{
  "teacher":           "教員",
  "headmaster": "教務部長_校長",
  "egd":      "就職指導部",
  "admin":             "管理者",
  "student":           "学生"
}

||**すべての中心**||

**

*-->

<!--KCS_JMS_PROJECT-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - ダッシュボード</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">

<style>
    /* システム上見やすさを追求したダッシュボードデザイン */
    
    /* 全体の設定 */
    .dashboard-page {
        background: #f8f9fa;
        color: #2c3e50;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        line-height: 1.6;
    }

    /* ダッシュボード全体 */
    .dashboard-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 24px;
        min-height: 100vh;
        background: #ffffff;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
    }

    /* ヘッダー - 視認性向上 */
    .dashboard-header {
        background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
        border-radius: 12px;
        padding: 32px;
        margin-bottom: 32px;
        box-shadow: 0 4px 20px rgba(44, 119, 68, 0.15);
        color: white;
    }

    .user-info {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 20px;
    }

    .user-welcome {
        display: flex;
        align-items: center;
        gap: 16px;
    }

    .user-avatar {
        width: 64px;
        height: 64px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.2);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 600;
        font-size: 24px;
        border: 3px solid rgba(255, 255, 255, 0.3);
    }

    .user-details h2 {
        margin: 0 0 8px 0;
        color: white;
        font-size: 28px;
        font-weight: 600;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    }

    .role-badge {
        background: rgba(255, 255, 255, 0.2);
        color: white;
        padding: 8px 16px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 600;
        border: 1px solid rgba(255, 255, 255, 0.3);
        backdrop-filter: blur(10px);
    }

    .logout-btn {
        background: rgba(255, 255, 255, 0.15);
        color: white;
        padding: 12px 24px;
        border: 2px solid rgba(255, 255, 255, 0.3);
        border-radius: 8px;
        cursor: pointer;
        font-weight: 600;
        font-size: 16px;
        transition: all 0.2s ease;
        text-decoration: none;
        display: inline-block;
        backdrop-filter: blur(10px);
    }

    .logout-btn:hover {
        background: rgba(255, 255, 255, 0.25);
        border-color: rgba(255, 255, 255, 0.5);
        transform: translateY(-1px);
    }

    /* メインコンテンツ - 情報階層の改善 */
    .dashboard-main {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
        gap: 24px;
        margin-bottom: 32px;
    }

    /* 機能カード - 視認性と操作性の向上 */
    .feature-card {
        background: white;
        border-radius: 12px;
        padding: 32px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        transition: all 0.2s ease;
        position: relative;
        overflow: hidden;
    }

    .feature-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background: linear-gradient(90deg, #2C7744, #5CA564);
    }

    .feature-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
        border-color: #2C7744;
    }

    .feature-icon {
        font-size: 48px;
        margin-bottom: 20px;
        display: block;
        opacity: 0.9;
    }

    .feature-title {
        font-size: 20px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 12px;
        line-height: 1.3;
    }

    .feature-description {
        color: #6c757d;
        margin-bottom: 24px;
        line-height: 1.6;
        font-size: 16px;
    }

    .feature-link {
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

    .feature-link:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
        color: white;
        text-decoration: none;
    }

    /* レスポンシブ対応の強化 */
    @media (max-width: 768px) {
        .dashboard-container {
            padding: 16px;
        }
        
        .dashboard-header {
            padding: 24px;
        }
        
        .user-info {
            flex-direction: column;
            text-align: center;
        }
        
        .user-details h2 {
            font-size: 24px;
        }
        
        .dashboard-main {
            grid-template-columns: 1fr;
            gap: 16px;
        }
        
        .feature-card {
            padding: 24px;
        }
        
        .feature-title {
            font-size: 18px;
        }
    }

    @media (max-width: 480px) {
        .dashboard-container {
            padding: 12px;
        }
        
        .dashboard-header {
            padding: 20px;
        }
        
        .user-avatar {
            width: 56px;
            height: 56px;
            font-size: 20px;
        }
        
        .user-details h2 {
            font-size: 20px;
        }
        
        .feature-card {
            padding: 20px;
        }
    }

    /* アクセシビリティの向上 */
    .feature-link:focus {
        outline: 3px solid #2C7744;
        outline-offset: 2px;
    }

    .feature-card:focus-within {
        outline: 2px solid #2C7744;
        outline-offset: 2px;
    }

    /* 高コントラストモード対応 */
    @media (prefers-contrast: high) {
        .feature-card {
            border: 2px solid #2c3e50;
        }
        
        .feature-link {
            border: 2px solid #2c3e50;
        }
    }

    /* ダークモード対応 */
    @media (prefers-color-scheme: dark) {
        .dashboard-page {
            background: #1a1a1a;
            color: #ffffff;
        }
        
        .dashboard-container {
            background: #2d2d2d;
        }
        
        .feature-card {
            background: #3d3d3d;
            border-color: #4d4d4d;
            color: #ffffff;
        }
        
        .feature-title {
            color: #ffffff;
        }
        
        .feature-description {
            color: #cccccc;
        }
    }

    /* アニメーションの最適化 */
    .feature-card {
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

    /* ローディング画面の最適化 */
    .dashboard-loading {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(44, 119, 68, 0.95);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 9999;
        opacity: 1;
        transition: opacity 0.3s ease-in-out;
    }

    .dashboard-loading.fade-out {
        opacity: 0;
        pointer-events: none;
    }

    .dashboard-loading-container {
        text-align: center;
        color: white;
    }

    .dashboard-loading-spinner {
        width: 60px;
        height: 60px;
        border: 4px solid rgba(255, 255, 255, 0.2);
        border-top: 4px solid white;
        border-radius: 50%;
        animation: spin 1s linear infinite;
        margin: 0 auto 20px;
    }

    .dashboard-loading-text {
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 8px;
    }

    .dashboard-loading-subtext {
        font-size: 14px;
        opacity: 0.8;
    }

    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
</style>
</head>

<body class="dashboard-page">
<% 
  String username = (String) session.getAttribute("username"); 
  String role = (String) session.getAttribute("role"); 
  
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

<!-- ダッシュボードローディング画面 -->
<div id="dashboardLoading" class="dashboard-loading">
    <div class="dashboard-loading-container">
        <div class="dashboard-loading-spinner"></div>
        <div class="dashboard-loading-text">ダッシュボードを読み込み中...</div>
        <div class="dashboard-loading-subtext">しばらくお待ちください</div>
    </div>
</div>

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
        <!--▼▼▼▼▼ここから「ダッシュボードメイン」-->
        <section class="bg1 bg-pattern1" role="main" aria-label="ダッシュボードメイン">
            <div class="dashboard-container">
                <!-- ダッシュボードヘッダー -->
                <div class="dashboard-header">
                    <div class="user-info">
                        <div class="user-welcome">
                            <div class="user-avatar">
                                <%= username != null ? username.charAt(0) : "U" %>
                            </div>
                            <div class="user-details">
                                <h2>こんにちは、<%= username != null ? username : "ゲスト" %>さん</h2>
                                <span class="role-badge"><%= roleDisplay %></span>
                            </div>
                        </div>
                        <% if (username != null) { %>
                            <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-btn">ログアウト</a>
                        <% } %>
                    </div>
                </div>

                <!-- メインコンテンツ -->
                <div class="dashboard-main" role="region" aria-label="機能メニュー">
                    
                    <!-- 学生管理機能 -->
                    <% if ("teacher".equals(role) || "headmaster".equals(role) || "admin".equals(role)) { %>
                        <div class="feature-card">
                            <span class="feature-icon">📚</span>
                            <h3 class="feature-title">学生管理</h3>
                            <p class="feature-description">
                                学生の情報を管理し、就職活動の進捗を把握できます。
                            </p>
                            <a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement" class="feature-link">
                                学生管理画面を開く
                            </a>
                        </div>
                    <% } %>

                    <!-- 企業管理機能 -->
                    <% if ("egd".equals(role) || "admin".equals(role)) { %>
                        <div class="feature-card">
                            <span class="feature-icon">🏢</span>
                            <h3 class="feature-title">企業管理</h3>
                            <p class="feature-description">
                                企業情報の登録・編集と求人情報の管理を行います。
                            </p>
                            <a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement" class="feature-link">
                                企業管理画面を開く
                            </a>
                        </div>
                    <% } %>

                    <!-- 就職管理機能 -->
                    <% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role) || "student".equals(role)) { %>
                        <div class="feature-card">
                            <span class="feature-icon">📄</span>
                            <h3 class="feature-title">就職管理</h3>
                            <p class="feature-description">
                                就職活動の進捗管理と選考状況の記録を行います。
                            </p>
                            <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting" class="feature-link">
                                就職管理画面を開く
                            </a>
                        </div>
                    <% } %>

                    <!-- 受験者一覧機能 -->
                    <% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role)) { %>
                        <div class="feature-card">
                            <span class="feature-icon">📊</span>
                            <h3 class="feature-title">受験者一覧</h3>
                            <p class="feature-description">
                                企業の選考に応募した学生の一覧と進捗を確認できます。
                            </p>
                            <a href="${pageContext.request.contextPath}/StatusServlet?view=applicantList" class="feature-link">
                                受験者一覧を表示
                            </a>
                        </div>
                    <% } %>

                    <!-- 管理者DB機能 -->
                    <% if ("admin".equals(role)) { %>
                        <div class="feature-card">
                            <span class="feature-icon">🛠</span>
                            <h3 class="feature-title">システム管理</h3>
                            <p class="feature-description">
                                データベースの管理とシステム設定を行います。
                            </p>
                            <a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp" class="feature-link">
                                管理者DBを開く
                            </a>
                        </div>
                    <% } %>

                    <!-- 権限エラー表示 -->
                    <% if (username != null && !("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role) || "student".equals(role))) { %>
                        <div class="feature-card" style="background: #ffebee; border-left: 4px solid #f44336;">
                            <span class="feature-icon">⚠️</span>
                            <h3 class="feature-title">アクセスエラー</h3>
                            <p class="feature-description">
                                現在の権限では利用できる機能がありません。
                                システム管理者にお問い合わせください。
                            </p>
                        </div>
                    <% } %>
                </div>
            </div>
        </section>
        <!--▲▲▲▲▲ここまで「ダッシュボードメイン」-->

        <!--▼▼▼▼▼ここから「お知らせセクション」-->
        <section class="bg3 bg-pattern3 arrow">
            <div class="c2">
                <div class="title">
                    <h2>お知らせ<span>News</span></h2>
                </div>
                <div class="text">
                    <dl class="new">
                        <dt>2025/01/20<span>重要</span></dt>
                        <dd>本年度の就職活動スケジュールが更新されました。2年次の自己分析ワークショップは1月25日に開催されます。詳細は教務部へお問い合わせください。</dd>

                        <dt>2025/01/15<span class="icon-bg1">企業説明会</span></dt>
                        <dd>県内外の主要企業による説明会が1月25日からスタートします。このアプリで予約が可能ですので、お早めに登録をしてください。</dd>

                        <dt>2025/01/10<span class="icon-bg2">就職対策</span></dt>
                        <dd>模擬面接セッションの追加開催が決定しました！1月20日から週ごとに行われます。JMSアプリを活用して予約が可能です。</dd>

                        <dt>2025/01/05<span>その他</span></dt>
                        <dd>今年度の就職活動用アプリの新機能について説明会を実施します。1月30日にオンラインで行いますので、詳細は教務部の通知をご確認ください。</dd>

                        <dt>2025/01/01<span>重要</span></dt>
                        <dd>内定承諾書の提出期限が近づいています。各自スケジュールを確認し、必要な書類を1月末までに提出してください。</dd>
                    </dl>
                </div>
            </div>
        </section>
        <!--▲▲▲▲▲ここまで「お知らせセクション」-->

        <!--▼▼▼▼▼ここから「クイックアクセス」-->
        <section class="bg-primary-color">
            <h2 class="c">クイックアクセス<span>Quick Access</span></h2>
            <div class="list-c2">
                <div class="list image1">
                    <div class="text">
                        <h4><span class="sub-text">お問い合わせ</span><span class="main-text">Contact</span></h4>
                        <p class="btn1"><a href="extension.html">お問い合わせフォーム</a></p>
                    </div>
                </div>
                <div class="list image2">
                    <div class="text">
                        <h4><span class="sub-text">資料請求</span><span class="main-text">Request</span></h4>
                        <p class="btn1"><a href="extension.html">資料請求フォーム</a></p>
                    </div>
                </div>
            </div>
        </section>
        <!--▲▲▲▲▲ここまで「クイックアクセス」-->
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
// 最適化されたダッシュボードローディング制御
document.addEventListener('DOMContentLoaded', () => {
    // ローディング時間を0.5秒に短縮
    setTimeout(() => {
        const loadingElement = document.getElementById('dashboardLoading');
        if (loadingElement) {
            loadingElement.classList.add('fade-out');
            // フェードアウト完了後に要素を削除
            setTimeout(() => {
                loadingElement.remove();
            }, 300);
        }
    }, 500);
});

// アクセシビリティの向上
document.addEventListener('DOMContentLoaded', () => {
    // キーボードナビゲーションの改善
    const featureLinks = document.querySelectorAll('.feature-link');
    featureLinks.forEach(link => {
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
</script>

</body>
</html>