<!--*
：：：色のテーマは緑：：：
試験面接内容一覧用画面

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

||**試験面接内容一覧画面用**||

**

*-->

<!--KCS_JMS_PROJECT-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>試験・面接内容一覧</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .company-info {
            background: #f9f9f9;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            border: 1px solid #ddd;
        }
        .company-info h2 {
            margin-top: 0;
            color: #333;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        .content-section {
            background: #fff;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            border: 1px solid #ddd;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .content-section h3 {
            margin-top: 0;
            color: #333;
            border-bottom: 2px solid #28a745;
            padding-bottom: 10px;
        }
        .content-item {
            background: #f8f9fa;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 6px;
            border-left: 4px solid #007bff;
        }
        .content-item h4 {
            margin-top: 0;
            color: #007bff;
            font-size: 16px;
        }
        .content-detail {
            margin: 8px 0;
        }
        .content-detail label {
            font-weight: bold;
            color: #555;
            min-width: 120px;
            display: inline-block;
        }
        .content-detail span {
            color: #333;
        }
        .content-date {
            font-size: 12px;
            color: #666;
            text-align: right;
            margin-top: 10px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            margin-right: 10px;
            text-decoration: none;
            display: inline-block;
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
        .no-content {
            text-align: center;
            color: #666;
            font-style: italic;
            padding: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>試験・面接内容一覧</h1>
        
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType}">${message}</div>
        </c:if>
        
        <c:if test="${empty company}">
            <div class="alert alert-warning">企業情報が見つかりません。</div>
        </c:if>
        
        <c:if test="${not empty company}">
            <div class="company-info">
                <h2>${company.companyName}</h2>
                <p>企業ID: ${company.companysId}</p>
            </div>
        </c:if>
        
        <!-- 試験内容セクション -->
        <div class="content-section">
            <h3>📝 試験内容</h3>
            <c:choose>
                <c:when test="${not empty examContents}">
                    <c:forEach var="content" items="${examContents}">
                        <div class="content-item">
                            <h4>試験 #${content.contentNumber}</h4>
                            <div class="content-detail">
                                <label>試験種別:</label>
                                <span>${content.examType}</span>
                            </div>
                            <c:if test="${not empty content.examSubject}">
                                <div class="content-detail">
                                    <label>試験科目:</label>
                                    <span>${content.examSubject}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty content.examContent}">
                                <div class="content-detail">
                                    <label>試験内容:</label>
                                    <span>${content.examContent}</span>
                                </div>
                            </c:if>
                            <div class="content-date">
                                登録日: <fmt:formatDate value="${content.createdAt}" pattern="yyyy/MM/dd HH:mm"/>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-content">
                        試験内容はまだ登録されていません。
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- 面接内容セクション -->
        <div class="content-section">
            <h3>🤝 面接内容</h3>
            <c:choose>
                <c:when test="${not empty interviewContents}">
                    <c:forEach var="content" items="${interviewContents}">
                        <div class="content-item">
                            <h4>面接 #${content.contentNumber}</h4>
                            <div class="content-detail">
                                <label>面接種別:</label>
                                <span>${content.interviewType}</span>
                            </div>
                            <c:if test="${not empty content.interviewQuestions}">
                                <div class="content-detail">
                                    <label>質問内容:</label>
                                    <span>${content.interviewQuestions}</span>
                                </div>
                            </c:if>
                            <c:if test="${not empty content.interviewNotes}">
                                <div class="content-detail">
                                    <label>備考:</label>
                                    <span>${content.interviewNotes}</span>
                                </div>
                            </c:if>
                            <div class="content-date">
                                登録日: <fmt:formatDate value="${content.createdAt}" pattern="yyyy/MM/dd HH:mm"/>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-content">
                        面接内容はまだ登録されていません。
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- 操作ボタン -->
        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/SelectionStageViewServlet" class="btn btn-success">選考ステージ確認</a>
            <a href="${pageContext.request.contextPath}/CompanyDetailServlet?id=${company.companysId}" class="btn btn-primary">企業詳細へ戻る</a>
            <a href="${pageContext.request.contextPath}/CompanyListServlet" class="btn btn-secondary">企業一覧へ</a>
        </div>
    </div>
</body>
</html> 