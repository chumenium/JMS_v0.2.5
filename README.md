# 就活管理アプリ

就職活動管理システム（JMS: Job Management System）

## 📋 概要

このアプリケーションは、学校の就職活動を管理するためのWebアプリケーションです。
教員、学生、就職指導部がそれぞれの権限に応じて就職活動の進捗を管理できます。

## 🚀 実行方法

### 前提条件

- **Java 21** 以上
- **Apache Tomcat 10** 以上
- **MySQL 8.0** 以上
- **Eclipse IDE** (推奨)

### 方法1: Eclipse IDE での実行（推奨）

1. **Eclipse IDE をインストール**
   ```
   Eclipse IDE for Enterprise Java Developers をダウンロード
   https://www.eclipse.org/downloads/packages/
   ```

2. **プロジェクトをインポート**
   ```
   File → Import → Existing Projects into Workspace
   → プロジェクトのルートディレクトリを選択
   ```

3. **Tomcat サーバーを設定**
   ```
   Window → Preferences → Server → Runtime Environments
   → Tomcat 10 (Java 21) を追加
   ```

4. **プロジェクトをサーバーに追加**
   ```
   プロジェクトを右クリック → Run As → Run on Server
   → Tomcat 10 を選択
   ```

5. **アプリケーションにアクセス**
   ```
   http://localhost:8080/就活管理アプリ/
   ```

### 方法2: Maven での実行

1. **Maven をインストール**
   ```bash
   # Windows
   choco install maven
   
   # macOS
   brew install maven
   
   # Linux
   sudo apt install maven
   ```

2. **プロジェクトをビルド**
   ```bash
   mvn clean compile
   ```

3. **WARファイルを作成**
   ```bash
   mvn package
   ```

4. **Tomcatにデプロイ**
   ```bash
   # WARファイルをTomcatのwebappsディレクトリにコピー
   cp target/job-management-system-1.0.0.war /path/to/tomcat/webapps/就活管理アプリ.war
   ```

5. **Tomcatを起動**
   ```bash
   cd /path/to/tomcat/bin
   ./startup.sh  # Linux/Mac
   startup.bat   # Windows
   ```

### 方法3: 組み込みTomcatでの実行

```bash
# プロジェクトディレクトリで実行
mvn cargo:run
```

## 🗄️ データベース設定

### MySQL データベースの準備

1. **MySQL をインストール・起動**

2. **データベースを作成**
   ```sql
   CREATE DATABASE jms_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

3. **ユーザーを作成**
   ```sql
   CREATE USER 'jms_user'@'localhost' IDENTIFIED BY 'password';
   GRANT ALL PRIVILEGES ON jms_db.* TO 'jms_user'@'localhost';
   FLUSH PRIVILEGES;
   ```

### データベース接続設定

`src/main/java/dao/DBconnecter.java` でデータベース接続設定を確認・修正してください。

## 👥 ユーザー権限

| 権限 | 説明 | アクセス可能画面 |
|------|------|------------------|
| `teacher` | 教員 | 学生管理、就職管理 |
| `headmaster` | 校長・教務部長 | 学生管理、就職管理 |
| `egd` | 就職指導部 | 企業管理、就職管理 |
| `admin` | システム管理者 | 全画面 |
| `student` | 学生 | 就職管理 |

## 📁 プロジェクト構造

```
就活管理アプリ/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── beans/          # JavaBeans
│   │   │   ├── dao/            # データアクセス層
│   │   │   └── servlet/        # サーブレット
│   │   └── webapp/
│   │       ├── css/            # スタイルシート
│   │       ├── images/         # 画像ファイル
│   │       ├── js/             # JavaScript
│   │       ├── WEB-INF/
│   │       │   ├── jsp/        # JSPファイル
│   │       │   ├── lib/        # ライブラリ
│   │       │   └── web.xml     # Web設定
│   │       ├── index.html      # トップページ
│   │       └── login.html      # ログインページ
│   └── test/                   # テストコード
├── build/                      # ビルド出力
├── .project                    # Eclipse設定
├── .classpath                  # クラスパス設定
├── pom.xml                     # Maven設定
└── README.md                   # このファイル
```

## 🔧 トラブルシューティング

### よくある問題

1. **ポート8080が使用中**
   ```bash
   # 使用中のプロセスを確認
   netstat -ano | findstr :8080  # Windows
   lsof -i :8080                 # Linux/Mac
   ```

2. **データベース接続エラー**
   - MySQL サービスが起動しているか確認
   - 接続情報（ホスト、ポート、ユーザー名、パスワード）を確認

3. **JSP コンパイルエラー**
   - Tomcat のバージョンが適切か確認（Tomcat 10 推奨）
   - Java のバージョンが21以上か確認

## 📞 サポート

問題が発生した場合は、以下を確認してください：

1. ログファイルの確認
2. ブラウザの開発者ツールでのエラー確認
3. Tomcat のログファイル確認

## 📝 ライセンス

このプロジェクトは教育目的で作成されています。 