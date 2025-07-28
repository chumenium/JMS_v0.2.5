<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>選考ステージ編集 - JMSアプリ</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <style>
        /* SelectionStage.jspのスタイルを流用 */
        .interview-exam-page { background: #f8f9fa; color: #2c3e50; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; line-height: 1.6; }
        .interview-exam-container { max-width: 1400px; width: 96vw; margin: 0 auto; padding: 40px 2vw; min-height: 100vh; background: #fff; box-shadow: 0 0 20px rgba(0,0,0,0.05); box-sizing: border-box; }
        .page-header { background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%); border-radius: 12px; padding: 32px; margin-bottom: 32px; box-shadow: 0 4px 20px rgba(44,119,68,0.15); color: #000; text-align: center; position: relative; overflow: hidden; }
        .page-title { font-size: 32px; color: #000; margin-bottom: 12px; font-weight: 700; text-shadow: 0 1px 2px rgba(255,255,255,0.3); }
        .page-subtitle { font-size: 18px; color: #000; margin-bottom: 24px; line-height: 1.6; font-weight: 600; }
        .breadcrumb { display: flex; justify-content: center; align-items: center; gap: 12px; font-size: 14px; color: #000; margin-top: 16px; }
        .breadcrumb a { color: #000; text-decoration: none; transition: all 0.2s ease; padding: 6px 12px; border-radius: 6px; background: rgba(255,255,255,0.3); border: 1px solid rgba(255,255,255,0.4); font-weight: 600; }
        .breadcrumb a:hover { background: rgba(255,255,255,0.5); transform: translateY(-1px); color: #000; }
        .breadcrumb .separator { color: #000; font-weight: 600; }
        .message { padding: 16px; border-radius: 8px; margin-bottom: 24px; text-align: center; font-weight: 600; }
        .success-message { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error-message { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .registration-form { background: white; border-radius: 12px; padding: 32px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); border: 1px solid #e9ecef; margin-bottom: 24px; }
        .form-title { font-size: 24px; color: #2c3e50; margin-bottom: 24px; text-align: center; font-weight: 700; padding: 16px; background: linear-gradient(135deg, rgba(44,119,68,0.1), rgba(92,165,100,0.1)); border-radius: 8px; border: 1px solid rgba(44,119,68,0.2); }
        .form-section { margin-bottom: 32px; padding: 24px; background: #f8f9fa; border-radius: 8px; border: 1px solid #e9ecef; }
        .section-title { font-size: 18px; color: #2c3e50; margin-bottom: 20px; font-weight: 600; display: flex; align-items: center; gap: 8px; }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .form-group { margin-bottom: 20px; position: relative; }
        .form-group.full-width { grid-column: 1 / -1; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50; }
        .required { color: #dc3545; font-weight: 700; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 12px 16px; border: 1px solid #e9ecef; border-radius: 8px; font-size: 16px; transition: all 0.2s ease; box-sizing: border-box; background: #fff; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { outline: none; border-color: #2C7744; box-shadow: 0 0 0 3px rgba(44,119,68,0.1); }
        .search-input-container { position: relative; display: flex; align-items: center; gap: 8px; }
        .search-input-container input { flex: 1; }
        .search-btn { background: #2C7744; color: white; border: none; border-radius: 4px; padding: 8px 12px; cursor: pointer; font-size: 14px; transition: background-color 0.3s ease; }
        .search-btn:hover { background: #1e5a2e; }
        .student-readonly { background-color: #f8f9fa !important; color: #6c757d !important; cursor: not-allowed; }
        .stage-card { background: white; border: 1px solid #e9ecef; border-radius: 12px; margin-bottom: 20px; overflow: hidden; transition: all 0.3s ease; box-shadow: 0 2px 8px rgba(0,0,0,0.05); position: relative; z-index: 1; }
        .stage-card:hover { border-color: #2C7744; box-shadow: 0 4px 12px rgba(44,119,68,0.15); z-index: 2; }
        .stage-header { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); padding: 16px 24px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e9ecef; }
        .stage-title { font-size: 18px; font-weight: 600; color: #2c3e50; margin: 0; display: flex; align-items: center; gap: 8px; }
        .stage-number { background: #2C7744; color: white; padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: 700; display: inline-block; min-width: 20px; text-align: center; visibility: visible !important; opacity: 1 !important; }
        .remove-btn { background: #dc3545; color: white; border: none; border-radius: 6px; padding: 8px 12px; cursor: pointer; font-size: 16px; transition: all 0.2s ease; display: block; }
        .remove-btn:hover { background: #c82333; transform: scale(1.05); }
        .stage-content { padding: 24px 24px 16px 24px; }
        .btn { padding: 14px 28px; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.2s ease; border: none; text-decoration: none; display: inline-block; text-align: center; min-width: 120px; }
        .btn-primary { background: #2C7744; color: white; }
        .btn-primary:hover { background: #1e5a2e; transform: translateY(-1px); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; transform: translateY(-1px); }
        .btn-sm { padding: 8px 16px; font-size: 14px; min-width: auto; }
        .form-buttons { display: flex; gap: 16px; justify-content: center; margin-top: 32px; flex-wrap: wrap; }
        @media (max-width: 768px) { .interview-exam-container { padding: 16px; } .page-header { padding: 24px; } .page-title { font-size: 24px; } .page-subtitle { font-size: 16px; } .registration-form { padding: 24px; } .form-grid { grid-template-columns: 1fr; gap: 16px; } .form-section { padding: 20px; } .form-buttons { flex-direction: column; } .btn { width: 100%; } }
        @media (max-width: 480px) { .interview-exam-container { padding: 12px; } .page-header { padding: 20px; } .page-title { font-size: 20px; } .registration-form { padding: 20px; } .form-section { padding: 16px; } }
    </style>
</head>
<body class="interview-exam-page">
<div id="container">
    <main>
        <div class="interview-exam-container">
            <header class="page-header" role="banner">
                <h1 class="page-title">選考ステージ編集</h1>
                <p class="page-subtitle">企業の選考情報を編集できます</p>
                <nav class="breadcrumb" aria-label="パンくずリスト">
                    <a href="${pageContext.request.contextPath}/StatusServlet?view=DashBoard">ダッシュボード</a>
                    <span class="separator" aria-hidden="true">/</span>
                    <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a>
                    <span class="separator" aria-hidden="true">/</span>
                    <span>選考ステージ編集</span>
                </nav>
            </header>

            <!-- メッセージ表示 -->
            <c:if test="${not empty errorMessage}">
                <div class="message error-message">❌ ${errorMessage}</div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="message success-message">✅ ${successMessage}</div>
            </c:if>

            <section class="registration-form" role="region" aria-label="選考ステージ編集フォーム">
                <h3 class="form-title">📝 選考情報編集</h3>
                <form action="${pageContext.request.contextPath}/SelectionStageViewServlet" method="post" id="selectionForm">
                    <input type="hidden" name="companyId" value="${selectionStage.companys_id}">
                    <input type="hidden" name="studentId" value="${selectionStage.student_id}">

                    <!-- 基本情報セクション -->
                    <div class="form-section">
                        <h4 class="section-title">🏢 基本情報</h4>
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="companyName">企業名 <span class="required">*</span></label>
                                <input type="text" id="companyName" name="companyName" value="${selectionStage.company_name}" readonly>
                            </div>
                            <div class="form-group">
                                <label for="studentName">学生名 <span class="required">*</span></label>
                                <input type="text" id="studentName" name="studentName" value="${selectionStage.student_name}" readonly>
                            </div>
                            <div class="form-group">
                                <label for="status">選考ステータス</label>
                                <select id="status" name="status">
                                    <option value="">選択してください</option>
                                    <option value="検討中" ${selectionStage.status == '検討中' ? 'selected' : ''}>検討中</option>
                                    <option value="エントリー中" ${selectionStage.status == 'エントリー中' ? 'selected' : ''}>エントリー中</option>
                                    <option value="選考中" ${selectionStage.status == '選考中' ? 'selected' : ''}>選考中</option>
                                    <option value="内定承諾" ${selectionStage.status == '内定承諾' ? 'selected' : ''}>内定承諾</option>
                                    <option value="内定保留" ${selectionStage.status == '内定保留' ? 'selected' : ''}>内定保留</option>
                                    <option value="内定辞退" ${selectionStage.status == '内定辞退' ? 'selected' : ''}>内定辞退</option>
                                    <option value="不採用" ${selectionStage.status == '不採用' ? 'selected' : ''}>不採用</option>
                                    <option value="選考中止" ${selectionStage.status == '選考中止' ? 'selected' : ''}>選考中止</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- 選考ステージ管理セクション -->
                    <div class="form-section">
                        <div class="section-header">
                            <h4 class="section-title">📋 選考ステージ管理</h4>
                            <button type="button" class="btn btn-primary btn-sm" onclick="addStage()">➕ ステージを追加</button>
                        </div>
                        <div id="stagesContainer">
                            <c:forEach items="${selectionStages}" var="stage" varStatus="status">
                                <div class="stage-card" data-stage-id="${status.index + 1}">
                                    <div class="stage-header">
                                        <h5 class="stage-title">選考ステージ <span class="stage-number">${status.index + 1}</span></h5>
                                        <button type="button" class="remove-btn" onclick="removeStage(this)" title="このステージを削除">🗑️</button>
                                    </div>
                                    <div class="stage-content">
                                        <div class="form-grid">
                                            <div class="form-group">
                                                <label>ステージ種別 <span class="required">*</span></label>
                                                <select name="stages[${status.index}].type" required>
                                                    <option value="">選択してください</option>
                                                    <option value="説明会" <c:if test="${stage.selection_name eq '説明会'}">selected</c:if>>説明会</option>
                                                    <option value="書類選考" <c:if test="${stage.selection_name eq '書類選考'}">selected</c:if>>書類選考</option>
                                                    <option value="筆記試験" <c:if test="${stage.selection_name eq '筆記試験'}">selected</c:if>>筆記試験</option>
                                                    <option value="適性検査" <c:if test="${stage.selection_name eq '適性検査'}">selected</c:if>>適性検査</option>
                                                    <option value="1次面接" <c:if test="${stage.selection_name eq '1次面接'}">selected</c:if>>1次面接</option>
                                                    <option value="2次面接" <c:if test="${stage.selection_name eq '2次面接'}">selected</c:if>>2次面接</option>
                                                    <option value="3次面接" <c:if test="${stage.selection_name eq '3次面接'}">selected</c:if>>3次面接</option>
                                                    <option value="最終面接" <c:if test="${stage.selection_name eq '最終面接'}">selected</c:if>>最終面接</option>
                                                    <option value="グループディスカッション" <c:if test="${stage.selection_name eq 'グループディスカッション'}">selected</c:if>>グループディスカッション</option>
                                                    <option value="プレゼンテーション" <c:if test="${stage.selection_name eq 'プレゼンテーション'}">selected</c:if>>プレゼンテーション</option>
                                                    <option value="実技試験" <c:if test="${stage.selection_name eq '実技試験'}">selected</c:if>>実技試験</option>
                                                    <option value="その他" <c:if test="${stage.selection_name eq 'その他'}">selected</c:if>>その他</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label>実施日</label>
                                                <input type="date" name="stages[${status.index}].date" value="${stage.date}" class="date-input">
                                            </div>
                                            <div class="form-group">
                                                <label>実施時間</label>
                                                <input type="time" name="stages[${status.index}].time" value="${stage.time}">
                                            </div>
                                            <div class="form-group">
                                                <label>実施形式</label>
                                                <select name="stages[${status.index}].venue">
                                                    <option value="">選択してください</option>
                                                    <option value="個人" <c:if test="${stage.venue eq '個人'}">selected</c:if>>個人</option>
                                                    <option value="集団" <c:if test="${stage.venue eq '集団'}">selected</c:if>>集団</option>
                                                    <option value="オンライン" <c:if test="${stage.venue eq 'オンライン'}">selected</c:if>>オンライン</option>
                                                    <option value="対面" <c:if test="${stage.venue eq '対面'}">selected</c:if>>対面</option>
                                                    <option value="ハイブリッド" <c:if test="${stage.venue eq 'ハイブリッド'}">selected</c:if>>ハイブリッド</option>
                                                </select>
                                                <input type="text" name="stages[${status.index}].venue_free" value="${stage.venue}" placeholder="その他の場合はこちらに入力" <c:if test="${stage.venue eq '個人' or stage.venue eq '集団' or stage.venue eq 'オンライン' or stage.venue eq '対面' or stage.venue eq 'ハイブリッド'}">style='display:none;'</c:if>>
                                            </div>
                                            <div class="form-group full-width">
                                                <label>備考・特記事項</label>
                                                <textarea name="stages[${status.index}].remarks" rows="3" class="notes-textarea">${stage.remarks}</textarea>
                                            </div>
                                            <div class="form-group">
                                                <label>ステータス</label>
                                                <select name="stages[${status.index}].status">
                                                    <option value="">選択してください</option>
                                                    <option value="予定" <c:if test="${stage.status eq '予定'}">selected</c:if>>予定</option>
                                                    <option value="実施済み" <c:if test="${stage.status eq '実施済み'}">selected</c:if>>実施済み</option>
                                                    <option value="合格" <c:if test="${stage.status eq '合格'}">selected</c:if>>合格</option>
                                                    <option value="不合格" <c:if test="${stage.status eq '不合格'}">selected</c:if>>不合格</option>
                                                    <option value="辞退" <c:if test="${stage.status eq '辞退'}">selected</c:if>>辞退</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- ボタンセクション -->
                    <div class="form-buttons">
                        <button type="submit" class="btn btn-primary">📝 選考ステージを更新</button>
                        <a href="${pageContext.request.contextPath}/SelectionStageViewServlet" class="btn btn-secondary">🔙 戻る</a>
                        <button type="button" class="btn btn-danger" onclick="deleteSelectionStage()">🗑️ 削除</button>
                    </div>
                </form>
            </section>
        </div>
    </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
// ステージ追加・削除・再整理のJS（SelectionStage.jspと同様に）
function addStage() {
    const container = document.getElementById('stagesContainer');
    const existingStages = container.querySelectorAll('.stage-card');
    const newStageNumber = existingStages.length + 1;
    const newStage = document.createElement('div');
    newStage.className = 'stage-card';
    newStage.setAttribute('data-stage-id', newStageNumber);
    newStage.innerHTML = `
        <div class="stage-header">
            <h5 class="stage-title">選考ステージ <span class="stage-number">${newStageNumber}</span></h5>
            <button type="button" class="remove-btn" onclick="removeStage(this)" title="このステージを削除">🗑️</button>
        </div>
        <div class="stage-content">
            <div class="form-grid">
                <div class="form-group">
                    <label>ステージ種別 <span class="required">*</span></label>
                    <select name="stages[${newStageNumber-1}].type" required>
                        <option value="">選択してください</option>
                        <option value="説明会">説明会</option>
                        <option value="書類選考">書類選考</option>
                        <option value="筆記試験">筆記試験</option>
                        <option value="適性検査">適性検査</option>
                        <option value="1次面接">1次面接</option>
                        <option value="2次面接">2次面接</option>
                        <option value="3次面接">3次面接</option>
                        <option value="最終面接">最終面接</option>
                        <option value="グループディスカッション">グループディスカッション</option>
                        <option value="プレゼンテーション">プレゼンテーション</option>
                        <option value="実技試験">実技試験</option>
                        <option value="その他">その他</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>実施日</label>
                    <input type="date" name="stages[${newStageNumber-1}].date" class="date-input">
                </div>
                <div class="form-group">
                    <label>実施時間</label>
                    <input type="time" name="stages[${newStageNumber-1}].time">
                </div>
                <div class="form-group">
                    <label>実施形式</label>
                    <select name="stages[${newStageNumber-1}].venue">
                        <option value="">選択してください</option>
                        <option value="個人">個人</option>
                        <option value="集団">集団</option>
                        <option value="オンライン">オンライン</option>
                        <option value="対面">対面</option>
                        <option value="ハイブリッド">ハイブリッド</option>
                    </select>
                    <input type="text" name="stages[${newStageNumber-1}].venue_free" value="" placeholder="その他の場合はこちらに入力" style='display:none;'>
                </div>
                <div class="form-group full-width">
                    <label>備考・特記事項</label>
                    <textarea name="stages[${newStageNumber-1}].remarks" rows="3" class="notes-textarea"></textarea>
                </div>
                <div class="form-group">
                    <label>ステータス</label>
                    <select name="stages[${newStageNumber-1}].status">
                        <option value="">選択してください</option>
                        <option value="予定">予定</option>
                        <option value="実施済み">実施済み</option>
                        <option value="合格">合格</option>
                        <option value="不合格">不合格</option>
                        <option value="辞退">辞退</option>
                    </select>
                </div>
            </div>
        </div>
    `;
    container.appendChild(newStage);
    // 番号を確実に設定
    const stageNumberElement = newStage.querySelector('.stage-number');
    if (stageNumberElement) { stageNumberElement.textContent = newStageNumber; }
    // 新しく追加された日付入力にFlatpickrを適用
    const dateInput = newStage.querySelector('.date-input');
    if (dateInput && typeof flatpickr !== 'undefined') {
        flatpickr(dateInput, { dateFormat: 'Y-m-d', locale: 'ja', allowInput: true, disableMobile: true });
    }
    // テキストエリアの自動リサイズ
    const textarea = newStage.querySelector('.notes-textarea');
    if (textarea) {
        textarea.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = this.scrollHeight + 'px';
        });
    }
}
function removeStage(button) {
    const stageCard = button.closest('.stage-card');
    const stageId = stageCard.getAttribute('data-stage-id');
    if (!confirm(`選考ステージ${stageId}を削除しますか？`)) { return; }
    stageCard.style.transition = 'all 0.3s ease';
    stageCard.style.opacity = '0';
    stageCard.style.transform = 'translateY(-10px)';
    stageCard.style.height = '0';
    stageCard.style.margin = '0';
    stageCard.style.padding = '0';
    setTimeout(() => { stageCard.remove(); reorderStages(); }, 300);
}
function reorderStages() {
    const stages = document.querySelectorAll('.stage-card');
    stages.forEach((stage, index) => {
        const newNumber = index + 1;
        const stageNumber = stage.querySelector('.stage-number');
        if (stageNumber) { stageNumber.textContent = newNumber; }
        const formElements = stage.querySelectorAll('input, select, textarea');
        formElements.forEach(element => {
            if (element.name) {
                element.name = element.name.replace(/stages\[\d+\]/, `stages[${index}]`);
            }
        });
        stage.setAttribute('data-stage-id', newNumber);
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
document.addEventListener('DOMContentLoaded', function() {
    // 既存の日付入力にFlatpickrを適用
    const dateInputs = document.querySelectorAll('.date-input');
    dateInputs.forEach(input => {
        if (typeof flatpickr !== 'undefined') {
            flatpickr(input, { dateFormat: 'Y-m-d', locale: 'ja', allowInput: true, disableMobile: true });
        }
    });
    // 既存のテキストエリアに自動リサイズを適用
    const textareas = document.querySelectorAll('.notes-textarea');
    textareas.forEach(textarea => {
        textarea.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = this.scrollHeight + 'px';
        });
    });
});
</script>
</body>
</html> 