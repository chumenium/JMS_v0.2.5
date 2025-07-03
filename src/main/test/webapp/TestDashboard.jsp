<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>UI確認用テストダッシュボード</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 40px;
        }
        
        .warning {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .screen-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .screen-card {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .screen-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .screen-card h3 {
            color: #495057;
            margin-top: 0;
            margin-bottom: 15px;
        }
        
        .screen-card p {
            color: #6c757d;
            font-size: 14px;
            margin-bottom: 15px;
        }
        
        .screen-card a {
            display: inline-block;
            background-color: #007bff;
            color: white;
            padding: 8px 20px;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.2s;
        }
        
        .screen-card a:hover {
            background-color: #0056b3;
        }
        
        .role-section {
            margin-bottom: 40px;
        }
        
        .role-section h2 {
            color: #495057;
            border-bottom: 2px solid #dee2e6;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>UI確認用テストダッシュボード</h1>
        
        <div class="warning">
            ⚠️ このページは開発・UI確認用です。ログイン認証をバイパスしています。
        </div>
        
        <div class="role-section">
            <h2>🎓 学生向け画面</h2>
            <div class="screen-grid">
                <div class="screen-card">
                    <h3>ダッシュボード（学生用）</h3>
                    <p>学生用のメインダッシュボード画面です。就活の進捗状況などを確認できます。</p>
                    <a href="/jms/TestUIServlet?page=dashboard&role=student">画面を確認</a>
                </div>
                <div class="screen-card">
                    <h3>学生情報管理</h3>
                    <p>学生の個人情報や就活状況を管理する画面です。</p>
                    <a href="/jms/TestUIServlet?page=studentManagement&role=student">画面を確認</a>
                </div>
            </div>
        </div>
        
        <div class="role-section">
            <h2>👩‍🏫 教員向け画面</h2>
            <div class="screen-grid">
                <div class="screen-card">
                    <h3>ダッシュボード（教員用）</h3>
                    <p>教員用のメインダッシュボード画面です。全体の就活状況を把握できます。</p>
                    <a href="/jms/TestUIServlet?page=dashboard&role=teacher">画面を確認</a>
                </div>
                <div class="screen-card">
                    <h3>学生一覧</h3>
                    <p>登録されている学生の一覧を表示・管理する画面です。</p>
                    <a href="/jms/TestUIServlet?page=studentList&role=teacher">画面を確認</a>
                </div>
                <div class="screen-card">
                    <h3>学生作成</h3>
                    <p>新規学生を登録する画面です。</p>
                    <a href="/jms/TestUIServlet?page=createStudent&role=teacher">画面を確認</a>
                </div>
                <div class="screen-card">
                    <h3>企業管理</h3>
                    <p>就職先企業の情報を管理する画面です。</p>
                    <a href="/jms/TestUIServlet?page=companyManagement&role=teacher">画面を確認</a>
                </div>
                <div class="screen-card">
                    <h3>面接・試験入力</h3>
                    <p>学生の面接や試験の結果を入力する画面です。</p>
                    <a href="/jms/TestUIServlet?page=interviewExam&role=teacher">画面を確認</a>
                </div>
                <div class="screen-card">
                    <h3>選考ステージ管理</h3>
                    <p>就活の選考ステージを管理する画面です。</p>
                    <a href="/jms/TestUIServlet?page=selectionStage&role=teacher">画面を確認</a>
                </div>
                <div class="screen-card">
                    <h3>テンポラリJMS画面</h3>
                    <p>一時的な管理画面やテスト用画面です。</p>
                    <a href="/jms/TestUIServlet?page=tempJms&role=teacher">画面を確認</a>
                </div>
            </div>
        </div>
        
        <div class="role-section">
            <h2>🔧 その他の画面</h2>
            <div class="screen-grid">
                <div class="screen-card">
                    <h3>ログイン画面</h3>
                    <p>通常のログイン画面です。</p>
                    <a href="/jms/login.html">画面を確認</a>
                </div>
                <div class="screen-card">
                    <h3>ユーザー登録画面</h3>
                    <p>新規ユーザーを登録する画面です。</p>
                    <a href="/jms/register.html">画面を確認</a>
                </div>
                <div class="screen-card">
                    <h3>トップページ</h3>
                    <p>アプリケーションのトップページです。</p>
                    <a href="/jms/index.html">画面を確認</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 