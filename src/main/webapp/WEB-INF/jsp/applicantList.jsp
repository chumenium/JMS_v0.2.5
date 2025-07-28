<!--*
：：：色のテーマは緑：：：
受験者一覧画面


**********

<!--* 画面：受験者一覧画面
        	
許可されている権限：
・就職指導部：egd
・システム管理者：admin
 
▼▼▼▼
*-->


<!--確認まだ-->

<!--KCS_JMS_PROJECT-->


<!-- 受験者一覧画面用 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="beans.ExamineeBean"%>
<% 
  String username = (String) session.getAttribute("username"); 
  String role     = (String) session.getAttribute("role"); 
  Integer totalCompanies = (Integer) request.getAttribute("totalCompanies");
  Integer recruitmentCompanies = (Integer) request.getAttribute("recruitmentCompanies");
  
  // デバッグ用：セッション情報をコンソールに出力
  System.out.println("CompanyManagement.jsp - username: " + username);
  System.out.println("CompanyManagement.jsp - role: " + role);
  
  // nullチェック
  if (username == null) {
    username = "ゲスト";
  }
  if (role == null) {
    role = "guest";
  }
  
  // エラーメッセージを取得
  String errorMessage = (String) request.getAttribute("errorMessage");
  String successMessage = (String) request.getAttribute("successMessage");
  java.util.List<ExamineeBean> examinees = (java.util.List<ExamineeBean>)request.getAttribute("examinees");
%>


<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - 受験者一覧</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">
<style>


/* 全体コンテナ */
.applicant-container {
    max-width: 3000px;
    margin: 0 auto;
    padding: 20px;
    background: #f8f9fa;
    min-height: 100vh;
}

/* ヘッダー */
.applicant-header {
    background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
    color: white;
    padding: 30px;
    border-radius: 10px;
    margin-bottom: 30px;
    text-align: center;
}

/* 検索セクション */
.search-section {
    background: white;
    border-radius: 10px;
    padding: 25px;
    margin-bottom: 30px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

/* 検索フィールドグリッド */
.search-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
    margin-bottom: 20px;
}

/* フォームグループ */
.form-group {
    display: flex;
    flex-direction: column;
}

.form-group label {
    margin-bottom: 5px;
    font-weight: 600;
    color: #333;
}

.form-group input,
.form-group select {
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
    font-size: 14px;
}

/* プライマリボタン */
.btn-primary {
    background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
    color: white;
    padding: 12px 24px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 14px;
    margin: 5px;
    text-decoration: none;
    display: inline-block;
    transition: all 0.3s ease;
    box-shadow: 0 2px 8px rgba(44, 119, 68, 0.2);
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
    color: white;
    text-decoration: none;
}

/* 受験者テーブル全体 */
.applicant-table {
    background: white;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.table-header {
    background: #2C7744;
    color: white;
    padding: 20px;
}

.table-responsive {
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th, td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #ddd;
}

th {
    background: #f8f9fa;
    font-weight: 600;
    color: #333;
    position: sticky;
    top: 0;
}

tr:hover {
    background: #f8f9fa;
}

/* 状態バッジ */
.status-badge {
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    text-align: center;
    display: inline-block;
    min-width: 80px;
}

.status-applying {
    background: #fff3cd;
    color: #856404;
}

.status-interview {
    background: #d4edda;
    color: #155724;
}

.status-result {
    background: #d1ecf1;
    color: #0c5460;
}

.status-pass {
    background: #d4edda;
    color: #155724;
}

.status-fail {
    background: #f8d7da;
    color: #721c24;
}

/* 概要カード */
.summary-cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 30px;
}

.summary-card {
    background: white;
    border-radius: 10px;
    padding: 20px;
    text-align: center;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    border-left: 4px solid #2C7744;
}

.summary-number {
    font-size: 2em;
    font-weight: bold;
    color: #2C7744;
    margin-bottom: 10px;
}

/* データなし時の表示 */
.no-data {
    text-align: center;
    padding: 50px;
    color: #666;
    font-style: italic;
}

/* 幅間調整用 */
	.custom-section {
    width: 100vw;           /* ビューポート全体の横幅を使用 */
    max-width: none;        /* 最大幅の制限を解除 */
    margin: 0;
    padding: 40px 32px;
    margin-top: 50px; /* ← ヘッダーとの距離をここで確保 */
    margin-bottom: 30px; /* ← 例えば60pxで広めに */
    box-sizing: border-box;
    background-color: #fff;
    color: #fff;
	}
	
	
	
	@media (max-width: 768px) {
	    .custom-section {
	        padding: 32px 16px;
	    }
	}

	@media (max-width: 480px) {
	    .custom-section {
	        padding: 24px 12px;
	    }
	}


</style>
</head>

<body>

<% 
  // 権限名を日本語に変換
  String roleDisplay = "";
  switch(role) {
    case "teacher": roleDisplay = "教員"; break;
    case "headmaster": roleDisplay = "教務部長・校長"; break;
    case "egd": roleDisplay = "就職指導部"; break;
    case "admin": roleDisplay = "システム管理者"; break;
    case "student": roleDisplay = "学生"; break;
    default: roleDisplay = role; break;
  }
%>
<div id="container">
    <!--▼▼▼▼▼ここから「ヘッダー」-->
    <header>
        <h1 id="logo"><a href="${pageContext.request.contextPath}/DashboardServlet"><img src="images/logo.png" alt="jms"></a></h1>
        <nav>
            <ul>
                <li><a href="${pageContext.request.contextPath}/DashboardServlet">ホーム</a></li>
                <% if ("teacher".equals(role) || "headmaster".equals(role) || "admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
                <% } %>
                <% if ("egd".equals(role) || "admin".equals(role)) { %>
                    <li><a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
                <% } %>
                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
                <li><a href="extension.html">お問い合わせ</a></li>
                <li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
            </ul>
        </nav>
    </header>
    <!--▲▲▲▲▲ここまで「ヘッダー」-->

    <main>
    <section class="custom-section" role="main" aria-label="幅調整用">
	        <div class="applicant-container">
	            <div class="applicant-header">
	                <h1>📊 受験者一覧</h1>
	                <p>企業の選考に応募した学生の一覧と進捗状況</p>
	            </div>
	
	            <!-- 統計サマリー -->
	            <div class="summary-cards">
	                <div class="summary-card">
	                    <div class="summary-number">0</div>
	                    <div style="color: #000000">総応募者数</div>
	                </div>
	                <div class="summary-card">
	                    <div class="summary-number">0</div>
	                    <div style="color: #000000">選考中</div>
	                </div>
	                <div class="summary-card">
	                    <div class="summary-number">0</div>
	                    <div style="color: #000000">内定者数</div>
	                </div>
	                <div class="summary-card">
	                    <div class="summary-number">0</div>
	                    <div style="color: #000000">不合格者数</div>
	                </div>
	            </div>
	
	            <!-- 検索フィルター -->
	            <div class="search-section">
	                <h3>🔍 検索・フィルター</h3>
	                <form method="get" action="${pageContext.request.contextPath}/StatusServlet">
	                    <input type="hidden" name="view" value="applicantList">
	                    <div class="search-grid">
	                        <div class="form-group">
	                            <label for="searchCompany">企業名</label>
	                            <input type="text" id="searchCompany" name="searchCompany" placeholder="企業名で検索">
	                        </div>
	                        <div class="form-group">
	                            <label for="searchStudent">学生名</label>
	                            <input type="text" id="searchStudent" name="searchStudent" placeholder="学生名で検索">
	                        </div>
	                        <div class="form-group">
	                            <label for="searchStatus">選考状況</label>
	                            <select id="searchStatus" name="searchStatus">
	                                <option value="">すべて</option>
	                                <option value="書類選考">書類選考</option>
	                                <option value="一次面接">一次面接</option>
	                                <option value="二次面接">二次面接</option>
	                                <option value="最終面接">最終面接</option>
	                                <option value="内定">内定</option>
	                                <option value="不合格">不合格</option>
	                            </select>
	                        </div>
	                        <div class="form-group">
	                            <label for="searchClass">クラス</label>
	                            <select id="searchClass" name="searchClass">
	                                <option value="">すべて</option>
                                    <option value="R1A1">R1A1</option>
	                                <option value="R1A2">R1A2</option>
                                    <option value="R2A1">R2A1</option>
                                    <option value="R2A2">R2A2</option>
                                    <option value="R3A1">R3A1</option>
	                                <option value="R3A2">R3A2</option>
                                    <option value="R4A1">R4A1</option>
	                                <option value="R4A2">R4A2</option>
	                                <option value="S3A1">S3A1</option>
	                                <option value="S3A2">S3A2</option>
	                                <option value="S2A1">S2A1</option>
	                                <option value="S2A1">S2A1</option>
                                    <option value="S1A1">S1A1</option>
	                                <option value="S1A2">S1A2</option>
                                    <option value="M3G1">M3G1</option>
	                                <option value="M3G2">M3G2</option>
                                    <option value="M2G1">M2G1</option>
	                                <option value="M2G2">M2G2</option>
                                    <option value="M1G1">M1G1</option>
	                                <option value="M1G2">M1G2</option>
                                    <option value="G2G1">G2G1</option>
	                                <option value="G2G2">G2G2</option>
                                    <option value="G1G1">G1G1</option>
	                                <option value="G1G2">G1G2</option>
                                    <option value="J2S1">J2S1</option>
	                                <option value="J2S2">J2S2</option>
                                    <option value="J1S1">J1S1</option>
	                                <option value="J1S2">J1S2</option>
	                            </select>
	                        </div>
	                    </div>
	                    <button type="submit" class="btn-primary">🔍 検索</button>
	                    <button type="button" class="btn-primary" onclick="clearSearch()">🔄 クリア</button>
	                </form>
	            </div>
	
	            <!-- 受験者一覧テーブル -->
	            <div class="applicant-table">
	                <div class="table-header">
	                    <h3>📋 受験者一覧</h3>
	                </div>
	                <div class="table-responsive">
	                    <table>
	                        <thead>
	                            <tr>
	                                <th>学生ID</th>
	                                <th>学生名</th>
	                                <th>クラス</th>
	                                <th>企業名</th>
	                                <!-- <th>職種</th>
	                                <th>応募日</th> -->
	                                <th>選考状況</th>
	                                <th>最終更新日</th>
	                                <th>操作</th>
	                            </tr>
	                        </thead>
	                        <tbody>
	                            <!-- サンプルデータ（実際の実装では動的に生成） -->
	                            <!-- <td style="color: #000000">を入れること
	                            または <tr style="color: #000000">を入れること！！！-->
                                <% for(ExamineeBean examinee : examinees){%>
                                    <tr style="color: #000000">
                                        <td><%= examinee.getStudentId()%></td>
                                        <td><%= examinee.getStudentName()%></td>
                                        <td><%= examinee.getClassName()%></td>
                                        <td><%= examinee.getCompanyName()%></td>
                                        <td><span class="status-badge status-interview"><%= examinee.getSelection()%></span></td>
                                        <td><%= examinee.getData()%></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/StudentDetailServlet?id=S2024001" class="btn-primary" style="font-size: 12px; padding: 6px 12px;">詳細</a>
                                        </td>
                                    </tr>
                                <%}%>
	                        </tbody>
	                    </table>
	                </div>
	                
	                <!-- データが存在しない場合の表示 -->
	                <div class="no-data" style="display: none;">
	                    <p>📝 現在、受験者データがありません。</p>
	                    <p>学生が企業に応募すると、ここに表示されます。</p>
	                </div>
	            </div>
	        </div>
	    </section>
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


<script>
function clearSearch() {
    document.getElementById('searchCompany').value = '';
    document.getElementById('searchStudent').value = '';
    document.getElementById('searchStatus').value = '';
    document.getElementById('searchClass').value = '';
}

// ページ読み込み時の処理
document.addEventListener('DOMContentLoaded', function() {
    console.log('受験者一覧画面が読み込まれました');
    
    // 統計数値の更新（実際の実装では動的に計算）
    updateSummaryCards();
});

function updateSummaryCards() {
    // 実際の実装では、サーバーサイドからデータを取得して更新
    const totalApplicants = document.querySelectorAll('tbody tr').length;
    const summaryNumbers = document.querySelectorAll('.summary-number');
    
    if (summaryNumbers.length >= 4) {
        summaryNumbers[0].textContent = totalApplicants;
        
        // 選考中の数をカウント
        const inProgress = document.querySelectorAll('.status-interview, .status-applying, .status-result').length;
        summaryNumbers[1].textContent = inProgress;
        
        // 内定者数をカウント
        const passed = document.querySelectorAll('.status-pass').length;
        summaryNumbers[2].textContent = passed;
        
        // 不合格者数をカウント
        const failed = document.querySelectorAll('.status-fail').length;
        summaryNumbers[3].textContent = failed;
    }
}
</script>

</body>
</html> 