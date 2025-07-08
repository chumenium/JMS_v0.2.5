<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="beans.StudentBeans" %>
<%
    StudentBeans student = (StudentBeans)request.getAttribute("student");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>学生詳細確認</title>
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
        .student-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 32px;
        }
        
        @media (max-width: 768px) {
            .student-info {
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
        .student-info {
            grid-template-columns: 1fr;
            gap: 16px;
        }
        .view-container {
            margin: 20px;
            padding: 20px;
        }
    }
    </style>
</head>
<body>
    <div class="view-container">
        <h2 class="view-title">学生詳細確認</h2>
        
        <div class="student-info">
            <!-- 基本情報 -->
            <div class="info-section">
                <h3>基本情報</h3>
                <div class="info-item">
                    <span class="info-label">学生ID</span>
                    <div class="info-value"><%= student != null ? student.getId() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">氏名</span>
                    <div class="info-value"><%= student != null ? student.getName() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">カナ</span>
                    <div class="info-value"><%= student != null ? student.getNameKana() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">性別</span>
                    <div class="info-value"><%= student != null ? student.getGender() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">クラス</span>
                    <div class="info-value"><%= student != null ? student.getClassName() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">出席番号</span>
                    <div class="info-value"><%= student != null ? student.getNumber() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">卒業年</span>
                    <div class="info-value"><%= student != null ? student.getGraduationYear() : "" %></div>
                </div>
            </div>

            <!-- 連絡先情報 -->
            <div class="info-section">
                <h3>連絡先情報</h3>
                <div class="info-item">
                    <span class="info-label">メールアドレス</span>
                    <div class="info-value"><%= student != null ? student.getEmail() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">電話番号</span>
                    <div class="info-value"><%= student != null ? student.getTel() : "" %></div>
                </div>
            </div>

            <!-- 在籍・就活状況 -->
            <div class="info-section">
                <h3>在籍・就活状況</h3>
                <div class="info-item">
                    <span class="info-label">在籍状況</span>
                    <div class="info-value">
                        <% if (student != null && student.getEnrollmentStatus() != null) { %>
                            <span class="status-badge <%= getStatusClass(student.getEnrollmentStatus()) %>">
                                <%= student.getEnrollmentStatus() %>
                            </span>
                        <% } %>
                    </div>
                </div>
                <div class="info-item">
                    <span class="info-label">斡旋状況</span>
                    <div class="info-value">
                        <% if (student != null && student.getAssistanceStatus() != null) { %>
                            <span class="status-badge <%= getAssistanceStatusClass(student.getAssistanceStatus()) %>">
                                <%= student.getAssistanceStatus() %>
                            </span>
                        <% } %>
                    </div>
                </div>
                <div class="info-item">
                    <span class="info-label">就活状況</span>
                    <div class="info-value">
                        <% if (student != null && student.getJobHuntingStatus() != null) { %>
                            <span class="status-badge <%= getJobHuntingStatusClass(student.getJobHuntingStatus()) %>">
                                <%= student.getJobHuntingStatus() %>
                            </span>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- 希望職種・勤務地 -->
            <div class="info-section">
                <h3>希望職種・勤務地</h3>
                <div class="info-item">
                    <span class="info-label">希望職種1</span>
                    <div class="info-value"><%= student != null ? student.getDesiredJobType1() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">希望職種2</span>
                    <div class="info-value"><%= student != null ? student.getDesiredJobType2() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">希望職種3</span>
                    <div class="info-value"><%= student != null ? student.getDesiredJobType3() : "" %></div>
                </div>
                <div class="info-item">
                    <span class="info-label">希望勤務地</span>
                    <div class="info-value"><%= student != null ? student.getDesiredWorkPlace() : "" %></div>
                </div>
            </div>
        </div>

        <!-- 備考 -->
        <% if (student != null && student.getRemarks() != null && !student.getRemarks().isEmpty()) { %>
        <div class="info-section">
            <h3>備考</h3>
            <div class="info-value" style="white-space: pre-wrap; min-height: auto;"><%= student.getRemarks() %></div>
        </div>
        <% } %>

        <div class="action-buttons">
            <a href="StudentDetailServlet?id=<%= student != null ? student.getId() : "" %>" class="btn btn-edit">編集</a>
            <a href="StudentServlet" class="btn btn-secondary">一覧に戻る</a>
        </div>
    </div>
</body>
</html>

<%!
    private String getStatusClass(String status) {
        if (status == null) return "";
        switch (status) {
            case "在籍": return "status-active";
            case "休学": return "status-pending";
            case "卒業": return "status-success";
            case "退学":
            case "除籍": return "status-inactive";
            default: return "";
        }
    }

    private String getAssistanceStatusClass(String status) {
        if (status == null) return "";
        switch (status) {
            case "受理": return "status-success";
            case "辞退": return "status-inactive";
            default: return "";
        }
    }

    private String getJobHuntingStatusClass(String status) {
        if (status == null) return "";
        switch (status) {
            case "未開始": return "status-pending";
            case "準備中": return "status-pending";
            case "活動中": return "status-active";
            case "内定済み": return "status-success";
            case "就職決定": return "status-success";
            case "就職辞退": return "status-inactive";
            default: return "";
        }
    }
%> 