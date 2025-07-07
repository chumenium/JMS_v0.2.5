# 無料データベース移行手順書

## 📋 **完了済み**
- ✅ Filess.ioアカウント作成
- ✅ 統合SQLファイル作成 (`filess_database_setup.sql`)
- ✅ DBConnection.javaの更新

## 🔧 **次の手順**

### **1. Filess.ioでデータベース作成**
1. https://filess.io にログイン
2. 「Create Database」をクリック
3. 設定：
   - **Type**: MySQL
   - **Name**: `jms` (推奨)
   - **Region**: Japan または Singapore
4. 「Create」をクリック

### **2. 接続情報を取得**
作成後に表示される情報をメモ：
```
Host: sql.filess.io
Port: 3306
Database: [自動生成された名前]
Username: [自動生成されたユーザー名]
Password: [自動生成されたパスワード]
```

### **3. データベースをセットアップ**
1. Filess.ioダッシュボードで「phpMyAdmin」をクリック
2. 上記の接続情報でログイン
3. 「インポート」タブを選択
4. `filess_database_setup.sql` ファイルを選択
5. 「実行」をクリック

### **4. DBConnection.javaを更新**
`src/main/java/utils/DBConnection.java` ファイルの以下の部分を更新：

```java
// 実際の接続情報に置き換え
private static final String FREE_URL = "jdbc:mysql://sql.filess.io:3306/[実際のDB名]";
private static final String FREE_USER = "[実際のユーザー名]";
private static final String FREE_PASSWORD = "[実際のパスワード]";

// 無料DBを使用する場合はtrueに変更
private static final boolean USE_FREE_DB = true;
```

### **5. 接続テスト**
1. アプリケーションを起動
2. ログイン画面にアクセス
3. 正常に動作することを確認

### **6. フェイルオーバーテスト**
1. `DBConnection.java`で`getConnectionWithFailover()`メソッドを使用
2. 片方のDBが停止した場合の動作を確認

## 🚨 **注意事項**

### **容量制限**
- 無料プラン: 10MB
- 学生データが多い場合は容量不足の可能性あり

### **同時接続数**
- 無料プランは同時接続数に制限あり
- 多数のユーザーが同時アクセスする場合は注意

### **バックアップ**
- 週1回の自動バックアップ
- 重要なデータは定期的に手動バックアップ推奨

## 📈 **容量が足りない場合の対策**

### **1. データの最適化**
- 不要なテストデータを削除
- TEXT型フィールドの見直し
- インデックスの最適化

### **2. 代替サービス**
- **Aiven**: 1GB無料
- **TiDB Cloud**: 25GB無料
- **PlanetScale**: 無料プランあり

### **3. データ分割**
- マスタデータ（職種、勤務地等）: 無料DB
- 学生データ: 別のDB
- 活動データ: 別のDB

## 🔧 **トラブルシューティング**

### **接続エラー**
1. 接続情報の確認
2. ファイアウォール設定
3. SSL/TLS設定

### **容量エラー**
1. 不要データの削除
2. 他のサービスへの移行検討

### **パフォーマンス問題**
1. クエリの最適化
2. インデックスの追加
3. 接続プールの実装

## 📞 **サポート**
- Filess.io: ドキュメント参照
- 技術的問題: GitHub Issues
- 緊急時: GCP DBへのフォールバック 