<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - 企業登録</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">

<style>
    /* 企業登録画面のスタイル */
    .create-company-page {
        background: #f8f9fa;
        color: #2c3e50;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        line-height: 1.6;
    }

    .create-company-container {
        max-width: 800px;
        margin: 0 auto;
        padding: 24px;
        min-height: 100vh;
        background: #ffffff;
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
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

    /* 登録フォーム - 視認性と操作性の向上 */
    .registration-form {
        background: white;
        border-radius: 12px;
        padding: 32px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        border: 1px solid #e9ecef;
        margin-bottom: 24px;
    }

    .form-group {
        margin-bottom: 24px;
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
    }

    .form-group input:focus,
    .form-group select:focus {
        outline: none;
        border-color: #2C7744;
        box-shadow: 0 0 0 3px rgba(44, 119, 68, 0.1);
    }

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
    }

    .required {
        color: #e74c3c;
        font-weight: 600;
    }

    /* ボタン */
    .form-buttons {
        display: flex;
        gap: 16px;
        justify-content: center;
        margin-top: 32px;
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

    /* レスポンシブ対応 */
    @media (max-width: 768px) {
        .create-company-container {
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
        
        .form-container {
            padding: 24px;
        }
        
        .form-title {
            font-size: 20px;
        }
        
        .action-buttons {
            flex-direction: column;
            align-items: center;
        }
    }

    @media (max-width: 480px) {
        .create-company-container {
            padding: 12px;
        }
        
        .page-header {
            padding: 20px;
        }
        
        .page-title {
            font-size: 20px;
        }
        
        .form-container {
            padding: 20px;
        }
        
        .form-input,
        .form-textarea,
        .form-select {
            font-size: 14px;
            padding: 10px 12px;
        }
    }

    /* アクセシビリティ */
    .form-input:focus,
    .form-textarea:focus,
    .form-select:focus,
    .action-btn:focus {
        outline: 3px solid #2C7744;
        outline-offset: 2px;
    }
</style>
</head>
<body class="create-student-page">
    <div class="create-student-container">
        <!-- ページヘッダー -->
        <div class="page-header">
            <h1 class="page-title">企業登録</h1>
            <div class="breadcrumb">
                <a href="StatusServlet?status=DashBoard">ダッシュボード</a>
                <span class="separator">&gt;</span>
                <a href="CompanyManagementServlet">企業管理</a>
                <span class="separator">&gt;</span>
                <span>企業登録</span>
            </div>
        </div>

        <!-- エラーメッセージ表示 -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error-message" style="background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; border-radius: 8px; padding: 16px; margin-bottom: 24px; text-align: center; font-weight: 600;">
                ❌ <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <!-- 企業登録フォーム -->
        <div class="registration-form">
            <form action="CompanyManagementServlet" method="post">
                <input type="hidden" name="action" value="add">
                
                <!-- 基本情報 -->
                <h3 style="margin-bottom: 20px; color: #2c3e50; border-bottom: 2px solid #2C7744; padding-bottom: 8px;">企業基本情報</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label for="company_name">企業名 <span class="required">*</span></label>
                        <input type="text" id="company_name" name="company_name" required placeholder="例：株式会社サンプル">
                    </div>
                    <div class="form-group">
                        <label for="post_code">郵便番号</label>
                        <input type="text" id="post_code" name="post_code" placeholder="例：123-4567" maxlength="8">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="address">住所</label>
                        <input type="text" id="address" name="address" placeholder="例：東京都渋谷区○○○" maxlength="200">
                    </div>
                    <div class="form-group">
                        <label for="tel">電話番号</label>
                        <input type="text" id="tel" name="tel" placeholder="例：03-1234-5678" maxlength="15">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="mail_address">メールアドレス</label>
                        <input type="email" id="mail_address" name="mail_address" placeholder="例：info@sample.co.jp" maxlength="100">
                    </div>
                    <div class="form-group">
                        <label for="manager_name">担当者名</label>
                        <input type="text" id="manager_name" name="manager_name" placeholder="例：山田太郎" maxlength="50">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="recruitment_results">採用実績</label>
                        <select id="recruitment_results" name="recruitment_results">
                            <option value="false">なし</option>
                            <option value="true">あり</option>
                        </select>
                    </div>
                </div>

                <!-- 職種・勤務地 複数登録エリア -->
                <div class="form-row">
                    <div class="form-group" style="width:100%;">
                        <label>職種</label>
                        <div id="occupation-container">
                            <select name="occupation0" class="occupation-select">
                                <option value="">選択してください</option>
                                <% java.util.List<String> occupationList = (java.util.List<String>) application.getAttribute("jobtypes");
                                   if (occupationList != null) {
                                       for (String occ : occupationList) { %>
                                           <option value="<%= occ %>"><%= occ %></option>
                                <%     } } %>
                            </select>
                        </div>
                        <button type="button" id="add-occupation-btn" class="btn btn-secondary" style="margin-top:8px;">職種を増やす＋</button>
                        <input type="hidden" id="maxOccupationIndex" name="maxOccupationIndex" value="0">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group" style="width:100%;">
                        <label>勤務地</label>
                        <div id="workplace-container">
                            <select name="workPlace0" class="workplace-select">
                                <option value="">選択してください</option>
                                <% java.util.List<String> workPlaceList = (java.util.List<String>) application.getAttribute("workplaces");
                                   if (workPlaceList != null) {
                                       for (String wp : workPlaceList) { %>
                                           <option value="<%= wp %>"><%= wp %></option>
                                <%     } } %>
                            </select>
                        </div>
                        <button type="button" id="add-workplace-btn" class="btn btn-secondary" style="margin-top:8px;">勤務地を増やす＋</button>
                        <input type="hidden" id="maxWorkPlaceIndex" name="maxWorkPlaceIndex" value="0">
                    </div>
                </div>
                <!-- ボタン -->
                <div class="form-buttons">
                    <button type="submit" class="btn btn-primary">登録する</button>
                    <a href="CompanyManagementServlet" class="btn btn-secondary">キャンセル</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        // フォームバリデーション
        document.querySelector('form').addEventListener('submit', function(e) {
            const companyName = document.getElementById('company_name').value;
            if (!companyName) {
                e.preventDefault();
                alert('企業名を入力してください。');
                return;
            }
        });

        // 職種追加
        document.getElementById('add-occupation-btn').addEventListener('click', function() {
            var container = document.getElementById('occupation-container');
            var maxIndexInput = document.getElementById('maxOccupationIndex');
            var currentIndex = parseInt(maxIndexInput.value, 10);
            var newIndex = currentIndex + 1;
            var selects = container.getElementsByTagName('select');
            var newSelect = selects[selects.length - 1].cloneNode(true);
            newSelect.name = 'occupation' + newIndex;
            newSelect.selectedIndex = 0;
            container.appendChild(newSelect);
            maxIndexInput.value = newIndex;
        });
        // 勤務地追加
        document.getElementById('add-workplace-btn').addEventListener('click', function() {
            var container = document.getElementById('workplace-container');
            var maxIndexInput = document.getElementById('maxWorkPlaceIndex');
            var currentIndex = parseInt(maxIndexInput.value, 10);
            var newIndex = currentIndex + 1;
            var selects = container.getElementsByTagName('select');
            var newSelect = selects[selects.length - 1].cloneNode(true);
            newSelect.name = 'workPlace' + newIndex;
            newSelect.selectedIndex = 0;
            container.appendChild(newSelect);
            maxIndexInput.value = newIndex;
        });
    </script>

</body>
</html> 