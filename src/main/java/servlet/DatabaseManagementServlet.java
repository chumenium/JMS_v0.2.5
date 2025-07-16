package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import utils.DBConnection;

/**
 * データベース管理サーブレット
 * データベースのバックアップ、復元、最適化、統計情報表示機能を提供
 */
public class DatabaseManagementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 管理者権限チェック
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("statistics".equals(action)) {
                // データベース統計情報を取得
                getDatabaseStatistics(request, response);
            } else if ("tables".equals(action)) {
                // テーブル一覧を取得
                getTableList(request, response);
            } else if ("backup".equals(action)) {
                // バックアップ実行
                performBackup(request, response);
            } else if ("optimize".equals(action)) {
                // データベース最適化
                optimizeDatabase(request, response);
                    } else if ("check".equals(action)) {
            // データ整合性チェック
            checkDataIntegrity(request, response);
        } else if ("download".equals(action)) {
            // バックアップファイルダウンロード
            downloadBackupFile(request, response);
        } else {
            // デフォルト：統計情報表示
            getDatabaseStatistics(request, response);
        }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "データベース操作中にエラーが発生しました: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/databaseManagement.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * データベース統計情報を取得
     */
    private void getDatabaseStatistics(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Map<String, Object> statistics = new HashMap<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // データベース情報を取得
            DatabaseMetaData metaData = conn.getMetaData();
            statistics.put("databaseName", metaData.getDatabaseProductName());
            statistics.put("databaseVersion", metaData.getDatabaseProductVersion());
            statistics.put("driverName", metaData.getDriverName());
            statistics.put("driverVersion", metaData.getDriverVersion());
            
            // テーブル統計を取得
            Map<String, Integer> tableCounts = getTableCounts(conn);
            statistics.put("tableCounts", tableCounts);
            
            // データベースサイズを取得（MySQL用）
            String sizeQuery = "SELECT ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS db_size_mb " +
                              "FROM information_schema.tables WHERE table_schema = DATABASE()";
            try (PreparedStatement stmt = conn.prepareStatement(sizeQuery);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    statistics.put("databaseSizeMB", rs.getDouble("db_size_mb"));
                }
            }
            
            // 接続情報
            statistics.put("connectionUrl", conn.getMetaData().getURL());
            statistics.put("connectionTime", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            
        } catch (Exception e) {
            e.printStackTrace();
            statistics.put("error", "統計情報の取得に失敗しました: " + e.getMessage());
        }
        
        request.setAttribute("statistics", statistics);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/databaseManagement.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * テーブル一覧を取得
     */
    private void getTableList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Map<String, Object>> tables = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT table_name, table_rows, " +
                          "ROUND((data_length + index_length) / 1024 / 1024, 2) AS size_mb, " +
                          "engine, table_collation " +
                          "FROM information_schema.tables " +
                          "WHERE table_schema = DATABASE() " +
                          "ORDER BY table_name";
            
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, Object> table = new HashMap<>();
                    table.put("name", rs.getString("table_name"));
                    table.put("rows", rs.getLong("table_rows"));
                    table.put("sizeMB", rs.getDouble("size_mb"));
                    table.put("engine", rs.getString("engine"));
                    table.put("collation", rs.getString("table_collation"));
                    tables.add(table);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "テーブル一覧の取得に失敗しました: " + e.getMessage());
        }
        
        request.setAttribute("tables", tables);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/databaseManagement.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * バックアップ実行
     */
    private void performBackup(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

    List<String> backupResults = new ArrayList<>();
    String backupFileName = "jms_backup_" + 
        new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".sql";

    try (Connection conn = DBConnection.getConnection()) {
        // テーブル一覧を取得
        String tableQuery = "SHOW TABLES";
        List<String> tableNames = new ArrayList<>();

        try (PreparedStatement stmt = conn.prepareStatement(tableQuery);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                tableNames.add(rs.getString(1));
            }
        }

        backupResults.add("=== JMSデータベースバックアップ ===");
        backupResults.add("バックアップ日時: " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        backupResults.add("対象テーブル数: " + tableNames.size());
        backupResults.add("");

        // 各テーブルの構造とデータをバックアップ
        for (String tableName : tableNames) {
            try {
                // テーブル構造を取得
                String createTableQuery = "SHOW CREATE TABLE " + tableName;
                try (PreparedStatement stmt = conn.prepareStatement(createTableQuery);
                     ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        backupResults.add("-- テーブル構造: " + tableName);
                        backupResults.add("DROP TABLE IF EXISTS `" + tableName + "`;");
                        backupResults.add(rs.getString(2) + ";");
                        backupResults.add("");
                    }
                }

                // データをエクスポート
                String dataQuery = "SELECT * FROM " + tableName;
                try (PreparedStatement stmt = conn.prepareStatement(dataQuery);
                     ResultSet rs = stmt.executeQuery()) {

                    java.sql.ResultSetMetaData metaData = rs.getMetaData();
                    int columnCount = metaData.getColumnCount();

                    // カラム名を取得
                    StringBuilder columnNames = new StringBuilder();
                    for (int i = 1; i <= columnCount; i++) {
                        if (i > 1) columnNames.append(", ");
                        columnNames.append("`").append(metaData.getColumnName(i)).append("`");
                    }

                    backupResults.add("-- データ: " + tableName);
                    backupResults.add("INSERT INTO `" + tableName + "` (" + columnNames.toString() + ") VALUES");

                    boolean firstRow = true;
                    int rowCount = 0;

                    while (rs.next()) {
                        if (!firstRow) {
                            backupResults.add(",");
                        }

                        StringBuilder values = new StringBuilder("(");
                        for (int i = 1; i <= columnCount; i++) {
                            if (i > 1) values.append(", ");

                            Object value = rs.getObject(i);
                            if (value == null) {
                                values.append("NULL");
                            } else if (value instanceof String) {
                                String strValue = (String) value;
                                strValue = strValue.replace("'", "''");
                                strValue = strValue.replace("\\", "\\\\");
                                values.append("'").append(strValue).append("'");
                            } else if (value instanceof java.sql.Date) {
                                values.append("'").append(value.toString()).append("'");
                            } else if (value instanceof java.sql.Timestamp) {
                                values.append("'").append(value.toString()).append("'");
                            } else {
                                values.append(value.toString());
                            }
                        }
                        values.append(")");
                        backupResults.add(values.toString());
                        firstRow = false;
                        rowCount++;

                        // 大量データ対策：1000行ごとにINSERT文を分割
                        if (rowCount % 1000 == 0) {
                            backupResults.add(";");
                            backupResults.add("");
                            backupResults.add("INSERT INTO `" + tableName + "` (" + columnNames.toString() + ") VALUES");
                            firstRow = true;
                        }
                    }

                    if (rowCount > 0) {
                        backupResults.add(";");
                        backupResults.add("-- " + tableName + " テーブル: " + rowCount + " 行をエクスポート");
                    }
                    backupResults.add("");
                }

            } catch (SQLException e) {
                backupResults.add("-- エラー: " + tableName + " - " + e.getMessage());
            }
        }

        // 直接ダウンロードレスポンス
        response.setContentType("application/octet-stream; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + backupFileName + "\"");
        try (java.io.PrintWriter writer = response.getWriter()) {
            for (String line : backupResults) {
                writer.println(line);
            }
        }
        // ここでreturnして終了。JSPへのフォワードやsetAttributeは絶対にしない
        return;

    } catch (Exception e) {
        e.printStackTrace();
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "バックアップ処理中にエラーが発生しました: " + e.getMessage());
    }
}
    
    /**
     * データベース最適化
     */
    private void optimizeDatabase(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<String> optimizationResults = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // テーブル一覧を取得
            String tableQuery = "SHOW TABLES";
            List<String> tableNames = new ArrayList<>();
            
            try (PreparedStatement stmt = conn.prepareStatement(tableQuery);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tableNames.add(rs.getString(1));
                }
            }
            
            // 各テーブルを最適化
            for (String tableName : tableNames) {
                try {
                    String optimizeQuery = "OPTIMIZE TABLE " + tableName;
                    try (PreparedStatement stmt = conn.prepareStatement(optimizeQuery)) {
                        stmt.executeUpdate();
                        optimizationResults.add("✓ " + tableName + " - 最適化完了");
                    }
                } catch (SQLException e) {
                    optimizationResults.add("✗ " + tableName + " - 最適化失敗: " + e.getMessage());
                }
            }
            
            request.setAttribute("success", "データベース最適化が完了しました。");
            request.setAttribute("optimizationResults", optimizationResults);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "最適化処理中にエラーが発生しました: " + e.getMessage());
        }
        
        getDatabaseStatistics(request, response);
    }
    
    /**
     * データ整合性チェック
     */
    private void checkDataIntegrity(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<String> checkResults = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // 基本的な整合性チェック
            
            // 1. 学生テーブルの整合性チェック
            String studentCheck = "SELECT COUNT(*) FROM students_tbl WHERE student_id IS NULL OR student_id = ''";
            try (PreparedStatement stmt = conn.prepareStatement(studentCheck);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    checkResults.add("⚠️ students_tbl: 学生IDが空のレコードが " + rs.getInt(1) + " 件あります");
                } else {
                    checkResults.add("✓ students_tbl: 学生IDの整合性OK");
                }
            }
            
            // 2. 企業テーブルの整合性チェック
            String companyCheck = "SELECT COUNT(*) FROM companys_tbl WHERE company_name IS NULL OR company_name = ''";
            try (PreparedStatement stmt = conn.prepareStatement(companyCheck);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    checkResults.add("⚠️ companys_tbl: 企業名が空のレコードが " + rs.getInt(1) + " 件あります");
                } else {
                    checkResults.add("✓ companys_tbl: 企業名の整合性OK");
                }
            }
            
            // 3. 外部キー制約チェック（存在する場合）
            try {
                String fkCheck = "SELECT COUNT(*) FROM students_work_place_tbl swp " +
                               "LEFT JOIN students_tbl s ON swp.student_id = s.student_id " +
                               "WHERE s.student_id IS NULL";
                try (PreparedStatement stmt = conn.prepareStatement(fkCheck);
                     ResultSet rs = stmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        checkResults.add("⚠️ students_work_place_tbl: 存在しない学生IDが " + rs.getInt(1) + " 件あります");
                    } else {
                        checkResults.add("✓ students_work_place_tbl: 外部キー整合性OK");
                    }
                }
            } catch (SQLException e) {
                checkResults.add("ℹ️ students_work_place_tbl: テーブルが存在しないか、チェックできませんでした");
            }
            
            request.setAttribute("success", "データ整合性チェックが完了しました。");
            request.setAttribute("checkResults", checkResults);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "整合性チェック中にエラーが発生しました: " + e.getMessage());
        }
        
        getDatabaseStatistics(request, response);
    }
    
    /**
     * バックアップファイルダウンロード
     */
    private void downloadBackupFile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fileName = request.getParameter("file");
        if (fileName == null || fileName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ファイル名が指定されていません");
            return;
        }
        
        // セキュリティ対策：ファイル名の検証
        if (fileName.contains("..") || !fileName.startsWith("jms_backup_")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "無効なファイル名です");
            return;
        }
        
        try {
            String backupDir = getServletContext().getRealPath("/backups");
            java.io.File backupFile = new java.io.File(backupDir, fileName);
            
            if (!backupFile.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "ファイルが見つかりません");
                return;
            }
            
            // レスポンスヘッダーを設定
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setContentLength((int) backupFile.length());
            
            // ファイルをストリームで送信
            try (java.io.FileInputStream fis = new java.io.FileInputStream(backupFile);
                 java.io.OutputStream os = response.getOutputStream()) {
                
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
                os.flush();
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "ファイルダウンロード中にエラーが発生しました");
        }
    }
    
    /**
     * テーブルごとのレコード数を取得
     */
    private Map<String, Integer> getTableCounts(Connection conn) throws SQLException {
        Map<String, Integer> counts = new HashMap<>();
        
        String[] tables = {"students_tbl", "companys_tbl", "occupations_tbl", "work_place_tbl"};
        
        for (String table : tables) {
            try {
                String query = "SELECT COUNT(*) FROM " + table;
                try (PreparedStatement stmt = conn.prepareStatement(query);
                     ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        counts.put(table, rs.getInt(1));
                    }
                }
            } catch (SQLException e) {
                counts.put(table, -1); // テーブルが存在しない場合
            }
        }
        
        return counts;
    }
} 