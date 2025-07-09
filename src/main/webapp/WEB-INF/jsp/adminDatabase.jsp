<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - システム管理</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">
<style>
    .admin-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
        background: #f8f9fa;
        min-height: 100vh;
    }
    
    .admin-header {
        background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        color: white;
        padding: 30px;
        border-radius: 10px;
        margin-bottom: 30px;
        text-align: center;
    }
    
    .admin-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }
    
    .admin-card {
        background: white;
        border-radius: 10px;
        padding: 25px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        border-left: 4px solid #dc3545;
    }
    
    .admin-card h3 {
        color: #dc3545;
        margin-bottom: 15px;
        font-size: 18px;
    }
    
    .admin-btn {
        background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
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
    }
    
    .admin-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
        color: white;
        text-decoration: none;
    }
    
    .warning-card {
        background: #fff3cd;
        border: 1px solid #ffeaa7;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
    }
    
    .warning-card h4 {
        color: #856404;
        margin-bottom: 10px;
    }
    
    .db-status {
        background: white;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }
    
    .status-indicator {
        display: inline-block;
        width: 12px;
        height: 12px;
        border-radius: 50%;
        margin-right: 8px;
    }
    
    .status-online {
        background: #28a745;
    }
    
    .status-offline {
        background: #dc3545;
    }
    
    @media (max-width: 768px) {
        .admin-grid {
            grid-template-columns: 1fr;
        }
        
        .admin-container {
            padding: 10px;
        }
    }
</style>
</head>

<body>
<% 
  String username = (String) session.getAttribute("username"); 
  String role = (String) session.getAttribute("role"); 
  
  // 管理者以外はアクセス拒否
  if (!"admin".equals(role)) {
      response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
      return;
  }
%>

<div id="container">
    <!--▼▼▼▼▼ここから「ヘッダー」-->
    <header>
        <h1 id="logo"><a href="${pageContext.request.contextPath}/DashboardServlet"><img src="images/logo.png" alt="jms"></a></h1>
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/DashboardServlet">ホーム</a></li>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
                <li><a href="extension.html">お問い合わせ</a></li>
                <li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
            </ul>
        </nav>
    </header>
    <!--▲▲▲▲▲ここまで「ヘッダー」-->

    <main>
        <div class="admin-container">
            <div class="admin-header">
                <h1>🛠️ システム管理</h1>
                <p>データベースとシステム設定の管理</p>
            </div>

            <div class="warning-card">
                <h4>⚠️ 重要な注意事項</h4>
                <p>この画面では重要なシステム操作を行います。操作前に必ずバックアップを取得し、慎重に実行してください。</p>
            </div>

            <div class="db-status">
                <h3>データベース接続状況</h3>
                <p><span class="status-indicator status-online"></span>メインデータベース: 接続中</p>
                <p><span class="status-indicator status-online"></span>バックアップデータベース: 待機中</p>
            </div>

            <div class="admin-grid">
                <div class="admin-card">
                    <h3>📊 データベース管理</h3>
                    <p>データベースのバックアップ、復元、最適化を行います。</p>
                    <a href="${pageContext.request.contextPath}/DatabaseManagementServlet" class="admin-btn">データベース管理画面</a>
                    <a href="${pageContext.request.contextPath}/DatabaseManagementServlet?action=statistics" class="admin-btn">統計情報表示</a>
                    <a href="${pageContext.request.contextPath}/DatabaseManagementServlet?action=backup" class="admin-btn" onclick="return confirm('バックアップを実行しますか？')">バックアップ実行</a>
                </div>

                <div class="admin-card">
                    <h3>👥 ユーザー管理</h3>
                    <p>システムユーザーの管理と権限設定を行います。</p>
                    <a href="${pageContext.request.contextPath}/CreateStudentServlet" class="admin-btn">学生アカウント作成</a>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">教員アカウント管理</a>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">権限設定</a>
                </div>

                <div class="admin-card">
                    <h3>🏢 マスターデータ管理</h3>
                    <p>職種、業界、勤務地などのマスターデータを管理します。</p>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">職種マスター</a>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">業界マスター</a>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">勤務地マスター</a>
                </div>

                <div class="admin-card">
                    <h3>📈 システム統計</h3>
                    <p>システムの利用状況と統計情報を確認します。</p>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">利用統計</a>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">エラーログ</a>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">パフォーマンス</a>
                </div>

                <div class="admin-card">
                    <h3>⚙️ システム設定</h3>
                    <p>システム全体の設定と構成を管理します。</p>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">システム設定</a>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">メール設定</a>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">セキュリティ設定</a>
                </div>

                <div class="admin-card">
                    <h3>🔄 データメンテナンス</h3>
                    <p>データの整合性チェックと修復を行います。</p>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">データ整合性チェック</a>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">不要データ削除</a>
                    <a href="#" class="admin-btn" onclick="showComingSoon()">データ修復</a>
                </div>
            </div>
        </div>
    </main>

    <!--▼▼▼▼▼ここから「フッター」-->
    <footer>
        <div>
            <p class="logo"><img src="images/logo.png" alt="Job Management System"></p>
            <small>Copyright&copy; @ 2025 Job Management System All Rights Reserved.</small>
        </div>
    </footer>
    <!--▲▲▲▲▲ここまで「フッター」-->
</div>

<script>
function showComingSoon() {
    alert('この機能は開発中です。近日公開予定です。');
}

// ページ読み込み時の処理
document.addEventListener('DOMContentLoaded', function() {
    console.log('管理者画面が読み込まれました');
    
    // 権限チェック
    const role = '<%= role %>';
    if (role !== 'admin') {
        alert('管理者権限が必要です');
        window.location.href = '${pageContext.request.contextPath}/error/access-denied.html';
    }
});
</script>

</body>
</html> 