<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>
<%@ page import="beans.*" %>

<%
    // セッションの確認
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.html");
        return;
    }
    
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("id");
    
    // エラーメッセージとサクセスメッセージの取得
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
    
    // 選考ステージ情報の取得
    Map<String, Object> selectionStage = (Map<String, Object>) request.getAttribute("selectionStage");
    CompanyBean company = (CompanyBean) request.getAttribute("company");
    ExamineeBean student = (ExamineeBean) request.getAttribute("student");
%>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>選考ステージ詳細・編集</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: #f8f9fa;
            color: #2c3e50;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
        }
        .edit-container {
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
            .edit-container {
                padding: 32px 1vw;
            }
        }
        @media (max-width: 768px) {
            .edit-container {
                margin: 20px 0;
                padding: 16px 2vw;
            }
        }
        @media (max-width: 480px) {
            .edit-container {
                margin: 8px 0;
                padding: 8px 1vw;
            }
        }
        .edit-title {
            font-size: 28px;
            color: #2C7744;
            font-weight: 700;
            margin-bottom: 24px;
            text-align: center;
        }
        .selection-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 32px;
        }
        
        @media (max-width: 768px) {
            .selection-info {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .edit-container {
                margin: 20px;
                padding: 20px;
            }
            
            .edit-title {
                font-size: 24px;
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
        .form-group {
            margin-bottom: 16px;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #495057;
            font-size: 14px;
        }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="tel"],
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e9ecef;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }
        .form-group input[type="text"]:focus,
        .form-group input[type="email"]:focus,
        .form-group input[type="tel"]:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #2C7744;
        }
        .form-group input[readonly] {
            background-color: #f8f9fa;
            color: #6c757d;
        }
        .btn-container {
            display: flex;
            gap: 16px;
            justify-content: center;
            margin-top: 32px;
            flex-wrap: wrap;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            cursor: pointer;
            min-width: 120px;
            justify-content: center;
        }
        .btn-primary {
            background: #2C7744;
            color: white;
        }
        .btn-primary:hover {
            background: #1e5a2f;
            transform: translateY(-2px);
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-2px);
        }
        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-active {
            background: #e8f5e8;
            color: #2e7d32;
        }
        .status-completed {
            background: #e3f2fd;
            color: #1565c0;
        }
        .status-failed {
            background: #ffebee;
            color: #c62828;
        }
        .message {
            padding: 15px;
            margin: 20px 0;
            border-radius: 8px;
            font-weight: 600;
        }
        .error-message {
            background: #ffebee;
            color: #c62828;
            border: 1px solid #ffcdd2;
        }
        .success-message {
            background: #e8f5e8;
            color: #2e7d32;
            border: 1px solid #c8e6c9;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        .no-data i {
            font-size: 3em;
            color: #ddd;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="edit-container">
        <h1 class="edit-title">
            <i class="fas fa-clipboard-list"></i> 選考ステージ詳細
        </h1>
        
        <% if (errorMessage != null) { %>
            <div class="message error-message">
                <i class="fas fa-exclamation-triangle"></i> <%= errorMessage %>
            </div>
        <% } %>
        
        <% if (successMessage != null) { %>
            <div class="message success-message">
                <i class="fas fa-check-circle"></i> <%= successMessage %>
            </div>
        <% } %>
        
        <% if (selectionStage != null && company != null && student != null) { %>
            <div class="selection-info">
                <!-- 基本情報 -->
                <div class="info-section">
                    <h3><i class="fas fa-info-circle"></i> 基本情報</h3>
                    <div class="form-group">
                        <label>学生名</label>
                        <input type="text" value="<%= student.getStudentName() %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>企業名</label>
                        <input type="text" value="<%= company.getCompanyName() %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>選考ステータス</label>
                        <div>
                            <span class="status-badge status-active">
                                <%= selectionStage.get("status") != null ? selectionStage.get("status") : "選考中" %>
                            </span>
                        </div>
                    </div>
                </div>
                
                <!-- 企業情報 -->
                <div class="info-section">
                    <h3><i class="fas fa-building"></i> 企業情報</h3>
                    <div class="form-group">
                        <label>企業名</label>
                        <input type="text" value="<%= company.getCompanyName() %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>住所</label>
                        <input type="text" value="<%= company.getAddress() != null ? company.getAddress() : "未設定" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>電話番号</label>
                        <input type="tel" value="<%= company.getTel() != null ? company.getTel() : "未設定" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>メールアドレス</label>
                        <input type="email" value="<%= company.getMailAddress() != null ? company.getMailAddress() : "未設定" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>担当者名</label>
                        <input type="text" value="<%= company.getManagerName() != null ? company.getManagerName() : "未設定" %>" readonly>
                    </div>
                </div>
                
                <!-- 学生情報 -->
                <div class="info-section">
                    <h3><i class="fas fa-user-graduate"></i> 学生情報</h3>
                    <div class="form-group">
                        <label>学生名</label>
                        <input type="text" value="<%= student.getStudentName() %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>クラス</label>
                        <input type="text" value="<%= student.getClassName() != null ? student.getClassName() : "未設定" %>" readonly>
                    </div>
                </div>
                
                <!-- 選考ステージ詳細情報 -->
                <div class="info-section">
                    <h3><i class="fas fa-calendar-alt"></i> 選考ステージ詳細</h3>
                    <div class="form-group">
                        <label>選考ステージ名</label>
                        <input type="text" value="<%= selectionStage.get("selection_name") != null ? selectionStage.get("selection_name") : "未設定" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>日付</label>
                        <input type="text" value="<%= selectionStage.get("date") != null ? selectionStage.get("date") : "未設定" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>時間</label>
                        <input type="text" value="<%= selectionStage.get("time") != null ? selectionStage.get("time") : "未設定" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>場所</label>
                        <input type="text" value="<%= selectionStage.get("venue") != null ? selectionStage.get("venue") : "未設定" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>備考</label>
                        <textarea readonly rows="3"><%= selectionStage.get("remarks") != null ? selectionStage.get("remarks") : "未設定" %></textarea>
                    </div>
                </div>
            </div>
            
            <!-- 操作ボタン -->
            <div class="btn-container">
                <a href="${pageContext.request.contextPath}/SelectionStageViewServlet" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> 戻る
                </a>
                <a href="${pageContext.request.contextPath}/SelectionStageViewServlet?action=edit&studentId=<%= selectionStage.get("student_id") %>&companyId=<%= selectionStage.get("companys_id") %>" class="btn btn-primary">
                    <i class="fas fa-edit"></i> 編集
                </a>
                <button type="button" class="btn btn-danger" onclick="deleteSelectionStage()">
                    <i class="fas fa-trash"></i> 削除
                </button>
            </div>
            
        <% } else { %>
            <div class="no-data">
                <i class="fas fa-exclamation-circle"></i>
                <h3>選考ステージ情報が見つかりません</h3>
                <p>指定された選考ステージの情報を取得できませんでした。</p>
                <% if (errorMessage != null) { %>
                    <p class="error-message" style="margin-top: 20px; padding: 10px; background: #ffebee; color: #c62828; border-radius: 5px;">
                        <i class="fas fa-exclamation-triangle"></i> <%= errorMessage %>
                    </p>
                <% } %>
                <a href="${pageContext.request.contextPath}/SelectionStageViewServlet" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> 選考ステージ一覧に戻る
                </a>
            </div>
        <% } %>
    </div>
    
    <script>
        function deleteSelectionStage() {
            if (confirm('この選考ステージを削除しますか？この操作は取り消せません。')) {
                // 削除処理の実装
                alert('削除機能は現在実装中です。');
            }
        }
        
        // ページ読み込み時のアニメーション
        document.addEventListener('DOMContentLoaded', function() {
            const container = document.querySelector('.edit-container');
            container.style.opacity = '0';
            container.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                container.style.transition = 'all 0.5s ease';
                container.style.opacity = '1';
                container.style.transform = 'translateY(0)';
            }, 100);
        });
    </script>
</body>
</html> 