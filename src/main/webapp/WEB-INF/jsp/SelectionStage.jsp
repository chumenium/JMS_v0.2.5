<!--*
：：：色のテーマは緑：：：
選考ステージを登録する画面

******教員-生徒-どちらにも表示されるページ****

許可されている権限：
・教員：teacher
・校長・教務部長：headmaster
・就職指導部：egd
・システム管理者：admin
・学生：student

▼▼▼▼
*-->

<!--KCS_JMS_PROJECT-->

<!-- 選考ステージ登録画面用 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% 
  String username = (String) session.getAttribute("username"); 
  String role     = (String) session.getAttribute("role"); 
  
  // デバッグ用：セッション情報をコンソールに出力
  System.out.println("SelectionStage.jsp - username: " + username);
  System.out.println("SelectionStage.jsp - role: " + role);
  
  // nullチェック
  if (username == null) {
    username = "ゲスト";
  }
  if (role == null) {
    role = "guest";
  }
  
  // 権限チェック
  boolean hasPermission = false;
  if ("teacher".equals(role) || "headmaster".equals(role) || 
      "egd".equals(role) || "admin".equals(role) || "student".equals(role)) {
    hasPermission = true;
  }
  
  // 権限がない場合はエラーページにリダイレクト
  if (!hasPermission) {
    response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
    return;
  }
  
  // リクエストパラメータを取得
  String companyId = request.getParameter("companyId");
  String studentId = request.getParameter("studentId");
  String companyName = request.getParameter("companyName");
  String studentName = request.getParameter("studentName");
  
  // デバッグ用ログ
  System.out.println("SelectionStage.jsp - companyId: " + companyId);
  System.out.println("SelectionStage.jsp - studentId: " + studentId);
  System.out.println("SelectionStage.jsp - companyName: " + companyName);
  System.out.println("SelectionStage.jsp - studentName: " + studentName);
  
  // メッセージを取得
  String successMessage = (String) request.getAttribute("successMessage");
  String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>選考ステージ登録 - JMSアプリ</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</head>

<body class="interview-exam-page">
<div id="container">
    <main>
        <div class="interview-exam-container">
            <!-- ページヘッダー -->
            <header class="page-header" role="banner">
                <h1 class="page-title">選考ステージ登録</h1>
                <p class="page-subtitle">企業の選考情報を登録できます</p>
                <nav class="breadcrumb" aria-label="パンくずリスト">
                    <a href="${pageContext.request.contextPath}/StatusServlet?view=DashBoard">ダッシュボード</a>
                    <span class="separator" aria-hidden="true">/</span>
                    <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a>
                    <span class="separator" aria-hidden="true">/</span>
                    <span>選考ステージ登録</span>
                </nav>
            </header>

            <!-- メッセージ表示 -->
            <% if (successMessage != null) { %>
                <div class="message success-message">
                    ✅ <%= successMessage %>
                </div>
            <% } %>
            <% if (errorMessage != null) { %>
                <div class="message error-message">
                    ❌ <%= errorMessage %>
                </div>
<% } %>

            <!-- 登録フォーム -->
            <section class="registration-form" role="region" aria-label="選考ステージ登録フォーム">
                <h3 class="form-title">📝 選考情報入力</h3>
                <form action="SelectionStageServlet" method="post" id="selectionForm">
                <!-- 隠しフィールドで企業IDと学生IDを送信 -->
                <input type="hidden" name="companyId" value="<%= companyId != null ? companyId : "" %>">
                <input type="hidden" name="studentId" value="<%= studentId != null ? studentId : "" %>">

                <!-- 基本情報セクション -->
                <div class="form-section">
                    <h4 class="section-title">🏢 基本情報</h4>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="companyName">企業名 <span class="required">*</span></label>
                            <div class="search-input-container">
                                <input type="text" id="companyName" name="companyName" value="<%= companyName != null ? companyName : "" %>" required placeholder="企業名を入力" autocomplete="off">
                                <button type="button" class="search-btn" onclick="openCompanySearch()" title="企業を検索">
                                    🔍
                                </button>
                            </div>
                            <input type="hidden" id="companyId" name="companyId" value="<%= companyId != null ? companyId : "" %>">
                        </div>
                        <div class="form-group">
                            <label for="studentName">学生名 <span class="required">*</span></label>
                            <div class="search-input-container">
                                <input type="text" id="studentName" name="studentName" 
                                       value="<%= "student".equals(role) ? username : (studentName != null ? studentName : "") %>" 
                                       required placeholder="学生名を入力" autocomplete="off"
                                       <%= "student".equals(role) ? "readonly" : "" %>>
                                <button type="button" class="search-btn" onclick="openStudentSearch()" title="学生を検索"
                                        <%= "student".equals(role) ? "style='display:none;'" : "" %>>
                                    🔍
                                </button>
                            </div>
                            <input type="hidden" id="studentId" name="studentId" value="<%= studentId != null ? studentId : "" %>">
                        </div>
                        <div class="form-group">
                            <label for="selectionStatus">選考ステータス</label>
                            <select id="selectionStatus" name="selectionStatus">
                                <option value="">選択してください</option>
                                <option value="検討中">検討中</option>
                                <option value="エントリー中">エントリー中</option>
                                <option value="選考中">選考中</option>
                                <option value="内定承諾">内定承諾</option>
                                <option value="内定保留">内定保留</option>
                                <option value="内定辞退">内定辞退</option>
                                <option value="不採用">不採用</option>
                                <option value="選考中止">選考中止</option>
                            </select>
                        </div>
                    </div>
    </div>

                <!-- 選考ステージ管理セクション -->
                <div class="form-section">
                    <div class="section-header">
                        <h4 class="section-title">📋 選考ステージ管理</h4>
                        <button type="button" class="btn btn-primary btn-sm" onclick="addStage()">
                            ➕ ステージを追加
                        </button>
        </div>
                    
                    <div id="stagesContainer">
                        <!-- 最初のステージ -->
                        <div class="stage-card" data-stage-id="1">
                            <div class="stage-header">
                                <h5 class="stage-title">選考ステージ <span class="stage-number">1</span></h5>
                                <button type="button" class="remove-btn" onclick="removeStage(this)" title="このステージを削除">🗑️</button>
                            </div>
                            <div class="stage-content">
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label>ステージ種別 <span class="required">*</span></label>
                                        <select name="stages[0].type" required>
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
                                        <input type="date" name="stages[0].date" class="date-input">
                                    </div>
                                    <div class="form-group">
                                        <label>実施時間</label>
                                        <input type="time" name="stages[0].time">
                                    </div>
                                    <div class="form-group">
                                        <label>実施形式</label>
                                        <select name="stages[0].format">
                                            <option value="">選択してください</option>
                                            <option value="個人">個人</option>
                                            <option value="集団">集団</option>
                                            <option value="オンライン">オンライン</option>
                                            <option value="対面">対面</option>
                                            <option value="ハイブリッド">ハイブリッド</option>
                                        </select>
                                    </div>
                                    <div class="form-group full-width">
                                        <label>備考・特記事項</label>
                                        <textarea name="stages[0].notes" rows="3" 
                                                  placeholder="特記事項があれば入力してください"
                                                  class="notes-textarea"></textarea>
                                    </div>
                                    <div class="form-group">
                                        <label>ステータス</label>
                                        <select name="stages[0].status">
                                            <option value="予定">予定</option>
                                            <option value="実施済み">実施済み</option>
                                            <option value="合格">合格</option>
                                            <option value="不合格">不合格</option>
                                            <option value="辞退">辞退</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ボタンセクション -->
                <div class="form-buttons">
                    <button type="submit" class="btn btn-primary">
                        📝 選考ステージを登録
                    </button>
                    <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting" class="btn btn-secondary">
                        🔙 戻る
                    </a>
    </div>
</form>
        </section>
        </div>
    </main>

<!--▼▼▼▼▼ここから「フッター」-->
<footer>
<div>
<p class="logo"><img src="images/logo.png" alt="Job Management System"></p>
<ul class="icons">
<li><a href="#"><i class="fa-brands fa-x-twitter"></i></a></li>
<li><a href="#"><i class="fab fa-line"></i></a></li>
<li><a href="#"><i class="fab fa-youtube"></i></a></li>
<li><a href="#"><i class="fab fa-instagram"></i></a></li>
</ul>
<small>Copyright&copy; @ 2025 Job Management System All Rights Reserved.</small>
</div>
<div>
            <ul>
                <li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
                <!-- 権限に応じた機能リンク -->
                <% if ("teacher".equals(role) || "headmaster".equals(role) || "admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
                <% } %>
                <% if ("egd".equals(role) || "admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
                <% } %>
                <% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role) || "student".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
                <% } %>
                <% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=applicantList">受験者一覧</a></li>
                <% } %>
                <% if ("admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase">システム管理</a></li>
                <% } %>
                <li><a href="extension.html">お問い合わせ</a></li>
</ul>
</div>
</footer>
<!--▲▲▲▲▲ここまで「フッター」-->

<!--▼▼最下部-->
<span class="pr"><a href="" target="_blank">@ 2025 Job Management System</a></span>
<!--▲▲ここまで最下部-->
</div>
<!--/#container-->

<!--ローディング-->
<div id="loading">
<img src="images/logo.png" alt="Loading">
<div class="progress-container">
<div class="progress-bar"></div>
</div>
</div>

<!--開閉ボタン（ハンバーガーアイコン）-->
<div id="menubar_hdr">
<span></span><span></span><span></span>
</div>

<!--開閉ブロック-->
<div id="menubar">
<p class="logo"><img src="images/logo.png" alt="Job Management System"></p>
<nav>
<ul>
            <li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
            <!-- 権限に応じた機能リンク -->
            <% if ("teacher".equals(role) || "headmaster".equals(role) || "admin".equals(role)) { %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
            <% } %>
            <% if ("egd".equals(role) || "admin".equals(role)) { %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
            <% } %>
            <% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role) || "student".equals(role)) { %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
            <% } %>
            <% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role)) { %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=applicantList">受験者一覧</a></li>
            <% } %>
            <% if ("admin".equals(role)) { %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase">システム管理</a></li>
            <% } %>
            <li><a href="extension.html">お問い合わせ</a></li>
            <% if (username != null) { %>
                <li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
            <% } %>
</ul>
</nav>
</div>
<!--/#menubar-->

<!--jQueryの読み込み-->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<!--パララックス（inview）-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/protonet-jquery.inview/1.1.2/jquery.inview.min.js"></script>
<script src="js/jquery.inview_set.js"></script>
<!--このテンプレート専用のスクリプト-->
<script src="js/main.js"></script>

<!--Flatpickrの読み込み-->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

<script>
// 選考ステージ登録画面のJavaScript - 完全に再構築



// ステージを追加
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
                    <select name="stages[${newStageNumber-1}].format">
                        <option value="">選択してください</option>
                        <option value="個人">個人</option>
                        <option value="集団">集団</option>
                        <option value="オンライン">オンライン</option>
                        <option value="対面">対面</option>
                        <option value="ハイブリッド">ハイブリッド</option>
                    </select>
                </div>
                <div class="form-group full-width">
                    <label>備考・特記事項</label>
                    <textarea name="stages[${newStageNumber-1}].notes" rows="3" 
                              placeholder="特記事項があれば入力してください"
                              class="notes-textarea"></textarea>
                </div>
                <div class="form-group">
                    <label>ステータス</label>
                    <select name="stages[${newStageNumber-1}].status">
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
    if (stageNumberElement) {
        stageNumberElement.textContent = newStageNumber;
    }
    
    // デバッグ用：番号が正しく設定されているか確認
    console.log('新しいステージを追加:', newStageNumber);
    console.log('設定された番号:', stageNumberElement ? stageNumberElement.textContent : '見つかりません');
    
    // 新しく追加された日付入力にFlatpickrを適用
    const dateInput = newStage.querySelector('.date-input');
    if (dateInput && typeof flatpickr !== 'undefined') {
        flatpickr(dateInput, {
            dateFormat: 'Y-m-d',
            locale: 'ja',
            allowInput: true,
            disableMobile: true
        });
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

// ステージを削除
function removeStage(button) {
    const stageCard = button.closest('.stage-card');
    const stageId = stageCard.getAttribute('data-stage-id');
    
    // 削除確認
    if (!confirm(`選考ステージ${stageId}を削除しますか？`)) {
        return;
    }
    
    // 削除アニメーション
    stageCard.style.transition = 'all 0.3s ease';
    stageCard.style.opacity = '0';
    stageCard.style.transform = 'translateY(-10px)';
    stageCard.style.height = '0';
    stageCard.style.margin = '0';
    stageCard.style.padding = '0';
    
    setTimeout(() => {
        stageCard.remove();
        reorderStages();
    }, 300);
}

// ステージ番号を再整理（データを保持）
function reorderStages() {
    const stages = document.querySelectorAll('.stage-card');
    
    // 各ステージの入力データを保存
    const stageData = [];
    stages.forEach((stage, index) => {
        const data = {
            type: stage.querySelector('select[name*=".type"]')?.value || '',
            date: stage.querySelector('input[name*=".date"]')?.value || '',
            time: stage.querySelector('input[name*=".time"]')?.value || '',
            format: stage.querySelector('select[name*=".format"]')?.value || '',
            notes: stage.querySelector('textarea[name*=".notes"]')?.value || '',
            status: stage.querySelector('select[name*=".status"]')?.value || '予定'
        };
        stageData.push(data);
    });
    
    // 番号とフォーム要素を更新
    stages.forEach((stage, index) => {
        const newNumber = index + 1;
        
        // ステージ番号を更新
        const stageNumber = stage.querySelector('.stage-number');
        if (stageNumber) {
            stageNumber.textContent = newNumber;
        }
        
        // フォーム要素のname属性を更新
        const formElements = stage.querySelectorAll('input, select, textarea');
        formElements.forEach(element => {
            if (element.name) {
                element.name = element.name.replace(/\[\d+\]/, `[${index}]`);
            }
        });
        
        // data-stage-id属性を更新
        stage.setAttribute('data-stage-id', newNumber);
        
        // 保存したデータを復元
        const data = stageData[index];
        if (data) {
            const typeSelect = stage.querySelector('select[name*=".type"]');
            if (typeSelect) typeSelect.value = data.type;
            
            const dateInput = stage.querySelector('input[name*=".date"]');
            if (dateInput) dateInput.value = data.date;
            
            const timeInput = stage.querySelector('input[name*=".time"]');
            if (timeInput) timeInput.value = data.time;
            
            const formatSelect = stage.querySelector('select[name*=".format"]');
            if (formatSelect) formatSelect.value = data.format;
            
            const notesTextarea = stage.querySelector('textarea[name*=".notes"]');
            if (notesTextarea) {
                notesTextarea.value = data.notes;
                // テキストエリアの高さを調整
                notesTextarea.style.height = 'auto';
                notesTextarea.style.height = notesTextarea.scrollHeight + 'px';
            }
            
            const statusSelect = stage.querySelector('select[name*=".status"]');
            if (statusSelect) statusSelect.value = data.status;
        }
    });
    

    
    // 削除ボタンの表示制御（全てのステージで削除可能）
    const removeBtns = document.querySelectorAll('.remove-btn');
    removeBtns.forEach(btn => {
        btn.style.display = 'block';
    });
}

// 検索機能
function openCompanySearch() {
    const searchTerm = document.getElementById('companyName').value.trim();
    const url = '${pageContext.request.contextPath}/SearchServlet?type=company&term=' + encodeURIComponent(searchTerm) + '&view=popup';
    
    const popup = window.open(url, 'companySearch', 'width=800,height=600,scrollbars=yes,resizable=yes');
    
    if (!popup || popup.closed || typeof popup.closed == 'undefined') {
        alert('ポップアップがブロックされました。ブラウザの設定でポップアップを許可してください。');
    }
}

function openStudentSearch() {
    const searchTerm = document.getElementById('studentName').value.trim();
    const url = '${pageContext.request.contextPath}/SearchServlet?type=student&term=' + encodeURIComponent(searchTerm) + '&view=popup';
    
    const popup = window.open(url, 'studentSearch', 'width=800,height=600,scrollbars=yes,resizable=yes');
    
    if (!popup || popup.closed || typeof popup.closed == 'undefined') {
        alert('ポップアップがブロックされました。ブラウザの設定でポップアップを許可してください。');
            }
}

// 検索結果を受け取る関数
function setSearchResult(id, name, type) {
    if (type === 'company') {
        document.getElementById('companyName').value = name;
        document.getElementById('companyId').value = id;
    } else if (type === 'student') {
        document.getElementById('studentName').value = name;
        document.getElementById('studentId').value = id;
    }
}

// ページ読み込み時の初期化
document.addEventListener('DOMContentLoaded', function() {
    // 学生権限の場合の処理
    const isStudent = '<%= "student".equals(role) %>' === 'true';
    if (isStudent) {
        const studentNameInput = document.getElementById('studentName');
        if (studentNameInput) {
            studentNameInput.classList.add('student-readonly');
        }
    }
    
    // 既存の日付入力にFlatpickrを適用
    const dateInputs = document.querySelectorAll('.date-input');
    dateInputs.forEach(input => {
        if (typeof flatpickr !== 'undefined') {
            flatpickr(input, {
                dateFormat: 'Y-m-d',
                locale: 'ja',
                allowInput: true,
                disableMobile: true
            });
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
    
    // フォームのバリデーション
    const form = document.getElementById('selectionForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            const stages = document.querySelectorAll('.stage-card');
            
            if (stages.length === 0) {
                alert('少なくとも1つの選考ステージが必要です。');
                e.preventDefault();
                return false;
            }
            
            // 各ステージの必須項目チェック
            let isValid = true;
            stages.forEach((stage, index) => {
                const typeSelect = stage.querySelector('select[name*=".type"]');
                if (typeSelect && !typeSelect.value) {
                    alert(`ステージ${index + 1}のステージ種別を選択してください。`);
                    isValid = false;
                }
            });
            
            if (!isValid) {
                e.preventDefault();
                return false;
            }
            
            // 送信前に最終確認
            if (!confirm('選考ステージを登録しますか？')) {
                e.preventDefault();
                return false;
            }
        });
    }
});
</script>

<style>
/* 選考ステージ登録画面のスタイル - 完全に再構築 */
    
    /* 全体の設定 */
    .interview-exam-page {
        background: #f8f9fa;
        color: #2c3e50;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        line-height: 1.6;
    }

    .interview-exam-container {
        max-width: 1400px;
        width: 96vw;
        margin: 0 auto;
        padding: 40px 2vw;
        min-height: 100vh;
        background: #ffffff;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
        box-sizing: border-box;
    }

/* ページヘッダー */
    .page-header {
        background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
        border-radius: 12px;
        padding: 32px;
        margin-bottom: 32px;
        box-shadow: 0 4px 20px rgba(44, 119, 68, 0.15);
        color: #000000;
        text-align: center;
        position: relative;
        overflow: hidden;
    }

    .page-title {
        font-size: 32px;
        color: #000000;
        margin-bottom: 12px;
        font-weight: 700;
        text-shadow: 0 1px 2px rgba(255, 255, 255, 0.3);
    }

    .page-subtitle {
        font-size: 18px;
        color: #000000;
        margin-bottom: 24px;
        line-height: 1.6;
        font-weight: 600;
    }

    .breadcrumb {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 12px;
        font-size: 14px;
        color: #000000;
        margin-top: 16px;
    }

    .breadcrumb a {
        color: #000000;
        text-decoration: none;
        transition: all 0.2s ease;
        padding: 6px 12px;
        border-radius: 6px;
        background: rgba(255, 255, 255, 0.3);
        border: 1px solid rgba(255, 255, 255, 0.4);
        font-weight: 600;
    }

    .breadcrumb a:hover {
        background: rgba(255, 255, 255, 0.5);
        transform: translateY(-1px);
        color: #000000;
    }

    .breadcrumb .separator {
        color: #000000;
        font-weight: 600;
    }

    /* メッセージ表示 */
    .message {
        padding: 16px;
        border-radius: 8px;
        margin-bottom: 24px;
        text-align: center;
        font-weight: 600;
    }

    .success-message {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
    }

    .error-message {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

/* 登録フォーム */
    .registration-form {
        background: white;
        border-radius: 12px;
        padding: 32px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        margin-bottom: 24px;
    }

    .form-title {
        font-size: 24px;
        color: #2c3e50;
        margin-bottom: 24px;
        text-align: center;
        font-weight: 700;
        padding: 16px;
        background: linear-gradient(135deg, rgba(44, 119, 68, 0.1), rgba(92, 165, 100, 0.1));
        border-radius: 8px;
        border: 1px solid rgba(44, 119, 68, 0.2);
    }

    .form-section {
        margin-bottom: 32px;
        padding: 24px;
        background: #f8f9fa;
        border-radius: 8px;
        border: 1px solid #e9ecef;
    }

    .section-title {
        font-size: 18px;
        color: #2c3e50;
        margin-bottom: 20px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 8px;
    }

.section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

    .form-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 20px;
    }

    .form-group {
        margin-bottom: 20px;
        position: relative;
    }

.form-group.full-width {
    grid-column: 1 / -1;
}

    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #2c3e50;
}

.required {
    color: #dc3545;
    font-weight: 700;
    }

    .form-group input,
.form-group select,
.form-group textarea {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        font-size: 16px;
        transition: all 0.2s ease;
        box-sizing: border-box;
    background: #ffffff;
    }

    .form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
        outline: none;
        border-color: #2C7744;
        box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.1);
    }

/* 検索機能のスタイル */
.search-input-container {
    position: relative;
        display: flex;
        align-items: center;
    gap: 8px;
    }

.search-input-container input {
    flex: 1;
}

.search-btn {
    background: #2C7744;
    color: white;
    border: none;
    border-radius: 4px;
    padding: 8px 12px;
    cursor: pointer;
        font-size: 14px;
    transition: background-color 0.3s ease;
    }

.search-btn:hover {
    background: #1e5a2e;
}

/* 学生権限時のスタイル */
.student-readonly {
    background-color: #f8f9fa !important;
    color: #6c757d !important;
    cursor: not-allowed;
}

/* ステージカード */
.stage-card {
        background: white;
    border: 1px solid #e9ecef;
        border-radius: 12px;
        margin-bottom: 20px;
        overflow: hidden;
        transition: all 0.3s ease;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    position: relative;
    z-index: 1;
    }

.stage-card:hover {
        border-color: #2C7744;
        box-shadow: 0 4px 12px rgba(44, 119, 68, 0.15);
    z-index: 2;
    }

    .stage-header {
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        padding: 16px 24px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #e9ecef;
    }

    .stage-title {
        font-size: 18px;
        font-weight: 600;
        color: #2c3e50;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .stage-number {
    background: #2C7744;
    color: white;
    padding: 4px 8px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: 700;
    display: inline-block;
    min-width: 20px;
    text-align: center;
    visibility: visible !important;
    opacity: 1 !important;
}



.remove-btn {
    background: #dc3545;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 8px 12px;
    cursor: pointer;
    font-size: 16px;
    transition: all 0.2s ease;
    display: block;
}

.remove-btn:hover {
        background: #c82333;
        transform: scale(1.05);
    }

    .stage-content {
    padding: 24px 24px 16px 24px;
    }

    /* ボタン */
    .btn {
        padding: 14px 28px;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
        border: none;
        text-decoration: none;
        display: inline-block;
        text-align: center;
        min-width: 120px;
    }

    .btn-primary {
    background: #2C7744;
        color: white;
    }

    .btn-primary:hover {
    background: #1e5a2e;
        transform: translateY(-1px);
    }

    .btn-secondary {
    background: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
    background: #5a6268;
        transform: translateY(-1px);
}

.btn-sm {
    padding: 8px 16px;
    font-size: 14px;
    min-width: auto;
        }
        
.form-buttons {
    display: flex;
    gap: 16px;
    justify-content: center;
    margin-top: 32px;
    flex-wrap: wrap;
    }

/* レスポンシブ対応 */
    @media (max-width: 768px) {
        .interview-exam-container {
            padding: 16px;
        }
        
        .page-header {
            padding: 24px;
        }
        
        .page-title {
            font-size: 24px;
        }
        
        .page-subtitle {
            font-size: 16px;
        }
        
        .registration-form {
            padding: 24px;
        }
        
        .form-grid {
            grid-template-columns: 1fr;
            gap: 16px;
        }
        
        .form-section {
            padding: 20px;
        }
        
        .form-buttons {
            flex-direction: column;
        }
        
        .btn {
            width: 100%;
        }
    }

    @media (max-width: 480px) {
        .interview-exam-container {
            padding: 12px;
        }
        
        .page-header {
            padding: 20px;
        }
        
        .page-title {
            font-size: 20px;
        }
        
        .registration-form {
            padding: 20px;
        }
        
        .form-section {
            padding: 16px;
        }
    }

/* ダークモード対応 */
@media (prefers-color-scheme: dark) {
    .interview-exam-page {
        background: #2c2f34;
        color: #f4f6f8;
    }
    
    .interview-exam-container {
        background: #23272b;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.3);
    }
    
        .registration-form,
        .form-section {
        background: #2c2f34;
        border-color: #4d4d4d;
        }
        
        .form-title {
        color: #ffffff;
        background: linear-gradient(135deg, rgba(44, 119, 68, 0.3), rgba(92, 165, 100, 0.3));
        border-color: rgba(44, 119, 68, 0.5);
    }
    
    .section-title {
        color: #ffffff;
    }
    
    .form-group label {
        color: #f4f6f8;
    }
    
    .form-group input,
    .form-group select,
    .form-group textarea {
        background: #4d4d4d;
        border-color: #5d5d5d;
        color: #ffffff;
        }
    
    .stage-card {
        background: #2c2f34;
        border-color: #4d4d4d;
    }
    
    .stage-header {
        background: linear-gradient(135deg, #4d4d4d 0%, #3d3d3d 100%);
        border-bottom-color: #4d4d4d;
}
    
        .stage-title {
        color: #ffffff;
    }
    

    
    .stage-notes {
        background: #4d4d4d;
        border-color: #5d5d5d;
        color: #ffffff;
    }
    
    .form-title {
        color: #ffffff;
        background: linear-gradient(135deg, rgba(44, 119, 68, 0.3), rgba(92, 165, 100, 0.3));
        border-color: rgba(44, 119, 68, 0.5);
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
    }
}

.notes-textarea {
    resize: none;
    overflow: hidden;
    min-height: 80px;
    /* 右下のリサイズカーソルを消す（Chrome/Safari） */
}
.notes-textarea::-webkit-resizer {
    display: none;
}
</style>

</body>
</html>