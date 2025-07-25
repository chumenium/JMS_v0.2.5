<!--*
：：：色のテーマは赤：：：
試験面接内容登録画面

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
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>試験・面接内容登録</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .form-section {
            background: #f9f9f9;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            border: 1px solid #ddd;
        }
        .form-section h3 {
            margin-top: 0;
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-control:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
        }
        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin-right: 10px;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-success:hover {
            background-color: #1e7e34;
        }
        .content-type-selector {
            margin-bottom: 20px;
        }
        .content-type-selector label {
            margin-right: 15px;
            cursor: pointer;
        }
        .content-type-selector input[type="radio"] {
            margin-right: 5px;
        }
        .hidden {
            display: none;
        }
        .alert {
            padding: 12px 16px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        .alert-danger {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        .alert-warning {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>登録済み選考ステージ一覧</h1>
        <form action="${pageContext.request.contextPath}/InterviewExamInputServlet" method="get">
            <div class="form-section">
                <h3>企業選択</h3>
                <div class="form-group">
                    <label for="companyId">企業名:</label>
                    <select name="companyId" id="companyId" class="form-control" required onchange="this.form.submit()">
                        <option value="">企業を選択してください</option>
                        <c:forEach var="company" items="${companies}">
                            <option value="${company.companyId}" ${selectedCompanyId ne null and selectedCompanyId eq company.companyId ? 'selected' : ''}>
                                ${company.companyName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </form>

        <c:if test="${not empty selectionStages}">
            <div class="form-section">
                <h3>選考ステージ一覧</h3>
                <table class="table">
                    <thead>
                        <tr>
                            <th>学生名</th>
                            <th>ステージ種別</th>
                            <th>日付</th>
                            <th>時間</th>
                            <th>実施形式</th>
                            <th>備考</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="stage" items="${selectionStages}">
                            <tr>
                                <td>${stage.student_name}</td>
                                <td>${stage.selection_name}</td>
                                <td>${stage.date}</td>
                                <td>${stage.time}</td>
                                <td>${stage.venue}</td>
                                <td>${stage.remarks}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </div>
    
    <script>
        function toggleContentType() {
            console.log('toggleContentType called');
            const examForm = document.getElementById('examForm');
            const interviewForm = document.getElementById('interviewForm');
            const selectedRadio = document.querySelector('input[name="contentType"]:checked');
            
            console.log('examForm:', examForm);
            console.log('interviewForm:', interviewForm);
            console.log('selectedRadio:', selectedRadio);
            
            if (selectedRadio) {
                const contentType = selectedRadio.value;
                console.log('contentType:', contentType);
                
                if (contentType === '試験') {
                    examForm.classList.remove('hidden');
                    interviewForm.classList.add('hidden');
                    console.log('試験フォームを表示');
                } else if (contentType === '面接') {
                    examForm.classList.add('hidden');
                    interviewForm.classList.remove('hidden');
                    console.log('面接フォームを表示');
                }
            } else {
                // 何も選択されていない場合は両方とも非表示
                examForm.classList.add('hidden');
                interviewForm.classList.add('hidden');
                console.log('両方とも非表示');
            }
        }
        
        // ページ読み込み時に初期化
        document.addEventListener('DOMContentLoaded', function() {
            toggleContentType();
        });
        
        // ラジオボタンの変更イベントを追加
        document.addEventListener('DOMContentLoaded', function() {
            const radioButtons = document.querySelectorAll('input[name="contentType"]');
            radioButtons.forEach(function(radio) {
                radio.addEventListener('change', toggleContentType);
            });
        });
    </script>
</body>
</html>
