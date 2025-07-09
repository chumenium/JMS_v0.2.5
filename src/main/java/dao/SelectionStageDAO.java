package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import utils.DBConnection;

/**
 * 選考段階データアクセスオブジェクト
 * 選考段階情報のCRUD操作を提供
 */
public class SelectionStageDAO {
    
    /**
     * 選考段階情報を登録
     */
    public boolean addSelectionStage(String studentId, String companyName, String jobTitle, 
                                   String currentStage, Date applyDate, String notes) {
        String sql = "INSERT INTO selection_stage_tbl (student_id, company_name, job_title, current_stage, apply_date, notes) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, studentId);
            stmt.setString(2, companyName);
            stmt.setString(3, jobTitle);
            stmt.setString(4, currentStage);
            stmt.setDate(5, new java.sql.Date(applyDate.getTime()));
            stmt.setString(6, notes);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 学生IDで選考段階情報一覧を取得
     */
    public List<Map<String, Object>> getSelectionStagesByStudentId(String studentId) {
        List<Map<String, Object>> stages = new ArrayList<>();
        String sql = "SELECT * FROM selection_stage_tbl WHERE student_id = ? ORDER BY apply_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> stage = new HashMap<>();
                stage.put("id", rs.getInt("id"));
                stage.put("student_id", rs.getString("student_id"));
                stage.put("company_name", rs.getString("company_name"));
                stage.put("job_title", rs.getString("job_title"));
                stage.put("current_stage", rs.getString("current_stage"));
                stage.put("apply_date", rs.getDate("apply_date"));
                stage.put("notes", rs.getString("notes"));
                stages.add(stage);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return stages;
    }
    
    /**
     * 選考段階を更新
     */
    public boolean updateSelectionStage(int id, String currentStage, String notes) {
        String sql = "UPDATE selection_stage_tbl SET current_stage=?, notes=? WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, currentStage);
            stmt.setString(2, notes);
            stmt.setInt(3, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 選考段階を進行させる
     */
    public boolean advanceSelectionStage(int id, String newStage) {
        String sql = "UPDATE selection_stage_tbl SET current_stage=? WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newStage);
            stmt.setInt(2, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 選考段階を却下状態にする
     */
    public boolean rejectSelectionStage(int id) {
        String sql = "UPDATE selection_stage_tbl SET current_stage='不合格' WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 選考段階情報を削除
     */
    public boolean deleteSelectionStage(int id) {
        String sql = "DELETE FROM selection_stage_tbl WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 全ての選考段階情報を取得
     */
    public List<Map<String, Object>> getAllSelectionStages() {
        List<Map<String, Object>> stages = new ArrayList<>();
        String sql = "SELECT ss.*, s.name as student_name FROM selection_stage_tbl ss LEFT JOIN students_tbl s ON ss.student_id = s.student_id ORDER BY ss.apply_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> stage = new HashMap<>();
                stage.put("id", rs.getInt("id"));
                stage.put("student_id", rs.getString("student_id"));
                stage.put("student_name", rs.getString("student_name"));
                stage.put("company_name", rs.getString("company_name"));
                stage.put("job_title", rs.getString("job_title"));
                stage.put("current_stage", rs.getString("current_stage"));
                stage.put("apply_date", rs.getDate("apply_date"));
                stage.put("notes", rs.getString("notes"));
                stages.add(stage);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return stages;
    }
    
    /**
     * 選考段階の統計情報を取得
     */
    public Map<String, Integer> getSelectionStageStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT current_stage, COUNT(*) as count FROM selection_stage_tbl GROUP BY current_stage";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                stats.put(rs.getString("current_stage"), rs.getInt("count"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return stats;
    }
} 