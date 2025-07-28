<!--*
：：：色のテーマは緑：：：
検索結果画面

******教員-生徒-どちらにも表示されるページ****
******権限によって表示されるボタンが変わる****

:::権限一覧:::

{
  "teacher":           "教員",
  "headmaster": "教務部長_校長",
  "egd":      "就職指導部",
  "admin":             "管理者",
  "student":           "学生"
}

||**検索結果用**||

**

*-->

<!--KCS_JMS_PROJECT-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="utils.DBConnection" %>

<%
    String searchType = (String) request.getAttribute("searchType"); // サーブレットから渡された値
    String searchTerm = (String) request.getAttribute("searchTerm"); // サーブレットから渡された値
    
    // フォールバック: パラメータからも取得
    if (searchType == null) searchType = request.getParameter("type");
    if (searchTerm == null) searchTerm = request.getParameter("term");
    
    List<Map<String, String>> results = new ArrayList<>();
    
    if (searchType != null && searchTerm != null && !searchTerm.trim().isEmpty()) {
        try (Connection conn = DBConnection.getConnection()) {
            if ("company".equals(searchType)) {
                // 企業検索
                String sql = "SELECT companys_id, company_name, manager_name FROM companys_tbl WHERE company_name LIKE ? ORDER BY company_name LIMIT 20";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, "%" + searchTerm.trim() + "%");
                    try (ResultSet rs = pstmt.executeQuery()) {
                        while (rs.next()) {
                            Map<String, String> result = new HashMap<>();
                            result.put("id", String.valueOf(rs.getInt("companys_id")));
                            result.put("name", rs.getString("company_name"));
                            String managerName = rs.getString("manager_name");
                            result.put("description", managerName != null && !managerName.isEmpty() ? "担当者: " + managerName : "担当者: 未設定");
                            results.add(result);
                        }
                    }
                }
            } else if ("student".equals(searchType)) {
                // 学生検索
                String sql = "SELECT student_id, name, department, class, number FROM students_tbl WHERE name LIKE ? OR name_reading LIKE ? ORDER BY name LIMIT 20";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, "%" + searchTerm.trim() + "%");
                    pstmt.setString(2, "%" + searchTerm.trim() + "%");
                    try (ResultSet rs = pstmt.executeQuery()) {
                        while (rs.next()) {
                            Map<String, String> result = new HashMap<>();
                            result.put("id", rs.getString("student_id"));
                            result.put("name", rs.getString("name"));
                            
                            String department = rs.getString("department");
                            String className = rs.getString("class");
                            String number = rs.getString("number");
                            
                            StringBuilder description = new StringBuilder();
                            if (department != null && !department.isEmpty()) {
                                description.append(department).append("科");
                            }
                            if (className != null && !className.isEmpty()) {
                                description.append(className).append("組");
                            }
                            if (number != null && !number.isEmpty()) {
                                description.append(number).append("番");
                            }
                            
                            result.put("description", description.length() > 0 ? description.toString() : "学生情報");
                            results.add(result);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>検索結果 - JMSアプリ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* 検索結果画面専用スタイル */
        body {
            background: var(--base-color);
            color: var(--base-inverse-color);
            font-family: "Noto Sans JP", "Hiragino Mincho Pro", "ヒラギノ明朝 Pro W3", "HGS明朝E", "ＭＳ Ｐ明朝", "MS PMincho", serif;
            margin: 0;
            padding: 0;
            line-height: 1.6;
        }
        
        .search-page {
            min-height: 100vh;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }
        
        .search-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .search-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, #5CA564 100%);
            color: var(--primary-inverse-color);
            padding: 2rem;
            border-radius: 12px 12px 0 0;
            text-align: center;
            box-shadow: 0 4px 12px rgba(44, 119, 68, 0.2);
        }
        
        .search-header h2 {
            margin: 0;
            font-size: 1.8rem;
            font-weight: 600;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .search-info {
            margin-top: 0.5rem;
            font-size: 0.9rem;
            opacity: 0.95;
        }
        
        .search-results {
            background: white;
            border-radius: 0 0 12px 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .results-content {
            padding: 2rem;
        }
        
        .results-count {
            margin-bottom: 1.5rem;
            color: #666;
            font-size: 0.9rem;
            font-weight: 500;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 0.5rem;
        }
        
        .result-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.2rem;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            margin-bottom: 0.8rem;
            background: white;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        
        .result-item::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: var(--primary-color);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }
        
        .result-item:hover {
            background: #f8f9fa;
            border-color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(44, 119, 68, 0.15);
        }
        
        .result-item:hover::before {
            transform: scaleY(1);
        }
        
        .result-info {
            flex: 1;
            padding-left: 0.5rem;
        }
        
        .result-name {
            font-weight: 600;
            font-size: 1.1rem;
            color: #333;
            margin-bottom: 0.3rem;
        }
        
        .result-description {
            font-size: 0.85rem;
            color: #666;
            line-height: 1.4;
        }
        
        .select-btn {
            background: var(--primary-color);
            color: var(--primary-inverse-color);
            border: none;
            padding: 0.6rem 1.2rem;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(44, 119, 68, 0.2);
        }
        
        .select-btn:hover {
            background: #1e5a2e;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(44, 119, 68, 0.3);
        }
        
        .no-results {
            text-align: center;
            padding: 3rem 2rem;
            color: #666;
        }
        
        .no-results h3 {
            margin: 0 0 1rem 0;
            font-size: 1.2rem;
            color: #333;
        }
        
        .no-results p {
            margin: 0;
            font-size: 0.9rem;
        }
        
        .back-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 0.8rem 1.5rem;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9rem;
            font-weight: 500;
            margin-top: 1.5rem;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(108, 117, 125, 0.2);
        }
        
        .back-btn:hover {
            background: #5a6268;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(108, 117, 125, 0.3);
        }
        
        .btn-container {
            text-align: center;
            padding: 1rem 2rem 2rem 2rem;
            border-top: 1px solid #f0f0f0;
        }
        
        /* レスポンシブ対応 */
        @media (max-width: 768px) {
            .search-container {
                padding: 1rem;
            }
            
            .search-header {
                padding: 1.5rem;
            }
            
            .search-header h2 {
                font-size: 1.5rem;
            }
            
            .results-content {
                padding: 1.5rem;
            }
            
            .result-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.8rem;
            }
            
            .select-btn {
                align-self: flex-end;
            }
        }
        
        @media (max-width: 480px) {
            .search-container {
                padding: 0.5rem;
            }
            
            .search-header {
                padding: 1rem;
            }
            
            .results-content {
                padding: 1rem;
            }
        }
        
        /* ダークモード対応 */
        @media (prefers-color-scheme: dark) {
            .search-page {
                background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);
            }
            
            .search-results {
                background: #2d2d2d;
                border-color: #4d4d4d;
            }
            
            .result-item {
                background: #3d3d3d;
                border-color: #4d4d4d;
            }
            
            .result-item:hover {
                background: #4d4d4d;
            }
            
            .result-name {
                color: #ffffff;
            }
            
            .result-description {
                color: #cccccc;
            }
            
            .no-results {
                color: #cccccc;
            }
            
            .no-results h3 {
                color: #ffffff;
            }
        }
    </style>
</head>
<body>
    <div class="search-page">
        <div class="search-container">
            <div class="search-header">
                <h2>
                    <% if ("company".equals(searchType)) { %>
                        🏢 企業検索結果
                    <% } else if ("student".equals(searchType)) { %>
                        👨‍🎓 学生検索結果
                    <% } else { %>
                        🔍 検索結果
                    <% } %>
                </h2>
                <div class="search-info">
                    検索条件: "<%= searchTerm != null ? searchTerm : "" %>"
                </div>
            </div>
            
            <div class="search-results">
                <div class="results-content">
                    <div class="results-count">
                        検索結果: <%= results.size() %>件
                    </div>
                    
                    <% if (results.isEmpty()) { %>
                        <div class="no-results">
                            <h3>検索結果が見つかりませんでした</h3>
                            <p>検索条件を変更して再度お試しください。</p>
                        </div>
                    <% } else { %>
                        <% for (Map<String, String> result : results) { %>
                            <div class="result-item" data-id="<%= result.get("id") %>" data-name="<%= result.get("name") %>" data-type="<%= searchType %>" onclick="selectResultFromData(this)">
                                <div class="result-info">
                                    <div class="result-name"><%= result.get("name") %></div>
                                    <div class="result-description"><%= result.get("description") %></div>
                                </div>
                                <button class="select-btn" onclick="event.stopPropagation(); selectResultFromData(this.parentElement)">
                                    選択
                                </button>
                            </div>
                        <% } %>
                    <% } %>
                </div>
                
                <div class="btn-container">
                    <button class="back-btn" onclick="window.close()">
                        <i class="fas fa-times"></i> 閉じる
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function selectResultFromData(element) {
            const id = element.getAttribute('data-id');
            const name = element.getAttribute('data-name');
            const type = element.getAttribute('data-type');
            selectResult(id, name, type);
        }
        
        function selectResult(id, name, type) {
            // 選択された項目をハイライト
            const selectedItem = event.target.closest('.result-item');
            if (selectedItem) {
                selectedItem.style.backgroundColor = '#e8f5e8';
                selectedItem.style.borderColor = '#2C7744';
            }
            
            // 少し遅延してから親ウィンドウに結果を送信
            setTimeout(() => {
                // 親ウィンドウに結果を送信
                if (window.opener && !window.opener.closed) {
                    if (type === 'company') {
                        if (window.opener.selectCompany) {
                            window.opener.selectCompany(id, name);
                        } else if (window.opener.setSearchResult) {
                            window.opener.setSearchResult(id, name, type);
                        }
                    } else if (type === 'student') {
                        if (window.opener.selectStudent) {
                            window.opener.selectStudent(id, name);
                        } else if (window.opener.setSearchResult) {
                            window.opener.setSearchResult(id, name, type);
                        }
                    }
                    window.close();
                } else {
                    // フォールバック: ローカルストレージを使用
                    localStorage.setItem('selectedResult', JSON.stringify({
                        id: id,
                        name: name,
                        type: type,
                        timestamp: new Date().getTime()
                    }));
                    window.close();
                }
            }, 200);
        }
        
        // キーボードナビゲーション
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                window.close();
            }
            
            if (event.key === 'Enter') {
                const focusedElement = document.querySelector('.result-item:focus');
                if (focusedElement) {
                    selectResultFromData(focusedElement);
                }
            }
        });
        
        // ページ読み込み時の処理
        window.onload = function() {
            // フォーカスを最初の結果に設定
            const firstResult = document.querySelector('.result-item');
            if (firstResult) {
                firstResult.focus();
            }
            
            // 結果がない場合のメッセージ
            const results = document.querySelectorAll('.result-item');
            if (results.length === 0) {
                const noResults = document.querySelector('.no-results');
                if (noResults) {
                    noResults.style.animation = 'fadeIn 0.5s ease-in';
                }
            }
        };
        
        // アニメーション効果
        document.addEventListener('DOMContentLoaded', function() {
            const resultItems = document.querySelectorAll('.result-item');
            resultItems.forEach((item, index) => {
                item.style.animation = `fadeIn 0.3s ease-in ${index * 0.1}s both`;
            });
        });
    </script>
</body>
</html> 