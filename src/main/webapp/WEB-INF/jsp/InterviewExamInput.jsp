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
  System.out.println("InterviewExamInput.jsp - username: " + username);
  System.out.println("InterviewExamInput.jsp - role: " + role);
  
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
  System.out.println("InterviewExamInput.jsp - companyId: " + companyId);
  System.out.println("InterviewExamInput.jsp - studentId: " + studentId);
  System.out.println("InterviewExamInput.jsp - companyName: " + companyName);
  System.out.println("InterviewExamInput.jsp - studentName: " + studentName);
  
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
                <form action="InterviewExamInputServlet" method="post" id="selectionForm">
                <!-- 隠しフィールドで企業IDと学生IDを送信 -->
                <input type="hidden" name="companyId" value="<%= companyId != null ? companyId : "" %>">
                <input type="hidden" name="studentId" value="<%= studentId != null ? studentId : "" %>">

                <!-- 基本情報セクション -->
                <div class="form-section">
                    <h4 class="section-title">🏢 基本情報</h4>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="companyName">企業名 <span class="required">*</span></label>
                            <input type="text" id="companyName" name="companyName" value="<%= companyName != null ? companyName : "" %>" required>
                        </div>
                        <div class="form-group">
                            <label for="studentName">学生名 <span class="required">*</span></label>
                            <input type="text" id="studentName" name="studentName" value="<%= studentName != null ? studentName : "" %>" required>
                        </div>
                        <div class="form-group">
                            <label for="jobTitle">職種</label>
                            <select id="jobTitle" name="jobTitle">
                                <option value="">選択してください</option>
                                <option value="インフラエンジニア">インフラエンジニア</option>
                                <option value="アプリ開発エンジニア">アプリ開発エンジニア</option>
                                <option value="セキュリティエンジニア">セキュリティエンジニア</option>
                                <option value="ネットワークエンジニア">ネットワークエンジニア</option>
                                <option value="PM補佐">PM補佐</option>
                                <option value="サーバーエンジニア">サーバーエンジニア</option>
                                <option value="データベース管理者">データベース管理者</option>
                                <option value="ITサポート">ITサポート</option>
                                <option value="ヘルプデスク">ヘルプデスク</option>
                                <option value="品質管理／テスト">品質管理／テスト</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- 選考ステージ管理セクション -->
                <div class="form-section">
                    <div class="section-header">
                        <h4 class="section-title">📋 選考ステージ管理</h4>
                        <button type="button" class="btn btn-primary btn-sm" onclick="addSelectionStage()">
                            ➕ ステージを追加
                        </button>
                    </div>
                    
                    <div id="selectionStagesContainer">
                        <!-- 選考ステージが動的に追加される場所 -->
                    </div>
                    
                    <div class="stage-template" id="stageTemplate" style="display: none;">
                        <div class="stage-item" data-stage-index="">
                            <div class="stage-header">
                                <h5 class="stage-title">選考ステージ <span class="stage-number"></span></h5>
                                <button type="button" class="remove-stage-btn" onclick="removeStage(this)" title="このステージを削除">
                                    🗑️
                                </button>
                            </div>
                            
                            <div class="stage-content">
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label>ステージ種別 <span class="required">*</span></label>
                                        <select class="stage-type" name="stages[].type" required>
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
                                        <input type="date" class="stage-date" name="stages[].date">
                                    </div>
                                    
                                    <div class="form-group">
                                        <label>実施時間</label>
                                        <div class="time-range">
                                            <input type="time" class="stage-start-time" name="stages[].startTime">
                                            <span class="time-separator">～</span>
                                            <input type="time" class="stage-end-time" name="stages[].endTime">
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label>実施場所</label>
                                        <select class="stage-venue" name="stages[].venue">
                                            <option value="">選択してください</option>
                                            <option value="校内">校内</option>
                                            <option value="企業本社">企業本社</option>
                                            <option value="オンライン">オンライン</option>
                                            <option value="その他">その他</option>
                                        </select>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label>実施形式</label>
                                        <select class="stage-format" name="stages[].format">
                                            <option value="">選択してください</option>
                                            <option value="個人">個人</option>
                                            <option value="集団">集団</option>
                                            <option value="オンライン">オンライン</option>
                                            <option value="対面">対面</option>
                                            <option value="ハイブリッド">ハイブリッド</option>
                                        </select>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label>担当者数</label>
                                        <select class="stage-interviewer-count" name="stages[].interviewerCount">
                                            <option value="">選択してください</option>
                                            <option value="1">1名</option>
                                            <option value="2">2名</option>
                                            <option value="3">3名</option>
                                            <option value="4">4名</option>
                                            <option value="5名以上">5名以上</option>
                                        </select>
                                    </div>
                                    
                                    <div class="form-group full-width">
                                        <label>備考・特記事項</label>
                                        <textarea class="stage-notes" name="stages[].notes" rows="3" 
                                                  placeholder="特記事項があれば入力してください"></textarea>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label>ステータス</label>
                                        <select class="stage-status" name="stages[].status">
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
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">システム管理</a></li>
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
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">システム管理</a></li>
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

<script>
// 選考ステージ登録画面のJavaScript

let stageCounter = 0;

// 選考ステージを追加
function addSelectionStage() {
    stageCounter++;
    const container = document.getElementById('selectionStagesContainer');
    const template = document.getElementById('stageTemplate');
    const newStage = template.cloneNode(true);
    
    // テンプレートから実際の要素に変換
    newStage.style.display = 'block';
    newStage.classList.remove('stage-template');
    newStage.classList.add('stage-item');
    newStage.setAttribute('data-stage-index', stageCounter);
    
    // ステージ番号を設定
    const stageNumber = newStage.querySelector('.stage-number');
    if (stageNumber) {
        stageNumber.textContent = stageCounter;
    }
    
    // フォーム要素のname属性を更新
    const formElements = newStage.querySelectorAll('input, select, textarea');
    formElements.forEach(element => {
        if (element.name) {
            element.name = element.name.replace('[]', '[' + (stageCounter - 1) + ']');
        }
    });
    
    // コンテナに追加
    container.appendChild(newStage);
    
    // アニメーション効果
    newStage.style.opacity = '0';
    newStage.style.transform = 'translateY(20px)';
    
    setTimeout(() => {
        newStage.style.transition = 'all 0.4s ease';
        newStage.style.opacity = '1';
        newStage.style.transform = 'translateY(0)';
    }, 10);
}

// 選考ステージを削除
function removeStage(button) {
    const stageItem = button.closest('.stage-item');
    if (stageItem) {
        // 削除アニメーション
        stageItem.classList.add('removing');
        
        setTimeout(() => {
            stageItem.remove();
            updateStageNumbers();
        }, 300);
    }
}

// ステージ番号を更新
function updateStageNumbers() {
    const stages = document.querySelectorAll('.stage-item');
    stages.forEach((stage, index) => {
        const stageNumber = stage.querySelector('.stage-number');
        if (stageNumber) {
            stageNumber.textContent = index + 1;
        }
        
        // フォーム要素のname属性を更新
        const formElements = stage.querySelectorAll('input, select, textarea');
        formElements.forEach(element => {
            if (element.name) {
                element.name = element.name.replace(/\[\d+\]/, '[' + index + ']');
            }
        });
    });
}

// ページ読み込み時の初期化
document.addEventListener('DOMContentLoaded', () => {
    // フォームのバリデーション
    const form = document.getElementById('selectionForm');
    if (form) {
        form.addEventListener('submit', (e) => {
            const stages = document.querySelectorAll('.stage-item');
            
            if (stages.length === 0) {
                alert('少なくとも1つの選考ステージを追加してください。');
                e.preventDefault();
                return false;
            }
            
            // 各ステージの必須項目チェック
            let isValid = true;
            stages.forEach((stage, index) => {
                const typeSelect = stage.querySelector('.stage-type');
                if (typeSelect && !typeSelect.value) {
                    alert(`ステージ${index + 1}のステージ種別を選択してください。`);
                    isValid = false;
                }
            });
            
            if (!isValid) {
                e.preventDefault();
                return false;
            }
        });
    }
    
    // キーボードナビゲーションの改善
    const buttons = document.querySelectorAll('button[type="button"]');
    buttons.forEach(button => {
        button.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                button.click();
            }
        });
    });
    
    // 初期ステージを自動追加
    addSelectionStage();
});

// ドラッグ&ドロップでステージの順序を変更（オプション機能）
function enableDragAndDrop() {
    const container = document.getElementById('selectionStagesContainer');
    if (!container) return;
    
    let draggedElement = null;
    
    container.addEventListener('dragstart', (e) => {
        if (e.target.classList.contains('stage-item')) {
            draggedElement = e.target;
            e.target.style.opacity = '0.5';
        }
    });
    
    container.addEventListener('dragend', (e) => {
        if (e.target.classList.contains('stage-item')) {
            e.target.style.opacity = '1';
        }
    });
    
    container.addEventListener('dragover', (e) => {
        e.preventDefault();
        const stageItem = e.target.closest('.stage-item');
        if (stageItem && draggedElement && stageItem !== draggedElement) {
            const rect = stageItem.getBoundingClientRect();
            const midY = rect.top + rect.height / 2;
            
            if (e.clientY < midY) {
                stageItem.parentNode.insertBefore(draggedElement, stageItem);
            } else {
                stageItem.parentNode.insertBefore(draggedElement, stageItem.nextSibling);
            }
        }
    });
}

// ドラッグ&ドロップを有効化（必要に応じて）
// enableDragAndDrop();
</script>

<style>
    /* システム上見やすさを追求した選考ステージ登録画面デザイン */
    
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
    @media (max-width: 1400px) {
        .interview-exam-container {
            padding: 32px 1vw;
        }
    }
    @media (max-width: 768px) {
        .interview-exam-container {
            padding: 16px 2vw;
        }
    }
    @media (max-width: 480px) {
        .interview-exam-container {
            padding: 8px 1vw;
        }
    }

    /* ページヘッダー - 視認性向上 */
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

    /* 登録フォーム - 視認性と操作性の向上 */
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

    .form-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 20px;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: #2c3e50;
        font-size: 16px;
    }

    .form-group input,
    .form-group select {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        font-size: 16px;
        transition: all 0.2s ease;
        box-sizing: border-box;
        min-height: 48px;
    }

    .form-group input:focus,
    .form-group select:focus {
        outline: none;
        border-color: #2C7744;
        box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.1);
    }

    .required {
        color: #e74c3c;
        font-weight: 600;
    }

    /* 選考ステージ管理のスタイル */
    .section-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
    }

    .btn-sm {
        padding: 8px 16px;
        font-size: 14px;
        min-width: auto;
    }

    .stage-item {
        background: white;
        border: 2px solid #e9ecef;
        border-radius: 12px;
        margin-bottom: 20px;
        overflow: hidden;
        transition: all 0.3s ease;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    }

    .stage-item:hover {
        border-color: #2C7744;
        box-shadow: 0 4px 12px rgba(44, 119, 68, 0.15);
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
    }

    .remove-stage-btn {
        background: #dc3545;
        color: white;
        border: none;
        border-radius: 6px;
        padding: 8px 12px;
        cursor: pointer;
        font-size: 16px;
        transition: all 0.2s ease;
    }

    .remove-stage-btn:hover {
        background: #c82333;
        transform: scale(1.05);
    }

    .stage-content {
        padding: 24px;
    }

    .time-range {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .time-separator {
        color: #6c757d;
        font-weight: 600;
    }

    .full-width {
        grid-column: 1 / -1;
    }

    .stage-notes {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        font-size: 16px;
        transition: all 0.2s ease;
        box-sizing: border-box;
        resize: vertical;
        min-height: 80px;
    }

    .stage-notes:focus {
        outline: none;
        border-color: #2C7744;
        box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.1);
    }

    /* ステージ追加アニメーション */
    .stage-item {
        animation: slideInUp 0.4s ease forwards;
    }

    @keyframes slideInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* ステージ削除アニメーション */
    .stage-item.removing {
        animation: slideOutDown 0.3s ease forwards;
    }

    @keyframes slideOutDown {
        from {
            opacity: 1;
            transform: translateY(0);
        }
        to {
            opacity: 0;
            transform: translateY(20px);
        }
    }

    .btn-group {
        display: flex;
        gap: 10px;
        margin: 10px 0;
        flex-wrap: wrap;
    }

    .btn-group button {
        padding: 12px 20px;
        border: 2px solid #2C7744;
        background: white;
        color: #2C7744;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.2s ease;
        font-weight: 600;
        font-size: 14px;
        min-width: 80px;
    }

    .btn-group button:hover {
        background: #2C7744;
        color: white;
        transform: translateY(-1px);
    }

    /* ボタン */
    .form-buttons {
        display: flex;
        gap: 16px;
        justify-content: center;
        margin-top: 32px;
        flex-wrap: wrap;
    }

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
        background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
        color: white;
        box-shadow: 0 2px 8px rgba(44, 119, 68, 0.2);
    }

    .btn-primary:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
        color: white;
        text-decoration: none;
    }

    .btn-secondary {
        background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
        color: white;
        box-shadow: 0 2px 8px rgba(108, 117, 125, 0.2);
    }

    .btn-secondary:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        color: white;
        text-decoration: none;
    }
    
    /* ダークモード対応 */
    @media (prefers-color-scheme: dark) {
        .interview-exam-page {
            background: #1a1a1a;
            color: #ffffff;
        }
        
        .interview-exam-container {
            background: #2d2d2d;
        }
        
        .registration-form {
            background: #3d3d3d;
            border-color: #4d4d4d;
            color: #ffffff;
        }
        
        .form-section {
            background: #3d3d3d;
            border-color: #4d4d4d;
        }
        
        .form-group input,
        .form-group select {
            background: #4d4d4d;
            border-color: #5d5d5d;
            color: #ffffff;
        }
        
        .form-group label {
            color: #ffffff;
        }
        
        .section-title {
            color: #ffffff;
        }
        
        .btn-group button {
            background: #4d4d4d;
            border-color: #5d5d5d;
            color: #ffffff;
        }
        
        .btn-group button:hover {
            background: #2C7744;
            color: #ffffff;
        }
        
        .stage-item {
            background: #3d3d3d;
            border-color: #4d4d4d;
        }
        
        .stage-header {
            background: linear-gradient(135deg, #4d4d4d 0%, #3d3d3d 100%);
            border-color: #4d4d4d;
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

    /* レスポンシブ対応の強化 */
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
        
        .btn-group {
            flex-direction: column;
        }
        
        .btn-group button {
            width: 100%;
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

    /* アクセシビリティの向上 */
    .btn:focus,
    .form-group input:focus,
    .form-group select:focus,
    .btn-group button:focus {
        outline: 3px solid #2C7744;
        outline-offset: 2px;
    }

    /* 高コントラストモード対応 */
    @media (prefers-contrast: high) {
        .registration-form,
        .form-section {
            border: 2px solid #2c3e50;
        }
        
        .btn,
        .btn-group button {
            border: 2px solid #2c3e50;
        }
        
        .form-title {
            border: 2px solid #2c3e50;
            background: #ffffff;
            color: #000000;
        }
    }



    /* アニメーションの最適化 */
    .page-header,
    .registration-form {
        animation: fadeInUp 0.4s ease forwards;
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
</style>


</body>
</html>