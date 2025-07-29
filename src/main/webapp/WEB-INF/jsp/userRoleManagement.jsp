<!--*
：：：色のテーマは緑：：：
ユーザー権限管理画面

******管理者のみ表示されるページ****

:::権限一覧:::

{
  "teacher":           "教員",
  "headmaster": "教務部長_校長",
  "egd":      "就職指導部",
  "admin":             "管理者",
  "student":           "学生"
}

||**管理者のみ見れる||

**

*-->

<!--KCS_JMS_PROJECT-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - ユーザー権限管理</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">
<style>
    .role-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
        background: #f8f9fa;
        min-height: 100vh;
        margin-top: 60px; /* ← ヘッダーとの距離をここで確保 */
	    margin-bottom: 60px; /* ← 例えば60pxで広めに */
    }
    
    .role-header {
        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        color: white;
        padding: 30px;
        border-radius: 10px;
         margin-top: 110px;
        margin-bottom: 30px;
        text-align: center;
        
    }
    
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }
    
    .stat-card {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 20px;
        border-left: 4px solid #28a745;
        text-align: center;
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
    
    .table-responsive {
        overflow-x: auto;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        margin-bottom: 30px;
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
    
    .role-badge {
        padding: 4px 8px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
        color: white;
        text-align: center;
        display: inline-block;
        min-width: 80px;
    }
    
    .role-student {
        background: #28a745;
    }
    
    .role-teacher {
        background: #007bff;
    }
    
    .role-headmaster {
        background: #6f42c1;
    }
    
    .role-egd {
        background: #fd7e14;
    }
    
    .role-admin {
        background: #dc3545;
    }
    
    .role-select {
        padding: 6px 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
        background: white;
        font-size: 14px;
        cursor: pointer;
        transition: border-color 0.3s ease;
    }
    
    .role-select:hover {
        border-color: #28a745;
    }
    
    .role-select:focus {
        outline: none;
        border-color: #28a745;
        box-shadow: 0 0 0 2px rgba(40, 167, 69, 0.25);
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
    
    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        text-decoration: none;
        color: inherit;
    }
    
    @media (max-width: 768px) {
        .stats-grid {
            grid-template-columns: 1fr;
        }
        
        .role-container {
            padding: 10px;
        }
        
        .custom-section {
            width: 100vw;
            max-width: none;
            margin: 0;
            padding: 40px 32px;
            margin-top: 100px;
            margin-bottom: 20px;
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
  List<Map<String, Object>> users = (List<Map<String, Object>>) request.getAttribute("users");
  Map<String, Integer> roleCounts = (Map<String, Integer>) request.getAttribute("roleCounts");
  String successMessage = (String) request.getAttribute("success");
  String errorMessage = (String) request.getAttribute("error");
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
            <div class="role-header">
                <h1>👥 ユーザー権限管理</h1>
                <p>システムユーザーの権限設定を行います</p>
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

            <!-- 権限別統計 -->
            <% if (roleCounts != null && !roleCounts.isEmpty()) { %>
                <div class="stats-grid">
                    <% 
                    String[] roleNames = {"student", "teacher", "headmaster", "egd", "admin"};
                    String[] roleDisplayNames = {"学生", "教員", "校長・教務部長", "就職指導部", "システム管理者"};
                    for (int i = 0; i < roleNames.length; i++) {
                        int count = roleCounts.getOrDefault(roleNames[i], 0);
                    %>
                        <div class="stat-card">
                            <div class="stat-label"><%= roleDisplayNames[i] %></div>
                            <div class="stat-value"><%= count %> 名</div>
                        </div>
                    <% } %>
                </div>
            <% } %>
            
            <!-- ユーザー一覧 -->
            <% if (users != null && !users.isEmpty()) { %>
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>ユーザーID</th>
                                <th>表示名</th>
                                <th>現在の権限</th>
                                <th>権限変更</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> user : users) { %>
                                <tr>
                                    <td><%= user.get("id") %></td>
                                    <td><%= user.get("display_name") != null ? user.get("display_name") : user.get("id") %></td>
                                    <td>
                                        <% 
                                        String currentRole = (String) user.get("role");
                                        String roleDisplayName = "";
                                        switch(currentRole) {
                                            case "student": roleDisplayName = "学生"; break;
                                            case "teacher": roleDisplayName = "教員"; break;
                                            case "headmaster": roleDisplayName = "校長・教務部長"; break;
                                            case "egd": roleDisplayName = "就職指導部"; break;
                                            case "admin": roleDisplayName = "システム管理者"; break;
                                            default: roleDisplayName = currentRole; break;
                                        }
                                        %>
                                        <span class="role-badge role-<%= currentRole %>"><%= roleDisplayName %></span>
                                    </td>
                                    <td>
                                        <% if (!"admin".equals(user.get("id"))) { %>
                                            <form method="post" action="${pageContext.request.contextPath}/UserRoleManagementServlet" style="display: inline;">
                                                <input type="hidden" name="action" value="updateRole">
                                                <input type="hidden" name="userId" value="<%= user.get("id") %>">
                                                <select name="newRole" class="role-select" onchange="confirmRoleChange(this)" data-original-role="<%= currentRole %>">
                                                    <option value="student" <%= "student".equals(currentRole) ? "selected" : "" %>>学生</option>
                                                    <option value="teacher" <%= "teacher".equals(currentRole) ? "selected" : "" %>>教員</option>
                                                    <option value="headmaster" <%= "headmaster".equals(currentRole) ? "selected" : "" %>>校長・教務部長</option>
                                                    <option value="egd" <%= "egd".equals(currentRole) ? "selected" : "" %>>就職指導部</option>
                                                    <option value="admin" <%= "admin".equals(currentRole) ? "selected" : "" %>>システム管理者</option>
                                                </select>
                                            </form>
                                        <% } else { %>
                                            <span style="color: #999; font-style: italic;">変更不可</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="alert alert-info">
                    <strong>情報:</strong> 登録されているユーザーがありません。
                </div>
            <% } %>
            
            <div class="alert alert-info">
                <strong>注意:</strong> 
                <ul>
                    <li>管理者（admin）の権限は変更できません</li>
                    <li>権限を変更すると、次回ログイン時から新しい権限が適用されます</li>
                    <li>学生権限の場合は、students_tblテーブルに対応するレコードが必要です</li>
                    <li>教員権限の場合は、teacher_tblテーブルに対応するレコードが必要です</li>
                    <li>権限変更は即座に反映されます</li>
                </ul>
            </div>

            <!-- 戻るボタン -->
            <div style="text-align: center; margin-top: 50px; margin-bottom: 50px;">
                <a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase" class="btn btn-primary">
                    ← 管理者設定に戻る
                </a>
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

<!--jQueryの読み込み-->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<!--パララックス（inview）-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/protonet-jquery.inview/1.1.2/jquery.inview.min.js"></script>
<script src="js/jquery.inview_set.js"></script>
<!--このテンプレート専用のスクリプト-->
<script src="js/main.js"></script>

<script>
function confirmRoleChange(selectElement) {
    const userId = selectElement.form.querySelector('input[name="userId"]').value;
    const newRole = selectElement.value;
    
    // 権限名を日本語に変換
    const roleDisplayNames = {
        'student': '学生',
        'teacher': '教員', 
        'headmaster': '校長・教務部長',
        'egd': '就職指導部',
        'admin': 'システム管理者'
    };
    
    const roleDisplay = roleDisplayNames[newRole] || newRole;
    
    if (confirm(`ユーザー「${userId}」の権限を「${roleDisplay}」に変更しますか？\n\nこの変更は即座に反映されます。`)) {
        selectElement.form.submit();
    } else {
        // 元の選択に戻す
        const originalRole = selectElement.getAttribute('data-original-role');
        if (originalRole) {
            selectElement.value = originalRole;
        }
    }
}

// ページ読み込み時の処理
document.addEventListener('DOMContentLoaded', function() {
    console.log('ユーザー権限管理画面が読み込まれました');
    
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