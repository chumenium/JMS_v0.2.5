package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import utils.DBConnection;

/**
 * 選考ステージデータアクセスオブジェクト
 * 選考ステージ情報のCRUD操作を提供
 */
public class SelectionStageDAO {
    
    /**
     * 選考ステージ情報を登録
     */
    public boolean addSelectionStages(String companyId, String studentId, String companyName, 
                                    String studentName, String selectionStatus, String[] stageTypes,
                                    String[] stageDates, String[] stageTimes, String[] stageFormats) {
        
        String sql = "INSERT INTO job_activity_detail_tbl (student_id, companys_id, selection_id, date, time, venue, remarks) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // トランザクション開始
            conn.setAutoCommit(false);
            
            try {
                for (int i = 0; i < stageTypes.length; i++) {
                    if (stageTypes[i] != null && !stageTypes[i].trim().isEmpty()) {
                        // selection_idを取得（selection_tblから）
                        int selectionId = getSelectionIdByName(stageTypes[i]);
                        
                        stmt.setString(1, studentId);
                        stmt.setInt(2, Integer.parseInt(companyId));
                        stmt.setInt(3, selectionId);
                        
                        // 日付の処理
                        if (stageDates != null && i < stageDates.length && 
                            stageDates[i] != null && !stageDates[i].trim().isEmpty()) {
                            stmt.setDate(4, Date.valueOf(stageDates[i]));
                        } else {
                            stmt.setNull(4, java.sql.Types.DATE);
                        }
                        
                        // 時間の処理
                        if (stageTimes != null && i < stageTimes.length && 
                            stageTimes[i] != null && !stageTimes[i].trim().isEmpty()) {
                            stmt.setTime(5, Time.valueOf(stageTimes[i] + ":00"));
                        } else {
                            stmt.setNull(5, java.sql.Types.TIME);
                        }
                        
                        // 実施形式をvenueフィールドに格納
                        String venue = "";
                        if (stageFormats != null && i < stageFormats.length && stageFormats[i] != null) {
                            venue = stageFormats[i];
                        }
                        stmt.setString(6, venue);
                        
                        // 備考の処理
                        String remarks = "選考ステータス: " + selectionStatus;
                        stmt.setString(7, remarks);
                        
                        stmt.executeUpdate();
                    }
                }
                
                // job_activity_tblに選考ステータスを登録・更新
                updateJobActivityStatus(Integer.parseInt(studentId), Integer.parseInt(companyId), selectionStatus);
                
                // トランザクションコミット
                conn.commit();
                return true;
                
            } catch (SQLException e) {
                // エラーが発生した場合はロールバック
                conn.rollback();
                throw e;
            }
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 選考種別名からselection_idを取得
     */
    private int getSelectionIdByName(String selectionName) {
        String sql = "SELECT selection_id FROM selection_tbl WHERE selection_name = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, selectionName);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("selection_id");
            } else {
                // 存在しない場合は新規作成
                return createSelectionType(selectionName);
            }
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return 1; // デフォルト値
        }
    }
    
    /**
     * 新しい選考種別を作成
     */
    private int createSelectionType(String selectionName) {
        String sql = "INSERT INTO selection_tbl (selection_name) VALUES (?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, selectionName);
            stmt.executeUpdate();
            
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return 1; // デフォルト値
    }
    
    /**
     * job_activity_tblの選考ステータスを更新
     */
    public boolean updateJobActivityStatus(int studentId, int companyId, String selectionStatus) {
        String sql = "INSERT INTO job_activity_tbl (student_id, companys_id, activity_status, reporte_date) " +
                    "VALUES (?, ?, ?, CURDATE()) " +
                    "ON DUPLICATE KEY UPDATE activity_status = ?, reporte_date = CURDATE()";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, studentId);
            stmt.setInt(2, companyId);
            stmt.setString(3, selectionStatus);
            stmt.setString(4, selectionStatus);
            
            stmt.executeUpdate();
            return true;
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 学生IDで選考ステージ情報一覧を取得
     */
    public List<Object> getSelectionStagesByStudentId(String studentId) {
        List<Object> stages = new ArrayList<>();
        String sql = "SELECT jad.*, s.selection_name, c.company_name, st.name as student_name " +
                    "FROM job_activity_detail_tbl jad " +
                    "LEFT JOIN selection_tbl s ON jad.selection_id = s.selection_id " +
                    "LEFT JOIN companys_tbl c ON jad.companys_id = c.companys_id " +
                    "LEFT JOIN students_tbl st ON jad.student_id = st.student_id " +
                    "WHERE jad.student_id = ? ORDER BY jad.date DESC, jad.time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> stage = new HashMap<>();
                stage.put("student_id", rs.getString("student_id"));
                stage.put("companys_id", rs.getInt("companys_id"));
                stage.put("selection_id", rs.getInt("selection_id"));
                stage.put("selection_name", rs.getString("selection_name"));
                stage.put("company_name", rs.getString("company_name"));
                stage.put("student_name", rs.getString("student_name"));
                stage.put("date", rs.getDate("date"));
                stage.put("time", rs.getTime("time"));
                stage.put("venue", rs.getString("venue"));
                stage.put("remarks", rs.getString("remarks"));
                stages.add(stage);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return stages;
    }
    
    /**
     * 企業IDで選考ステージ情報一覧を取得
     */
    public List<Object> getSelectionStagesByCompanyId(String companyId) {
        List<Object> stages = new ArrayList<>();
        String sql = "SELECT jad.*, s.selection_name, c.company_name, st.name as student_name " +
                    "FROM job_activity_detail_tbl jad " +
                    "LEFT JOIN selection_tbl s ON jad.selection_id = s.selection_id " +
                    "LEFT JOIN companys_tbl c ON jad.companys_id = c.companys_id " +
                    "LEFT JOIN students_tbl st ON jad.student_id = st.student_id " +
                    "WHERE jad.companys_id = ? ORDER BY jad.date DESC, jad.time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, Integer.parseInt(companyId));
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> stage = new HashMap<>();
                stage.put("student_id", rs.getString("student_id"));
                stage.put("companys_id", rs.getInt("companys_id"));
                stage.put("selection_id", rs.getInt("selection_id"));
                stage.put("selection_name", rs.getString("selection_name"));
                stage.put("company_name", rs.getString("company_name"));
                stage.put("student_name", rs.getString("student_name"));
                stage.put("date", rs.getDate("date"));
                stage.put("time", rs.getTime("time"));
                stage.put("venue", rs.getString("venue"));
                stage.put("remarks", rs.getString("remarks"));
                stages.add(stage);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return stages;
    }
    
    /**
     * 選考ステージ情報を更新
     */
    public boolean updateSelectionStage(String studentId, int companyId, int selectionId, 
                                     Date stageDate, Time stageTime, String stageVenue, String stageRemarks) {
        String sql = "UPDATE job_activity_detail_tbl SET date=?, time=?, venue=?, remarks=? " +
                    "WHERE student_id=? AND companys_id=? AND selection_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, stageDate);
            stmt.setTime(2, stageTime);
            stmt.setString(3, stageVenue);
            stmt.setString(4, stageRemarks);
            stmt.setString(5, studentId);
            stmt.setInt(6, companyId);
            stmt.setInt(7, selectionId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 選考ステージ情報を削除
     */
    public boolean deleteSelectionStage(String studentId, int companyId, int selectionId) {
        String sql = "DELETE FROM job_activity_detail_tbl WHERE student_id=? AND companys_id=? AND selection_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, studentId);
            stmt.setInt(2, companyId);
            stmt.setInt(3, selectionId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 企業と学生の両方を指定して選考ステージ情報を取得
     */
    public List<Object> getSelectionStagesByCompanyAndStudent(String companyId, String studentId) {
        List<Object> stages = new ArrayList<>();
        String sql = "SELECT jad.*, s.selection_name, c.company_name, st.name as student_name " +
                    "FROM job_activity_detail_tbl jad " +
                    "LEFT JOIN selection_tbl s ON jad.selection_id = s.selection_id " +
                    "LEFT JOIN companys_tbl c ON jad.companys_id = c.companys_id " +
                    "LEFT JOIN students_tbl st ON jad.student_id = st.student_id " +
                    "WHERE jad.companys_id = ? AND jad.student_id = ? " +
                    "ORDER BY jad.date DESC, jad.time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, Integer.parseInt(companyId));
            stmt.setString(2, studentId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> stage = new HashMap<>();
                    stage.put("student_id", rs.getString("student_id"));
                    stage.put("companys_id", rs.getInt("companys_id"));
                    stage.put("selection_id", rs.getInt("selection_id"));
                    stage.put("selection_name", rs.getString("selection_name"));
                    stage.put("company_name", rs.getString("company_name"));
                    stage.put("student_name", rs.getString("student_name"));
                    stage.put("date", rs.getDate("date"));
                    stage.put("time", rs.getTime("time"));
                    stage.put("venue", rs.getString("venue"));
                    stage.put("remarks", rs.getString("remarks"));
                    stages.add(stage);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return stages;
    }
    
    /**
     * 全ての選考ステージ情報を取得
     */
    public List<Object> getAllSelectionStages() {
        List<Object> stages = new ArrayList<>();
        String sql = "SELECT jad.*, s.selection_name, c.company_name, st.name as student_name " +
                    "FROM job_activity_detail_tbl jad " +
                    "LEFT JOIN selection_tbl s ON jad.selection_id = s.selection_id " +
                    "LEFT JOIN companys_tbl c ON jad.companys_id = c.companys_id " +
                    "LEFT JOIN students_tbl st ON jad.student_id = st.student_id " +
                    "ORDER BY jad.date DESC, jad.time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> stage = new HashMap<>();
                stage.put("student_id", rs.getString("student_id"));
                stage.put("companys_id", rs.getInt("companys_id"));
                stage.put("selection_id", rs.getInt("selection_id"));
                stage.put("selection_name", rs.getString("selection_name"));
                stage.put("company_name", rs.getString("company_name"));
                stage.put("student_name", rs.getString("student_name"));
                stage.put("date", rs.getDate("date"));
                stage.put("time", rs.getTime("time"));
                stage.put("venue", rs.getString("venue"));
                stage.put("remarks", rs.getString("remarks"));
                stages.add(stage);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return stages;
    }
    
    /**
     * 選考ステージ種類を指定して選考ステージ情報を取得
     */
    public List<Object> getSelectionStagesByType(String selectionType) {
        List<Object> stages = new ArrayList<>();
        String sql = "SELECT jad.*, s.selection_name, c.company_name, st.name as student_name " +
                    "FROM job_activity_detail_tbl jad " +
                    "LEFT JOIN selection_tbl s ON jad.selection_id = s.selection_id " +
                    "LEFT JOIN companys_tbl c ON jad.companys_id = c.companys_id " +
                    "LEFT JOIN students_tbl st ON jad.student_id = st.student_id " +
                    "WHERE s.selection_name = ? " +
                    "ORDER BY jad.date DESC, jad.time DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, selectionType);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> stage = new HashMap<>();
                    stage.put("student_id", rs.getString("student_id"));
                    stage.put("companys_id", rs.getInt("companys_id"));
                    stage.put("selection_id", rs.getInt("selection_id"));
                    stage.put("selection_name", rs.getString("selection_name"));
                    stage.put("company_name", rs.getString("company_name"));
                    stage.put("student_name", rs.getString("student_name"));
                    stage.put("date", rs.getDate("date"));
                    stage.put("time", rs.getTime("time"));
                    stage.put("venue", rs.getString("venue"));
                    stage.put("remarks", rs.getString("remarks"));
                    stages.add(stage);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return stages;
    }
    

    
    // 選考ステージの基本情報を取得
    public Map<String, Object> getSelectionStageById(int studentId, int companyId, int selectionId) {
        String sql = "SELECT ja.*, c.company_name, st.name as student_name " +
                    "FROM job_activity_tbl ja " +
                    "LEFT JOIN companys_tbl c ON ja.companys_id = c.companys_id " +
                    "LEFT JOIN students_tbl st ON ja.student_id = st.student_id " +
                    "WHERE ja.student_id = ? AND ja.companys_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, studentId);
            stmt.setInt(2, companyId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> stage = new HashMap<>();
                    stage.put("student_id", rs.getString("student_id"));
                    stage.put("companys_id", rs.getInt("companys_id"));
                    stage.put("company_name", rs.getString("company_name"));
                    stage.put("student_name", rs.getString("student_name"));
                    stage.put("status", rs.getString("activity_status"));
                    return stage;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // 選考ステージの詳細情報を取得
    public List<Map<String, Object>> getSelectionStageDetails(int studentId, int companyId) {
        List<Map<String, Object>> details = new ArrayList<>();
        String sql = "SELECT jad.*, s.selection_name " +
                    "FROM job_activity_detail_tbl jad " +
                    "LEFT JOIN selection_tbl s ON jad.selection_id = s.selection_id " +
                    "WHERE jad.student_id = ? AND jad.companys_id = ? " +
                    "ORDER BY jad.date, jad.time";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, studentId);
            stmt.setInt(2, companyId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> detail = new HashMap<>();
                    detail.put("selection_id", rs.getInt("selection_id"));
                    detail.put("selection_name", rs.getString("selection_name"));
                    detail.put("date", rs.getDate("date"));
                    detail.put("time", rs.getTime("time"));
                    detail.put("venue", rs.getString("venue"));
                    detail.put("remarks", rs.getString("remarks"));
                    details.add(detail);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return details;
    }
    
    // 選考ステージ詳細を削除
    public boolean deleteSelectionStageDetails(int studentId, int companyId) {
        String sql = "DELETE FROM job_activity_detail_tbl WHERE student_id = ? AND companys_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, studentId);
            stmt.setInt(2, companyId);
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 選考ステージ基本情報を削除
    public boolean deleteJobActivity(int studentId, int companyId) {
        String sql = "DELETE FROM job_activity_tbl WHERE student_id = ? AND companys_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, studentId);
            stmt.setInt(2, companyId);
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 選考ステージ詳細を追加
    public boolean addSelectionStageDetail(int studentId, int companyId, String selectionType, 
                                        String date, String time, String venue, String remarks) {
        try {
            // 選考ステージタイプのIDを取得
            int selectionId = getSelectionIdByName(selectionType);
            if (selectionId == -1) {
                selectionId = createSelectionType(selectionType);
            }
            
            String sql = "INSERT INTO job_activity_detail_tbl (student_id, companys_id, selection_id, date, time, venue, remarks) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                
                stmt.setInt(1, studentId);
                stmt.setInt(2, companyId);
                stmt.setInt(3, selectionId);
                stmt.setString(4, date);
                stmt.setString(5, time);
                stmt.setString(6, venue);
                stmt.setString(7, remarks);
                
                int result = stmt.executeUpdate();
                return result > 0;
                
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 選考種別一覧を取得
     */
    public List<Map<String, Object>> getAllSelectionTypes() {
        List<Map<String, Object>> selectionTypes = new ArrayList<>();
        String sql = "SELECT * FROM selection_tbl ORDER BY selection_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> selectionType = new HashMap<>();
                selectionType.put("selection_id", rs.getInt("selection_id"));
                selectionType.put("selection_name", rs.getString("selection_name"));
                selectionTypes.add(selectionType);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return selectionTypes;
    }
} 