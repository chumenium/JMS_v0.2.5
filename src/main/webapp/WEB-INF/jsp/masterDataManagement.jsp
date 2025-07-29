<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - マスターデータ管理</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">
<style>
    .master-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
        background: #f8f9fa;
        min-height: 100vh;
    }
    
    .master-header {
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
    
    .data-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        background: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }
    
    .data-table th,
    .data-table td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    
    .data-table th {
        background: #f8f9fa;
        font-weight: 600;
        color: #333;
    }
    
    .data-table tr:hover {
        background: #f8f9fa;
    }
    
    .btn {
        padding: 8px 16px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        display: inline-block;
        transition: all 0.3s ease;
        text-align: center;
        margin: 2px;
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
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        text-decoration: none;
        color: inherit;
    }
    
    .form-group {
        margin-bottom: 15px;
    }
    
    .form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: 600;
        color: #333;
    }
    
    .form-control {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 14px;
        box-sizing: border-box;
    }
    
    .form-control:focus {
        outline: none;
        border-color: #28a745;
        box-shadow: 0 0 0 2px rgba(40, 167, 69, 0.25);
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
    
    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
    }
    
    .modal-content {
        background-color: white;
        margin: 5% auto;
        padding: 20px;
        border-radius: 10px;
        width: 90%;
        max-width: 500px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
    }
    
    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 1px solid #ddd;
    }
    
    .modal-title {
        font-size: 18px;
        font-weight: 600;
        color: #333;
    }
    
    .close {
        color: #aaa;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
    }
    
    .close:hover {
        color: #000;
    }
    
    .action-buttons {
        display: flex;
        gap: 10px;
        margin-top: 20px;
        justify-content: flex-end;
    }
    
    .empty-message {
        text-align: center;
        padding: 40px;
        color: #666;
        font-style: italic;
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
        
        .master-container {
            padding: 10px;
        }
        
        .data-table {
            font-size: 12px;
        }
        
        .data-table th,
        .data-table td {
            padding: 8px;
        }
        
        .btn {
            padding: 6px 12px;
            font-size: 12px;
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
  
  // 管理者以外はアクセス拒否
  if (!"admin".equals(role)) {
      response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
      return;
  }
  
  // リクエスト属性を取得
  List<Map<String, Object>> occupations = (List<Map<String, Object>>) request.getAttribute("occupations");
  List<Map<String, Object>> workplaces = (List<Map<String, Object>>) request.getAttribute("workplaces");
  String currentTab = (String) request.getAttribute("currentTab");
  String successMessage = (String) request.getAttribute("success");
  String errorMessage = (String) request.getAttribute("error");
  
  // デフォルトタブ設定
  if (currentTab == null) {
      currentTab = "occupations";
  }
%>

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
    </header>
    <!--▲▲▲▲▲ここまで「ヘッダー」-->

    <main>
        <div class="master-container">
            <div class="master-header">
                <h1>📋 マスターデータ管理</h1>
                <p>職種、勤務地などのマスターデータを管理します</p>
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
                <a href="${pageContext.request.contextPath}/MasterDataManagementServlet?action=occupations" 
                   class="nav-tab <%= "occupations".equals(currentTab) ? "active" : "" %>">
                    💼 職種管理
                </a>
                <a href="${pageContext.request.contextPath}/MasterDataManagementServlet?action=workplaces" 
                   class="nav-tab <%= "workplaces".equals(currentTab) ? "active" : "" %>">
                    🏢 勤務地管理
                </a>
            </div>

            <!-- タブコンテンツ -->
            <div class="tab-content">
                <!-- 職種管理タブ -->
                <% if ("occupations".equals(currentTab)) { %>
                    <div class="tab-pane active">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                            <h3>💼 職種管理</h3>
                            <button class="btn btn-success" onclick="showAddOccupationModal()">
                                ➕ 新規追加
                            </button>
                        </div>
                        
                        <% if (occupations != null && !occupations.isEmpty()) { %>
                            <table class="data-table">
                                                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>職種名</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                <tbody>
                                    <% for (Map<String, Object> occupation : occupations) { %>
                                                                                    <tr>
                                                <td><%= occupation.get("id") %></td>
                                                <td><%= occupation.get("name") %></td>
                                                <td>
                                                <button class="btn btn-warning" onclick="showEditOccupationModal(<%= occupation.get("id") %>, '<%= occupation.get("name") %>', '')">
                                                    編集
                                                </button>
                                                <button class="btn btn-danger" onclick="deleteOccupation(<%= occupation.get("id") %>, '<%= occupation.get("name") %>')">
                                                    削除
                                                </button>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } else { %>
                            <div class="empty-message">
                                <p>職種データが登録されていません</p>
                                <button class="btn btn-success" onclick="showAddOccupationModal()">
                                    ➕ 最初の職種を追加
                                </button>
                            </div>
                        <% } %>
                    </div>
                <% } %>

                <!-- 勤務地管理タブ -->
                <% if ("workplaces".equals(currentTab)) { %>
                    <div class="tab-pane active">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                            <h3>🏢 勤務地管理</h3>
                            <button class="btn btn-success" onclick="showAddWorkplaceModal()">
                                ➕ 新規追加
                            </button>
                        </div>
                        
                        <% if (workplaces != null && !workplaces.isEmpty()) { %>
                            <table class="data-table">
                                                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>勤務地名</th>
                                            <th>操作</th>
                                        </tr>
                                    </thead>
                                <tbody>
                                    <% for (Map<String, Object> workplace : workplaces) { %>
                                                                                    <tr>
                                                <td><%= workplace.get("id") %></td>
                                                <td><%= workplace.get("name") %></td>
                                                <td>
                                                <button class="btn btn-warning" onclick="showEditWorkplaceModal(<%= workplace.get("id") %>, '<%= workplace.get("name") %>', '')">
                                                    編集
                                                </button>
                                                <button class="btn btn-danger" onclick="deleteWorkplace(<%= workplace.get("id") %>, '<%= workplace.get("name") %>')">
                                                    削除
                                                </button>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } else { %>
                            <div class="empty-message">
                                <p>勤務地データが登録されていません</p>
                                <button class="btn btn-success" onclick="showAddWorkplaceModal()">
                                    ➕ 最初の勤務地を追加
                                </button>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>

            <!-- アクションボタン -->
            <div style="text-align: center; margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase" class="btn btn-primary">
                    ← 管理者設定に戻る
                </a>
            </div>
        </div>
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
            <% if (username != null) { %>
                <li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
            <% } %>
        </ul>
    </nav>
</div>
<!--/#menubar-->

<!-- 職種追加モーダル -->
<div id="addOccupationModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <span class="modal-title">職種を追加</span>
            <span class="close" onclick="closeModal('addOccupationModal')">&times;</span>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/MasterDataManagementServlet">
            <input type="hidden" name="action" value="addOccupation">
            <div class="form-group">
                <label for="occupationName">職種名 *</label>
                <input type="text" id="occupationName" name="name" class="form-control" required>
            </div>

            <div class="action-buttons">
                <button type="button" class="btn btn-warning" onclick="closeModal('addOccupationModal')">キャンセル</button>
                <button type="submit" class="btn btn-success">追加</button>
            </div>
        </form>
    </div>
</div>

<!-- 職種編集モーダル -->
<div id="editOccupationModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <span class="modal-title">職種を編集</span>
            <span class="close" onclick="closeModal('editOccupationModal')">&times;</span>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/MasterDataManagementServlet">
            <input type="hidden" name="action" value="updateOccupation">
            <input type="hidden" id="editOccupationId" name="id">
            <div class="form-group">
                <label for="editOccupationName">職種名 *</label>
                <input type="text" id="editOccupationName" name="name" class="form-control" required>
            </div>

            <div class="action-buttons">
                <button type="button" class="btn btn-warning" onclick="closeModal('editOccupationModal')">キャンセル</button>
                <button type="submit" class="btn btn-success">更新</button>
            </div>
        </form>
    </div>
</div>

<!-- 勤務地追加モーダル -->
<div id="addWorkplaceModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <span class="modal-title">勤務地を追加</span>
            <span class="close" onclick="closeModal('addWorkplaceModal')">&times;</span>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/MasterDataManagementServlet">
            <input type="hidden" name="action" value="addWorkplace">
            <div class="form-group">
                <label for="workplaceName">勤務地名 *</label>
                <input type="text" id="workplaceName" name="name" class="form-control" required>
            </div>

            <div class="action-buttons">
                <button type="button" class="btn btn-warning" onclick="closeModal('addWorkplaceModal')">キャンセル</button>
                <button type="submit" class="btn btn-success">追加</button>
            </div>
        </form>
    </div>
</div>

<!-- 勤務地編集モーダル -->
<div id="editWorkplaceModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <span class="modal-title">勤務地を編集</span>
            <span class="close" onclick="closeModal('editWorkplaceModal')">&times;</span>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/MasterDataManagementServlet">
            <input type="hidden" name="action" value="updateWorkplace">
            <input type="hidden" id="editWorkplaceId" name="id">
            <div class="form-group">
                <label for="editWorkplaceName">勤務地名 *</label>
                <input type="text" id="editWorkplaceName" name="name" class="form-control" required>
            </div>

            <div class="action-buttons">
                <button type="button" class="btn btn-warning" onclick="closeModal('editWorkplaceModal')">キャンセル</button>
                <button type="submit" class="btn btn-success">更新</button>
            </div>
        </form>
    </div>
</div>

<!--jQueryの読み込み-->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<!--パララックス（inview）-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/protonet-jquery.inview/1.1.2/jquery.inview.min.js"></script>
<script src="js/jquery.inview_set.js"></script>
<!--このテンプレート専用のスクリプト-->
<script src="js/main.js"></script>

<script>
// モーダル表示・非表示
function showAddOccupationModal() {
    document.getElementById('addOccupationModal').style.display = 'block';
}

function showEditOccupationModal(id, name, description) {
    document.getElementById('editOccupationId').value = id;
    document.getElementById('editOccupationName').value = name;
    document.getElementById('editOccupationDescription').value = description;
    document.getElementById('editOccupationModal').style.display = 'block';
}

function showAddWorkplaceModal() {
    document.getElementById('addWorkplaceModal').style.display = 'block';
}

function showEditWorkplaceModal(id, name, description) {
    document.getElementById('editWorkplaceId').value = id;
    document.getElementById('editWorkplaceName').value = name;
    document.getElementById('editWorkplaceDescription').value = description;
    document.getElementById('editWorkplaceModal').style.display = 'block';
}

function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
}

// 削除確認
function deleteOccupation(id, name) {
    if (confirm('職種「' + name + '」を削除しますか？\n\n注意: 使用中の職種は削除できません。')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/MasterDataManagementServlet';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'deleteOccupation';
        
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'id';
        idInput.value = id;
        
        form.appendChild(actionInput);
        form.appendChild(idInput);
        document.body.appendChild(form);
        form.submit();
    }
}

function deleteWorkplace(id, name) {
    if (confirm('勤務地「' + name + '」を削除しますか？\n\n注意: 使用中の勤務地は削除できません。')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/MasterDataManagementServlet';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'deleteWorkplace';
        
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'id';
        idInput.value = id;
        
        form.appendChild(actionInput);
        form.appendChild(idInput);
        document.body.appendChild(form);
        form.submit();
    }
}

// モーダル外クリックで閉じる
window.onclick = function(event) {
    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
}

// ページ読み込み時の処理
document.addEventListener('DOMContentLoaded', function() {
    console.log('マスターデータ管理画面が読み込まれました');
    
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