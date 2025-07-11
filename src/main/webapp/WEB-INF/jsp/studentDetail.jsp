<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="beans.StudentBeans" %>
<%
    StudentBeans student = (StudentBeans)request.getAttribute("student");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>学生詳細・編集</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/style.css">
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
            
            .edit-container {
                margin: 20px;
                padding: 20px;
            }
            
            .edit-title {
                font-size: 24px;
            }
            
            .info-section {
                padding: 16px;
            }
            
            .info-section h3 {
                font-size: 16px;
            }
            
            .form-group input[type="text"],
            .form-group input[type="email"],
            .form-group input[type="tel"],
            .form-group select,
            .form-group textarea {
                font-size: 16px;
                padding: 14px 16px;
                min-height: 52px;
            }
            
            .form-group label {
                font-size: 16px;
                margin-bottom: 6px;
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
            .edit-container {
                margin: 12px;
                padding: 16px;
            }
            
            .edit-title {
                font-size: 20px;
            }
            
            .info-section {
                padding: 12px;
            }
            
            .info-section h3 {
                font-size: 18px;
            }
            
            .form-group input[type="text"],
            .form-group input[type="email"],
            .form-group input[type="tel"],
            .form-group select,
            .form-group textarea {
                font-size: 18px;
                padding: 16px 20px;
                min-height: 56px;
            }
            
            .form-group label {
                font-size: 18px;
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
            border: 1.5px solid #e9ecef;
            border-radius: 8px;
            font-size: 16px;
            background: #fff;
            transition: all 0.2s ease;
            box-sizing: border-box;
            min-height: 48px;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #2C7744;
            outline: none;
            box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.1);
        }
        .form-group input[readonly] {
            background: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
            border-color: #dee2e6;
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
    </style>
    <style>
    @media (prefers-color-scheme: dark) {
        body {
            background: #181a1b;
            color: #f1f1f1;
        }
        .edit-container {
            background: #23272a;
            box-shadow: 0 0 20px rgba(44, 119, 68, 0.18);
        }
        .edit-title {
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
        .form-group label {
            color: #dcddde;
        }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="tel"],
        .form-group select,
        .form-group textarea {
            background: #23272a;
            color: #f1f1f1;
            border-color: #40444b;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #7fffd4;
        }
        .form-group input[readonly] {
            background: #2c2f33 !important;
            color: #72767d !important;
            border-color: #40444b;
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
        .edit-container {
            margin: 20px;
            padding: 20px;
        }
    }
    </style>
</head>
<body>
    <div class="edit-container">
        <h2 class="edit-title">学生詳細・編集</h2>
        <form class="edit-form" action="StudentDetailServlet" method="post">
            <div class="student-info">
                <!-- 基本情報 -->
                <div class="info-section">
                    <h3>基本情報</h3>
                    <div class="form-group">
                        <label for="id">学生ID</label>
                        <input type="text" id="id" name="studentId" value="<%= student != null ? student.getId() : "" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="className">クラス</label>
                        <input type="text" id="className" name="className" value="<%= student != null ? student.getClassName() : "" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="number">出席番号</label>
                        <input type="text" id="number" name="number" value="<%= student != null ? student.getNumber() : "" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="name">氏名</label>
                        <input type="text" id="name" name="name" value="<%= student != null ? student.getName() : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label for="nameKana">カナ</label>
                        <input type="text" id="nameKana" name="nameKana" value="<%= student != null ? student.getNameKana() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="gender">性別</label>
                        <select id="gender" name="gender">
                            <option value="">選択してください</option>
                            <option value="男" <%= "男".equals(student != null ? student.getGender() : "") ? "selected" : "" %>>男</option>
                            <option value="女" <%= "女".equals(student != null ? student.getGender() : "") ? "selected" : "" %>>女</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="graduationYear">卒業年</label>
                        <input type="text" id="graduationYear" name="graduationYear" value="<%= student != null ? student.getGraduationYear() : "" %>" readonly>
                    </div>
                </div>

                <!-- 連絡先情報 -->
                <div class="info-section">
                    <h3>連絡先情報</h3>
                    <div class="form-group">
                        <label for="email">メールアドレス</label>
                        <input type="email" id="email" name="email" value="<%= student != null ? student.getEmail() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="tel">電話番号</label>
                        <input type="tel" id="tel" name="tel" value="<%= student != null ? student.getTel() : "" %>">
                    </div>
                </div>

                <!-- 在籍・就活状況 -->
                <div class="info-section">
                    <h3>在籍・就活状況</h3>
                    <div class="form-group">
                        <label for="enrollmentStatus">在籍状況</label>
                        <select id="enrollmentStatus" name="enrollmentStatus">
                            <option value="在籍" <%= "在籍".equals(student != null ? student.getEnrollmentStatus() : "") ? "selected" : "" %>>在籍</option>
                            <option value="休学" <%= "休学".equals(student != null ? student.getEnrollmentStatus() : "") ? "selected" : "" %>>休学</option>
                            <option value="卒業" <%= "卒業".equals(student != null ? student.getEnrollmentStatus() : "") ? "selected" : "" %>>卒業</option>
                            <option value="退学" <%= "退学".equals(student != null ? student.getEnrollmentStatus() : "") ? "selected" : "" %>>退学</option>
                            <option value="除籍" <%= "除籍".equals(student != null ? student.getEnrollmentStatus() : "") ? "selected" : "" %>>除籍</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="assistanceStatus">斡旋状況</label>
                        <select id="assistanceStatus" name="assistanceStatus">
                            <option value="受理" <%= "受理".equals(student != null ? student.getAssistanceStatus() : "") ? "selected" : "" %>>受理</option>
                            <option value="辞退" <%= "辞退".equals(student != null ? student.getAssistanceStatus() : "") ? "selected" : "" %>>辞退</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="jobHuntingStatus">就活状況</label>
                        <select id="jobHuntingStatus" name="jobHuntingStatus">
                            <option value="未開始" <%= "未開始".equals(student != null ? student.getJobHuntingStatus() : "") ? "selected" : "" %>>未開始</option>
                            <option value="準備中" <%= "準備中".equals(student != null ? student.getJobHuntingStatus() : "") ? "selected" : "" %>>準備中</option>
                            <option value="活動中" <%= "活動中".equals(student != null ? student.getJobHuntingStatus() : "") ? "selected" : "" %>>活動中</option>
                            <option value="内定済み" <%= "内定済み".equals(student != null ? student.getJobHuntingStatus() : "") ? "selected" : "" %>>内定済み</option>
                            <option value="就職決定" <%= "就職決定".equals(student != null ? student.getJobHuntingStatus() : "") ? "selected" : "" %>>就職決定</option>
                            <option value="就職辞退" <%= "就職辞退".equals(student != null ? student.getJobHuntingStatus() : "") ? "selected" : "" %>>就職辞退</option>
                        </select>
                    </div>
                </div>

                <!-- 希望職種・勤務地 -->
                <div class="info-section">
                    <h3>希望職種・勤務地</h3>
                    <div class="form-group">
                        <label for="desiredJobType1">希望職種1</label>
                        <select id="desiredJobType1" name="desiredJobType1">
                            <option value="0">選択してください</option>
                            <% java.util.List<String> jobtypes = (java.util.List<String>) request.getAttribute("jobtypes");
                               String selected1 = student != null ? student.getDesiredJobType1() : "";
                               if (jobtypes != null) {
                                 int i = 1;
                                 for (String jobtype : jobtypes) { %>
                                    <option value="<%= i %>" <%= jobtype.equals(selected1) ? "selected" : "" %>><%= jobtype %></option>
                                    
                            <%  i+=1; } } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="desiredJobType2">希望職種2</label>
                        <select id="desiredJobType2" name="desiredJobType2">
                            <option value="0">選択してください</option>
                            <% String selected2 = student != null ? student.getDesiredJobType2() : "";
                               if (jobtypes != null) {
                                int j = 1;
                                 for (String jobtype : jobtypes) { %>
                                    <option value="<%= j %>" <%= jobtype.equals(selected2) ? "selected" : "" %>><%= jobtype %></option>
                                    
                            <%  j+=1; } } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="desiredJobType3">希望職種3</label>
                        <select id="desiredJobType3" name="desiredJobType3">
                            <option value="0">選択してください</option>
                            <% String selected3 = student != null ? student.getDesiredJobType3() : "";
                               if (jobtypes != null) {
                                int k = 1;
                                 for (String jobtype : jobtypes) { %>
                                    <option value="<%= k %>" <%= jobtype.equals(selected3) ? "selected" : "" %>><%= jobtype %></option>
                                    
                            <%   k+=1;} } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="desiredWorkPlace">希望勤務地</label>
                        <select id="desiredWorkPlace" name="desiredWorkPlace">
                            <option value="">選択してください</option>
                            <% java.util.List<String> workplaces = (java.util.List<String>) request.getAttribute("workplaces");
                               String selectedWp = student != null ? student.getDesiredWorkPlace() : "";
                               if (workplaces != null) {
                                 for (String wp : workplaces) { %>
                                    <option value="<%= wp %>" <%= wp.equals(selectedWp) ? "selected" : "" %>><%= wp %></option>
                            <%   } } %>
                        </select>
                    </div>
                </div>
            </div>

            <!-- 備考 -->
            <div class="info-section">
                <h3>備考</h3>
                <div class="form-group">
                    <label for="remarks">備考</label>
                    <textarea id="remarks" name="remarks" rows="4"><%= student != null ? student.getRemarks() : "" %></textarea>
                </div>
            </div>

            <div class="action-buttons">
                <button type="submit" class="btn">更新</button>
                <a href="StudentServlet" class="btn btn-secondary">一覧に戻る</a>
            </div>
        </form>
    </div>
</body>
</html> 