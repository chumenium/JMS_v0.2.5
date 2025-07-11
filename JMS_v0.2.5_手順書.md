# JMS (Job Management System) v0.2.5 手順書

## 目次
1. [概要](#概要)
2. [システム要件](#システム要件)
3. [セットアップ手順](#セットアップ手順)
4. [アプリケーションの起動](#アプリケーションの起動)
5. [ユーザー権限と機能](#ユーザー権限と機能)
6. [開発・デバッグ](#開発デバッグ)
7. [トラブルシューティング](#トラブルシューティング)
8. [パフォーマンス最適化](#パフォーマンス最適化)
9. [セキュリティ](#セキュリティ)
10. [バックアップ・復旧](#バックアップ復旧)
11. [更新・メンテナンス](#更新メンテナンス)

---

## 概要

JMS (Job Management System) v0.2.5は、学生の就職活動管理、企業情報管理、選考状況の追跡を行うWebアプリケーションです。

### 主な特徴
- 学生情報の管理（登録・編集・削除・検索）
- 企業情報の管理
- 就職活動状況の追跡
- 選考段階の管理
- 面接情報の管理
- 統計情報の表示
- 権限ベースのアクセス制御

---

## システム要件

### 必要なソフトウェア
- **Java**: 17以上 (推奨: Java 21)
- **Apache Tomcat**: 10.x以上
- **MySQL**: 8.0以上
- **Git**: 最新版

### 推奨環境
- **OS**: Windows 10/11, macOS, Linux
- **メモリ**: 8GB以上
- **ディスク容量**: 10GB以上の空き容量
- **ブラウザ**: Chrome, Firefox, Safari, Edge (最新版)

---

## セットアップ手順

### 1. プロジェクトのクローン

```bash
# リポジトリをクローン
git clone https://github.com/chumenium/JMS_v0.2.5.git

# プロジェクトディレクトリに移動
cd JMS_v0.2.5
```

### 2. データベースのセットアップ

#### 2.1 MySQLのインストールと起動
1. MySQL 8.0以上をインストール
2. MySQLサービスを起動
3. rootパスワードを設定

#### 2.2 データベースの作成
```sql
-- MySQLにログイン
mysql -u root -p

-- データベースを作成
CREATE DATABASE jms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- データベースを選択
USE jms;
```

#### 2.3 テーブルの作成
`MySQL構成.txt`の内容を実行してテーブルを作成：

```sql
-- 一括作成スクリプトを実行
-- MySQL構成.txtの内容をコピーして実行

-- 例：
CREATE TABLE occupations_tbl (
    occupation_id INT AUTO_INCREMENT PRIMARY KEY,
    occupation VARCHAR(25)
);

CREATE TABLE companys_tbl (
    companys_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(50),
    post_code VARCHAR(10),
    address VARCHAR(100),
    tel VARCHAR(15),
    mail_address VARCHAR(30),
    manager_name VARCHAR(20),
    recruitment_results boolean
);

-- 他のテーブルも同様に作成
```

### 3. データベース接続設定

#### 3.1 DBConnection.javaの設定
`src/main/java/utils/DBConnection.java`を編集：

```java
// データベース接続情報を設定
private static final String URL = "jdbc:mysql://localhost:3306/jms?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Tokyo";
private static final String USER = "your_username";
private static final String PASSWORD = "your_password";
```

### 4. Tomcatの設定

#### 4.1 Tomcatのインストール
1. Apache Tomcat 10.xをダウンロード
2. 適切なディレクトリに解凍
3. 環境変数`CATALINA_HOME`を設定

#### 4.2 プロジェクトのデプロイ
```bash
# プロジェクトをビルド（Mavenを使用する場合）
mvn clean package

# WARファイルをTomcatのwebappsディレクトリにコピー
cp target/JMS_v0.2.5.war $CATALINA_HOME/webapps/
```

#### 4.3 Tomcatの起動
```bash
# Tomcatを起動
$CATALINA_HOME/bin/startup.sh  # Linux/macOS
$CATALINA_HOME/bin/startup.bat # Windows
```

---

## アプリケーションの起動

### 1. データベースの確認
```bash
# MySQLが起動していることを確認
mysql -u root -p -e "USE jms; SHOW TABLES;"
```

### 2. Tomcatの起動
```bash
# Tomcatを起動
$CATALINA_HOME/bin/startup.sh  # Linux/macOS
$CATALINA_HOME/bin/startup.bat # Windows
```

### 3. アプリケーションへのアクセス
ブラウザで以下のURLにアクセス：
```
http://localhost:8080/JMS_v0.2.5/
```

### 4. 初期ログイン
デフォルトの管理者アカウントでログイン：
- **ユーザーID**: admin
- **パスワード**: admin

---

## ユーザー権限と機能

### 権限レベル

| 権限 | 機能 | 説明 |
|------|------|------|
| **学生 (student)** | 自分の情報の閲覧・編集 | 自分の学生情報のみアクセス可能 |
| **教員 (teacher)** | 学生管理、就職管理 | 学生の情報管理と就職活動の支援 |
| **校長・教務部長 (headmaster)** | 教員と同じ権限 | 教員と同等の権限を持つ |
| **就職指導部 (egd)** | 企業管理、就職管理 | 企業情報の管理と就職活動の支援 |
| **システム管理者 (admin)** | 全機能の利用 | システム全体の管理権限 |

### 主要機能

#### 学生管理機能
- **学生一覧**: 登録されている学生の一覧表示
- **学生詳細**: 学生の詳細情報の閲覧・編集
- **新規登録**: 新しい学生の登録
- **統計情報**: 総学生数、就職活動中の学生数などの表示

#### 企業管理機能
- **企業一覧**: 登録されている企業の一覧表示
- **企業詳細**: 企業の詳細情報の閲覧・編集
- **新規登録**: 新しい企業の登録
- **統計情報**: 企業数、採用実績などの表示

#### 就職管理機能
- **就職活動状況**: 学生の就職活動状況の管理
- **選考段階**: 企業の選考段階の追跡
- **面接情報**: 面接の日程・結果の管理
- **受験者一覧**: 企業の受験者一覧の表示

---

## 開発・デバッグ

### 1. ログの確認

#### Tomcatログの確認
```bash
# Tomcatのログを確認
tail -f $CATALINA_HOME/logs/catalina.out

# アプリケーション固有のログ
tail -f $CATALINA_HOME/logs/localhost.log
```

#### アプリケーションログの確認
- Javaの`System.out.println()`の出力はTomcatログで確認
- ブラウザの開発者ツールでコンソールログを確認

### 2. データベースのデバッグ

#### 統計情報の確認
```sql
-- 学生統計情報の確認
SELECT 
    COUNT(*) AS total_students,
    SUM(CASE WHEN job_hunting_status = '活動中' THEN 1 ELSE 0 END) AS hunting_students
FROM students_tbl;

-- 就職活動状況別の集計
SELECT job_hunting_status, COUNT(*) as count 
FROM students_tbl 
GROUP BY job_hunting_status;
```

#### テーブル構造の確認
```sql
-- テーブル一覧の確認
SHOW TABLES;

-- 特定テーブルの構造確認
DESCRIBE students_tbl;
DESCRIBE companys_tbl;
```

### 3. アプリケーションのデバッグ

#### デバッグモードの有効化
```java
// StudentDAO.javaでデバッグ情報を出力
System.out.println("=== 学生統計情報取得開始 ===");
System.out.println("実行SQL: " + sql);
```

#### ブラウザでのデバッグ
1. F12キーで開発者ツールを開く
2. ConsoleタブでJavaScriptエラーを確認
3. NetworkタブでHTTPリクエストを確認

---

## トラブルシューティング

### よくある問題と解決方法

#### 1. データベース接続エラー

**症状**: `java.sql.SQLException: Communications link failure`

**解決方法**:
1. MySQLサービスが起動しているか確認
2. 接続情報（URL、ユーザー名、パスワード）を確認
3. ファイアウォールの設定を確認
4. ポート3306が開放されているか確認

**確認コマンド**:
```bash
# MySQLサービスの状態確認
systemctl status mysql  # Linux
sc query mysql          # Windows

# 接続テスト
mysql -u root -p -h localhost
```

#### 2. 文字化け

**症状**: 日本語が文字化けする

**解決方法**:
1. データベースの文字エンコーディングを確認
2. JDBC接続URLに文字エンコーディング設定を追加
3. JSPファイルの文字エンコーディングを確認

**設定例**:
```java
// DBConnection.java
private static final String URL = "jdbc:mysql://localhost:3306/jms?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Tokyo";
```

#### 3. 権限エラー

**症状**: アクセス拒否エラーが表示される

**解決方法**:
1. セッション情報を確認
2. ユーザーの権限設定を確認
3. ログイン状態を確認

**確認方法**:
```java
// セッション情報の確認
HttpSession session = request.getSession(false);
if (session != null) {
    String role = (String) session.getAttribute("role");
    System.out.println("現在の権限: " + role);
}
```

#### 4. Tomcat起動エラー

**症状**: Tomcatが起動しない

**解決方法**:
1. ポート8080が使用されていないか確認
2. Javaのバージョンを確認
3. 環境変数の設定を確認

**確認コマンド**:
```bash
# ポート使用状況の確認
netstat -an | grep 8080

# Javaバージョンの確認
java -version
```

---

## パフォーマンス最適化

### 1. データベース最適化

#### インデックスの追加
```sql
-- 学生IDのインデックス
CREATE INDEX idx_student_id ON students_tbl(student_id);

-- 就職活動状況のインデックス
CREATE INDEX idx_job_hunting_status ON students_tbl(job_hunting_status);

-- 企業IDのインデックス
CREATE INDEX idx_company_id ON companys_tbl(companys_id);
```

#### クエリの最適化
```sql
-- 統計情報を1回のクエリで取得
SELECT 
    COUNT(*) AS total_students,
    SUM(CASE WHEN job_hunting_status = '活動中' THEN 1 ELSE 0 END) AS hunting_students,
    SUM(CASE WHEN job_hunting_status = '内定済み' THEN 1 ELSE 0 END) AS decided_students
FROM students_tbl;
```

### 2. アプリケーション最適化

#### 接続プールの設定
```xml
<!-- web.xml -->
<resource-ref>
    <res-ref-name>jdbc/jms</res-ref-name>
    <res-type>javax.sql.DataSource</res-type>
    <res-auth>Container</res-auth>
</resource-ref>
```

#### キャッシュの活用
```java
// 統計情報のキャッシュ
private static Map<String, Integer> statisticsCache = new HashMap<>();
private static long cacheTimestamp = 0;
private static final long CACHE_DURATION = 300000; // 5分
```

---

## セキュリティ

### 1. 認証・認可

#### セッション管理
```java
// セッションの確認
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("id") == null) {
    response.sendRedirect(request.getContextPath() + "/login.html");
    return;
}
```

#### 権限ベースのアクセス制御
```java
// 権限チェック
String role = (String) session.getAttribute("role");
if (role == null || (!role.equals("admin") && !role.equals("teacher"))) {
    response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
    return;
}
```

### 2. データ保護

#### パスワードのハッシュ化
```java
// パスワードのハッシュ化
public static String hashPassword(String password, String salt) {
    try {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        String saltedPassword = password + salt;
        byte[] hashedBytes = md.digest(saltedPassword.getBytes());
        return Base64.getEncoder().encodeToString(hashedBytes);
    } catch (NoSuchAlgorithmException e) {
        throw new RuntimeException(e);
    }
}
```

#### SQLインジェクション対策
```java
// PreparedStatementの使用
String sql = "SELECT * FROM students_tbl WHERE student_id = ?";
PreparedStatement ps = conn.prepareStatement(sql);
ps.setString(1, studentId);
```

---

## バックアップ・復旧

### 1. データベースのバックアップ

#### 自動バックアップスクリプト
```bash
#!/bin/bash
# backup_jms.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/jms"
DB_NAME="jms"

# バックアップディレクトリの作成
mkdir -p $BACKUP_DIR

# データベースのバックアップ
mysqldump -u root -p$MYSQL_ROOT_PASSWORD $DB_NAME > $BACKUP_DIR/jms_backup_$DATE.sql

# 古いバックアップの削除（30日以上前）
find $BACKUP_DIR -name "jms_backup_*.sql" -mtime +30 -delete

echo "バックアップ完了: jms_backup_$DATE.sql"
```

#### 手動バックアップ
```bash
# データベースのバックアップ
mysqldump -u root -p jms > jms_backup_$(date +%Y%m%d).sql

# 特定のテーブルのみバックアップ
mysqldump -u root -p jms students_tbl companys_tbl > tables_backup.sql
```

### 2. アプリケーションのバックアップ

#### プロジェクトファイルのバックアップ
```bash
# プロジェクトファイルのバックアップ
tar -czf jms_project_$(date +%Y%m%d).tar.gz JMS_v0.2.5/

# Gitリポジトリのバックアップ
git archive --format=tar --output=jms_git_backup_$(date +%Y%m%d).tar HEAD
```

### 3. 復旧手順

#### データベースの復旧
```bash
# データベースの復旧
mysql -u root -p jms < jms_backup_20250101.sql

# 特定のテーブルの復旧
mysql -u root -p jms < tables_backup.sql
```

---

## 更新・メンテナンス

### 1. アプリケーションの更新

#### コードの更新
```bash
# 最新版を取得
git pull origin main

# 変更内容の確認
git log --oneline -10

# アプリケーションを再デプロイ
mvn clean package
cp target/JMS_v0.2.5.war $CATALINA_HOME/webapps/
```

#### データベースの更新
```sql
-- 新しいテーブルの追加
CREATE TABLE new_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

-- 既存テーブルの変更
ALTER TABLE students_tbl ADD COLUMN new_column VARCHAR(50);
```

### 2. 定期メンテナンス

#### ログファイルのローテーション
```bash
# ログローテーションスクリプト
#!/bin/bash
# rotate_logs.sh

LOG_DIR="$CATALINA_HOME/logs"
DATE=$(date +%Y%m%d)

# 古いログファイルを圧縮
find $LOG_DIR -name "*.log" -mtime +7 -exec gzip {} \;

# 30日以上前のログファイルを削除
find $LOG_DIR -name "*.log.gz" -mtime +30 -delete
```

#### データベースの最適化
```sql
-- テーブルの最適化
OPTIMIZE TABLE students_tbl;
OPTIMIZE TABLE companys_tbl;

-- 統計情報の更新
ANALYZE TABLE students_tbl;
ANALYZE TABLE companys_tbl;
```

### 3. セキュリティアップデート

#### 定期的なセキュリティチェック
1. 依存関係の脆弱性チェック
2. セキュリティパッチの適用
3. アクセスログの監視
4. 不正アクセスの検出

---

## 運用チェックリスト

### 日次チェック
- [ ] アプリケーションの起動確認
- [ ] データベース接続の確認
- [ ] ログファイルの確認
- [ ] バックアップの実行確認

### 週次チェック
- [ ] パフォーマンスの確認
- [ ] ディスク容量の確認
- [ ] セキュリティログの確認
- [ ] 統計情報の確認

### 月次チェック
- [ ] セキュリティアップデートの確認
- [ ] データベースの最適化
- [ ] ログファイルの整理
- [ ] バックアップの検証

---

## サポート・連絡先

### 技術サポート
- **プロジェクト管理者**: [連絡先情報]
- **開発チーム**: [連絡先情報]
- **システム管理者**: [連絡先情報]

### ドキュメント
- **API仕様書**: [URL]
- **データベース設計書**: [URL]
- **運用マニュアル**: [URL]
- **トラブルシューティングガイド**: [URL]

### 緊急時連絡先
- **システム障害**: [緊急連絡先]
- **セキュリティインシデント**: [セキュリティ連絡先]

---

## ライセンス
このプロジェクトは[ライセンス名]の下で公開されています。

---

**最終更新日**: 2025年1月  
**バージョン**: v0.2.5  
**作成者**: JMS開発チーム  
**文書管理**: [文書管理システムURL] 