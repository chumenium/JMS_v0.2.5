<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>JMSアプリ - 新規学生登録</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="本アプリは就職対策アプリです。">
<link rel="stylesheet" href="css/style.css">
<style>
    /* システム上見やすさを追求した新規学生登録画面デザイン */
    
    /* 全体の設定 */
    .create-student-page {
        background: #f8f9fa;
        color: #2c3e50;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        line-height: 1.6;
    }

    .create-student-container {
        max-width: 800px;
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
</style>
</head>
<body class="create-student-page">
    <div class="create-student-container">
        <!-- ページヘッダー -->
        <div class="page-header">
            <h1 class="page-title">新規学生登録</h1>
            <div class="breadcrumb">
                <a href="StatusServlet?status=DashBoard">ダッシュボード</a>
                <span class="separator">></span>
                <a href="StatusServlet?status=studentManagement">学生管理</a>
                <span class="separator">></span>
                <span>新規学生登録</span>
            </div>
        </div>

        <!-- エラーメッセージ表示 -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error-message" style="background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; border-radius: 8px; padding: 16px; margin-bottom: 24px; text-align: center; font-weight: 600;">
                ❌ <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <!-- 登録フォーム -->
        <div class="registration-form">
            <form action="StudentServlet" method="post">
                <input type="hidden" name="action" value="add">
                
                <!-- 基本情報 -->
                <h3 style="margin-bottom: 20px; color: #2c3e50; border-bottom: 2px solid #2C7744; padding-bottom: 8px;">基本情報</h3>
                <div class="form-row">
                    <div class="form-group">
                        <label for="admissionYear">入学年（西暦）<span class="required">*</span></label>
                        <input type="number" id="admissionYear" name="admissionYear" min="2000" max="2099" required placeholder="例: 2022">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="classType">クラス種別 <span class="required">*</span></label>
                        <select id="classType" name="classType" required>
                            <option value="">選択してください</option>
                            <option value="R">R（大学併修）</option>
                            <option value="S">S（エンジニア・クリエータ科システム分野）</option>
                            <option value="M">M（エンジニア・クリエータ科ゲーム分野）</option>
                            <option value="J">J（プログラム・デザイン科システム分野）</option>
                            <option value="G">G（プログラム・デザイン科ゲーム分野）</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="classGrade">学年 <span class="required">*</span></label>
                        <select id="classGrade" name="classGrade" required>
                            <option value="">選択してください</option>
                            <option value="1">1年</option>
                            <option value="2">2年</option>
                            <option value="3">3年</option>
                            <option value="4">4年</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="classGroup">組 <span class="required">*</span></label>
                        <select id="classGroup" name="classGroup" required>
                            <option value="">選択してください</option>
                            <option value="1">1組</option>
                            <option value="2">2組</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="className">クラス名（自動生成）</label>
                    <input type="text" id="className" name="className" readonly placeholder="自動生成">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="attendanceNo">出席番号 <span class="required">*</span></label>
                        <input type="number" id="attendanceNo" name="attendanceNo" min="1" max="999" required placeholder="例: 1">
                    </div>
                </div>
                <div class="form-group">
                    <label for="studentId">学籍番号 </label>
                    <input type="text" id="studentId" name="studentId" required maxlength="8" readonly placeholder="自動生成">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="name">氏名 <span class="required">*</span></label>
                        <input type="text" id="name" name="name" required placeholder="例: 山田太郎">
                    </div>
                    <div class="form-group">
                        <label for="kana">フリガナ <span class="required">*</span></label>
                        <input type="text" id="kana" name="kana" required placeholder="例: ヤマダタロウ">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="gender">性別 <span class="required">*</span></label>
                        <select id="gender" name="gender" required>
                            <option value="">選択してください</option>
                            <option value="男">男</option>
                            <option value="女">女</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="email">メールアドレス</label>
                        <input type="text" id="email" name="email" maxlength="100" placeholder="例: xxxxx@gmail.com">
                    </div>
                    <div class="form-group">
                        <label for="tel">電話番号(ハイフンなし)</label>
                        <input type="text" id="tel" name="tel" maxlength="11" placeholder="例: 08012345678">
                    </div>
                </div>

                <!-- 学籍情報 -->
                <!-- <h3 style="margin: 32px 0 20px 0; color: #2c3e50; border-bottom: 2px solid #2C7744; padding-bottom: 8px;">学籍情報</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="department">学部 <span class="required">*</span></label>
                        <select id="department" name="department" required>
                            <option value="情報工学">情報工学</option>
                        </select>
                    </div>
                </div> -->

                <!-- <div class="form-group">
                    <label for="major">専攻・学科</label>
                    <select id="major" name="major" required>
                        <option value="大学併修">大学併修</option>
                        <option value="エンジニア・クリエータ科システム分野">エンジニア・クリエータ科システム分野</option>
                        <option value="エンジニア・クリエータ科ゲーム分野">エンジニア・クリエータ科ゲーム分野</option>
                        <option value="プログラム・デザイン科システム分野">プログラム・デザイン科システム分野</option>
                        <option value="プログラム・デザイン科ゲーム分野">プログラム・デザイン科ゲーム分野</option>
                    </select>
                </div> -->

                <!-- 就活情報 -->
                <h3 style="margin: 32px 0 20px 0; color: #2c3e50; border-bottom: 2px solid #2C7744; padding-bottom: 8px;">就活情報</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="jobHuntingStatus">就活状況</label>
                        <select id="jobHuntingStatus" name="jobHuntingStatus">
                            <option value="未開始">選択してください</option>
                            <option value="未開始">未開始</option>
                            <option value="準備中">準備中</option>
                            <option value="活動中">活動中</option>
                            <option value="内定済み">内定済み</option>
                            <option value="就職決定">就職決定</option>
                            <option value="就職辞退">就職辞退</option>
                        </select>
                    </div>
                    <%@ page import="java.util.List" %>
                    <% List<String> jobtypes = (List<String>) request.getAttribute("jobtypes"); %>
                    <div class="form-group">
                        <label for="targetIndustry">第一希望職種</label>
                        <select id="targetIndustry1" name="targetIndustry1">
                            <option value="0">選択してください</option>
                            <% int i = 1; %>
                            <% for (String jobtype : jobtypes) {%>
                                <option value="<%= i %>"><%= jobtype %></option>
                                <% i++; %>
                            <% } %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="targetIndustry">第二希望職種</label>
                        <select id="targetIndustry2" name="targetIndustry2">
                            <option value="0">選択してください</option>
                            <% int j = 1; %>
                            <% for (String jobtype : jobtypes) {%>
                                <option value="<%= j %>"><%= jobtype %></option>
                                <% j++; %>
                            <% } %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="targetIndustry">第三希望職種</label>
                        <select id="targetIndustry3" name="targetIndustry3">
                            <option value="0">選択してください</option>
                            <% int k = 1; %>
                            <% for (String jobtype : jobtypes) {%>
                                <option value="<%= k %>"><%= jobtype %></option>
                                <% k++; %>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="notes">備考</label>
                    <textarea id="notes" name="notes" rows="4" maxlength="500" style="width: 100%; padding: 12px 16px; border: 1px solid #e9ecef; border-radius: 8px; font-size: 16px; resize: vertical;" placeholder="特記事項があれば記入してください"></textarea>
                </div>

                <!-- ボタン -->
                <div class="form-buttons">
                    <button type="submit" class="btn btn-primary">登録する</button>
                    <a href="StatusServlet?status=studentManagement" class="btn btn-secondary">キャンセル</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        // フォームバリデーション
        document.querySelector('form').addEventListener('submit', function(e) {
            const studentId = document.getElementById('studentId').value;
            const name = document.getElementById('name').value;
            const kana = document.getElementById('kana').value;
            const department = document.getElementById('department').value;

            // 必須項目チェック
            if (!studentId || !name || !kana || !department) {
                e.preventDefault();
                alert('必須項目を入力してください。');
                return;
            }

            // 学籍番号の形式チェック（8桁）
            if (!/^[0-9]{8}$/.test(studentId)) {
                e.preventDefault();
                alert('学籍番号は8桁の数字で自動生成されます。');
                return;
            }
        });

  
        const kanaInput = document.getElementById('kana');
        let previousValue = '';  // 直前の値

        // IME確定時に実行（1文字ずつ）
        kanaInput.addEventListener('compositionend', () => {
            const currentValue = kanaInput.value;
            
            // 直前と比較して追加された文字を特定
            const addedChar = currentValue.slice(previousValue.length);

            // 追加された1文字がひらがななら変換
            const katakanaChar = addedChar.replace(/[\u3041-\u3096]/g, (match) =>
                String.fromCharCode(match.charCodeAt(0) + 0x60)
            );

            // カタカナに置き換えて反映
            kanaInput.value = previousValue + katakanaChar;

            // 更新
            previousValue = kanaInput.value;
        });

        // 入力の変化を追跡
        kanaInput.addEventListener('input', () => {
            if (kanaInput.value.length < previousValue.length) {
                // バックスペースなどで削除された場合も追跡
                previousValue = kanaInput.value;
            }
        });


        // --- 学籍番号自動生成（表ルール対応） ---
        function generateStudentId() {
            const year = document.getElementById('admissionYear').value;
            const type = document.getElementById('classType').value;
            const grade = document.getElementById('classGrade').value;
            const group = document.getElementById('classGroup').value;
            const classCodeMap = {
                'R': '11',
                'S': '21',
                'M': '22',
                'J': '31',
                'G': '32',
            };
            let studentId = '';
            let studentIdTmp = '';
            if (year && type && grade && group) {
                const yy = year.slice(-2);
                const mid = classCodeMap[type] || '';
                const studentIdTmp = "2" + yy + mid;

                fetch('/就活管理アプリ/StudentServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: new URLSearchParams({
                        action: 'getStudentId',
                        student_id: studentIdTmp
                    })
                })
                .then(response => {
                    console.log('レスポンスステータス:', response.status);
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.text();  // JSONじゃないなら text() にする
                })
                .then(data => {
                    console.log('受け取ったデータ:', data);
                    let serialNumber = '';
                    if (data === "0") {
                        serialNumber = "001";
                    } else {
                        serialNumber = (parseInt(data.slice(-3)) + 1).toString().padStart(3, '0');
                    }

                    const studentId = "2" + yy + mid + serialNumber; // ← ここで組み立てる
                    console.log("生成された studentId:", studentId);

                    // 必要ならHTMLの input に設定
                    document.getElementById("studentId").value = studentId;
                })
                .catch(error => {
                    console.error('エラー:', error);
                });
        }
    }
        document.getElementById('admissionYear').addEventListener('change', generateStudentId);
        document.getElementById('classType').addEventListener('change', generateStudentId);
        document.getElementById('classGrade').addEventListener('change', generateStudentId);
        document.getElementById('classGroup').addEventListener('change', generateStudentId);

        function updateClassNameRxAx() {
            const type = document.getElementById('classType').value;
            const grade = document.getElementById('classGrade').value;
            const group = document.getElementById('classGroup').value;
            let className = '';
            if (type != "" && grade != "" && group != "") {
                let fixedChar = '';
                if (type == 'R' || type == 'S') fixedChar = 'A';
                else if (type == 'M' || type == 'G') fixedChar = 'G';
                else if (type == 'J') fixedChar = 'S';
                className = type+grade+fixedChar+group;
            }
            document.getElementById('className').value = className;
        }

        // イベントリスナーを追加（DOMContentLoadedで確実にDOM読み込み後に設定）
        document.addEventListener('DOMContentLoaded', () => {
            document.getElementById('classType').addEventListener('change', updateClassNameRxAx);
            document.getElementById('classGrade').addEventListener('change', updateClassNameRxAx);
            document.getElementById('classGroup').addEventListener('change', updateClassNameRxAx);
        });
    </script>
</body>
</html> 