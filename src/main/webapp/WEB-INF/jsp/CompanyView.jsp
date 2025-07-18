<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="beans.CompanyBean" %>
<%
    CompanyBean company = (CompanyBean)request.getAttribute("company");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>企業詳細確認</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            background: #f8f9fa;
            color: #2c3e50;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
        }
        .view-container {
            max-width: 1400px;
            width: 96vw;
            margin: 40px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(44, 119, 68, 0.08);
            padding: 40px 2vw;
            box-sizing: border-box;
        }
        @media (max-width: 1400px) {
            .view-container {
                padding: 32px 1vw;
            }
        }
        @media (max-width: 768px) {
            .view-container {
                margin: 20px 0;
                padding: 16px 2vw;
            }
        }
        @media (max-width: 480px) {
            .view-container {
                margin: 8px 0;
                padding: 8px 1vw;
            }
        }
        .view-title {
            font-size: 28px;
            color: #2C7744;
            font-weight: 700;
            margin-bottom: 24px;
            text-align: center;
        }
        .company-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 32px;
        }
        
        @media (max-width: 768px) {
            .company-info {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .view-container {
                margin: 20px;
                padding: 20px;
            }
            
            .view-title {
                font-size: 24px;
            }
            
            .info-section {
                padding: 16px;
            }
            
            .info-section h3 {
                font-size: 16px;
            }
            
            .info-value {
                font-size: 16px;
                padding: 10px 12px;
                min-height: 52px;
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
            .view-container {
                margin: 12px;
                padding: 16px;
            }
            
            .view-title {
                font-size: 20px;
            }
            
            .info-section {
                padding: 12px;
            }
            
            .info-section h3 {
                font-size: 18px;
            }
            
            .info-value {
                font-size: 18px;
                padding: 12px 16px;
                min-height: 56px;
            }
            
            .btn {
                padding: 16px 24px;
                font-size: 18px;
                min-height: 56px;
            }
        }
        .info-section {
            background: #f8f9fa;
            padding: 20px;
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
            margin-bottom: 12px;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
            display: block;
            margin-bottom: 4px;
            font-size: 14px;
        }
        .info-value {
            color: #2c3e50;
            font-size: 16px;
            padding: 8px 12px;
            background: #fff;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            min-height: 20px;
        }
        .info-value.empty {
            color: #6c757d;
            font-style: italic;
        }
        .action-buttons {
            text-align: center;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid #e9ecef;
        }
        
        @media (max-width: 768px) {
            .action-buttons {
                margin-top: 24px;
                padding-top: 16px;
            }
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
        
        @media (max-width: 768px) {
            .btn {
                padding: 14px 20px;
                font-size: 16px;
                min-width: 100px;
                min-height: 52px;
                margin-bottom: 8px;
            }
        }
        .btn:hover {
            background: #388E3C;
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
        }
        .btn-delete {
            background: #ce3d3d;
            color: #fff;
        }
        .btn-delete:hover {
            background: #c42f2f;
        }
        .btn-secondary {
            background: #6c757d;
            color: #fff;
        }
        .btn-secondary:hover {
            background: #495057;
        }
        .btn-edit {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
        }
        .btn-edit:hover {
            background: #0056b3;
        }
        .back-link {
            display: inline-block;
            margin-top: 24px;
            color: #2C7744;
            text-decoration: underline;
            font-weight: 600;
        }
        .back-link:hover {
            color: #388E3C;
        }
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
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
        .status-pending {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        .status-success {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
    </style>
    <style>
    @media (prefers-color-scheme: dark) {
        body {
            background: #181a1b;
            color: #f1f1f1;
        }
        .view-container {
            background: #23272a;
            box-shadow: 0 0 20px rgba(44, 119, 68, 0.18);
        }
        .view-title {
            color: #7fffd4;
        }
        .info-section {
            background: #2c2f33;
            border-left-color: #7fffd4;
        }
        .info-section h3 {
            color: #7fffd4;
            border-bottom-color: #40444b;
        }
        .info-label {
            color: #dcddde;
        }
        .info-value {
            background: #23272a;
            color: #f1f1f1;
            border-color: #40444b;
        }
        .info-value.empty {
            color: #72767d;
        }
        .action-buttons {
            border-top-color: #40444b;
        }
        .back-link {
            color: #7fffd4;
        }
        .back-link:hover {
            color: #fff;
        }
    }
    @media (max-width: 768px) {
        .company-info {
            grid-template-columns: 1fr;
            gap: 16px;
        }
        .view-container {
            margin: 20px;
            padding: 20px;
        }
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
    #loading-overlay { display: flex; }
    </style>
</head>
<body>
    <div class="view-container">
        <h2 class="view-title">企業詳細確認</h2>
        
        <div class="company-info">
            <!-- 基本情報 -->
            <div class="info-section">
                <h3>基本情報</h3>
                <div class="info-item">
                    <span class="info-label">企業ID</span>
                    <div class="info-value"><%= company != null ? company.getCompanyId() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">企業名</span>
                    <div class="info-value"><%= company != null ? company.getCompanyName() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">担当者名</span>
                    <div class="info-value"><%= company != null ? company.getManagerName() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">採用実績</span>
                    <div class="info-value">
                        <% if (company != null) { %>
                            <span class="status-badge <%= company.getRecruitmentResults() ? "status-success" : "status-inactive" %>">
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
                    <span class="info-label">メールアドレス</span>
                    <div class="info-value"><%= company != null ? company.getMailAddress() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">電話番号</span>
                    <div class="info-value"><%= company != null ? company.getTel() : "" %></div>
                </div>
            </div>

            <!-- 住所情報 -->
            <div class="info-section">
                <h3>住所情報</h3>
                <div class="info-item">
                    <span class="info-label">郵便番号</span>
                    <div class="info-value"><%= company != null ? company.getPostCode() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">住所</span>
                    <div class="info-value"><%= company != null ? company.getAddress() : "" %></div>
                </div>
            </div>

            <!-- 職種・勤務地 -->
            <div class="info-section">
                <h3>職種・勤務地</h3>
                <div class="info-item">
                    <% if(company != null && company.getOccupations() != null && !company.getOccupations().isEmpty()) { %>
                    <span class="info-label">職種</span>
                    <% for(String occupation : company.getOccupations()) { %>
                        <div class="info-value"><%= occupation %></div>
                    <% }} else { %>
                    <span class="info-label">職種</span>
                    <div class="info-value empty">未設定</div>
                    <% } %>
                </div>
                <div class="info-item">
                    <% if(company != null && company.getWorkPlaces() != null && !company.getWorkPlaces().isEmpty()) { %>
                    <span class="info-label">勤務地</span>
                    <% for(String workPlace : company.getWorkPlaces()) { %>
                        <div class="info-value"><%= workPlace %></div>
                    <% }} else { %>
                    <span class="info-label">勤務地</span>
                    <div class="info-value empty">未設定</div>
                    <% } %>
                </div>
            </div>
        </div>

        <div class="action-buttons">
            <a class="btn btn-delete" id="btn-delete">削除</a>
            <a href="CompanyDetailServlet?companyId=<%= company != null ? company.getCompanyId() : "" %>&mode=edit" class="btn btn-edit">編集</a>
            <a href="CompanyListServlet" class="btn btn-secondary">一覧に戻る</a>
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
    </div>
    <!-- ローディングアニメーション -->
    <div id="loading-overlay" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(255,255,255,0.7); z-index:10000; align-items:center; justify-content:center;">
        <div class="loader"></div>
    </div>
    <script>
        var delete_btn = document.getElementById('btn-delete');
        var modal = document.getElementById('delete-confirm-modal');
        var confirmBtn = document.getElementById('confirm-delete-btn');
        var cancelBtn = document.getElementById('cancel-delete-btn');
        var loadingOverlay = document.getElementById('loading-overlay');

        delete_btn.addEventListener('click', function() {
            modal.style.display = 'flex';
        });
        cancelBtn.addEventListener('click', function() {
            modal.style.display = 'none';
        });
        confirmBtn.addEventListener('click', function() {
            modal.style.display = 'none';
            loadingOverlay.style.display = 'flex';
            delete_data();
        });

        function delete_data(){
            fetch('/就活管理アプリ/CompanyDetailServlet', {
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
    </script>
</body>
</html> 