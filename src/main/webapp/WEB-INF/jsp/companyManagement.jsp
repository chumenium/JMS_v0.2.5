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
/*----------------------------------------------
  カラー変数
----------------------------------------------*/
:root {
  --primary: #4CAF50;
  --primary-dark: #388E3C;
  --bg: #fff;
  --surface: #f5f7fa;
  --border: #ddd;
  --text: #333;
  --success: #4CAF50;
  --warning: #FF9800;
  --danger: #F44336;
}

/*----------------------------------------------
  ベースリセット
----------------------------------------------*/
*,
*::before,
*::after {
  box-sizing: border-box;
}

body {
  margin: 0;
  font-family: "Segoe UI", "Hiragino Kaku Gothic ProN", "Hiragino Sans", Meiryo, sans-serif;
  background: var(--bg);
  color: var(--text);
  line-height: 1.6;
}

main {
  max-width: 1200px;
  padding: 2rem;
  margin: 0 auto;
}

h1 {
  text-align: center;
  margin-bottom: 2rem;
  color: var(--primary);
  font-size: 2rem;
}

/*----------------------------------------------
  検索フォーム
----------------------------------------------*/
.search-section {
  background: var(--surface);
  padding: 1.5rem;
  border-radius: 8px;
  margin-bottom: 2rem;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.search-section h2 {
  margin-top: 0;
  color: var(--primary);
  font-size: 1.3rem;
}

.grid-form .grid-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-bottom: 1rem;
}

.field {
  display: flex;
  flex-direction: column;
}

.field label {
  margin-bottom: 0.5rem;
  font-weight: bold;
  color: var(--text);
}

.field input,
.field select {
  padding: 0.75rem;
  border: 1px solid var(--border);
  border-radius: 4px;
  font-size: 1rem;
  transition: border-color 0.3s ease;
}

.field input:focus,
.field select:focus {
  border-color: var(--primary);
  outline: none;
  box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
}

/*----------------------------------------------
  ボタン
----------------------------------------------*/
.btn-wrap {
  text-align: center;
  margin-top: 1rem;
}

.btn {
  padding: 0.75rem 1.5rem;
  margin: 0 0.5rem;
  font-size: 1rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s ease;
  text-decoration: none;
  display: inline-block;
}

.btn-primary {
  background: var(--primary);
  color: white;
}

.btn-primary:hover {
  background: var(--primary-dark);
  transform: translateY(-2px);
}

.btn-secondary {
  background: var(--surface);
  color: var(--text);
  border: 1px solid var(--border);
}

.btn-secondary:hover {
  background: #e2e6ea;
}

.btn-success {
  background: var(--success);
  color: white;
}

.btn-warning {
  background: var(--warning);
  color: white;
}

.btn-danger {
  background: var(--danger);
  color: white;
}

/*----------------------------------------------
  企業一覧テーブル
----------------------------------------------*/
.company-table {
  width: 100%;
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  margin-bottom: 2rem;
}

.company-table table {
  width: 100%;
  border-collapse: collapse;
}

.company-table th,
.company-table td {
  padding: 1rem;
  text-align: left;
  border-bottom: 1px solid var(--border);
}

.company-table th {
  background: var(--primary);
  color: white;
  font-weight: bold;
}

.company-table tr:hover {
  background: var(--surface);
}

.company-table .actions {
  display: flex;
  gap: 0.5rem;
  flex-wrap: wrap;
}

/*----------------------------------------------
  モーダル
----------------------------------------------*/
.modal {
  display: none;
  position: fixed;
  z-index: 1000;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.5);
}

.modal-content {
  background-color: white;
  margin: 5% auto;
  padding: 2rem;
  border-radius: 8px;
  width: 90%;
  max-width: 600px;
  position: relative;
}

.close {
  position: absolute;
  right: 1rem;
  top: 1rem;
  font-size: 2rem;
  cursor: pointer;
  color: #aaa;
}

.close:hover {
  color: var(--text);
}

/*----------------------------------------------
  レスポンシブ
----------------------------------------------*/
@media (max-width: 768px) {
  .grid-form .grid-container {
    grid-template-columns: 1fr;
  }
  
  .company-table {
    font-size: 0.9rem;
  }
  
  .company-table th,
  .company-table td {
    padding: 0.5rem;
  }
  
  .company-table .actions {
    flex-direction: column;
  }
  
  .btn {
    margin: 0.25rem;
    padding: 0.5rem 1rem;
  }
}

/* 権限チェック用スタイル */
.permission-error {
  text-align: center;
  padding: 3rem;
  color: var(--danger);
  font-size: 1.2rem;
}
</style>

</head>
<body>
<div id="container">
<!--▼▼▼▼▼ここから「ヘッダー」-->
<header>
<!-- ▼▼▼▼ 画面上部アイコン-->
<h1 id="logo"><a href="index.html"><img src="images/logo.png" alt="jms"></a></h1>
<!-- ▲▲▲▲ -->

<!--ヘッダー上部分のリスト-->
<nav>
<ul>
  <%-- ユーザ名・権限表示 --%>
  <% if (username != null) { %>
    <li>こんにちは、<%= username %>さん</li>
    <li><%= username %>さんの権限は<%= role %>です</li>
  <% } else { %>
    <li><a href="login.html">ログイン</a></li>
  <% } %>

  <!--* 画面：学生管理画面
        	
   許可されている権限：
        	
   ・教員：teacher
   ・校長・教務部長：headmaster
   ・システム管理者：admin
        	
    ▼▼▼▼
    *-->
  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=studentManagement">
        📚 学生管理画面
      </a>
    </li>
  <% } %>

  <!--* 画面：企業管理画面
        	
  許可されている権限：
        	
  ・就職指導部：egd
  ・システム管理者：admin
        	
   ▼▼▼▼
   *-->
  <% if ("egd".equals(role) 
         || "admin".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=CompanyManagement">
        🏢 企業管理画面
      </a>
    </li>
  <% } %>

   <!--* 画面：就職管理画面
        	
     許可されている権限：
        	
     ・教員：teacher
     ・校長・教務部長：headmaster
     ・就職指導部：egd
     ・システム管理者：admin
    ・学生： student
        	
        	
   ▼▼▼▼
   *-->
  <% if ("teacher".equals(role) 
         || "headmaster".equals(role) 
         || "egd".equals(role) 
         || "admin".equals(role) 
         || "student".equals(role)) { %>
    <li>
      <a href="StatusServlet?view=jobHunting">
        📄 就職管理画面
      </a>
    </li>
  <% } %>

  <!--* ログアウトボタン
        	
   許可されている権限：
        	
   ・すべての権限
        	
   ▼▼▼▼
   *-->
  <% if (username != null) { %>
    <li>
      <a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a>
    </li>
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
  <h1>🏢 企業管理画面</h1>

  <!-- 検索セクション -->
  <section class="search-section">
    <h2>🔍 企業検索</h2>
    <form class="grid-form" method="GET" action="CompanyServlet">
      <input type="hidden" name="action" value="search">
      <div class="grid-container">
        <div class="field">
          <label for="companyName">企業名</label>
          <input type="text" id="companyName" name="companyName" placeholder="企業名を入力">
        </div>
        <div class="field">
          <label for="industry">業界</label>
          <select id="industry" name="industry">
            <option value="">すべての業界</option>
            <option value="IT">IT・ソフトウェア</option>
            <option value="manufacturing">製造業</option>
            <option value="finance">金融・保険</option>
            <option value="retail">小売・流通</option>
            <option value="service">サービス業</option>
            <option value="construction">建設業</option>
            <option value="medical">医療・福祉</option>
            <option value="education">教育</option>
            <option value="other">その他</option>
          </select>
        </div>
        <div class="field">
          <label for="location">所在地</label>
          <input type="text" id="location" name="location" placeholder="都道府県を入力">
        </div>
        <div class="field">
          <label for="status">採用状況</label>
          <select id="status" name="status">
            <option value="">すべて</option>
            <option value="active">採用中</option>
            <option value="inactive">採用終了</option>
            <option value="planning">採用予定</option>
          </select>
        </div>
      </div>
      <div class="btn-wrap">
        <button type="submit" class="btn btn-primary">検索</button>
        <button type="reset" class="btn btn-secondary">リセット</button>
      </div>
    </form>
  </section>

  <!-- 企業登録ボタン -->
  <div class="btn-wrap" style="margin-bottom: 2rem;">
    <button onclick="openAddModal()" class="btn btn-success">➕ 新規企業登録</button>
  </div>

  <!-- 企業一覧テーブル -->
  <section class="company-table">
    <table>
      <thead>
        <tr>
          <th>企業名</th>
          <th>業界</th>
          <th>所在地</th>
          <th>連絡先</th>
          <th>採用状況</th>
          <th>登録日</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <!-- サンプルデータ（実際の実装ではデータベースから取得） -->
        <tr>
          <td>株式会社サンプルIT</td>
          <td>IT・ソフトウェア</td>
          <td>東京都</td>
          <td>03-1234-5678</td>
          <td><span style="color: var(--success);">採用中</span></td>
          <td>2024-01-15</td>
          <td class="actions">
            <button onclick="openEditModal(1)" class="btn btn-warning">編集</button>
            <button onclick="deleteCompany(1)" class="btn btn-danger">削除</button>
          </td>
        </tr>
        <tr>
          <td>サンプル製造株式会社</td>
          <td>製造業</td>
          <td>大阪府</td>
          <td>06-9876-5432</td>
          <td><span style="color: var(--warning);">採用予定</span></td>
          <td>2024-01-10</td>
          <td class="actions">
            <button onclick="openEditModal(2)" class="btn btn-warning">編集</button>
            <button onclick="deleteCompany(2)" class="btn btn-danger">削除</button>
          </td>
        </tr>
        <tr>
          <td>サンプル金融銀行</td>
          <td>金融・保険</td>
          <td>愛知県</td>
          <td>052-5555-1234</td>
          <td><span style="color: var(--danger);">採用終了</span></td>
          <td>2024-01-05</td>
          <td class="actions">
            <button onclick="openEditModal(3)" class="btn btn-warning">編集</button>
            <button onclick="deleteCompany(3)" class="btn btn-danger">削除</button>
          </td>
        </tr>
      </tbody>
    </table>
  </section>
</main>

<!-- 企業登録・編集モーダル -->
<div id="companyModal" class="modal">
  <div class="modal-content">
    <span class="close" onclick="closeModal()">&times;</span>
    <h2 id="modalTitle">企業登録</h2>
    <form id="companyForm" method="POST" action="CompanyServlet">
      <input type="hidden" id="companyId" name="companyId">
      <input type="hidden" id="formAction" name="action" value="add">
      
      <div class="grid-container">
        <div class="field">
          <label for="modalCompanyName">企業名 *</label>
          <input type="text" id="modalCompanyName" name="companyName" required>
        </div>
        <div class="field">
          <label for="modalIndustry">業界 *</label>
          <select id="modalIndustry" name="industry" required>
            <option value="">業界を選択</option>
            <option value="IT">IT・ソフトウェア</option>
            <option value="manufacturing">製造業</option>
            <option value="finance">金融・保険</option>
            <option value="retail">小売・流通</option>
            <option value="service">サービス業</option>
            <option value="construction">建設業</option>
            <option value="medical">医療・福祉</option>
            <option value="education">教育</option>
            <option value="other">その他</option>
          </select>
        </div>
        <div class="field">
          <label for="modalLocation">所在地 *</label>
          <input type="text" id="modalLocation" name="location" required>
        </div>
        <div class="field">
          <label for="modalPhone">電話番号</label>
          <input type="tel" id="modalPhone" name="phone" placeholder="03-1234-5678">
        </div>
        <div class="field">
          <label for="modalEmail">メールアドレス</label>
          <input type="email" id="modalEmail" name="email" placeholder="example@company.com">
        </div>
        <div class="field">
          <label for="modalStatus">採用状況 *</label>
          <select id="modalStatus" name="status" required>
            <option value="active">採用中</option>
            <option value="inactive">採用終了</option>
            <option value="planning">採用予定</option>
          </select>
        </div>
        <div class="field">
          <label for="modalWebsite">Webサイト</label>
          <input type="url" id="modalWebsite" name="website" placeholder="https://example.com">
        </div>
        <div class="field">
          <label for="modalDescription">企業説明</label>
          <textarea id="modalDescription" name="description" rows="4" placeholder="企業の特徴や事業内容を入力してください"></textarea>
        </div>
      </div>
      
      <div class="btn-wrap">
        <button type="submit" class="btn btn-primary">保存</button>
        <button type="button" onclick="closeModal()" class="btn btn-secondary">キャンセル</button>
      </div>
    </form>
  </div>
</div>

<!-- JavaScript -->
<script>
// モーダル制御
function openAddModal() {
  document.getElementById('modalTitle').textContent = '企業登録';
  document.getElementById('formAction').value = 'add';
  document.getElementById('companyForm').reset();
  document.getElementById('companyModal').style.display = 'block';
}

function openEditModal(companyId) {
  document.getElementById('modalTitle').textContent = '企業編集';
  document.getElementById('formAction').value = 'edit';
  document.getElementById('companyId').value = companyId;
  
  // サンプルデータ（実際の実装ではAjaxでデータを取得）
  const sampleData = {
    1: {
      companyName: '株式会社サンプルIT',
      industry: 'IT',
      location: '東京都',
      phone: '03-1234-5678',
      email: 'info@sampleit.co.jp',
      status: 'active',
      website: 'https://sampleit.co.jp',
      description: 'ITソリューションを提供する企業です。'
    },
    2: {
      companyName: 'サンプル製造株式会社',
      industry: 'manufacturing',
      location: '大阪府',
      phone: '06-9876-5432',
      email: 'contact@sample-manufacturing.co.jp',
      status: 'planning',
      website: 'https://sample-manufacturing.co.jp',
      description: '製造業を営む企業です。'
    },
    3: {
      companyName: 'サンプル金融銀行',
      industry: 'finance',
      location: '愛知県',
      phone: '052-5555-1234',
      email: 'hr@sample-bank.co.jp',
      status: 'inactive',
      website: 'https://sample-bank.co.jp',
      description: '金融サービスを提供する銀行です。'
    }
  };
  
  const data = sampleData[companyId];
  if (data) {
    document.getElementById('modalCompanyName').value = data.companyName;
    document.getElementById('modalIndustry').value = data.industry;
    document.getElementById('modalLocation').value = data.location;
    document.getElementById('modalPhone').value = data.phone;
    document.getElementById('modalEmail').value = data.email;
    document.getElementById('modalStatus').value = data.status;
    document.getElementById('modalWebsite').value = data.website;
    document.getElementById('modalDescription').value = data.description;
  }
  
  document.getElementById('companyModal').style.display = 'block';
}

function closeModal() {
  document.getElementById('companyModal').style.display = 'none';
}

function deleteCompany(companyId) {
  if (confirm('この企業を削除してもよろしいですか？')) {
    // 実際の実装ではAjaxで削除処理を実行
    alert('企業ID: ' + companyId + ' を削除しました。');
    location.reload();
  }
}

// モーダル外クリックで閉じる
window.onclick = function(event) {
  const modal = document.getElementById('companyModal');
  if (event.target == modal) {
    closeModal();
  }
}

// フォーム送信時の処理
document.getElementById('companyForm').addEventListener('submit', function(e) {
  e.preventDefault();
  
  // 実際の実装ではAjaxでフォームデータを送信
  const formData = new FormData(this);
  const action = formData.get('action');
  
  if (action === 'add') {
    alert('企業を登録しました。');
  } else if (action === 'edit') {
    alert('企業情報を更新しました。');
  }
  
  closeModal();
  location.reload();
});
</script>

<% } %>

</div>
</body>
</html>
