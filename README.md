# Job Management System (JMS) v0.2.5

## 📋 プロジェクト概要

**Job Management System (JMS)** は、教育機関向けの包括的な就職活動管理システムです。学生の就職活動を効率的に管理し、教職員による指導支援を強化することを目的として開発されました。

### 🎯 主な目的
- 学生の就職活動進捗の一元管理
- 教職員による学生指導の効率化
- 企業情報の体系的な管理
- 選考ステージの可視化と分析
- 権限ベースのアクセス制御

## 🏗️ 技術スタック

### バックエンド
- **言語**: Java 17
- **フレームワーク**: Java Servlet 4.0
- **Webコンテナ**: Apache Tomcat 10.0
- **アーキテクチャ**: MVC (Model-View-Controller) パターン
- **セッション管理**: HttpSession
- **セキュリティ**: パスワードハッシュ化 (SHA-256 + Salt)

### フロントエンド
- **マークアップ**: HTML5
- **スタイリング**: CSS3 (レスポンシブデザイン)
- **クライアントサイド**: JavaScript (ES6+)
- **ライブラリ**: jQuery 3.6.0
- **テンプレートエンジン**: JSP (JavaServer Pages)
- **UI/UX**: モダンなダッシュボードデザイン

### データベース
- **RDBMS**: MySQL 8.0
- **接続プール**: Tomcat JDBC Pool
- **ORM**: カスタムDAOパターン
- **トランザクション管理**: 手動管理
- **バックアップ**: 自動バックアップ機能

### インフラストラクチャ
- **Webサーバー**: Apache Tomcat 10.0
- **OS対応**: Windows 10/11, Linux, macOS
- **ブラウザ対応**: Chrome, Firefox, Safari, Edge
- **デプロイ**: WAR形式での配布

## 📁 プロジェクト構造

```
JMS_v0.2.5/
├── src/
│   └── main/
│       ├── java/
│       │   ├── beans/                    # JavaBeans (データモデル)
│       │   │   ├── CompanyBean.java      # 企業情報Bean
│       │   │   ├── ExamineeBean.java     # 受験者情報Bean
│       │   │   ├── ExamTypeBean.java     # 試験種別Bean
│       │   │   ├── InterviewExamContentBean.java  # 面接試験内容Bean
│       │   │   ├── InterviewTypeBean.java # 面接種別Bean
│       │   │   ├── StudentBeans.java     # 学生情報Bean
│       │   │   └── UserBeans.java        # ユーザー情報Bean
│       │   ├── dao/                      # データアクセス層
│       │   │   ├── CompanyDAO.java       # 企業データアクセス
│       │   │   ├── DropdownDataDAO.java  # ドロップダウンデータアクセス
│       │   │   ├── SelectionStageDAO.java # 選考ステージデータアクセス
│       │   │   ├── StudentDAO.java       # 学生データアクセス
│       │   │   └── UserDAO.java          # ユーザーデータアクセス
│       │   ├── servlet/                  # コントローラー層
│       │   │   ├── CompanyDetailServlet.java    # 企業詳細表示
│       │   │   ├── CompanyListServlet.java      # 企業一覧表示
│       │   │   ├── CompanyManagementServlet.java # 企業管理
│       │   │   ├── CreateCompanyServlet.java    # 企業作成
│       │   │   ├── CreateStudentServlet.java    # 学生作成
│       │   │   ├── DashboardServlet.java        # ダッシュボード
│       │   │   ├── DatabaseManagementServlet.java # DB管理
│       │   │   ├── ExamineeSearch.java          # 受験者検索
│       │   │   ├── JobHuntingSearchServlet.java # 就職活動検索
│       │   │   ├── LoginServlet.java            # ログイン処理
│       │   │   ├── LogoutServlet.java           # ログアウト処理
│       │   │   ├── RegisterServlet.java         # ユーザー登録
│       │   │   ├── SearchServlet.java           # 検索処理
│       │   │   ├── SelectionStageServlet.java   # 選考ステージ登録
│       │   │   ├── SelectionStageViewServlet.java # 選考ステージ表示
│       │   │   ├── StatusServlet.java           # ステータス管理
│       │   │   ├── StudentDetailServlet.java    # 学生詳細表示
│       │   │   ├── StudentListServlet.java      # 学生一覧表示
│       │   │   ├── StudentManagementServlet.java # 学生管理
│       │   │   ├── StudentServlet.java          # 学生処理
│       │   │   ├── StudentViewServlet.java      # 学生表示
│       │   │   └── UserRoleManagementServlet.java # ユーザー権限管理
│       │   └── utils/                   # ユーティリティ
│       │       └── DBConnection.java    # データベース接続管理
│       └── webapp/                      # Webアプリケーション
│           ├── css/                     # スタイルシート
│           │   ├── inview.css           # アニメーション用CSS
│           │   └── style.css            # メインスタイル
│           ├── images/                  # 画像リソース
│           ├── js/                      # JavaScript
│           │   ├── jquery.inview_set.js # jQuery InView プラグイン
│           │   └── main.js              # メインJavaScript
│           ├── WEB-INF/
│           │   ├── jsp/                 # JSPビュー
│           │   │   ├── adminDatabase.jsp        # 管理者設定画面
│           │   │   ├── applicantList.jsp        # 受験者一覧
│           │   │   ├── CompanyList.jsp          # 企業一覧
│           │   │   ├── CompanyManagement.jsp    # 企業管理
│           │   │   ├── CompanyView.jsp          # 企業詳細
│           │   │   ├── CreateCompany.jsp        # 企業作成
│           │   │   ├── CreateStudent.jsp        # 学生作成
│           │   │   ├── DashBoard.jsp            # ダッシュボード
│           │   │   ├── databaseManagement.jsp   # DB管理画面
│           │   │   ├── InterviewExamView.jsp    # 面接試験表示
│           │   │   │   ├── jobHunting.jsp       # 就職活動管理
│           │   │   ├── jobHuntingSearch.jsp     # 就職活動検索
│           │   │   ├── SearchResults.jsp        # 検索結果
│           │   │   ├── SelectionStage.jsp       # 選考ステージ登録
│           │   │   ├── SelectionStageEdit.jsp   # 選考ステージ編集
│           │   │   ├── SelectionStageView.jsp   # 選考ステージ表示
│           │   │   ├── studentDetail.jsp        # 学生詳細
│           │   │   ├── StudentList.jsp          # 学生一覧
│           │   │   ├── StudentManagement.jsp    # 学生管理
│           │   │   ├── studentView.jsp          # 学生表示
│           │   │   ├── temp_jms.jsp             # 一時画面
│           │   │   └── userRoleManagement.jsp   # ユーザー権限管理
│           │   ├── lib/                 # ライブラリ
│           │   └── web.xml              # Webアプリケーション設定
│           ├── error/                   # エラーページ
│           │   ├── 403.html             # アクセス拒否
│           │   ├── 404.html             # ページ未発見
│           │   ├── 500.html             # サーバーエラー
│           │   ├── access-denied.html   # アクセス拒否
│           │   ├── login-failed.html    # ログイン失敗
│           │   └── session-expired.html # セッション期限切れ
│           ├── index.html               # メインページ
│           ├── login.html               # ログインページ
│           └── register.html            # ユーザー登録ページ
├── Servers/                             # サーバー設定
│   ├── Tomcat10_Java17-config/          # Tomcat 10 + Java 17設定
│   ├── Tomcat10_Java21-config/          # Tomcat 10 + Java 21設定
│   ├── Tomcat8_Java8-config/            # Tomcat 8 + Java 8設定
│   ├── Tomcat9_Java11-config/           # Tomcat 9 + Java 11設定
│   └── Tomcat9_Java17-config/           # Tomcat 9 + Java 17設定
├── interview_exam_tables.sql            # 面接試験テーブル定義
├── JMS_v0.2.5_手順書.md                 # システム手順書
├── JMS_チーム開発タスク表.md             # 開発タスク管理
├── MySQL構成.txt                        # データベース構成
├── ローカル用DB(現在未使用).sql          # ローカルDB設定
└── README.md                            # このファイル
```

## 🚀 セットアップ手順

### 前提条件
- **Java**: JDK 17以上
- **Webサーバー**: Apache Tomcat 10.0以上
- **データベース**: MySQL 8.0以上
- **IDE**: Eclipse IDE for Enterprise Java Developers (推奨)

### 1. データベースセットアップ
```sql
-- MySQLデータベースの作成
CREATE DATABASE jms_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ユーザーの作成と権限付与
CREATE USER 'jms_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON jms_db.* TO 'jms_user'@'localhost';
FLUSH PRIVILEGES;

-- テーブル作成
mysql -u jms_user -p jms_db < interview_exam_tables.sql
```

### 2. プロジェクト設定
1. Eclipseでプロジェクトをインポート
2. Java Build PathでJDK 17を設定
3. `src/main/java/utils/DBConnection.java`でデータベース接続情報を更新
4. Tomcat 10.0サーバーを設定

### 3. デプロイ
1. プロジェクトを右クリック → Export → WAR file
2. 生成されたWARファイルをTomcatのwebappsディレクトリに配置
3. Tomcatを起動
4. `http://localhost:8080/JMS_v0.2.5/` にアクセス

## 🔐 権限システム

### ユーザー権限レベル
1. **学生 (student)**
   - 自分の選考ステージ登録・確認
   - 企業一覧閲覧
   - 書類提出状況確認

2. **教員 (teacher)**
   - 学生管理（登録・編集・削除）
   - 企業管理
   - 就職活動管理

3. **校長・教務部長 (headmaster)**
   - 教員権限 + システム全体の管理

4. **就職指導部 (egd)**
   - 就職活動専門の管理機能

5. **システム管理者 (admin)**
   - 全権限
   - ユーザー権限管理
   - データベース管理

## 🎯 主要機能

### 学生管理機能
- ✅ 学生情報の登録・編集・削除
- ✅ 学生一覧表示と検索
- ✅ 進級・卒業処理
- ✅ 在籍状況管理

### 企業管理機能
- ✅ 企業情報の登録・編集・削除
- ✅ 企業一覧表示と検索
- ✅ 企業詳細情報管理

### 選考ステージ管理
- ✅ 選考ステージの登録・編集
- ✅ 選考進捗の可視化
- ✅ 面接試験情報管理

### 就職活動管理
- ✅ 就職活動状況の追跡
- ✅ 書類提出状況管理
- ✅ 受験者検索機能

### システム管理機能
- ✅ ユーザー権限管理
- ✅ データベース管理
- ✅ 統計情報表示
- ✅ バックアップ・復元

## 🔧 開発・運用

### ビルド
```bash
# Mavenプロジェクトの場合
mvn clean package

# 手動ビルドの場合
javac -cp "lib/*" src/main/java/**/*.java
```

### テスト
```bash
# 単体テスト実行
java -cp "lib/*:target/test-classes" org.junit.runner.JUnitCore TestSuite
```

### ログ管理
- アプリケーションログ: `logs/jms.log`
- エラーログ: `logs/error.log`
- アクセスログ: Tomcat標準ログ

### パフォーマンス最適化
- データベース接続プール設定
- JSPキャッシュ有効化
- 静的リソースの圧縮

## 🛡️ セキュリティ機能

### 認証・認可
- セッションベース認証
- 権限ベースアクセス制御 (RBAC)
- パスワードハッシュ化 (SHA-256 + Salt)

### 入力検証
- SQLインジェクション対策
- XSS対策
- CSRF対策

### セッション管理
- セッションタイムアウト設定
- セッション固定化攻撃対策
- セキュアなログアウト処理

## 📊 データベース設計

### 主要テーブル
- `users_tbl`: ユーザー情報
- `students_tbl`: 学生情報
- `companies_tbl`: 企業情報
- `selection_stages_tbl`: 選考ステージ
- `interview_exam_tbl`: 面接試験情報
- `exam_types_tbl`: 試験種別
- `interview_types_tbl`: 面接種別

### リレーション
- ユーザー ↔ 学生 (1:1)
- 学生 ↔ 選考ステージ (1:N)
- 企業 ↔ 選考ステージ (1:N)
- 選考ステージ ↔ 面接試験 (1:N)

## 🚀 今後の拡張予定

### v0.3.0 予定機能
- [ ] RESTful API実装
- [ ] モバイルアプリ対応
- [ ] リアルタイム通知機能
- [ ] データ分析・レポート機能
- [ ] 外部システム連携

### v0.4.0 予定機能
- [ ] マイクロサービス化
- [ ] クラウド対応
- [ ] AI支援機能
- [ ] 多言語対応

## 👥 開発チーム

### 役割分担
- **プロジェクトマネージャー**: 全体統括・進捗管理
- **システム設計者**: アーキテクチャ設計・DB設計
- **バックエンド開発者**: Java Servlet・DAO実装
- **フロントエンド開発者**: JSP・CSS・JavaScript実装
- **テスト担当者**: 単体テスト・結合テスト

### 開発環境
- **バージョン管理**: Git
- **プロジェクト管理**: GitHub Projects
- **CI/CD**: GitHub Actions (予定)
- **ドキュメント**: Markdown

## 📝 ライセンス

このプロジェクトは教育目的で作成されており、以下のライセンスに従います：
- **教育利用**: 自由
- **商用利用**: 要相談
- **改変・配布**: 要許可

## 🤝 貢献

### バグ報告
GitHubのIssuesで報告してください。

### 機能要望
Feature RequestとしてIssuesに投稿してください。

### プルリクエスト
1. フォークしてブランチを作成
2. 変更をコミット
3. プルリクエストを作成

## 📞 サポート

### 技術サポート
- **メール**: support@jms.example.com
- **ドキュメント**: [Wiki](https://github.com/your-repo/wiki)
- **FAQ**: [よくある質問](https://github.com/your-repo/wiki/FAQ)

### 緊急時
- **システム障害**: 24時間対応
- **セキュリティ問題**: 即座に対応

---

**Job Management System v0.2.5** - 教育機関向け就職活動管理システム

*最終更新: 2025年1月* 