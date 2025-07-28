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

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="beans.CompanyBean,java.util.List" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null) username = "ゲスト";
    if (role == null) role = "guest";
    List<CompanyBean> companies = (List<CompanyBean>) request.getAttribute("companies");
    Integer totalCompanies = (Integer) request.getAttribute("totalCompanies");
    Integer recruitmentCompanies = (Integer) request.getAttribute("recruitmentCompanies");
    java.util.List<java.util.List<String>> workPlacesList = (java.util.List<java.util.List<String>>) request.getAttribute("workPlacesList");
    java.util.List<java.util.List<String>> occupationsList = (java.util.List<java.util.List<String>>) request.getAttribute("occupationsList");
%>
<!--▲▲▲▲▲-->
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - 企業一覧</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">

<style>
    /* 企業一覧画面のスタイル */
    .company-list-page {
        background: #f8f9fa;
        color: #2c3e50;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        line-height: 1.6;
    }

    .company-list-container {
        max-width: 3000px;
        margin: 0 auto;
        padding: 24px;
        min-height: 100vh;
        background: #ffffff;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
    }

    /* ダッシュボード用ヘッダー調整 */
    .company-list-page header {
        position: relative;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    }

    .company-list-page #mainimg {
        display: none;
    }

    .company-list-page main {
        margin-top: 0;
    }

    /* テキストスライドショー用の調整 */
    .company-list-page .text-slide-wrapper {
        margin-top: 0;
        margin-bottom: 0;
    }

    .company-list-page .text-slide {
        font-size: 8vw;
        opacity: 0.08;
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

    /* 操作ボタン */
    .action-buttons {
        display: flex;
        gap: 16px;
        margin-bottom: 24px;
        justify-content: center;
        flex-wrap: wrap;
    }

    .action-btn {
        background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
        color: white;
        padding: 12px 24px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.2s ease;
        border: none;
        cursor: pointer;
        font-size: 14px;
        box-shadow: 0 2px 8px rgba(44, 119, 68, 0.2);
    }

    .action-btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
        color: white;
        text-decoration: none;
    }

    .action-btn.secondary {
        background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
        box-shadow: 0 2px 8px rgba(108, 117, 125, 0.2);
    }

    .action-btn.secondary:hover {
        box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
    }

    /* 企業一覧テーブル */
    .company-table-container {
        background: white;
        border-radius: 12px;
        padding: 24px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        overflow-x: auto;
    }

    .company-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 16px;
    }

    .company-table th,
    .company-table td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #e9ecef;
    }

    .company-table th {
        background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
        color: white;
        font-weight: 600;
        position: sticky;
        top: 0;
        z-index: 10;
    }

    .company-table tr:hover {
        background-color: rgba(44, 119, 68, 0.05);
    }

    .company-table tr:nth-child(even) {
        background-color: #f8f9fa;
    }

    .company-table tr:nth-child(even):hover {
        background-color: rgba(44, 119, 68, 0.05);
    }

    /* ステータスバッジ */
    .status-badge {
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 600;
        text-transform: uppercase;
    }

    .status-badge.success {
        background-color: #d4edda;
        color: #155724;
    }

    .status-badge.warning {
        background-color: #fff3cd;
        color: #856404;
    }

    /* 操作ボタン */
    .table-action-btn {
        padding: 6px 12px;
        border-radius: 4px;
        text-decoration: none;
        font-size: 12px;
        font-weight: 600;
        margin: 2px;
        display: inline-block;
        transition: all 0.2s ease;
    }

    .table-action-btn.edit {
        background-color: #007bff;
        color: white;
    }

    .table-action-btn.edit:hover {
        background-color: #0056b3;
        color: white;
        text-decoration: none;
    }

    .table-action-btn.delete {
        background-color: #dc3545;
        color: white;
    }

    .table-action-btn.delete:hover {
        background-color: #c82333;
        color: white;
        text-decoration: none;
    }

    /* 統計情報 */
    .stats-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 16px;
        margin-bottom: 24px;
    }

    .stat-card {
        background: white;
        border-radius: 8px;
        padding: 20px;
        text-align: center;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        border: 1px solid #e9ecef;
    }

    .stat-number {
        font-size: 24px;
        font-weight: 700;
        color: #2C7744;
        display: block;
    }

    .stat-label {
        font-size: 14px;
        color: #6c757d;
        margin-top: 4px;
    }

    /* レスポンシブ対応 */
    @media (max-width: 768px) {
        .company-list-container {
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
        
        .action-buttons {
            flex-direction: column;
            align-items: center;
        }
        
        .stats-container {
            grid-template-columns: 1fr;
        }
        
        .company-table-container {
            padding: 16px;
        }
        
        .company-table th,
        .company-table td {
            padding: 8px;
            font-size: 14px;
        }
    }

    /* 空の状態 */
    .empty-state {
        text-align: center;
        padding: 48px 24px;
        color: #6c757d;
    }

    .empty-state-icon {
        font-size: 48px;
        margin-bottom: 16px;
        opacity: 0.5;
    }

    .empty-state-title {
        font-size: 20px;
        font-weight: 600;
        margin-bottom: 8px;
        color: #2c3e50;
    }

    .empty-state-description {
        font-size: 16px;
        margin-bottom: 24px;
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
<body class="company-list-page">

<div id="container">
    <!-- ヘッダー -->
    <header>
        <h1 id="logo"><a href="javascript:void(0);" onclick="location.reload();"><img src="images/logo.png" alt="jms"></a></h1>
        <nav>
            <ul>
                <li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
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
    </header>

    <main>
    <section class="custom-section" role="main" aria-label="幅調整用">
	        <div class="company-list-container">
	            <!-- ページヘッダー -->
	            <header class="page-header" role="banner">
	                <h1 class="page-title">企業一覧</h1>
	                <p class="page-subtitle">登録されている企業の一覧を表示します</p>
	                <nav class="breadcrumb" aria-label="パンくずリスト">
	                    <a href="${pageContext.request.contextPath}/StatusServlet?view=DashBoard">ダッシュボード</a>
	                    <span class="separator" aria-hidden="true">/</span>
	                    <a href="CompanyManagementServlet">企業管理</a>
	                    <span class="separator" aria-hidden="true">/</span>
	                    <span>企業一覧</span>
	                </nav>
	            </header>
	
	            <!-- 統計情報 -->
	            <div class="stats-container">
	                <div class="stat-card">
	                    <span class="stat-number"><%= totalCompanies != null ? totalCompanies : 0 %></span>
	                    <span class="stat-label">総企業数</span>
	                </div>
	                <div class="stat-card">
	                    <span class="stat-number"><%= recruitmentCompanies != null ? recruitmentCompanies : 0 %></span>
	                    <span class="stat-label">採用実績あり</span>
	                </div>
	                <div class="stat-card">
	                    <span class="stat-number"><%= (totalCompanies != null && recruitmentCompanies != null) ? totalCompanies - recruitmentCompanies : 0 %></span>
	                    <span class="stat-label">採用実績なし</span>
	                </div>
	            </div>
	
	            <!-- 操作ボタン -->
                <%if(!role.equals("student")){%>
	            <div class="action-buttons">
	                <a href="CreateCompanyServlet" class="action-btn">
	                    <i class="fas fa-plus"></i>新規企業登録
	                </a>
	                <a href="CompanyManagementServlet" class="action-btn secondary">
	                    <i class="fas fa-arrow-left"></i>企業管理に戻る
	                </a>
	            </div>
                <%}else{%>
                    <div class="action-buttons">
                        <a href="StatusServlet?view=DashBoard" class="action-btn secondary">
                            <i class="fas fa-arrow-left"></i>ダッシュボードに戻る
                        </a>
                    </div>
                <%}%>
	
	            <!-- 企業一覧テーブル -->
	            <div class="company-table-container">
	                <% if (companies != null && !companies.isEmpty()) { %>
	                    <table class="company-table">
	                        <thead>
	                            <tr>
	                                <th>企業名</th>
	                                <th>職種</th>
	                                <th>勤務地</th>
	                                <th>採用実績</th>
                                    <%if(!role.equals("student")){%>
	                                <th>操作</th>
                                    <%}%>
	                            </tr>
	                        </thead>
	                        <tbody>
	                            <% for (int i = 0; i < companies.size(); i++) {
	                                beans.CompanyBean company = companies.get(i);
	                                List<String> occupations = company.getOccupations();
	                                List<String> workPlaces = company.getWorkPlaces();
	                            %>
	                            <tr>
	                              <td style="color: #000000"><%= company.getCompanyName() %></td>
	                              <td style="color: #000000">
	                                <% if (occupations != null && !occupations.isEmpty()) { %>
	                                    <% for (int j = 0; j < occupations.size(); j++) { %>
	                                        <span><%= occupations.get(j) %></span><% if (j != occupations.size()-1) { %>, <% } %>
	                                    <% } %>
	                                <% } else { %>
	                                    <span style="color:#aaa;">未設定</span>
	                                <% } %>
	                              </td>
	                              <td style="color: #000000">
	                                <% if (workPlaces != null && !workPlaces.isEmpty()) { %>
	                                    <% for (int j = 0; j < workPlaces.size(); j++) { %>
	                                        <span><%= workPlaces.get(j) %></span><% if (j != workPlaces.size()-1) { %>, <% } %>
	                                    <% } %>
	                                <% } else { %>
	                                    <span style="color:#aaa;">未設定</span>
	                                <% } %>
	                              </td>
	                              <td style="color: #000000">
	                                <% if (company.getRecruitmentResults()) { %>
	                                  <span class="status-badge success">あり</span>
	                                <% } else { %>
	                                  <span class="status-badge warning">なし</span>
	                                <% } %>
	                              </td>
                                  <%if(!role.equals("student")){%>
	                              <td>
	                                <a href="CompanyDetailServlet?companyId=<%= company.getCompanyId() %>" class="table-action-btn" style="background-color: #28a745; color: white;">
	                                  <i class="fas fa-eye"></i>詳細
	                                </a>
	                                <a href="CompanyDetailServlet?companyId=<%= company.getCompanyId() %>&mode=edit" class="table-action-btn edit">
	                                  <i class="fas fa-edit"></i>編集
	                                </a>
	                              </td>
                                  <%}%>
	                            </tr>
	                            <% } %>
	                        </tbody>
	                    </table>
	                <% } else { %>
	                    <div class="empty-state">
	                        <div class="empty-state-icon">🏢</div>
	                        <h3 class="empty-state-title">企業が登録されていません</h3>
	                        <p class="empty-state-description">新しい企業を登録して、就職活動をサポートしましょう。</p>
	                        <a href="CreateCompanyServlet" class="action-btn">
	                            <i class="fas fa-plus"></i>新規企業登録
	                        </a>
	                    </div>
	                <% } %>
	            </div>
	        </div>
	    </section>
    </main>

    <!--▼▼▼▼▼ここから「テキストスライドショー」-->
    <div class="text-slide-wrapper">
        <div class="text-slide">
            <span>Company List System</span>
        </div>
    </div>
    <!--▲▲▲▲▲ここまで「テキストスライドショー」-->

    <!-- フッター -->
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

    <span class="pr"><a href="" target="_blank">@ 2025 Job Management System</a></span>
</div>

<!-- ローディング -->
<div id="loading">
    <img src="images/logo.png" alt="Loading">
    <div class="progress-container">
        <div class="progress-bar"></div>
    </div>
</div>

<!-- ハンバーガーメニュー -->
<div id="menubar_hdr">
    <span></span><span></span><span></span>
</div>

<div id="menubar">
    <p class="logo"><img src="images/logo.png" alt="Job Management System"></p>
    <nav>
        <ul>
            <li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
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

<!-- スクリプト -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/protonet-jquery.inview/1.1.2/jquery.inview.min.js"></script>
<script src="js/jquery.inview_set.js"></script>
<script src="js/main.js"></script>

<script>
// 企業一覧画面のJavaScript

function deleteCompany(companyId) {
    if (confirm('企業ID: ' + companyId + ' の企業を削除しますか？\nこの操作は取り消せません。')) {
        // 削除処理
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'CompanyManagementServlet';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'delete';
        
        const companyIdInput = document.createElement('input');
        companyIdInput.type = 'hidden';
        companyIdInput.name = 'company_id';
        companyIdInput.value = companyId;
        
        form.appendChild(actionInput);
        form.appendChild(companyIdInput);
        document.body.appendChild(form);
        form.submit();
    }
}

// ページ読み込み時の処理
document.addEventListener('DOMContentLoaded', function() {
    // テーブルの行にホバー効果を追加
    const tableRows = document.querySelectorAll('.company-table tbody tr');
    tableRows.forEach(function(row) {
        row.addEventListener('mouseenter', function() {
            row.style.backgroundColor = 'rgba(44, 119, 68, 0.05)';
        });
        
        row.addEventListener('mouseleave', function() {
            row.style.backgroundColor = '';
        });
    });
    
    // 統計データのアニメーション
    const statNumbers = document.querySelectorAll('.stat-number');
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                const target = entry.target;
                const text = target.textContent;
                if (!isNaN(text)) {
                    const finalValue = parseInt(text);
                    animateNumber(target, 0, finalValue, 1000);
                }
                observer.unobserve(target);
            }
        });
    });

    statNumbers.forEach(function(stat) {
        observer.observe(stat);
    });
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
</script>

</body>
</html>
