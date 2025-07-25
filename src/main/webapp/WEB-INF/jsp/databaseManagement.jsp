<!--*
：：：色のテーマは緑：：：
DB管理用画面

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

||**DB管理者のみ見れる||

**

*-->

<!--KCS_JMS_PROJECT-->


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - データベース管理</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">
<style>
    .db-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 20px;
        background: #f8f9fa;
        min-height: 100vh;
    }
    
    .db-header {
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        color: white;
        padding: 30px;
        border-radius: 10px;
        margin-bottom: 30px;
        text-align: center;
    }
    
    .nav-tabs {
        display: flex;
        background: white;
        border-radius: 10px 10px 0 0;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        margin-bottom: 0;
    }
    
    .nav-tab {
        flex: 1;
        padding: 15px 20px;
        text-align: center;
        background: #f8f9fa;
        border: none;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        color: #666;
        transition: all 0.3s ease;
        text-decoration: none;
        display: block;
    }
    
    .nav-tab:first-child {
        border-radius: 10px 0 0 0;
    }
    
    .nav-tab:last-child {
        border-radius: 0 10px 0 0;
    }
    
    .nav-tab.active {
        background: #28a745;
        color: white;
    }
    
    .nav-tab:hover:not(.active) {
        background: #e9ecef;
        color: #333;
    }
    
    .tab-content {
        background: white;
        border-radius: 0 0 10px 10px;
        padding: 30px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        margin-bottom: 30px;
    }
    
    .tab-pane {
        display: none;
    }
    
    .tab-pane.active {
        display: block;
    }
    
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }
    
    .stat-card {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 20px;
        border-left: 4px solid #28a745;
    }
    
    .stat-label {
        font-size: 12px;
        color: #666;
        text-transform: uppercase;
        margin-bottom: 5px;
    }
    
    .stat-value {
        font-size: 24px;
        font-weight: bold;
        color: #28a745;
    }
    
    .action-buttons {
        display: flex;
        gap: 15px;
        margin-bottom: 30px;
        flex-wrap: wrap;
    }
    
    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        display: inline-block;
        transition: all 0.3s ease;
        text-align: center;
    }
    
    .btn-primary {
        background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
        color: white;
    }
    
    .btn-success {
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        color: white;
    }
    
    .btn-warning {
        background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
        color: #212529;
    }
    
    .btn-danger {
        background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        color: white;
    }
    
    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        text-decoration: none;
        color: inherit;
    }
    
    .table-responsive {
        overflow-x: auto;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
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
    }
    
    tr:hover {
        background: #f8f9fa;
    }
    
    .alert {
        padding: 15px;
        border-radius: 5px;
        margin-bottom: 20px;
    }
    
    .alert-success {
        background: #d4edda;
        border: 1px solid #c3e6cb;
        color: #155724;
    }
    
    .alert-danger {
        background: #f8d7da;
        border: 1px solid #f5c6cb;
        color: #721c24;
    }
    
    .alert-info {
        background: #d1ecf1;
        border: 1px solid #bee5eb;
        color: #0c5460;
    }
    
    .result-list {
        background: #f8f9fa;
        border-radius: 5px;
        padding: 15px;
        margin-top: 15px;
        max-height: 300px;
        overflow-y: auto;
    }
    
    .result-item {
        padding: 8px 0;
        border-bottom: 1px solid #e9ecef;
        font-family: monospace;
        font-size: 14px;
    }
    
    .result-item:last-child {
        border-bottom: none;
    }
    
    .loading {
        display: none;
        text-align: center;
        padding: 20px;
        color: #666;
    }
    
    .loading.show {
        display: block;
    }
    
    .spinner {
        display: inline-block;
        width: 20px;
        height: 20px;
        border: 3px solid #f3f3f3;
        border-top: 3px solid #28a745;
        border-radius: 50%;
        animation: spin 1s linear infinite;
        margin-right: 10px;
    }
    
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }
    
    @media (max-width: 768px) {
        .nav-tabs {
            flex-direction: column;
        }
        
        .nav-tab {
            border-radius: 0 !important;
        }
        
        .nav-tab:first-child {
            border-radius: 10px 10px 0 0 !important;
        }
        
        .stats-grid {
            grid-template-columns: 1fr;
        }
        
        .action-buttons {
            flex-direction: column;
        }
        
        .db-container {
            padding: 10px;
        }
        
        
        
	/* 幅間調整用 */
		.custom-section {
	    width: 100vw;           /* ビューポート全体の横幅を使用 */
	    max-width: none;        /* 最大幅の制限を解除 */
	    margin: 0;
	    padding: 40px 32px;
	    margin-top: 100px; /* ← ヘッダーとの距離をここで確保 */
	    margin-bottom: 20px; /* ← 例えば60pxで広めに */
	    box-sizing: border-box;
	    background-color: #ffffff;
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
    }
</style>
</head>

<body>

<!-- ここでセッションを取得しているため消さないように -->
<% 
  String username = (String) session.getAttribute("username"); 
  String role = (String) session.getAttribute("role"); 
  
//権限名を日本語に変換
 String roleDisplay = "";
 switch(role) {
   case "teacher": roleDisplay = "教員"; break;
   case "headmaster": roleDisplay = "教務部長・校長"; break;
   case "egd": roleDisplay = "就職指導部"; break;
   case "admin": roleDisplay = "システム管理者"; break;
   case "student": roleDisplay = "学生"; break;
   default: roleDisplay = role; break;
 }
  
  
  // 管理者以外はアクセス拒否
  if (!"admin".equals(role)) {
      response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
      return;
  }
  
  // リクエスト属性を取得
  Map<String, Object> statistics = (Map<String, Object>) request.getAttribute("statistics");
  List<Map<String, Object>> tables = (List<Map<String, Object>>) request.getAttribute("tables");
  List<String> optimizationResults = (List<String>) request.getAttribute("optimizationResults");
  List<String> checkResults = (List<String>) request.getAttribute("checkResults");
  String successMessage = (String) request.getAttribute("success");
  String errorMessage = (String) request.getAttribute("error");
%>
<!-- ::::::::::::::::::: -->

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
        <section class="custom-section" role="main" aria-label="幅調整用">
            <div class=" db-header">
                <h1>🗄️ データベース管理</h1>
                <p>データベースの統計情報、バックアップ、最適化、整合性チェック</p>
            </div>

            <!-- メッセージ表示 -->
            <% if (successMessage != null) { %>
                <div class="alert alert-success">
                    <strong>成功:</strong> <%= successMessage %>
                </div>
            <% } %>
            
            <% if (errorMessage != null) { %>
                <div class="alert alert-danger">
                    <strong>エラー:</strong> <%= errorMessage %>
                </div>
            <% } %>

            <!-- ナビゲーションタブ -->
            <div class="nav-tabs">
                <a href="${pageContext.request.contextPath}/DatabaseManagementServlet?action=statistics" 
                   class="nav-tab <%= request.getParameter("action") == null || "statistics".equals(request.getParameter("action")) ? "active" : "" %>">
                    📊 統計情報
                </a>
                <a href="${pageContext.request.contextPath}/DatabaseManagementServlet?action=tables" 
                   class="nav-tab <%= "tables".equals(request.getParameter("action")) ? "active" : "" %>">
                    📋 テーブル一覧
                </a>
                <a href="#" class="nav-tab" onclick="showBackupTab()">
                    💾 バックアップ
                </a>
                <a href="#" class="nav-tab" onclick="showMaintenanceTab()">
                    🔧 メンテナンス
                </a>
            </div>

            <!-- タブコンテンツ -->
            <div class="tab-content">
                <!-- 統計情報タブ -->
                <% if (statistics != null) { %>
                    <div class="tab-pane active">
                        <h3>📊 データベース統計情報</h3>
                        
                        <div class="stats-grid">
                            <div class="stat-card">
                                <div class="stat-label">データベース名</div>
                                <div class="stat-value"><%= statistics.get("databaseName") %></div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">バージョン</div>
                                <div class="stat-value"><%= statistics.get("databaseVersion") %></div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">データベースサイズ</div>
                                <div class="stat-value"><%= statistics.get("databaseSizeMB") %> MB</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">接続時刻</div>
                                <div class="stat-value" style="font-size: 16px;"><%= statistics.get("connectionTime") %></div>
                            </div>
                        </div>

                        <h4>テーブル統計</h4>
                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th>テーブル名</th>
                                        <th>レコード数</th>
                                        <th>状態</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    Map<String, Integer> tableCounts = (Map<String, Integer>) statistics.get("tableCounts");
                                    if (tableCounts != null) {
                                        for (Map.Entry<String, Integer> entry : tableCounts.entrySet()) {
                                    %>
                                        <tr>
                                            <td><%= entry.getKey() %></td>
                                            <td><%= entry.getValue() >= 0 ? entry.getValue() : "N/A" %></td>
                                            <td>
                                                <% if (entry.getValue() >= 0) { %>
                                                    <span style="color: #28a745;">✓ 正常</span>
                                                <% } else { %>
                                                    <span style="color: #dc3545;">✗ 不明</span>
                                                <% } %>
                                            </td>
                                        </tr>
                                    <% 
                                        }
                                    }
                                    %>
                                </tbody>
                            </table>
                        </div>

                        <div style="margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 5px;">
                            <h5>接続情報</h5>
                            <p><strong>ドライバー:</strong> <%= statistics.get("driverName") %> (<%= statistics.get("driverVersion") %>)</p>
                            <p><strong>接続URL:</strong> <%= statistics.get("connectionUrl") %></p>
                        </div>
                    </div>
                <% } %>

                <!-- テーブル一覧タブ -->
                <% if (tables != null) { %>
                    <div class="tab-pane active">
                        <h3>📋 テーブル詳細情報</h3>
                        
                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th>テーブル名</th>
                                        <th>レコード数</th>
                                        <th>サイズ (MB)</th>
                                        <th>エンジン</th>
                                        <th>文字コード</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> table : tables) { %>
                                        <tr>
                                            <td><%= table.get("name") %></td>
                                            <td><%= table.get("rows") %></td>
                                            <td><%= table.get("sizeMB") %></td>
                                            <td><%= table.get("engine") %></td>
                                            <td><%= table.get("collation") %></td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                <% } %>

                <!-- デフォルト表示（統計情報がない場合） -->
                <% if (statistics == null && tables == null) { %>
                    <div class="tab-pane active">
                        <h3>📊 データベース管理</h3>
                        
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/DatabaseManagementServlet?action=statistics" class="btn btn-primary">
                                📊 統計情報を表示
                            </a>
                            <a href="${pageContext.request.contextPath}/DatabaseManagementServlet?action=tables" class="btn btn-success">
                                📋 テーブル一覧を表示
                            </a>
                        </div>

                        <div class="alert alert-info">
                            <strong>情報:</strong> データベース管理機能を使用するには、上記のボタンから操作を選択してください。
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- アクションボタン -->
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/DatabaseManagementServlet?action=backup" 
                   class="btn btn-primary">
                    💾 バックアップ実行（ダウンロード）
                </a>
                <a href="${pageContext.request.contextPath}/DatabaseManagementServlet?action=optimize" 
                   class="btn btn-warning" onclick="return confirmAction('データベースを最適化しますか？')">
                    🚀 データベース最適化
                </a>
                <a href="${pageContext.request.contextPath}/DatabaseManagementServlet?action=check" 
                   class="btn btn-success">
                    🔍 整合性チェック
                </a>
                <a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase" 
                   class="btn btn-danger">
                    ← システム管理に戻る
                </a>
            </div>

            <!-- 結果表示エリア -->
            <% if (optimizationResults != null && !optimizationResults.isEmpty()) { %>
                <div class="alert alert-info">
                    <h5>最適化結果:</h5>
                    <div class="result-list">
                        <% for (String result : optimizationResults) { %>
                            <div class="result-item"><%= result %></div>
                        <% } %>
                    </div>
                </div>
            <% } %>

            <% if (checkResults != null && !checkResults.isEmpty()) { %>
                <div class="alert alert-info">
                    <h5>整合性チェック結果:</h5>
                    <div class="result-list">
                        <% for (String result : checkResults) { %>
                            <div class="result-item"><%= result %></div>
                        <% } %>
                    </div>
                </div>
            <% } %>

            <!-- ローディング表示 -->
            <div id="loading" class="loading">
                <div class="spinner"></div>
                処理中です。しばらくお待ちください...
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
function confirmAction(message) {
    return confirm(message + '\n\n注意: この操作は時間がかかる場合があります。');
}

function showLoading() {
    document.getElementById('loading').classList.add('show');
}

function hideLoading() {
    document.getElementById('loading').classList.remove('show');
}

function showBackupTab() {
    // バックアップタブの内容を表示
    const tabContent = document.querySelector('.tab-content');
    const activePane = tabContent.querySelector('.tab-pane.active');
    if (activePane) {
        activePane.classList.remove('active');
    }
    
    // バックアップタブの内容を作成
    const backupPane = document.createElement('div');
    backupPane.className = 'tab-pane active';
    backupPane.innerHTML = `
        <h3>💾 データベースバックアップ</h3>
        <div class="alert alert-info">
            <strong>バックアップ機能:</strong>
            <ul>
                <li>全テーブルの構造とデータをSQLファイルとしてエクスポート</li>
                <li>バックアップファイルは自動的にダウンロード可能</li>
                <li>文字エンコーディング: UTF-8</li>
                <li>大量データ対応（1000行ごとにINSERT文を分割）</li>
            </ul>
        </div>
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/DatabaseManagementServlet?action=backup" 
               class="btn btn-success" onclick="return confirmAction('バックアップを実行しますか？\n\n注意: データ量によっては時間がかかる場合があります。')">
                💾 バックアップ実行
            </a>
        </div>
    `;
    
    tabContent.appendChild(backupPane);
    
    // タブのアクティブ状態を更新
    const tabs = document.querySelectorAll('.nav-tab');
    tabs.forEach(tab => tab.classList.remove('active'));
    event.target.classList.add('active');
}

function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(function() {
        alert('パスをクリップボードにコピーしました');
    }).catch(function(err) {
        console.error('クリップボードへのコピーに失敗しました:', err);
        // フォールバック: テキストエリアを使用
        const textArea = document.createElement('textarea');
        textArea.value = text;
        document.body.appendChild(textArea);
        textArea.select();
        document.execCommand('copy');
        document.body.removeChild(textArea);
        alert('パスをクリップボードにコピーしました');
    });
}

function showMaintenanceTab() {
    alert('メンテナンス機能は開発中です。\n\n現在利用可能な機能:\n- データベース最適化\n- 整合性チェック');
}

// ページ読み込み時の処理
document.addEventListener('DOMContentLoaded', function() {
    console.log('データベース管理画面が読み込まれました');
    
    // 権限チェック
    const role = '<%= role %>';
    if (role !== 'admin') {
        alert('管理者権限が必要です');
        window.location.href = '${pageContext.request.contextPath}/error/access-denied.html';
    }
    
    // リンクにローディング表示を追加
    const actionLinks = document.querySelectorAll('a[href*="DatabaseManagementServlet"]');
    actionLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            if (this.href.includes('action=')) {
                showLoading();
            }
        });
    });
});

// フォーム送信時のローディング表示
document.addEventListener('submit', function(e) {
    showLoading();
});
</script>


</body>
</html> 