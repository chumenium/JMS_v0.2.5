# 動的プルダウン実装について

## 概要
学生管理画面のプルダウンメニューを、データベースから動的に取得するように変更しました。

## 変更内容

### 1. 新規作成ファイル

#### `src/main/java/dao/DropdownDataDAO.java`
- プルダウン用のデータをデータベースから取得するDAOクラス
- 以下のメソッドを提供：
  - `getClassList()`: クラス一覧取得
  - `getEnrollmentStatusList()`: 在籍状況一覧取得
  - `getAssistanceList()`: 斡旋一覧取得
  - `getFirstChoiceIndustryList()`: 第一希望業種一覧取得
  - `getGraduationYearList()`: 卒業年一覧取得

#### `src/main/java/servlet/StudentManagementServlet.java`
- 学生管理画面専用のServlet
- プルダウン用データを取得してJSPに渡す
- 権限チェック機能付き

#### `database_setup.sql`
- プルダウン用のデータベーステーブルとサンプルデータ
- 実行してデータベースを初期化

### 2. 修正ファイル

#### `src/main/java/servlet/StatusServlet.java`
- 学生管理画面のルーティングを追加
- `studentManagement`パラメータで`StudentManagementServlet`にリダイレクト

#### `src/main/webapp/WEB-INF/web.xml`
- `StudentManagementServlet`のマッピングを追加

#### `src/main/webapp/WEB-INF/jsp/StudentManagement.jsp`
- プルダウンを動的データに変更
- エラーメッセージ表示機能を追加

## 使用方法

### 1. データベースの初期化
```sql
-- database_setup.sqlを実行
mysql -u root -p jms < database_setup.sql
```

### 2. アプリケーションの起動
- Tomcatサーバーを起動
- ブラウザで学生管理画面にアクセス

### 3. プルダウンの更新
データベースの各テーブルに新しいデータを追加すると、次回の画面表示時に自動的に反映されます：

```sql
-- 新しいクラスを追加
INSERT INTO classes (class_name) VALUES ('S1A1');

-- 新しい業種を追加
INSERT INTO industries (industry_name) VALUES ('ゲーム業界');
```

## データベース構造

### classes テーブル
- `id`: 主キー
- `class_name`: クラス名（例：S3A1）

### enrollment_status テーブル
- `id`: 主キー
- `status_name`: 在籍状況名（例：在籍、休学、卒業）

### assistance_types テーブル
- `id`: 主キー
- `assistance_name`: 斡旋タイプ名（例：学校斡旋、自己応募）

### industries テーブル
- `id`: 主キー
- `industry_name`: 業種名（例：IT・ソフトウェア、製造業）

### students テーブル
- `graduation_year`: 卒業年（プルダウン用データの取得元）

## メリット

1. **保守性の向上**: プルダウンの内容をコード変更なしで更新可能
2. **データの一貫性**: データベースで一元管理
3. **拡張性**: 新しい選択肢を簡単に追加可能
4. **ユーザビリティ**: 常に最新のデータが表示される

## 注意事項

- データベース接続エラー時はエラーメッセージが表示されます
- 権限がない場合はログイン画面にリダイレクトされます
- データベーステーブルが存在しない場合は、まず`database_setup.sql`を実行してください 