# 就活管理アプリ

## 概要
学生の就職活動を管理するためのWebアプリケーションです。学生情報の登録・更新・削除、進級・卒業処理、検索機能などを提供します。

## 技術スタック
- **バックエンド**: Java Servlet
- **フロントエンド**: HTML, CSS, JavaScript, JSP
- **データベース**: SQL
- **サーバー**: Tomcat

## プロジェクト構造
```
就活管理アプリ2/
├── src/
│   └── main/
│       ├── java/
│       │   ├── beans/          # JavaBeans
│       │   ├── dao/            # データアクセスオブジェクト
│       │   ├── servlet/        # Servletクラス
│       │   └── utils/          # ユーティリティクラス
│       └── webapp/
│           ├── css/            # スタイルシート
│           ├── images/         # 画像ファイル
│           ├── js/             # JavaScriptファイル
│           ├── WEB-INF/
│           │   ├── jsp/        # JSPファイル
│           │   └── web.xml     # Webアプリケーション設定
│           ├── index.html      # メインページ
│           └── login.html      # ログインページ
├── database_setup.sql          # データベース初期化スクリプト
└── README_動的プルダウン実装.md  # 実装ドキュメント
```

## セットアップ手順

### 1. 必要な環境
- Java 8以上
- Apache Tomcat 9以上
- SQLデータベース（MySQL推奨）

### 2. データベースのセットアップ
```sql
-- database_setup.sqlを実行してデータベースを初期化
mysql -u username -p database_name < database_setup.sql
```

### 3. アプリケーションのデプロイ
1. プロジェクトをEclipseにインポート
2. Tomcatサーバーを設定
3. プロジェクトをサーバーにデプロイ
4. `http://localhost:8080/就活管理アプリ2/` にアクセス

## 主な機能

### 学生管理
- **新規登録**: 学生情報の追加
- **更新**: 既存学生情報の編集
- **削除**: 学生情報の削除
- **検索**: 条件に基づく学生検索

### 進級・卒業処理
- 自動進級処理
- 卒業判定
- 在籍状況の更新

### セキュリティ
- パスワードのハッシュ化（SHA-256）
- ソルト生成によるセキュリティ強化

## 開発者向け情報

### ビルド
```bash
# プロジェクトのビルド
javac -cp "lib/*" src/main/java/**/*.java
```

### テスト
```bash
# テストの実行
java -cp "lib/*:target/test-classes" org.junit.runner.JUnitCore TestSuite
```

## ライセンス
このプロジェクトは教育目的で作成されています。

## 貢献
バグ報告や機能要望は、Issueとして報告してください。 