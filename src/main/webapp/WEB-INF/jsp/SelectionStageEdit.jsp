<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>選考ステージ編集</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .edit-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .edit-form {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .form-group textarea {
            height: 80px;
            resize: vertical;
        }
        
        .stages-container {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 20px;
            margin-top: 20px;
        }
        
        .stage-item {
            border: 1px solid #eee;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
            background: #f9f9f9;
        }
        
        .stage-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .stage-number {
            font-weight: bold;
            color: #2C7744;
        }
        
        .remove-stage {
            background: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 3px;
            cursor: pointer;
        }
        
        .add-stage {
            background: #2C7744;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
        }
        
        .btn-container {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background: #2C7744;
            color: white;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        
        .error-message {
            color: #dc3545;
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .success-message {
            color: #155724;
            background: #d4edda;
            border: 1px solid #c3e6cb;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="edit-container">
        <div class="edit-form">
            <h2>選考ステージ編集</h2>
            
            <!-- エラーメッセージ表示 -->
            <c:if test="${not empty errorMessage}">
                <div class="error-message">
                    ❌ ${errorMessage}
                </div>
            </c:if>
            
            <!-- 成功メッセージ表示 -->
            <c:if test="${not empty successMessage}">
                <div class="success-message">
                    ✅ ${successMessage}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/SelectionStageViewServlet" method="post">
                <!-- 企業情報 -->
                <div class="form-group">
                    <label for="companyName">企業名</label>
                    <input type="text" id="companyName" name="companyName" value="${selectionStage.companyName}" readonly>
                    <input type="hidden" id="companyId" name="companyId" value="${selectionStage.companyId}">
                </div>
                
                <!-- 学生情報 -->
                <div class="form-group">
                    <label for="studentName">学生名</label>
                    <input type="text" id="studentName" name="studentName" value="${selectionStage.studentName}" readonly>
                    <input type="hidden" id="studentId" name="studentId" value="${selectionStage.studentId}">
                </div>
                
                <!-- 選考ステータス -->
                <div class="form-group">
                    <label for="status">選考ステータス</label>
                    <select id="status" name="status" required>
                        <option value="">選択してください</option>
                        <option value="検討中" ${selectionStage.status == '検討中' ? 'selected' : ''}>検討中</option>
                        <option value="選考中" ${selectionStage.status == '選考中' ? 'selected' : ''}>選考中</option>
                        <option value="内定" ${selectionStage.status == '内定' ? 'selected' : ''}>内定</option>
                        <option value="内定承諾" ${selectionStage.status == '内定承諾' ? 'selected' : ''}>内定承諾</option>
                        <option value="内定辞退" ${selectionStage.status == '内定辞退' ? 'selected' : ''}>内定辞退</option>
                        <option value="不採用" ${selectionStage.status == '不採用' ? 'selected' : ''}>不採用</option>
                    </select>
                </div>
                
                <!-- 選考ステージ詳細 -->
                <div class="stages-container">
                    <h3>選考ステージ詳細</h3>
                    <div id="stagesContainer">
                        <c:forEach items="${selectionStages}" var="stage" varStatus="status">
                            <div class="stage-item" data-stage-index="${status.index}">
                                <div class="stage-header">
                                    <span class="stage-number">ステージ ${status.index + 1}</span>
                                    <button type="button" class="remove-stage" onclick="removeStage(this)">削除</button>
                                </div>
                                
                                <div class="form-group">
                                    <label>選考ステージ</label>
                                    <select name="stages[${status.index}].type" required>
                                        <option value="">選択してください</option>
                                        <c:forEach items="${selectionTypes}" var="type">
                                            <option value="${type.selectionName}" ${stage.selectionName == type.selectionName ? 'selected' : ''}>
                                                ${type.selectionName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label>日付</label>
                                    <input type="date" name="stages[${status.index}].date" value="${stage.date}" required>
                                </div>
                                
                                <div class="form-group">
                                    <label>時間</label>
                                    <input type="time" name="stages[${status.index}].time" value="${stage.time}" required>
                                </div>
                                
                                <div class="form-group">
                                    <label>会場</label>
                                    <input type="text" name="stages[${status.index}].venue" value="${stage.venue}" placeholder="会場を入力してください">
                                </div>
                                
                                <div class="form-group">
                                    <label>備考</label>
                                    <textarea name="stages[${status.index}].remarks" placeholder="備考を入力してください">${stage.remarks}</textarea>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <button type="button" class="add-stage" onclick="addStage()">+ ステージを追加</button>
                </div>
                
                <!-- ボタン -->
                <div class="btn-container">
                    <button type="submit" class="btn btn-primary">更新</button>
                    <a href="${pageContext.request.contextPath}/SelectionStageViewServlet" class="btn btn-secondary">戻る</a>
                    <button type="button" class="btn btn-danger" onclick="deleteSelectionStage()">削除</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // JSTLの値をJavaScriptで安全に扱うために、data属性を利用
        let stageIndex = Number(document.getElementById('stagesContainer').getAttribute('data-stage-count')) || 0;
        
        function addStage() {
            const container = document.getElementById('stagesContainer');
            const stageItem = document.createElement('div');
            stageItem.className = 'stage-item';
            stageItem.setAttribute('data-stage-index', stageIndex);
            
            stageItem.innerHTML = `
                <div class="stage-header">
                    <span class="stage-number">ステージ ${stageIndex + 1}</span>
                    <button type="button" class="remove-stage" onclick="removeStage(this)">削除</button>
                </div>
                
                <div class="form-group">
                    <label>選考ステージ</label>
                    <select name="stages[${stageIndex}].type" required>
                        <option value="">選択してください</option>
                        <c:forEach items="${selectionTypes}" var="type">
                            <option value="${type.selectionName}">${type.selectionName}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>日付</label>
                    <input type="date" name="stages[${stageIndex}].date" required>
                </div>
                
                <div class="form-group">
                    <label>時間</label>
                    <input type="time" name="stages[${stageIndex}].time" required>
                </div>
                
                <div class="form-group">
                    <label>会場</label>
                    <input type="text" name="stages[${stageIndex}].venue" placeholder="会場を入力してください">
                </div>
                
                <div class="form-group">
                    <label>備考</label>
                    <textarea name="stages[${stageIndex}].remarks" placeholder="備考を入力してください"></textarea>
                </div>
            `;
            
            container.appendChild(stageItem);
            stageIndex++;
            updateStageNumbers();
        }
        
        function removeStage(button) {
            const stageItem = button.closest('.stage-item');
            stageItem.remove();
            updateStageNumbers();
        }
        
        function updateStageNumbers() {
            const stageItems = document.querySelectorAll('.stage-item');
            stageItems.forEach((item, index) => {
                const numberSpan = item.querySelector('.stage-number');
                numberSpan.textContent = `ステージ ${index + 1}`;
                
                // name属性を更新
                const inputs = item.querySelectorAll('input, select, textarea');
                inputs.forEach(input => {
                    const name = input.getAttribute('name');
                    if (name) {
                        input.setAttribute('name', name.replace(/stages\[\d+\]/, `stages[${index}]`));
                    }
                });
            });
        }
        
        function deleteSelectionStage() {
            if (confirm('この選考ステージを削除しますか？')) {
                const form = document.querySelector('form');
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);
                form.submit();
            }
        }
    </script>
</body>
</html> 