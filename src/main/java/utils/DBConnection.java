package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


//PCが変わるたび変更をすること
public class DBConnection {
  // 現在のGCP MySQL（バックアップ用）
  private static final String GCP_URL = "jdbc:mysql://35.200.16.205:3306/jms";
  private static final String GCP_USER = "root";
  private static final String GCP_PASSWORD = "";
  
      // 無料MySQLホスティング設定（Filess.io）
    private static final String FREE_URL = "jdbc:mysql://sa7np.h.filess.io:3307/jms_essential";
    private static final String FREE_USER = "jms_essential";
    private static final String FREE_PASSWORD = "admin_jms"; // TODO: Filess.ioから取得した実際のパスワードを入力してください
  
      // 使用するDB設定（true: 無料DB, false: GCP DB）
    private static final boolean USE_FREE_DB = true;

  public static Connection getConnection() throws SQLException, ClassNotFoundException {
      Class.forName("com.mysql.cj.jdbc.Driver");
      
      if (USE_FREE_DB) {
          return DriverManager.getConnection(FREE_URL, FREE_USER, FREE_PASSWORD);
      } else {
          return DriverManager.getConnection(GCP_URL, GCP_USER, GCP_PASSWORD);
      }
  }
  
  // フェイルオーバー機能付き接続
  public static Connection getConnectionWithFailover() throws SQLException, ClassNotFoundException {
      Class.forName("com.mysql.cj.jdbc.Driver");
      
      try {
          // まずメインDBに接続を試行
          if (USE_FREE_DB) {
              return DriverManager.getConnection(FREE_URL, FREE_USER, FREE_PASSWORD);
          } else {
              return DriverManager.getConnection(GCP_URL, GCP_USER, GCP_PASSWORD);
          }
      } catch (SQLException e) {
          System.out.println("メインDB接続失敗、バックアップDBに接続中...");
          // バックアップDBに接続
          if (USE_FREE_DB) {
              return DriverManager.getConnection(GCP_URL, GCP_USER, GCP_PASSWORD);
          } else {
              return DriverManager.getConnection(FREE_URL, FREE_USER, FREE_PASSWORD);
          }
      }
  }
}