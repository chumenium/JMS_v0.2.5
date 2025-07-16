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
        <h1>試験・面接内容登録</h1>
        
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType}">${message}</div>
        </c:if>
        
        <c:if test="${empty companies}">
            <div class="alert alert-warning">
                <c:choose>
                    <c:when test="${sessionScope.role == 'student'}">
                        就職活動を開始していないか、企業に登録されていません。<br>
                        先に就職活動画面で企業に登録してください。
                    </c:when>
                    <c:otherwise>
                        企業データが登録されていません。
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/InterviewExamInputServlet" method="post">
            <input type="hidden" name="action" value="register">
            
            <!-- 企業選択 -->
            <div class="form-section">
                <h3>企業選択</h3>
                <div class="form-group">
                    <label for="companyId">企業名:</label>
                    <select name="companyId" id="companyId" class="form-control" required>
                        <option value="">企業を選択してください</option>
                        <c:forEach var="company" items="${companies}">
                            <option value="${company.companysId}" ${selectedCompanyId == company.companysId ? 'selected' : ''}>
                                ${company.companyName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            
            <!-- 内容種別選択 -->
            <div class="form-section">
                <h3>内容種別</h3>
                <div class="content-type-selector">
                    <label>
                        <input type="radio" name="contentType" value="試験" ${contentType == '試験' ? 'checked' : ''}> 試験内容
                    </label>
                    <label>
                        <input type="radio" name="contentType" value="面接" ${contentType == '面接' ? 'checked' : ''}> 面接内容
                    </label>
                </div>
            </div>
            
            <!-- 試験内容フォーム -->
            <div id="examForm" class="form-section ${contentType == '試験' ? '' : 'hidden'}">
                <h3>試験内容</h3>
                <div class="form-group">
                    <label for="examType">試験種別:</label>
                    <select name="examType" id="examType" class="form-control">
                        <option value="">選択してください</option>
                        <c:forEach var="examType" items="${examTypes}">
                            <option value="${examType.id}" ${examType.id == selectedExamTypeId ? 'selected' : ''}>
                                ${examType.examTypeName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="examSubject">試験科目:</label>
                    <input type="text" name="examSubject" id="examSubject" class="form-control" 
                           value="${examSubject}" placeholder="例: 数学、英語、プログラミング">
                </div>
                <div class="form-group">
                    <label for="examContent">試験内容詳細:</label>
                    <textarea name="examContent" id="examContent" class="form-control" 
                              placeholder="試験の詳細内容を入力してください">${examContent}</textarea>
                </div>
            </div>
            
            <!-- 面接内容フォーム -->
            <div id="interviewForm" class="form-section ${contentType == '面接' ? '' : 'hidden'}">
                <h3>面接内容</h3>
                <div class="form-group">
                    <label for="interviewType">面接種別:</label>
                    <select name="interviewType" id="interviewType" class="form-control">
                        <option value="">選択してください</option>
                        <c:forEach var="interviewType" items="${interviewTypes}">
                            <option value="${interviewType.id}" ${interviewType.id == selectedInterviewTypeId ? 'selected' : ''}>
                                ${interviewType.interviewTypeName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="interviewQuestions">面接質問内容:</label>
                    <textarea name="interviewQuestions" id="interviewQuestions" class="form-control" 
                              placeholder="面接で聞かれた質問内容を入力してください">${interviewQuestions}</textarea>
                </div>
                <div class="form-group">
                    <label for="interviewNotes">面接備考:</label>
                    <textarea name="interviewNotes" id="interviewNotes" class="form-control" 
                              placeholder="面接に関する備考を入力してください">${interviewNotes}</textarea>
                </div>
            </div>
            
            <!-- ボタン -->
            <div class="form-section">
                <button type="submit" class="btn btn-success">登録</button>
                <button type="button" class="btn btn-secondary" onclick="history.back()">戻る</button>
                <a href="${pageContext.request.contextPath}/CompanyListServlet" class="btn btn-primary">企業一覧へ</a>
            </div>
        </form>
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
