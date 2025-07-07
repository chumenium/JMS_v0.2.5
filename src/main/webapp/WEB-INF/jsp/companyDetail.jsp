<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.CompanyBean" %>
<%@ page import="java.util.List" %>
<%
    // セッション情報を取得
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    
    // リクエストスコープからデータを取得
    CompanyBean company = (CompanyBean) request.getAttribute("company");
    String workPlaceName = (String) request.getAttribute("workPlaceName");
    String occupationName = (String) request.getAttribute("occupationName");
    List<String> workPlaces = (List<String>) request.getAttribute("workPlaces");
    List<String> occupations = (List<String>) request.getAttribute("occupations");
    Boolean isEditMode = (Boolean) request.getAttribute("isEditMode");
    
    // メッセージ取得
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>企業詳細・編集 - JMS</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .company-detail-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        .company-detail-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #4CAF50;
        }
        
        .company-detail-header h1 {
            color: #333;
            margin: 0;
        }
        
        .btn-group {
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            transition: background-color 0.3s;
            display: inline-block;
        }
        
        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #45a049;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        .form-group label {
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .form-group input:disabled,
        .form-group select:disabled,
        .form-group input[readonly],
        .form-group textarea[readonly] {
            background-color: #f5f5f5;
            color: #666;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: auto;
        }
        
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: bold;
        }
        
        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .form-actions {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
        }
        
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .company-detail-header {
                flex-direction: column;
                gap: 15px;
            }
            
            .btn-group {
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>
    <div id="container">
        <!-- ヘッダー -->
        <header>
            <h1 id="logo">
                <a href="index.html">
                    <img src="images/logo.png" alt="JMS">
                </a>
            </h1>
            <nav>
                <ul>
                    <% if (username != null) { %>
                        <li>こんにちは、<%= username %>さん</li>
                        <li><%= username %>さんの権限は<%= role %>です</li>
                        <li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
                    <% } else { %>
                        <li><a href="login.html">ログイン</a></li>
                    <% } %>
                </ul>
            </nav>
        </header>
        
        <!-- メインコンテンツ -->
        <main>
            <div class="company-detail-container">
                <div class="company-detail-header">
                    <h1>
                        <% if (isEditMode != null && isEditMode) { %>
                            企業情報編集
                        <% } else { %>
                            企業詳細情報
                        <% } %>
                    </h1>
                    <div class="btn-group">
                        <% if (isEditMode != null && isEditMode) { %>
                            <a href="CompanyDetailServlet?companyId=<%= company.getCompanyId() %>" class="btn btn-secondary">
                                詳細表示に戻る
                            </a>
                        <% } else { %>
                            <a href="CompanyDetailServlet?companyId=<%= company.getCompanyId() %>&mode=edit" class="btn btn-primary">
                                編集する
                            </a>
                        <% } %>
                        <a href="StatusServlet?view=CompanyManagement" class="btn btn-secondary">
                            企業管理に戻る
                        </a>
                    </div>
                </div>
                
                <!-- メッセージ表示 -->
                <% if (successMessage != null) { %>
                    <div class="message success-message">
                        <%= successMessage %>
                    </div>
                <% } %>
                
                <% if (errorMessage != null) { %>
                    <div class="message error-message">
                        <%= errorMessage %>
                    </div>
                <% } %>
                
                <!-- フォーム -->
                <% if (isEditMode != null && isEditMode) { %>
                    <form method="post" action="CompanyDetailServlet">
                        <input type="hidden" name="companyId" value="<%= company.getCompanyId() %>">
                <% } %>
                
                <div class="form-grid">
                    <!-- 企業ID -->
                    <div class="form-group">
                        <label for="companyId">企業ID</label>
                        <input type="text" id="companyId" name="companyId" 
                               value="<%= company.getCompanyId() %>" disabled>
                    </div>
                    
                    <!-- 企業名 -->
                    <div class="form-group">
                        <label for="companyName">企業名 <span style="color: red;">*</span></label>
                        <input type="text" id="companyName" name="companyName" 
                               value="<%= company.getCompanyName() != null ? company.getCompanyName() : "" %>"
                               <% if (isEditMode == null || !isEditMode) { %>readonly<% } %> required>
                    </div>
                    
                    <!-- 郵便番号 -->
                    <div class="form-group">
                        <label for="postCode">郵便番号</label>
                        <input type="text" id="postCode" name="postCode" 
                               value="<%= company.getPostCode() != null ? company.getPostCode() : "" %>"
                               <% if (isEditMode == null || !isEditMode) { %>readonly<% } %>
                               placeholder="例: 123-4567">
                    </div>
                    
                    <!-- 住所 -->
                    <div class="form-group full-width">
                        <label for="address">住所</label>
                        <textarea id="address" name="address" 
                                  <% if (isEditMode == null || !isEditMode) { %>readonly<% } %>><%= company.getAddress() != null ? company.getAddress() : "" %></textarea>
                    </div>
                    
                    <!-- 電話番号 -->
                    <div class="form-group">
                        <label for="tel">電話番号</label>
                        <input type="tel" id="tel" name="tel" 
                               value="<%= company.getTel() != null ? company.getTel() : "" %>"
                               <% if (isEditMode == null || !isEditMode) { %>readonly<% } %>
                               placeholder="例: 03-1234-5678">
                    </div>
                    
                    <!-- メールアドレス -->
                    <div class="form-group">
                        <label for="mailAddress">メールアドレス</label>
                        <input type="email" id="mailAddress" name="mailAddress" 
                               value="<%= company.getMailAddress() != null ? company.getMailAddress() : "" %>"
                               <% if (isEditMode == null || !isEditMode) { %>readonly<% } %>
                               placeholder="例: info@company.com">
                    </div>
                    
                    <!-- 担当者名 -->
                    <div class="form-group">
                        <label for="managerName">担当者名</label>
                        <input type="text" id="managerName" name="managerName" 
                               value="<%= company.getManagerName() != null ? company.getManagerName() : "" %>"
                               <% if (isEditMode == null || !isEditMode) { %>readonly<% } %>>
                    </div>
                    
                    <!-- 採用実績 -->
                    <div class="form-group">
                        <label>採用実績</label>
                        <div class="checkbox-group">
                            <input type="checkbox" id="recruitmentResults" name="recruitmentResults" 
                                   value="true" <%= company.getRecruitmentResults() ? "checked" : "" %>
                                   <% if (isEditMode == null || !isEditMode) { %>disabled<% } %>>
                            <label for="recruitmentResults">一度でも学生を採用したことがある</label>
                        </div>
                    </div>
                    
                    <!-- 勤務地 -->
                    <div class="form-group">
                        <label for="workPlace">勤務地</label>
                        <% if (isEditMode != null && isEditMode) { %>
                            <select id="workPlace" name="workPlace" required>
                                <option value="">選択してください</option>
                                <% if (workPlaces != null) {
                                    for (String place : workPlaces) { %>
                                        <option value="<%= place %>" 
                                                <%= place.equals(workPlaceName) ? "selected" : "" %>>
                                            <%= place %>
                                        </option>
                                    <% }
                                } %>
                            </select>
                        <% } else { %>
                            <input type="text" id="workPlace" name="workPlace" 
                                   value="<%= workPlaceName != null ? workPlaceName : "" %>" readonly>
                        <% } %>
                    </div>
                    
                    <!-- 職種 -->
                    <div class="form-group">
                        <label for="occupation">職種</label>
                        <% if (isEditMode != null && isEditMode) { %>
                            <select id="occupation" name="occupation" required>
                                <option value="">選択してください</option>
                                <% if (occupations != null) {
                                    for (String occupation : occupations) { %>
                                        <option value="<%= occupation %>" 
                                                <%= occupation.equals(occupationName) ? "selected" : "" %>>
                                            <%= occupation %>
                                        </option>
                                    <% }
                                } %>
                            </select>
                        <% } else { %>
                            <input type="text" id="occupation" name="occupation" 
                                   value="<%= occupationName != null ? occupationName : "" %>" readonly>
                        <% } %>
                    </div>
                </div>
                
                <!-- ボタン -->
                <% if (isEditMode != null && isEditMode) { %>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">更新する</button>
                        <a href="CompanyDetailServlet?companyId=<%= company.getCompanyId() %>" class="btn btn-secondary">
                            キャンセル
                        </a>
                    </div>
                    </form>
                <% } %>
            </div>
        </main>
        
        <!-- フッター -->
        <footer>
            <div>
                <p class="logo">
                    <img src="images/logo.png" alt="Job Management System">
                </p>
                <small>Copyright&copy; @ 2025 Job Management System All Rights Reserved.</small>
            </div>
        </footer>
    </div>
    
    <script>
        // 郵便番号フォーマット
        document.getElementById('postCode').addEventListener('input', function(e) {
            let value = e.target.value.replace(/[^\d]/g, '');
            if (value.length > 3) {
                value = value.substring(0, 3) + '-' + value.substring(3, 7);
            }
            e.target.value = value;
        });
        
        // 電話番号フォーマット
        document.getElementById('tel').addEventListener('input', function(e) {
            let value = e.target.value.replace(/[^\d]/g, '');
            if (value.length > 2 && value.length <= 6) {
                value = value.substring(0, 2) + '-' + value.substring(2);
            } else if (value.length > 6) {
                value = value.substring(0, 2) + '-' + value.substring(2, 6) + '-' + value.substring(6, 10);
            }
            e.target.value = value;
        });
    </script>
</body>
</html>
