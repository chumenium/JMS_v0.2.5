<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - 受験者一覧</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">
<style>
    .applicant-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 20px;
        background: #f8f9fa;
        min-height: 100vh;
    }
    
    .applicant-header {
        background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
        color: white;
        padding: 30px;
        border-radius: 10px;
        margin-bottom: 30px;
        text-align: center;
    }
    
    .search-section {
        background: white;
        border-radius: 10px;
        padding: 25px;
        margin-bottom: 30px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }
    
    .search-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 20px;
    }
    
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
    
    .btn-primary {
        background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
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
    }
    
    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
        color: white;
        text-decoration: none;
    }
    
    .applicant-table {
        background: white;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }
    
    .table-header {
        background: #007bff;
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
        border-left: 4px solid #007bff;
    }
    
    .summary-number {
        font-size: 2em;
        font-weight: bold;
        color: #007bff;
        margin-bottom: 10px;
    }
    
    .no-data {
        text-align: center;
        padding: 50px;
        color: #666;
        font-style: italic;
    }
    
    @media (max-width: 768px) {
        .search-grid {
            grid-template-columns: 1fr;
        }
        
        .summary-cards {
            grid-template-columns: repeat(2, 1fr);
        }
        
        .applicant-container {
            padding: 10px;
        }
        
        th, td {
            padding: 8px;
            font-size: 12px;
        }
    }
</style>
</head>

<body>
<% 
  String username = (String) session.getAttribute("username"); 
  String role = (String) session.getAttribute("role"); 
  
  // 権限チェック
  if (role == null || (!"teacher".equals(role) && !"headmaster".equals(role) && 
                      !"egd".equals(role) && !"admin".equals(role))) {
      response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
      return;
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
        <div class="applicant-container">
            <div class="applicant-header">
                <h1>📊 受験者一覧</h1>
                <p>企業の選考に応募した学生の一覧と進捗状況</p>
            </div>

            <!-- 統計サマリー -->
            <div class="summary-cards">
                <div class="summary-card">
                    <div class="summary-number">0</div>
                    <div>総応募者数</div>
                </div>
                <div class="summary-card">
                    <div class="summary-number">0</div>
                    <div>選考中</div>
                </div>
                <div class="summary-card">
                    <div class="summary-number">0</div>
                    <div>内定者数</div>
                </div>
                <div class="summary-card">
                    <div class="summary-number">0</div>
                    <div>不合格者数</div>
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
                                <option value="IT2A">IT2A</option>
                                <option value="IT2B">IT2B</option>
                                <option value="IT1A">IT1A</option>
                                <option value="IT1B">IT1B</option>
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
                                <th>職種</th>
                                <th>応募日</th>
                                <th>選考状況</th>
                                <th>最終更新日</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- サンプルデータ（実際の実装では動的に生成） -->
                            <tr>
                                <td>S2024001</td>
                                <td>山田太郎</td>
                                <td>IT2A</td>
                                <td>株式会社サンプル</td>
                                <td>システムエンジニア</td>
                                <td>2025-01-15</td>
                                <td><span class="status-badge status-interview">一次面接</span></td>
                                <td>2025-01-20</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/StudentDetailServlet?id=S2024001" class="btn-primary" style="font-size: 12px; padding: 6px 12px;">詳細</a>
                                </td>
                            </tr>
                            <tr>
                                <td>S2024002</td>
                                <td>佐藤花子</td>
                                <td>IT2B</td>
                                <td>テクノロジー株式会社</td>
                                <td>プログラマー</td>
                                <td>2025-01-10</td>
                                <td><span class="status-badge status-pass">内定</span></td>
                                <td>2025-01-18</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/StudentDetailServlet?id=S2024002" class="btn-primary" style="font-size: 12px; padding: 6px 12px;">詳細</a>
                                </td>
                            </tr>
                            <tr>
                                <td>S2024003</td>
                                <td>田中次郎</td>
                                <td>IT2A</td>
                                <td>イノベーション企業</td>
                                <td>Webデザイナー</td>
                                <td>2025-01-12</td>
                                <td><span class="status-badge status-applying">書類選考</span></td>
                                <td>2025-01-12</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/StudentDetailServlet?id=S2024003" class="btn-primary" style="font-size: 12px; padding: 6px 12px;">詳細</a>
                                </td>
                            </tr>
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
    </main>

    <!--▼▼▼▼▼ここから「フッター」-->
    <footer>
        <div>
            <p class="logo"><img src="images/logo.png" alt="Job Management System"></p>
            <small>Copyright&copy; @ 2025 Job Management System All Rights Reserved.</small>
        </div>
    </footer>
    <!--▲▲▲▲▲ここまで「フッター」-->
</div>

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