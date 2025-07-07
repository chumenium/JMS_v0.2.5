package dao;

import java.sql.*;
import java.util.*;
import utils.DBConnection;

/**
 * 面接・選考データアクセスオブジェクト
 * 面接・選考情報のCRUD操作を提供
 */
public class InterviewDAO {
    
    /**
     * 全面接情報を取得
     */
    public List<Map<String, Object>> getAllInterviews() {
        List<Map<String, Object>> interviews = new ArrayList<>();
        String sql = "SELECT * FROM interviews_tbl ORDER BY interview_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> interview = new HashMap<>();
                interview.put("interview_id", rs.getInt("interview_id"));
                interview.put("student_id", rs.getString("student_id"));
                interview.put("company_id", rs.getInt("company_id"));
                interview.put("interview_date", rs.getDate("interview_date"));
                interview.put("interview_type", rs.getString("interview_type"));
                interview.put("status", rs.getString("status"));
                interview.put("notes", rs.getString("notes"));
                interviews.add(interview);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return interviews;
    }
    
    /**
     * 面接情報を登録
     */
    public boolean addInterview(String studentId, int companyId, java.sql.Date interviewDate, 
                              String interviewType, String status, String notes) {
        String sql = "INSERT INTO interviews_tbl (student_id, company_id, interview_date, interview_type, status, notes) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, studentId);
            stmt.setInt(2, companyId);
            stmt.setDate(3, interviewDate);
            stmt.setString(4, interviewType);
            stmt.setString(5, status);
            stmt.setString(6, notes);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 面接情報を更新
     */
    public boolean updateInterview(int interviewId, String studentId, int companyId, 
                                 java.sql.Date interviewDate, String interviewType, String status, String notes) {
        String sql = "UPDATE interviews_tbl SET student_id=?, company_id=?, interview_date=?, interview_type=?, status=?, notes=? WHERE interview_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, studentId);
            stmt.setInt(2, companyId);
            stmt.setDate(3, interviewDate);
            stmt.setString(4, interviewType);
            stmt.setString(5, status);
            stmt.setString(6, notes);
            stmt.setInt(7, interviewId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 面接情報を削除
     */
    public boolean deleteInterview(int interviewId) {
        String sql = "DELETE FROM interviews_tbl WHERE interview_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, interviewId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 面接IDで面接情報を取得
     */
    public Map<String, Object> getInterviewById(int interviewId) {
        String sql = "SELECT * FROM interviews_tbl WHERE interview_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, interviewId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Map<String, Object> interview = new HashMap<>();
                interview.put("interview_id", rs.getInt("interview_id"));
                interview.put("student_id", rs.getString("student_id"));
                interview.put("company_id", rs.getInt("company_id"));
                interview.put("interview_date", rs.getDate("interview_date"));
                interview.put("interview_type", rs.getString("interview_type"));
                interview.put("status", rs.getString("status"));
                interview.put("notes", rs.getString("notes"));
                return interview;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * 学生IDで面接情報を取得
     */
    public List<Map<String, Object>> getInterviewsByStudentId(String studentId) {
        List<Map<String, Object>> interviews = new ArrayList<>();
        String sql = "SELECT * FROM interviews_tbl WHERE student_id=? ORDER BY interview_date";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> interview = new HashMap<>();
                interview.put("interview_id", rs.getInt("interview_id"));
                interview.put("student_id", rs.getString("student_id"));
                interview.put("company_id", rs.getInt("company_id"));
                interview.put("interview_date", rs.getDate("interview_date"));
                interview.put("interview_type", rs.getString("interview_type"));
                interview.put("status", rs.getString("status"));
                interview.put("notes", rs.getString("notes"));
                interviews.add(interview);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return interviews;
    }
    
    /**
     * 企業IDで面接情報を取得
     */
    public List<Map<String, Object>> getInterviewsByCompanyId(int companyId) {
        List<Map<String, Object>> interviews = new ArrayList<>();
        String sql = "SELECT * FROM interviews_tbl WHERE company_id=? ORDER BY interview_date";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, companyId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> interview = new HashMap<>();
                interview.put("interview_id", rs.getInt("interview_id"));
                interview.put("student_id", rs.getString("student_id"));
                interview.put("company_id", rs.getInt("company_id"));
                interview.put("interview_date", rs.getDate("interview_date"));
                interview.put("interview_type", rs.getString("interview_type"));
                interview.put("status", rs.getString("status"));
                interview.put("notes", rs.getString("notes"));
                interviews.add(interview);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return interviews;
    }
    
    /**
     * 面接数を取得
     */
    public int getInterviewCount() {
        String sql = "SELECT COUNT(*) FROM interviews_tbl";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return 0;
    }
} 