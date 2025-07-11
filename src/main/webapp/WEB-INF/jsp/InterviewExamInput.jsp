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

<body>
<div id="container">
    <!--▼▼▼▼▼ここから「ヘッダー」-->
    <header>
        <h1 id="logo"><a href="javascript:void(0);" onclick="location.reload();"><img src="images/logo.png" alt="jms"></a></h1>
        <nav>
            <ul>
                <% if (username != null) { %>
                    <li>こんにちは、<%= username %>さん</li>
                <% } else { %>
                    <li><a href="login.html">ログイン</a></li>
                <% } %>
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
    </header>
    <!--▲▲▲▲▲ここまで「ヘッダー」-->

    <main>
        <div style="max-width: 800px; margin: 0 auto; padding: 24px;">
            <h2 style="text-align: center; color: #2C7744; margin-bottom: 32px;">選考ステージ登録</h2>

            <!-- メッセージ表示 -->
            <% if (successMessage != null) { %>
                <div style="background: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 8px; padding: 16px; margin-bottom: 24px; text-align: center; font-weight: 600;">
                    ✅ <%= successMessage %>
                </div>
            <% } %>
            <% if (errorMessage != null) { %>
                <div style="background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; border-radius: 8px; padding: 16px; margin-bottom: 24px; text-align: center; font-weight: 600;">
                    ❌ <%= errorMessage %>
                </div>
            <% } %>

            <form action="InterviewExamInputServlet" method="post" style="background: white; padding: 32px; border-radius: 12px; box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);">
                <!-- 隠しフィールドで企業IDと学生IDを送信 -->
                <input type="hidden" name="companyId" value="<%= companyId != null ? companyId : "" %>">
                <input type="hidden" name="studentId" value="<%= studentId != null ? studentId : "" %>">

                <div class="section">
                    <label>企業名：</label>
                    <input type="text" name="companyName" value="<%= companyName != null ? companyName : "" %>" required>
                </div>

                <div class="section">
                    <label>学生名：</label>
                    <input type="text" name="studentName" value="<%= studentName != null ? studentName : "" %>" required>
                </div>

                <div class="section">
                    <label>職種：</label>
                    <select name="jobTitle">
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

                <div class="section">
                    <label>試験種別：</label>
                    <div class="btn-group">
                        <button type="button" class="examType-btn" id="examType-筆記" onclick="selectButton('examType','筆記')">筆記</button>
                        <button type="button" class="examType-btn" id="examType-適性" onclick="selectButton('examType','適性')">適性</button>
                        <button type="button" class="examType-btn" id="examType-なし" onclick="selectButton('examType','なし')">なし</button>
                    </div>
                    <input type="hidden" name="examType" id="examTypeInput" required>
                </div>

                <div class="section">
                    <label>試験日：</label>
                    <input type="date" name="examDate">
                </div>

                <div class="section">
                    <label>試験会場：</label>
                    <select name="examVenue">
                        <option value="">選択してください</option>
                        <option value="校内">校内</option>
                        <option value="企業本社">企業本社</option>
                        <option value="オンライン">オンライン</option>
                    </select>
                </div>

                <div class="section">
                    <label>試験時間：</label>
                    <input type="time" name="examStartTime"> ～ 
                    <input type="time" name="examEndTime">
                </div>

                <div class="section">
                    <label>面接日：</label>
                    <input type="date" name="interviewDate">
                </div>

                <div class="section">
                    <label>面接会場：</label>
                    <select name="interviewVenue">
                        <option value="">選択してください</option>
                        <option value="校内">校内</option>
                        <option value="企業本社">企業本社</option>
                        <option value="オンライン">オンライン</option>
                    </select>
                </div>

                <div class="section">
                    <label>面接形式：</label>
                    <div class="btn-group">
                        <button type="button" class="interviewFormat-btn" id="interviewFormat-個人" onclick="selectButton('interviewFormat','個人')">個人</button>
                        <button type="button" class="interviewFormat-btn" id="interviewFormat-集団" onclick="selectButton('interviewFormat','集団')">集団</button>
                        <button type="button" class="interviewFormat-btn" id="interviewFormat-オンライン" onclick="selectButton('interviewFormat','オンライン')">オンライン</button>
                    </div>
                    <input type="hidden" name="interviewFormat" id="interviewFormatInput" required>
                </div>

                <div class="section">
                    <label>面接官人数：</label>
                    <select name="interviewerCount">
                        <option value="">選択してください</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5名以上">5名以上</option>
                    </select>
                </div>

                <div class="section" style="text-align: center; margin-top: 32px;">
                    <button type="submit" style="background: #2C7744; color: white; padding: 15px 30px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold;">
                        登録
                    </button>
                </div>
            </form>
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

// ボタン選択機能
function selectButton(type, value) {
    // 既存の選択をクリア
    const buttons = document.querySelectorAll('.' + type + '-btn');
    buttons.forEach(btn => {
        btn.classList.remove('selected');
    });
    
    // 選択されたボタンをハイライト
    const selectedButton = document.getElementById(type + '-' + value);
    if (selectedButton) {
        selectedButton.classList.add('selected');
    }
    
    // 隠しフィールドに値を設定
    const input = document.getElementById(type + 'Input');
    if (input) {
        input.value = value;
    }
}

// ページ読み込み時の初期化
document.addEventListener('DOMContentLoaded', () => {
    // フォームのバリデーション
    const form = document.querySelector('form[action="InterviewExamInputServlet"]');
    if (form) {
        form.addEventListener('submit', (e) => {
            const examType = document.getElementById('examTypeInput').value;
            const interviewFormat = document.getElementById('interviewFormatInput').value;
            
            if (!examType) {
                alert('試験種別を選択してください。');
                e.preventDefault();
                return false;
            }
            
            if (!interviewFormat) {
                alert('面接形式を選択してください。');
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
});
</script>

<style>
/* ボタン選択時のスタイル */
.examType-btn.selected,
.interviewFormat-btn.selected {
    background: #2C7744 !important;
    color: white !important;
    transform: scale(1.05);
}

.btn-group {
    display: flex;
    gap: 10px;
    margin: 10px 0;
}

.btn-group button {
    padding: 10px 20px;
    border: 2px solid #2C7744;
    background: white;
    color: #2C7744;
    border-radius: 5px;
    cursor: pointer;
    transition: all 0.2s ease;
}

.btn-group button:hover {
    background: #2C7744;
    color: white;
}

.section {
    margin-bottom: 20px;
}

.section label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
}

.section input,
.section select {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

.section button[type="submit"] {
    background: #2C7744;
    color: white;
    padding: 15px 30px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 16px;
    font-weight: bold;
}

.section button[type="submit"]:hover {
    background: #5CA564;
}
</style>

</body>
</html>