<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>企業詳細</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .button-group {
            margin-top: 20px;
            text-align: center;
        }
        .btn {
            padding: 10px 20px;
            margin: 0 5px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .readonly {
            background-color: #f8f9fa;
            color: #6c757d;
        }
        .error-message {
            color: #dc3545;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>企業詳細</h1>
        
        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>
        
        <form method="post" action="${pageContext.request.contextPath}/CompanyDetailServlet">
            <input type="hidden" name="companyId" value="${company.companyId}">
            
            <div class="form-group">
                <label for="companyName">企業名:</label>
                <input type="text" id="companyName" name="companyName" 
                       value="${company.companyName}" 
                       ${isEditMode ? '' : 'readonly class="readonly"'} required>
            </div>
            
            <div class="form-group">
                <label for="postCode">郵便番号:</label>
                <input type="text" id="postCode" name="postCode" 
                       value="${company.postCode}" 
                       ${isEditMode ? '' : 'readonly class="readonly"'}>
            </div>
            
            <div class="form-group">
                <label for="address">住所:</label>
                <input type="text" id="address" name="address" 
                       value="${company.address}" 
                       ${isEditMode ? '' : 'readonly class="readonly"'}>
            </div>
            
            <div class="form-group">
                <label for="tel">電話番号:</label>
                <input type="text" id="tel" name="tel" 
                       value="${company.tel}" 
                       ${isEditMode ? '' : 'readonly class="readonly"'}>
            </div>
            
            <div class="form-group">
                <label for="mailAddress">メールアドレス:</label>
                <input type="email" id="mailAddress" name="mailAddress" 
                       value="${company.mailAddress}" 
                       ${isEditMode ? '' : 'readonly class="readonly"'}>
            </div>
            
            <div class="form-group">
                <label for="managerName">担当者名:</label>
                <input type="text" id="managerName" name="managerName" 
                       value="${company.managerName}" 
                       ${isEditMode ? '' : 'readonly class="readonly"'}>
            </div>
            
            <div class="form-group">
                <label for="workPlace">勤務地:</label>
                <c:choose>
                    <c:when test="${isEditMode}">
                        <select id="workPlace" name="workPlace">
                            <c:forEach items="${workPlaces}" var="place">
                                <option value="${place}" ${place eq workPlaceName ? 'selected' : ''}>${place}</option>
                            </c:forEach>
                        </select>
                    </c:when>
                    <c:otherwise>
                        <input type="text" value="${workPlaceName}" readonly class="readonly">
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="form-group">
                <label for="occupation">職種:</label>
                <c:choose>
                    <c:when test="${isEditMode}">
                        <select id="occupation" name="occupation">
                            <c:forEach items="${occupations}" var="occ">
                                <option value="${occ}" ${occ eq occupationName ? 'selected' : ''}>${occ}</option>
                            </c:forEach>
                        </select>
                    </c:when>
                    <c:otherwise>
                        <input type="text" value="${occupationName}" readonly class="readonly">
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="form-group">
                <label>
                    <input type="checkbox" name="recruitmentResults" value="true" 
                           ${company.recruitmentResults ? 'checked' : ''} 
                           ${isEditMode ? '' : 'disabled'}>
                    採用実績あり
                </label>
            </div>
            
            <div class="button-group">
                <c:choose>
                    <c:when test="${isEditMode}">
                        <button type="submit" class="btn btn-primary">更新</button>
                        <a href="${pageContext.request.contextPath}/CompanyDetailServlet?companyId=${company.companyId}" 
                           class="btn btn-secondary">キャンセル</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/CompanyDetailServlet?companyId=${company.companyId}&mode=edit" 
                           class="btn btn-primary">編集</a>
                        <button type="button" class="btn btn-danger" id="btn-delete">削除</button>
                        <a href="${pageContext.request.contextPath}/CompanyListServlet" 
                           class="btn btn-secondary">一覧に戻る</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </form>
        
        <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/CompanyDetailServlet" style="display: none;">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="companyId" value="${company.companyId}">
        </form>
        
        <!-- 削除確認ポップアップ -->
        <div id="delete-confirm-modal" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.35); z-index:9999; align-items:center; justify-content:center;">
            <div style="background:#fff; color:#222; border-radius:10px; padding:32px 24px; min-width:280px; max-width:90vw; box-shadow:0 4px 24px rgba(0,0,0,0.18); text-align:center;">
                <div style="font-size:18px; font-weight:600; margin-bottom:18px;">本当に削除しますか？</div>
                <div style="margin-bottom:24px; color:#c42f2f; font-size:15px;">この操作は元に戻せません。</div>
                <button id="confirm-delete-btn" class="btn btn-danger" style="margin-right:12px;">削除</button>
                <button id="cancel-delete-btn" class="btn btn-secondary">キャンセル</button>
            </div>
        </div>
    </div>
    
    <script>
        var delete_btn = document.getElementById('btn-delete');
        var modal = document.getElementById('delete-confirm-modal');
        var confirmBtn = document.getElementById('confirm-delete-btn');
        var cancelBtn = document.getElementById('cancel-delete-btn');
        var deleteForm = document.getElementById('deleteForm');

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
                console.log('削除フォームを送信します');
                deleteForm.submit();
            });
        }
        
        // モーダル外クリックでキャンセル
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                modal.style.display = 'none';
            }
        });
    </script>
</body>
</html> 