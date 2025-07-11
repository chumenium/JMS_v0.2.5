<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.CompanyBean" %>
<%@ page import="java.util.List" %>
<%
    // デバッグ情報
    System.out.println("companyDetail.jsp: JSP started");
    
    // セッション情報を取得
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    
    // nullチェック
    if (username == null) {
        username = "ゲスト";
    }
    if (role == null) {
        role = "guest";
    }
    
    // リクエストスコープから企業情報を取得
    CompanyBean company = (CompanyBean) request.getAttribute("company");
    String workPlaceName = (String) request.getAttribute("workPlaceName");
    String occupationName = (String) request.getAttribute("occupationName");
    List<String> workPlaces = (List<String>) request.getAttribute("workPlaces");
    List<String> occupations = (List<String>) request.getAttribute("occupations");
    Boolean isEditMode = (Boolean) request.getAttribute("isEditMode");
    
    System.out.println("companyDetail.jsp: company = " + company);
    System.out.println("companyDetail.jsp: isEditMode = " + isEditMode);
    
    if (isEditMode == null) {
        isEditMode = false;
    }
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>JMSアプリ - 企業詳細</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="本アプリは就職対策アプリです。">
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* 企業詳細画面専用スタイル */
        .company-detail-page {
            background: #f8f9fa;
            color: #2c3e50;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            min-height: 100vh;
        }
        
        .detail-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 24px;
            background: #ffffff;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
            border-radius: 12px;
        }
        
        .detail-title {
            font-size: 28px;
            color: #2C7744;
            margin-bottom: 24px;
            text-align: center;
            font-weight: 700;
            border-bottom: 3px solid #2C7744;
            padding-bottom: 12px;
        }
        
        .company-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 24px;
            margin-bottom: 32px;
        }
        
        .info-section {
            background: #f8f9fa;
            padding: 24px;
            border-radius: 8px;
            border-left: 4px solid #2C7744;
        }
        
        .info-section h3 {
            color: #2C7744;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 16px;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 8px;
        }
        
        .info-item {
            margin-bottom: 16px;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
            display: block;
            margin-bottom: 6px;
            font-size: 14px;
        }
        
        .info-value {
            color: #2c3e50;
            font-size: 16px;
            padding: 12px;
            background: #fff;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            min-height: 20px;
        }
        
        .info-value.empty {
            color: #6c757d;
            font-style: italic;
        }
        
        .form-input {
            width: 100%;
            padding: 12px;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            font-size: 16px;
            background: #fff;
            color: #2c3e50;
            box-sizing: border-box;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #2C7744;
            box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.1);
        }
        
        .form-select {
            width: 100%;
            padding: 12px;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            font-size: 16px;
            background: #fff;
            color: #2c3e50;
            box-sizing: border-box;
        }
        
        .form-checkbox {
            margin-right: 8px;
            transform: scale(1.2);
        }
        
        .checkbox-label {
            display: flex;
            align-items: center;
            font-size: 16px;
            color: #2c3e50;
            cursor: pointer;
        }
        
        .action-buttons {
            text-align: center;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid #e9ecef;
        }
        
        .btn {
            background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 32px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 2px 8px rgba(44, 119, 68, 0.15);
            margin-right: 12px;
            text-decoration: none;
            display: inline-block;
            min-width: 120px;
            min-height: 48px;
        }
        
        .btn:hover {
            background: #388E3C;
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
            text-decoration: none;
            color: white;
        }
        
        .btn-delete {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        }
        
        .btn-delete:hover {
            background: #c82333;
            color: white;
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
        }
        
        .btn-secondary:hover {
            background: #495057;
            color: white;
        }
        
        .btn-edit {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
        }
        
        .btn-edit:hover {
            background: #0056b3;
            color: white;
        }
        
        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            text-align: center;
            min-width: 80px;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .status-inactive {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .loader {
            border: 8px solid #f3f3f3;
            border-top: 8px solid #2C7744;
            border-radius: 50%;
            width: 64px;
            height: 64px;
            animation: spin 1s linear infinite;
            margin: auto;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* レスポンシブ対応 */
        @media (max-width: 768px) {
            .company-info {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .detail-container {
                margin: 20px;
                padding: 20px;
            }
            
            .detail-title {
                font-size: 24px;
            }
            
            .info-section {
                padding: 16px;
            }
            
            .btn {
                padding: 14px 20px;
                font-size: 16px;
                min-width: 100px;
                min-height: 52px;
                margin-bottom: 8px;
            }
        }
        
        @media (max-width: 480px) {
            .detail-container {
                margin: 12px;
                padding: 16px;
            }
            
            .detail-title {
                font-size: 20px;
            }
            
            .info-section {
                padding: 12px;
            }
            
            .btn {
                padding: 16px 24px;
                font-size: 18px;
                min-height: 56px;
            }
        }
    </style>
</head>
<body class="company-detail-page">
    <div class="detail-container">
        <h2 class="detail-title">
            <% if (isEditMode) { %>
                企業情報編集
            <% } else { %>
                企業詳細確認
            <% } %>
        </h2>
        
        <% if (isEditMode) { %>
            <!-- 編集モード -->
            <form method="post" action="CompanyDetailServlet">
                <input type="hidden" name="companyId" value="<%= company != null ? company.getCompanyId() : "" %>">
                
                <div class="company-info">
                    <!-- 基本情報 -->
                    <div class="info-section">
                        <h3>基本情報</h3>
                        <div class="info-item">
                            <span class="info-label">企業ID</span>
                            <div class="info-value"><%= company != null ? company.getCompanyId() : "" %></div>
                        </div>
                        <div class="info-item">
                            <span class="info-label">企業名 *</span>
                            <input type="text" name="companyName" class="form-input" 
                                   value="<%= company != null && company.getCompanyName() != null ? company.getCompanyName() : "" %>" required>
                        </div>
                        <div class="info-item">
                            <span class="info-label">担当者名</span>
                            <input type="text" name="managerName" class="form-input" 
                                   value="<%= company != null && company.getManagerName() != null ? company.getManagerName() : "" %>">
                        </div>
                        <div class="info-item">
                            <span class="info-label">採用実績</span>
                            <label class="checkbox-label">
                                <input type="checkbox" name="recruitmentResults" value="true" class="form-checkbox"
                                       <%= company != null && company.getRecruitmentResults() ? "checked" : "" %>>
                                採用実績あり
                            </label>
                        </div>
                    </div>
                    
                    <!-- 連絡先情報 -->
                    <div class="info-section">
                        <h3>連絡先情報</h3>
                        <div class="info-item">
                            <span class="info-label">郵便番号</span>
                            <input type="text" name="postCode" class="form-input" 
                                   value="<%= company != null && company.getPostCode() != null ? company.getPostCode() : "" %>" 
                                   pattern="[0-9]{3}-[0-9]{4}" placeholder="123-4567">
                        </div>
                        <div class="info-item">
                            <span class="info-label">住所</span>
                            <input type="text" name="address" class="form-input" 
                                   value="<%= company != null && company.getAddress() != null ? company.getAddress() : "" %>">
                        </div>
                        <div class="info-item">
                            <span class="info-label">電話番号</span>
                            <input type="tel" name="tel" class="form-input" 
                                   value="<%= company != null && company.getTel() != null ? company.getTel() : "" %>">
                        </div>
                        <div class="info-item">
                            <span class="info-label">メールアドレス</span>
                            <input type="email" name="mailAddress" class="form-input" 
                                   value="<%= company != null && company.getMailAddress() != null ? company.getMailAddress() : "" %>">
                        </div>
                    </div>
                </div>
                
                <div class="action-buttons">
                    <button type="submit" class="btn">保存</button>
                    <a href="CompanyDetailServlet?companyId=<%= company != null ? company.getCompanyId() : "" %>" class="btn btn-secondary">キャンセル</a>
                </div>
            </form>
        <% } else { %>
            <!-- 表示モード -->
            <div class="company-info">
                <!-- 基本情報 -->
                <div class="info-section">
                    <h3>基本情報</h3>
                    <div class="info-item">
                        <span class="info-label">企業ID</span>
                        <div class="info-value" id="company_id"><%= company != null ? company.getCompanyId() : "" %></div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">企業名</span>
                        <div class="info-value"><%= company != null && company.getCompanyName() != null ? company.getCompanyName() : "" %></div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">担当者名</span>
                        <div class="info-value"><%= company != null && company.getManagerName() != null ? company.getManagerName() : "" %></div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">採用実績</span>
                        <div class="info-value">
                            <% if (company != null) { %>
                                <span class="status-badge <%= company.getRecruitmentResults() ? "status-active" : "status-inactive" %>">
                                    <%= company.getRecruitmentResults() ? "あり" : "なし" %>
                                </span>
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <!-- 連絡先情報 -->
                <div class="info-section">
                    <h3>連絡先情報</h3>
                    <div class="info-item">
                        <span class="info-label">郵便番号</span>
                        <div class="info-value"><%= company != null && company.getPostCode() != null ? company.getPostCode() : "" %></div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">住所</span>
                        <div class="info-value"><%= company != null && company.getAddress() != null ? company.getAddress() : "" %></div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">電話番号</span>
                        <div class="info-value"><%= company != null && company.getTel() != null ? company.getTel() : "" %></div>
                    </div>
                    <div class="info-item">
                        <span class="info-label">メールアドレス</span>
                        <div class="info-value"><%= company != null && company.getMailAddress() != null ? company.getMailAddress() : "" %></div>
                    </div>
                </div>
            </div>
            
            <div class="action-buttons">
                <a class="btn btn-delete" id="btn-delete">削除</a>
                <a href="CompanyDetailServlet?companyId=<%= company != null ? company.getCompanyId() : "" %>&mode=edit" class="btn btn-edit">編集</a>
                <a href="CompanyListServlet" class="btn btn-secondary">一覧に戻る</a>
            </div>
        <% } %>
    </div>
    
    <!-- 削除確認ポップアップ -->
    <div id="delete-confirm-modal" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.35); z-index:9999; align-items:center; justify-content:center;">
        <div style="background:#fff; color:#222; border-radius:10px; padding:32px 24px; min-width:280px; max-width:90vw; box-shadow:0 4px 24px rgba(0,0,0,0.18); text-align:center;">
            <div style="font-size:18px; font-weight:600; margin-bottom:18px;">本当に削除しますか？</div>
            <div style="margin-bottom:24px; color:#c42f2f; font-size:15px;">この操作は元に戻せません。</div>
            <button id="confirm-delete-btn" class="btn btn-delete" style="margin-right:12px;">削除</button>
            <button id="cancel-delete-btn" class="btn btn-secondary">キャンセル</button>
        </div>
    </div>
    
    <!-- ローディングアニメーション -->
    <div id="loading-overlay" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(255,255,255,0.7); z-index:10000; align-items:center; justify-content:center;">
        <div class="loader"></div>
    </div>
    
    <script>
        // 削除機能のJavaScript
        var delete_btn = document.getElementById('btn-delete');
        var modal = document.getElementById('delete-confirm-modal');
        var confirmBtn = document.getElementById('confirm-delete-btn');
        var cancelBtn = document.getElementById('cancel-delete-btn');
        var loadingOverlay = document.getElementById('loading-overlay');

        if (delete_btn) {
            delete_btn.addEventListener('click', function() {
                modal.style.display = 'flex';
            });
        }
        
        if (cancelBtn) {
            cancelBtn.addEventListener('click', function() {
                modal.style.display = 'none';
            });
        }
        
        if (confirmBtn) {
            confirmBtn.addEventListener('click', function() {
                modal.style.display = 'none';
                loadingOverlay.style.display = 'flex';
                delete_company();
            });
        }

        function delete_company() {
            fetch('CompanyDetailServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: new URLSearchParams({
                    action: 'delete',
                    companyId: '<%= company != null ? company.getCompanyId() : "" %>'
                })
            })
            .then(response => {
                if (response.ok) {
                    window.location.href = 'CompanyListServlet';
                } else {
                    loadingOverlay.style.display = 'none';
                    alert('削除に失敗しました');
                }
            })
            .catch(() => {
                loadingOverlay.style.display = 'none';
                alert('通信エラーが発生しました');
            });
        }
        
        // フォームバリデーション
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    const companyName = document.querySelector('input[name="companyName"]');
                    if (companyName && companyName.value.trim() === '') {
                        e.preventDefault();
                        alert('企業名は必須項目です。');
                        companyName.focus();
                        return false;
                    }
                });
            }
        });
    </script>
</body>
</html>