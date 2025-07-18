

<!--*
：：：色のテーマは緑：：：
【企業詳細】画面


**********

<!--* 画面：【企業詳細】
        	
許可されている権限：
・教員：teacher
・校長・教務部長：headmaster
・システム管理者：admin
 
▼▼▼▼
*-->


<!--確認まだ-->

<!--KCS_JMS_PROJECT-->


<!-- 【企業詳細】画面用 -->



<!--▼▼▼▼▼スコープから取得する情報　これをもとに判定をしていく -->
<% 
  int companys_id = (Integer) session.getAttribute("companys_id");
  String companys_name = (String) session.getAttribute("companys_name");
  String post_code = (String) session.getAttribute("post_code");
  String address = (String) session.getAttribute("address");
  String tel = (String) session.getAttribute("tel");
  String mail_address = (String) session.getAttribute("mail_address");
  String manager_name = (String) session.getAttribute("manager_name");
  boolean recruit_results = (Boolean) session.getAttribute("recruit_results");
  int work_place_id = (Integer) session.getAttribute("work_place_id");
  int occupation_id = (Integer) session.getAttribute("occupation_id");
%>
<!--▲▲▲▲▲-->
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="beans.CompanyBean" %>
<%
    CompanyBean company = (CompanyBean)request.getAttribute("company");
    String role = (String) session.getAttribute("role"); 
%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>企業詳細・編集</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            background: #f8f9fa;
            color: #2c3e50;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
        }
        .edit-container {
            max-width: 1400px;
            width: 96vw;
            margin: 40px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(44, 119, 68, 0.08);
            padding: 40px 2vw;
            box-sizing: border-box;
        }
        @media (max-width: 1400px) {
            .edit-container {
                padding: 32px 1vw;
            }
        }
        @media (max-width: 768px) {
            .edit-container {
                margin: 20px 0;
                padding: 16px 2vw;
            }
        }
        @media (max-width: 480px) {
            .edit-container {
                margin: 8px 0;
                padding: 8px 1vw;
            }
        }
        .edit-title {
            font-size: 28px;
            color: #2C7744;
            font-weight: 700;
            margin-bottom: 24px;
            text-align: center;
        }
        .company-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 32px;
        }
        
        @media (max-width: 768px) {
            .company-info {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .edit-container {
                margin: 20px;
                padding: 20px;
            }
            
            .edit-title {
                font-size: 24px;
            }
            
            .info-section {
                padding: 16px;
            }
            
            .info-section h3 {
                font-size: 16px;
            }
            
            .form-group input[type="text"],
            .form-group input[type="email"],
            .form-group input[type="tel"],
            .form-group select,
            .form-group textarea {
                font-size: 16px;
                padding: 14px 16px;
                min-height: 52px;
            }
            
            .form-group label {
                font-size: 16px;
                margin-bottom: 6px;
            }
            
            .btn {
                padding: 14px 20px;
                font-size: 16px;
                min-width: 100px;
                min-height: 52px;
                margin-bottom: 8px;
            }
        }
        
        @media (max-width: 480px) {
            .edit-container {
                margin: 12px;
                padding: 16px;
            }
            
            .edit-title {
                font-size: 20px;
            }
            
            .info-section {
                padding: 12px;
            }
            
            .info-section h3 {
                font-size: 18px;
            }
            
            .form-group input[type="text"],
            .form-group input[type="email"],
            .form-group input[type="tel"],
            .form-group select,
            .form-group textarea {
                font-size: 18px;
                padding: 16px 20px;
                min-height: 56px;
            }
            
            .form-group label {
                font-size: 18px;
            }
            
            .btn {
                padding: 16px 24px;
                font-size: 18px;
                min-height: 56px;
            }
        }
        .info-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #2C7744;
        }
        .info-section h3 {
            color: #2C7744;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 16px;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 8px;
        }
        .form-group {
            margin-bottom: 16px;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #495057;
            font-size: 14px;
        }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="tel"],
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid #e9ecef;
            border-radius: 8px;
            font-size: 16px;
            background: #fff;
            transition: all 0.2s ease;
            box-sizing: border-box;
            min-height: 48px;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #2C7744;
            outline: none;
            box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.1);
        }
        .form-group input[readonly] {
            background: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
            border-color: #dee2e6;
        }
        .action-buttons {
            text-align: center;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid #e9ecef;
        }
        
        @media (max-width: 768px) {
            .action-buttons {
                margin-top: 24px;
                padding-top: 16px;
            }
        }
        .btn {
            background: linear-gradient(135deg, #2C7744 0%, #5CA564 100%);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 32px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 2px 8px rgba(44, 119, 68, 0.15);
            margin-right: 12px;
            text-decoration: none;
            display: inline-block;
            min-width: 120px;
            min-height: 48px;
        }
        
        @media (max-width: 768px) {
            .btn {
                padding: 14px 20px;
                font-size: 16px;
                min-width: 100px;
                min-height: 52px;
                margin-bottom: 8px;
            }
        }
        .btn:hover {
            background: #388E3C;
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(44, 119, 68, 0.3);
        }
        .btn-secondary {
            background: #6c757d;
            color: #fff;
        }
        .btn-secondary:hover {
            background: #495057;
        }
        .back-link {
            display: inline-block;
            margin-top: 24px;
            color: #2C7744;
            text-decoration: underline;
            font-weight: 600;
        }
        .back-link:hover {
            color: #388E3C;
        }
        .add-btn {
            background: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 8px 16px;
            font-size: 14px;
            cursor: pointer;
            margin-top: 8px;
        }
        .add-btn:hover {
            background: #218838;
        }
    </style>
    <style>
    @media (prefers-color-scheme: dark) {
        body {
            background: #181a1b;
            color: #f1f1f1;
        }
        .edit-container {
            background: #23272a;
            box-shadow: 0 0 20px rgba(44, 119, 68, 0.18);
        }
        .edit-title {
            color: #7fffd4;
        }
        .info-section {
            background: #2c2f33;
            border-left-color: #7fffd4;
        }
        .info-section h3 {
            color: #7fffd4;
            border-bottom-color: #40444b;
        }
        .form-group label {
            color: #dcddde;
        }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="tel"],
        .form-group select,
        .form-group textarea {
            background: #23272a;
            color: #f1f1f1;
            border-color: #40444b;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #7fffd4;
        }
        .form-group input[readonly] {
            background: #2c2f33 !important;
            color: #72767d !important;
            border-color: #40444b;
        }
        .action-buttons {
            border-top-color: #40444b;
        }
        .back-link {
            color: #7fffd4;
        }
        .back-link:hover {
            color: #fff;
        }
    }
    @media (max-width: 768px) {
        .company-info {
            grid-template-columns: 1fr;
            gap: 16px;
        }
        .edit-container {
            margin: 20px;
            padding: 20px;
        }
    }
    </style>
</head>
<body>
    <div class="edit-container">
        <h2 class="edit-title">企業詳細・編集</h2>
        <form class="edit-form" action="CompanyDetailServlet" method="post">
          <<input type="hidden" name="action" value="update">
            <div class="company-info">
                <!-- 基本情報 -->
                <div class="info-section">
                    <h3>基本情報</h3>
                    <div class="form-group">
                        <label for="companyId">企業ID</label>
                        <input type="text" id="companyId" name="companyId" value="<%= company != null ? company.getCompanyId() : "" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="companyName">企業名</label>
                        <input type="text" id="companyName" name="companyName" value="<%= company != null ? company.getCompanyName() : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label for="managerName">担当者名</label>
                        <input type="text" id="managerName" name="managerName" value="<%= company != null ? company.getManagerName() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="recruitmentResults">採用実績</label>
                        <select id="recruitmentResults" name="recruitmentResults">
                            <option value="true" <%= company != null && company.getRecruitmentResults() ? "selected" : "" %>>あり</option>
                            <option value="false" <%= company != null && !company.getRecruitmentResults() ? "selected" : "" %>>なし</option>
                        </select>
                    </div>
                </div>

                <!-- 連絡先情報 -->
                <div class="info-section">
                    <h3>連絡先情報</h3>
                    <div class="form-group">
                        <label for="mailAddress">メールアドレス</label>
                        <input type="email" id="mailAddress" name="mailAddress" value="<%= company != null ? company.getMailAddress() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="tel">電話番号</label>
                        <input type="tel" id="tel" name="tel" value="<%= company != null ? company.getTel() : "" %>">
                    </div>
                </div>

                <!-- 住所情報 -->
                <div class="info-section">
                    <h3>住所情報</h3>
                    <div class="form-group">
                        <label for="postCode">郵便番号</label>
                        <input type="text" id="postCode" name="postCode" value="<%= company != null ? company.getPostCode() : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="address">住所</label>
                        <textarea id="address" name="address" rows="3"><%= company != null ? company.getAddress() : "" %></textarea>
                    </div>
                </div>

                <!-- 職種・勤務地 -->
                <div class="info-section">
                    <h3>職種・勤務地</h3>
                    <div class="form-group">
                        <label for="occupations">職種</label>
                        <% int occIndex = 0; %>
                        <% if(company != null && company.getOccupations() != null) { %>
                            <% for(String occupation : company.getOccupations()) { %>
                                <select id="occupation<%= occIndex %>" name="occupation<%= occIndex %>">
                                    <option value="<%= occupation %>"><%= occupation %></option>
                                    <option value="">未設定</option>
                                    <% java.util.List<String> occupationList = (java.util.List<String>) request.getAttribute("occupationList");
                                    if (occupationList != null) {
                                        for (String occ : occupationList) { %>
                                            <option value="<%= occ %>"><%= occ %></option>
                                    <%   } } %>
                                </select>
                            <% occIndex++; %>
                        <% } } %>
                        <div id="occupation-container">
                            <select id="occupation<%= occIndex %>" name="occupation<%= occIndex %>">
                                <% occIndex++; %>
                                <option value="">未設定</option>
                                <% java.util.List<String> occupationList = (java.util.List<String>) request.getAttribute("occupationList");
                                if (occupationList != null) {
                                    for (String occ : occupationList) { %>
                                        <option value="<%= occ %>"><%= occ %></option>
                                <%   } } %>
                            </select>
                        </div>
                        <button type="button" id="add-occupation-btn" class="add-btn">職種を増やす＋</button>
                    </div>
                    
                    <div class="form-group">
                        <label for="workPlaces">勤務地</label>
                        <% int wpIndex = 0; %>
                        <% if(company != null && company.getWorkPlaces() != null) { %>
                            <% for(String workPlace : company.getWorkPlaces()) { %>
                                <select id="workPlace<%= wpIndex %>" name="workPlace<%= wpIndex %>">
                                    <option value="<%= workPlace %>"><%= workPlace %></option>
                                    <option value="">未設定</option>
                                    <% java.util.List<String> workPlaceList = (java.util.List<String>) request.getAttribute("workPlaceList");
                                    if (workPlaceList != null) {
                                        for (String wp : workPlaceList) { %>
                                            <option value="<%= wp %>"><%= wp %></option>
                                    <%   } } %>
                                </select>
                            <% wpIndex++; %>
                        <% } } %>
                        <div id="workplace-container">
                            <select id="workPlace<%= wpIndex %>" name="workPlace<%= wpIndex %>">
                                <% wpIndex++; %>
                                <option value="">未設定</option>
                                <% java.util.List<String> workPlaceList = (java.util.List<String>) request.getAttribute("workPlaceList");
                                if (workPlaceList != null) {
                                    for (String wp : workPlaceList) { %>
                                        <option value="<%= wp %>"><%= wp %></option>
                                <%   } } %>
                            </select>
                        </div>
                        <button type="button" id="add-workplace-btn" class="add-btn">勤務地を増やす＋</button>
                    </div>
                </div>
            </div>



            <div class="action-buttons">
                <input type="hidden" id="maxOccupationIndex" name="maxOccupationIndex" value="<%= occIndex-1 %>">
                <input type="hidden" id="maxWorkPlaceIndex" name="maxWorkPlaceIndex" value="<%= wpIndex-1 %>">
                <div id="updating-indicator" style="display:none; margin-top:10px; color:#007bff; font-weight:bold;">
                    <span class="spinner"></span> 更新中...
                </div>
                <button type="submit" class="btn" id="updateBtn">更新</button>
                <a href="CompanyListServlet" class="btn btn-secondary">一覧に戻る</a>
            </div>
        </form>
    </div>
    <style>
      .spinner {
        display: inline-block;
        width: 18px;
        height: 18px;
        border: 3px solid #cce3ff;
        border-top: 3px solid #007bff;
        border-radius: 50%;
        animation: spin 1s linear infinite;
        margin-right: 8px;
        vertical-align: middle;
      }
      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
    </style>
    <script>
        // 職種を増やすボタンの処理
        document.getElementById('add-occupation-btn').addEventListener('click', function() {
            var container = document.getElementById('occupation-container');
            var maxIndexInput = document.getElementById('maxOccupationIndex');
            var currentIndex = parseInt(maxIndexInput.value, 10);

            var selects = container.getElementsByTagName('select');
            var maxIndex = -1;
            for (var i = 0; i < selects.length; i++) {
                var id = selects[i].id;
                var match = id.match(/^occupation(\d+)$/);
                if (match) {
                    var num = parseInt(match[1], 10);
                    if (num > maxIndex) maxIndex = num;
                }
            }
            // 新しいselectを追加
            var newIndex = maxIndex + 1;
            var newSelect = selects[selects.length - 1].cloneNode(true);
            newSelect.id = "occupation" + newIndex;
            newSelect.name = "occupation" + newIndex;
            newSelect.selectedIndex = 0;
            container.appendChild(newSelect);
            // hiddenの値を「新しい最大連番」に更新
            maxIndexInput.value = newIndex;
        });

        // 勤務地を増やすボタンの処理
        document.getElementById('add-workplace-btn').addEventListener('click', function() {
            var container = document.getElementById('workplace-container');
            var maxIndexInput = document.getElementById('maxWorkPlaceIndex');
            var currentIndex = parseInt(maxIndexInput.value, 10);

            var selects = container.getElementsByTagName('select');
            var maxIndex = -1;
            for (var i = 0; i < selects.length; i++) {
                var id = selects[i].id;
                var match = id.match(/^workPlace(\d+)$/);
                if (match) {
                    var num = parseInt(match[1], 10);
                    if (num > maxIndex) maxIndex = num;
                }
            }
            // 新しいselectを追加
            var newIndex = maxIndex + 1;
            var newSelect = selects[selects.length - 1].cloneNode(true);
            newSelect.id = "workPlace" + newIndex;
            newSelect.name = "workPlace" + newIndex;
            newSelect.selectedIndex = 0;
            container.appendChild(newSelect);
            // hiddenの値を「新しい最大連番」に更新
            maxIndexInput.value = newIndex;
        });

        // 更新ボタン押下時にアニメーション表示
        document.getElementById('updateBtn').addEventListener('click', function() {
          document.getElementById('updating-indicator').style.display = 'block';
        });
    </script>
</body>
</html>
