<!--*
：：：色のテーマは緑：：：
選考ステージ確認画面

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

||**選考ステージ確認用**||

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
    <title>選考ステージ確認</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .form-section {
            margin-bottom: 30px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        .table th, .table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        .table th {
            background-color: #4CAF50;
            color: white;
        }
        .table tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 5px;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>選考ステージ確認</h1>
        <form action="${pageContext.request.contextPath}/SelectionStageViewServlet" method="get">
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
</body>
</html> 