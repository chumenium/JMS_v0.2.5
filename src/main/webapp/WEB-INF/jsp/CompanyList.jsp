<!--*
：：：色のテーマは緑：：：
企業管理画面

**********

<!--* 画面：企業管理画面
        	
許可されている権限：
・就職指導部：egd
・システム管理者：admin
 
▼▼▼▼
*-->

<!--確認まだ-->

<!--KCS_JMS_PROJECT-->

<!-- 企業管理画面用 -->

<!--▼▼▼▼▼スコープから取得する情報　これをもとに判定をしていく -->
<% 
  String username = (String) session.getAttribute("username"); 
  String role     = (String) session.getAttribute("role"); 
%>
<!--▲▲▲▲▲-->

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>企業管理画面</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">

<!-- 企業管理画面用CSS -->
<style>
/* システム上見やすさを追求した学生一覧管理画面デザイン */

/* 全体の設定 */
.company-list-page {
	background: #f8f9fa;
	color: #2c3e50;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	line-height: 1.6;
}

.company-list-container {
	max-width: 1400px;
	margin: 0 auto;
	padding: 24px;
	min-height: 100vh;
	background: #ffffff;
	box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
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

/* 検索バー - 視認性と操作性の向上 */
.search-bar {
	background: white;
	border-radius: 12px;
	padding: 24px;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
	border: 1px solid #e9ecef;
	margin-bottom: 24px;
	display: flex;
	gap: 12px;
	align-items: center;
}

.search-bar input[type="text"] {
	flex: 1;
	padding: 12px 16px;
	border: 1px solid #e9ecef;
	border-radius: 8px;
	font-size: 16px;
	transition: all 0.2s ease;
}

.search-bar input[type="text"]:focus {
	outline: none;
	border-color: #2C7744;
	box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.1);
}

.search-bar button {
	background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
	color: white;
	border: none;
	border-radius: 8px;
	padding: 12px 24px;
	font-size: 16px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s ease;
	box-shadow: 0 2px 8px rgba(44, 119, 68, 0.2);
}

.search-bar button:hover {
	transform: translateY(-1px);
	box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
}

/* 学生一覧表 - 視認性と操作性の向上 */
.company-table {
	width: 100%;
	border-collapse: collapse;
	background: white;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
	margin-bottom: 24px;
	border: 1px solid #e9ecef;
}

.company-table th, .company-table td {
	padding: 16px 12px;
	text-align: left;
	border-bottom: 1px solid #e9ecef;
}

.company-table th {
	background: linear-gradient(135deg, #e9f5ee 0%, #f1f8f5 100%);
	color: #2C7744;
	font-size: 16px;
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: 0.5px;
}

.company-table tr:company-child td {
	border-bottom: none;
}

.company-table tr:hover {
	background: linear-gradient(135deg, #f1f8f5 0%, #e9f5ee 100%);
	transform: translateY(-1px);
	box-shadow: 0 2px 8px rgba(44, 119, 68, 0.1);
}

.company-table tr {
	transition: all 0.2s ease;
}

/* 操作ボタン */
.action-btn {
	background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
	color: white;
	padding: 6px 12px;
	border-radius: 6px;
	text-decoration: none;
	font-weight: 600;
	font-size: 14px;
	display: inline-block;
	margin-right: 8px;
	transition: all 0.2s ease;
	border: none;
	cursor: pointer;
	box-shadow: 0 2px 4px rgba(44, 119, 68, 0.2);
}

.action-btn:hover {
	transform: translateY(-1px);
	box-shadow: 0 4px 8px rgba(44, 119, 68, 0.3);
	color: white;
	text-decoration: none;
}

.action-btn.secondary {
	background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
	box-shadow: 0 2px 4px rgba(108, 117, 125, 0.2);
}

.action-btn.secondary:hover {
	box-shadow: 0 4px 8px rgba(108, 117, 125, 0.3);
}

/* ページネーション - 視認性と操作性の向上 */
.pagination {
	display: flex;
	justify-content: center;
	gap: 8px;
	margin-top: 24px;
	flex-wrap: wrap;
}

.pagination form {
	margin: 0;
}

.pagination button {
	background: white;
	border: 2px solid #2C7744;
	color: #2C7744;
	border-radius: 8px;
	padding: 10px 16px;
	font-size: 16px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s ease;
	min-width: 44px;
	box-shadow: 0 2px 4px rgba(44, 119, 68, 0.1);
}

.pagination button.active, .pagination button:hover {
	background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
	color: white;
	transform: translateY(-1px);
	box-shadow: 0 4px 8px rgba(44, 119, 68, 0.3);
}

/* レスポンシブ対応の強化 */
@media ( max-width : 768px) {
	.company-list-container {
		padding: 16px;
	}
	.page-header {
		padding: 24px;
	}
	.page-title {
		font-size: 24px;
	}
	.search-bar {
		flex-direction: column;
		gap: 12px;
		padding: 20px;
	}
	.company-table th, .company-table td {
		padding: 12px 8px;
		font-size: 14px;
	}
	.action-btn {
		padding: 4px 8px;
		font-size: 12px;
		margin-right: 4px;
	}
	.pagination button {
		padding: 8px 12px;
		font-size: 14px;
		min-width: 40px;
	}
}

@media ( max-width : 480px) {
	.company-list-container {
		padding: 12px;
	}
	.page-header {
		padding: 20px;
	}
	.page-title {
		font-size: 20px;
	}
	.search-bar {
		padding: 16px;
	}
	.company-table th, .company-table td {
		padding: 8px 6px;
		font-size: 12px;
	}
}

/* アクセシビリティの向上 */
.search-bar input[type="text"]:focus, .search-bar button:focus,
	.action-btn:focus, .pagination button:focus {
	outline: 3px solid #2C7744;
	outline-offset: 2px;
}

/* 高コントラストモード対応 */
@media ( prefers-contrast : high) {
	.company-table {
		border: 2px solid #2c3e50;
	}
	.action-btn, .pagination button {
		border: 2px solid #2c3e50;
	}
}

/* ダークモード対応 */
@media ( prefers-color-scheme : dark) {
	.company-list-page {
		background: #1a1a1a;
		color: #ffffff;
	}
	.company-list-container {
		background: #2d2d2d;
	}
	.search-bar {
		background: #3d3d3d;
		border-color: #4d4d4d;
		color: #ffffff;
	}
	.search-bar input[type="text"] {
		background: #4d4d4d;
		border-color: #5d5d5d;
		color: #ffffff;
	}
	.company-table {
		background: #3d3d3d;
		color: #ffffff;
		border-color: #4d4d4d;
	}
	.company-table th {
		background: #2C7744;
		color: #ffffff;
	}
	.company-table tr:hover {
		background: #2C7744;
		color: #ffffff;
	}
	.pagination button {
		background: #3d3d3d;
		border-color: #2C7744;
		color: #ffffff;
	}
}
</style>

</head>
<body>
	<div id="container">
		<!--▼▼▼▼▼ここから「ヘッダー」-->
		<header>
			<h1 id="logo">
				<a href="javascript:void(0);" onclick="location.reload();"><img
					src="images/logo.png" alt="jms"></a>
			</h1>
			<nav>
				<ul>
					<li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
					<!-- 権限に応じた機能リンク -->
					<% if ("teacher".equals(role) || "headmaster".equals(role) || "admin".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
					<% } %>
					<% if ("egd".equals(role) || "admin".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
					<% } %>
					<% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role) || "student".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
					<% } %>
					<% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=applicantList">受験者一覧</a></li>
					<% } %>
					<% if ("admin".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">システム管理</a></li>
					<% } %>
					<li><a href="extension.html">お問い合わせ</a></li>
					<% if (username != null) { %>
					<li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
					<% } %>
				</ul>
			</nav>
		</header>
		<!--▲▲▲▲▲ここまで「ヘッダー」-->

		<!-- 権限チェック -->
		<% if (!"egd".equals(role) && !"admin".equals(role)) { %>
		<div class="permission-error">
			<h2>アクセス権限がありません</h2>
			<p>企業管理画面にアクセスするには、就職指導部またはシステム管理者の権限が必要です。</p>
			<a href="StatusServlet?view=dashboard" class="btn btn-primary">ダッシュボードに戻る</a>
		</div>
		<% } else { %>

		<main>
			<div>.</div>
			<div>.</div>
			<div>.</div>
			<div class="company-list-container">
				<!-- ページヘッダー -->
				<header class="page-header" role="banner">
					<h1 class="page-title">企業一覧管理</h1>
					<nav class="breadcrumb" aria-label="パンくずリスト">
						<a
							href="${pageContext.request.contextPath}/StatusServlet?view=DashBoard">ダッシュボード</a>
						<span class="separator" aria-hidden="true">/</span> <a
							href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">企業管理</a>
						<span class="separator" aria-hidden="true">/</span> <span>企業一覧管理</span>
					</nav>
				</header>

				<!-- 検索バー -->
				<form class="search-bar" method="get" action="StudentServlet">
					<input type="text" name="keyword"
						placeholder="企業名・所在地・募集状況などで検索..." aria-label="検索キーワード"
						value="${keyword != null ? keyword : ''}">
					<button type="submit" aria-label="検索">🔍 検索</button>
				</form>

				<!-- 企業一覧表 -->
				<table class="company-table" aria-label="企業一覧">
					<thead>
						<tr>
							<th>企業名</th>
							<th>業界</th>
							<th>所在地</th>
							<th>募集状況</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${not empty companys and companys[0].size() > 0}">
								<c:forEach var="i" begin="0" end="${students[0].size()-1}">
									<tr>
										<td>${companys[0][i]}</td>
										<td>${companys[1][i]}</td>
										<td>${companys[2][i]}</td>
										<td>${companys[3][i]}</td>
										<td><a href="#" class="action-btn" aria-label="企業詳細を表示">詳細</a>
											<a href="#" class="action-btn secondary" aria-label="企業情報を編集">編集</a>
										</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="5"
										style="text-align: center; padding: 40px; color: #6c757d; font-style: italic;">
										該当する企業がありません</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>


			</div>
		</main>
		<!--開閉ボタン（ハンバーガーアイコン）-->
		<div id="menubar_hdr">
			<span></span><span></span><span></span>
		</div>

		<!--開閉ブロック-->
		<div id="menubar">
			<p class="logo">
				<img src="images/logo.png" alt="Job Management System">
			</p>
			<nav>
				<ul>
					<li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
					<!-- 権限に応じた機能リンク -->
					<% if ("teacher".equals(role) || "headmaster".equals(role) || "admin".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
					<% } %>
					<% if ("egd".equals(role) || "admin".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
					<% } %>
					<% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role) || "student".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
					<% } %>
					<% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=applicantList">受験者一覧</a></li>
					<% } %>
					<% if ("admin".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">システム管理</a></li>
					<% } %>
					<li><a href="extension.html">お問い合わせ</a></li>
					<% if (username != null) { %>
					<li><a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a></li>
					<% } %>
				</ul>
			</nav>
		</div>
		<!--/#menubar-->

		<!--▼▼▼▼▼ここから「テキストスライドショー」-->
		<div class="text-slide-wrapper">
			<div class="text-slide">
				<span>Student Management System</span>
			</div>
		</div>
		<!--▲▲▲▲▲ここまで「テキストスライドショー」-->

		<!--▼▼▼▼▼ここから「フッター」-->
		<footer>
			<div>
				<p class="logo">
					<img src="images/logo.png" alt="Job Management System">
				</p>
				<ul class="icons">
					<li><a href="#"><i class="fa-brands fa-x-twitter"></i></a></li>
					<li><a href="#"><i class="fab fa-line"></i></a></li>
					<li><a href="#"><i class="fab fa-youtube"></i></a></li>
					<li><a href="#"><i class="fab fa-instagram"></i></a></li>
				</ul>
				<small>Copyright&copy; @ 2025 Job Management System All
					Rights Reserved.</small>
			</div>
			<div>
				<ul>
					<li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
					<!-- 権限に応じた機能リンク -->
					<% if ("teacher".equals(role) || "headmaster".equals(role) || "admin".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
					<% } %>
					<% if ("egd".equals(role) || "admin".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
					<% } %>
					<% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role) || "student".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
					<% } %>
					<% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=applicantList">受験者一覧</a></li>
					<% } %>
					<% if ("admin".equals(role)) { %>
					<li><a
						href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">システム管理</a></li>
					<% } %>
					<li><a href="extension.html">お問い合わせ</a></li>
				</ul>
			</div>
		</footer>
		<!--▲▲▲▲▲ここまで「フッター」-->

		<!--▼▼最下部-->
		<span class="pr"><a href="" target="_blank">@ 2025 Job
				Management System</a></span>
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
		<p class="logo">
			<img src="images/logo.png" alt="Job Management System">
		</p>
		<nav>
			<ul>
				<li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
				<!-- 権限に応じた機能リンク -->
				<% if ("teacher".equals(role) || "headmaster".equals(role) || "admin".equals(role)) { %>
				<li><a
					href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a></li>
				<% } %>
				<% if ("egd".equals(role) || "admin".equals(role)) { %>
				<li><a
					href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a></li>
				<% } %>
				<% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role) || "student".equals(role)) { %>
				<li><a
					href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a></li>
				<% } %>
				<% if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role)) { %>
				<li><a
					href="${pageContext.request.contextPath}/StatusServlet?view=applicantList">受験者一覧</a></li>
				<% } %>
				<% if ("admin".equals(role)) { %>
				<li><a
					href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">システム管理</a></li>
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
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<!--パララックス（inview）-->
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/protonet-jquery.inview/1.1.2/jquery.inview.min.js"></script>
	<script src="js/jquery.inview_set.js"></script>
	<!--このテンプレート専用のスクリプト-->
	<script src="js/main.js"></script>

	<script>
// 学生管理画面の最適化されたJavaScript

// アクセシビリティの向上
document.addEventListener('DOMContentLoaded', () => {
    // キーボードナビゲーションの改善
    const actionButtons = document.querySelectorAll('.action-btn');
    actionButtons.forEach(button => {
        button.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                button.click();
            }
        });
    });

    // カードリンクのキーボード操作
    const cardLinks = document.querySelectorAll('.card-link');
    cardLinks.forEach(link => {
        link.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                link.click();
            }
        });
    });

    // フォーカス管理の改善
    const focusableElements = document.querySelectorAll('a, button, input, select, textarea, [tabindex]:not([tabindex="-1"])');
    focusableElements.forEach(element => {
        element.addEventListener('focus', () => {
            element.style.outline = '2px solid #2C7744';
            element.style.outlineOffset = '2px';
        });
        
        element.addEventListener('blur', () => {
            element.style.outline = '';
            element.style.outlineOffset = '';
        });
    });

    // 統計データのアニメーション
    const statNumbers = document.querySelectorAll('.stat-number');
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const target = entry.target;
                const finalValue = parseInt(target.textContent);
                animateNumber(target, 0, finalValue, 1000);
                observer.unobserve(target);
            }
        });
    });

    statNumbers.forEach(stat => observer.observe(stat));
});

// 数値アニメーション関数
function animateNumber(element, start, end, duration) {
    const startTime = performance.now();
    
    function updateNumber(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        
        const current = Math.floor(start + (end - start) * progress);
        element.textContent = current;
        
        if (progress < 1) {
            requestAnimationFrame(updateNumber);
        }
    }
    
    requestAnimationFrame(updateNumber);
}

// パフォーマンス最適化
window.addEventListener('load', () => {
    // 画像の遅延読み込み
    const images = document.querySelectorAll('img[data-src]');
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
                observer.unobserve(img);
            }
        });
    });

    images.forEach(img => imageObserver.observe(img));

    // スムーズスクロール
    const smoothScrollLinks = document.querySelectorAll('a[href^="#"]');
    smoothScrollLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const targetId = link.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});

// エラーハンドリング
window.addEventListener('error', (e) => {
    console.error('JavaScript error:', e.error);
    // エラーが発生した場合のフォールバック処理
});

// ページの可視性変更時の処理
document.addEventListener('visibilitychange', () => {
    if (document.hidden) {
        // ページが非表示になった時の処理
        console.log('Page hidden');
    } else {
        // ページが表示された時の処理
        console.log('Page visible');
    }
});
</script>


	<% } %>

	</div>
</body>
</html>
