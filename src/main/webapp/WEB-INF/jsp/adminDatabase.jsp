<!--*
：：：色のテーマは赤：：：
DB用画面

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

||**管理者用**||

**

*-->

<!--KCS_JMS_PROJECT-->

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
        max-width: 3000px;
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
	
	/* 幅間調整用 */
	.custom-section {
    width: 200vw;           /* ビューポート全体の横幅を使用 */
    max-width: none;        /* 最大幅の制限を解除 */
    margin: 0;
    padding: 40px 32px;
    margin-top: 60px; /* ← ヘッダーとの距離をここで確保 */
    margin-bottom: 60px; /* ← 例えば60pxで広めに */
    box-sizing: border-box;
    background-color: #ebd0b8f6;
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


<!-- DBローディング画面 -->
<div id="dashboardLoading" class="dashboard-loading">
    <div class="dashboard-loading-container">
        <div class="dashboard-loading-spinner"></div>
        <div class="dashboard-loading-text">データベースをを読み込み中...</div>
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
                <!-- 管理者権限のナビゲーション -->
                <% if ("admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase">管理者設定</a></li>
                <% } %>
                <!-- 教師権限のナビゲーション -->
                <% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
                <% } %>
                <!-- 生徒権限のナビゲーション -->
                <% if ("student".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/SelectionStageServlet">選考ステージ登録</a></li>
                    <li><a href="${pageContext.request.contextPath}/InterviewExamInputServlet">試験面接情報</a></li>
                    <li><a href="${pageContext.request.contextPath}/CompanyListServlet">企業一覧</a></li>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">書類提出チェック</a></li>
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
    	<section class="custom-section"  role="main" aria-label="黒 統一">
	            <div class="admin-header">
	                <h1>🛠️ システム管理</h1>
	                <p>データベースとシステム設定の管理</p>
	            </div>
	
	            <div class="warning-card">
	                <h4>⚠️ 重要な注意事項</h4>
	                <p style="color: #000000">この画面では重要なシステム操作を行います。操作前に必ずバックアップを取得し、慎重に実行してください。</p>
	            </div>
	
	            <div class="db-status">
	                <h3 style="color: #000000">データベース接続状況</h3>
	                <p style="color: #000000"><span class="status-indicator status-online"></span>メインデータベース: 接続中</p>
	                <p style="color: #000000"><span class="status-indicator status-online"></span>バックアップデータベース: 待機中</p>
	            </div>
	
	            <div class="admin-grid">
	                <div class="admin-card">
	                    <h3>📊 データベース管理</h3>
	                    <p style="color: #000000">データベースのバックアップ、復元、最適化を行います。</p>
	                    <a href="${pageContext.request.contextPath}/DatabaseManagementServlet" class="admin-btn">データベース管理画面</a>
	                    <a href="${pageContext.request.contextPath}/DatabaseManagementServlet?action=statistics" class="admin-btn">統計情報表示</a>
	                    <a href="${pageContext.request.contextPath}/DatabaseManagementServlet?action=backup" class="admin-btn" onclick="return confirm('バックアップを実行しますか？')">バックアップ実行</a>
	                </div>
	
	                                <div class="admin-card">
                    <h3>👥 ユーザー管理</h3>
                    <p style="color: #000000">システムユーザーの管理と権限設定を行います。</p>
                    <a href="${pageContext.request.contextPath}/UserRoleManagementServlet" class="admin-btn">権限設定</a>
                </div>
	
	                <div class="admin-card">
	                    <h3>🏢 マスターデータ管理</h3>
	                    <p style="color: #000000">職種、業界、勤務地などのマスターデータを管理します。</p>
	                    <a href="#" class="admin-btn" onclick="showComingSoon()">職種マスター</a>
	                    <a href="#" class="admin-btn" onclick="showComingSoon()">業界マスター</a>
	                    <a href="#" class="admin-btn" onclick="showComingSoon()">勤務地マスター</a>
	                </div>
	
	                <div class="admin-card">
	                    <h3>📈 システム統計</h3>
	                    <p style="color: #000000">システムの利用状況と統計情報を確認します。</p>
	                    <a href="#" class="admin-btn" onclick="showComingSoon()">利用統計</a>
	                    <a href="#" class="admin-btn" onclick="showComingSoon()">エラーログ</a>
	                    <a href="#" class="admin-btn" onclick="showComingSoon()">パフォーマンス</a>
	                </div>
	
	                <div class="admin-card">
	                    <h3>⚙️ システム設定</h3>
	                    <p style="color: #000000">システム全体の設定と構成を管理します。</p>
	                    <a href="#" class="admin-btn" onclick="showComingSoon()">システム設定</a>
	                    <a href="#" class="admin-btn" onclick="showComingSoon()">メール設定</a>
	                    <a href="#" class="admin-btn" onclick="showComingSoon()">セキュリティ設定</a>
	                </div>
	
	                <div class="admin-card">
	                    <h3>🔄 データメンテナンス</h3>
	                    <p style="color: #000000">データの整合性チェックと修復を行います。</p>
	                    <a href="#" class="admin-btn" onclick="showComingSoon()">データ整合性チェック</a>
	                    <a href="#" class="admin-btn" onclick="showComingSoon()">不要データ削除</a>
	                    <a href="#" class="admin-btn" onclick="showComingSoon()">データ修復</a>
	                </div>
	    </section>
	    
	    
	    <!--▼▼▼▼▼ここから「お知らせセクション（システム管理者向け）」-->
		<section class="bg3 bg-pattern3 arrow">
		  <div class="c2">
		    <div class="title">
		      <h2>管理者向けのお知らせ<span>Admin News</span></h2>
		    </div>
		    <div class="text">
		      <dl class="new">
		        <dt>2025/01/20<span>重要</span></dt>
		        <dd>本年度の運用スケジュールが更新されました。新しいカレンダーは管理者ポータルにてご確認いただけます。</dd>
		
		        <dt>2025/01/15<span class="icon-bg1">機能更新</span></dt>
		        <dd>企業説明会予約システムに新機能を追加しました。予約管理と通知設定のカスタマイズが可能になっています。</dd>
		
		        <dt>2025/01/10<span class="icon-bg2">運用支援</span></dt>
		        <dd>面接対策支援ツールの操作ガイドを改訂しました。JMS管理メニュー内からダウンロード可能です。</dd>
		
		        <dt>2025/01/05<span>その他</span></dt>
		        <dd>新年度のアプリ機能紹介セミナーを1月30日に実施予定です。参加申し込みは管理者ページよりお願いいたします。</dd>
		
		        <dt>2025/01/01<span>重要</span></dt>
		        <dd>内定承諾書提出状況の確認手順が変更されました。詳細は教務部からの通知をご参照ください。</dd>
		      </dl>
		    </div>
		  </div>
		</section>
		<!--▲▲▲▲▲ここまで「お知らせセクション（システム管理者向け）」-->
	    
	    
	    
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
                <!-- 管理者権限のナビゲーション -->
                <% if ("admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase">管理者設定</a></li>
                <% } %>
                <!-- 教師権限のナビゲーション -->
                <% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
                <% } %>
                <!-- 生徒権限のナビゲーション -->
                <% if ("student".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/SelectionStageServlet">選考ステージ登録</a></li>
                    <li><a href="${pageContext.request.contextPath}/SelectionStageViewServlet">選考ステージ確認</a></li>
                    <li><a href="${pageContext.request.contextPath}/CompanyListServlet">企業一覧</a></li>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">書類提出チェック</a></li>
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
            <!-- 管理者権限のナビゲーション -->
            <% if ("admin".equals(role)) { %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">管理者設定</a></li>
            <% } %>
            <!-- 教師権限のナビゲーション -->
            <% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role)) { %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
            <% } %>
            <!-- 生徒権限のナビゲーション -->
            <% if ("student".equals(role)) { %>
                <li><a href="${pageContext.request.contextPath}/SelectionStageServlet">選考ステージ登録</a></li>
                <li><a href="${pageContext.request.contextPath}/SelectionStageViewServlet">選考ステージ確認</a></li>
                <li><a href="${pageContext.request.contextPath}/CompanyListServlet">企業一覧</a></li>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">書類提出チェック</a></li>
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

<!-- ローディング用スクリプト -->
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