<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="beans.CompanyBean" %>
<%
    CompanyBean company = (CompanyBean)request.getAttribute("company");
    boolean isEditMode = request.getAttribute("isEditMode") != null && (Boolean)request.getAttribute("isEditMode");
    java.util.List<String> workPlaces = (java.util.List<String>) request.getAttribute("workPlaces");
    java.util.List<String> occupations = (java.util.List<String>) request.getAttribute("occupations");
    String workPlaceName = (String) request.getAttribute("workPlaceName");
    String occupationName = (String) request.getAttribute("occupationName");
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>企業詳細・編集</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { background: #f8f9fa; color: #2c3e50; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .edit-container { max-width: 900px; margin: 40px auto; background: #fff; border-radius: 12px; box-shadow: 0 0 20px rgba(44, 119, 68, 0.08); padding: 40px 2vw; }
        .edit-title { font-size: 28px; color: #2C7744; font-weight: 700; margin-bottom: 24px; text-align: center; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 600; color: #495057; font-size: 14px; }
        .form-group input, .form-group select { width: 100%; padding: 12px 16px; border: 1.5px solid #e9ecef; border-radius: 8px; font-size: 16px; background: #fff; }
        .form-group input[readonly] { background: #f8f9fa; color: #6c757d; cursor: not-allowed; border-color: #dee2e6; }
        .action-buttons { text-align: center; margin-top: 32px; }
        .btn { background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%); color: white; border: none; border-radius: 8px; padding: 12px 32px; font-size: 16px; font-weight: 600; cursor: pointer; margin-right: 12px; min-width: 120px; }
        .btn-secondary { background: #6c757d; color: #fff; }
        .btn-danger { background: #dc3545; color: #fff; }
        .btn-danger:hover { background: #c82333; }
    </style>
    <script>
    function confirmDelete() {
        if(confirm('本当にこの企業を削除しますか？')) {
            document.getElementById('deleteForm').submit();
        }
    }
    </script>
</head>
<body>
    <div class="edit-container">
        <h2 class="edit-title">企業詳細・編集</h2>
        <form class="edit-form" action="CompanyDetailServlet" method="post">
            <input type="hidden" name="companyId" value="<%= company != null ? company.getCompanyId() : "" %>">
            <div class="form-group">
                <label for="companyName">企業名</label>
                <input type="text" id="companyName" name="companyName" value="<%= company != null ? company.getCompanyName() : "" %>" <%= isEditMode ? "" : "readonly" %> required>
            </div>
            <div class="form-group">
                <label for="postCode">郵便番号</label>
                <input type="text" id="postCode" name="postCode" value="<%= company != null ? company.getPostCode() : "" %>" <%= isEditMode ? "" : "readonly" %>>
            </div>
            <div class="form-group">
                <label for="address">住所</label>
                <input type="text" id="address" name="address" value="<%= company != null ? company.getAddress() : "" %>" <%= isEditMode ? "" : "readonly" %>>
            </div>
            <div class="form-group">
                <label for="tel">電話番号</label>
                <input type="text" id="tel" name="tel" value="<%= company != null ? company.getTel() : "" %>" <%= isEditMode ? "" : "readonly" %>>
            </div>
            <div class="form-group">
                <label for="mailAddress">メールアドレス</label>
                <input type="text" id="mailAddress" name="mailAddress" value="<%= company != null ? company.getMailAddress() : "" %>" <%= isEditMode ? "" : "readonly" %>>
            </div>
            <div class="form-group">
                <label for="managerName">担当者名</label>
                <input type="text" id="managerName" name="managerName" value="<%= company != null ? company.getManagerName() : "" %>" <%= isEditMode ? "" : "readonly" %>>
            </div>
            <div class="form-group">
                <label for="recruitmentResults">採用実績</label>
                <select id="recruitmentResults" name="recruitmentResults" <%= isEditMode ? "" : "disabled" %>>
                    <option value="true" <%= company != null && company.getRecruitmentResults() ? "selected" : "" %>>あり</option>
                    <option value="false" <%= company != null && !company.getRecruitmentResults() ? "selected" : "" %>>なし</option>
                </select>
            </div>
            <div class="form-group">
                <label for="workPlaceId">勤務地</label>
                <select id="workPlaceId" name="workPlaceId" <%= isEditMode ? "" : "disabled" %>>
                    <option value="">選択してください</option>
                    <% if (workPlaces != null) { for (int i = 0; i < workPlaces.size(); i++) { String wp = workPlaces.get(i); %>
                        <option value="<%= i+1 %>" <%= company != null && company.getWorkPlaceId() == (i+1) ? "selected" : "" %>><%= wp %></option>
                    <% } } %>
                </select>
            </div>
            <div class="form-group">
                <label for="occupationId">職種</label>
                <select id="occupationId" name="occupationId" <%= isEditMode ? "" : "disabled" %>>
                    <option value="">選択してください</option>
                    <% if (occupations != null) { for (int i = 0; i < occupations.size(); i++) { String oc = occupations.get(i); %>
                        <option value="<%= i+1 %>" <%= company != null && company.getOccupationId() == (i+1) ? "selected" : "" %>><%= oc %></option>
                    <% } } %>
                </select>
            </div>
            <% if (isEditMode) { %>
            <div class="action-buttons">
                <button type="submit" class="btn">更新</button>
                <a href="CompanyDetailServlet?companyId=<%= company != null ? company.getCompanyId() : "" %>" class="btn btn-secondary">キャンセル</a>
            </div>
            <% } else { %>
            <div class="action-buttons">
                <a href="CompanyDetailServlet?companyId=<%= company != null ? company.getCompanyId() : "" %>&mode=edit" class="btn">編集</a>
                <form id="deleteForm" action="CompanyDetailServlet" method="post" style="display:inline;">
                    <input type="hidden" name="companyId" value="<%= company != null ? company.getCompanyId() : "" %>">
                    <input type="hidden" name="action" value="delete">
                    <button type="button" class="btn btn-danger" onclick="confirmDelete()">削除</button>
                </form>
                <a href="CompanyManagementServlet" class="btn btn-secondary">一覧に戻る</a>
            </div>
            <% } %>
        </form>
    </div>
</body>
</html>