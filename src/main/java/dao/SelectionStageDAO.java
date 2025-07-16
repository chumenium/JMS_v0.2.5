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
 * 面接・試験データアクセスオブジェクト
 * 面接・試験情報のCRUD操作を提供
 */
public class InterviewDAO {
    
    /**
     * 面接・試験情報を登録
     */
    public boolean addInterviewExam(String studentId, String companyName, String jobTitle, 
                                  String examType, Date examDate, String examVenue, 
                                  String examStartTime, String examEndTime, String interviewType,
                                  Date interviewDate, String interviewVenue, String interviewStartTime,
                                  String interviewEndTime, String notes) {
        String sql = "INSERT INTO interview_exam_tbl (student_id, company_name, job_title, exam_type, exam_date, exam_venue, exam_start_time, exam_end_time, interview_type, interview_date, interview_venue, interview_start_time, interview_end_time, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, studentId);
            stmt.setString(2, companyName);
            stmt.setString(3, jobTitle);
            stmt.setString(4, examType);
            stmt.setDate(5, new java.sql.Date(examDate.getTime()));
            stmt.setString(6, examVenue);
            stmt.setString(7, examStartTime);
            stmt.setString(8, examEndTime);
            stmt.setString(9, interviewType);
            stmt.setDate(10, new java.sql.Date(interviewDate.getTime()));
            stmt.setString(11, interviewVenue);
            stmt.setString(12, interviewStartTime);
            stmt.setString(13, interviewEndTime);
            stmt.setString(14, notes);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 学生IDで面接・試験情報一覧を取得
     */
    public List<Map<String, Object>> getInterviewExamsByStudentId(String studentId) {
        List<Map<String, Object>> interviews = new ArrayList<>();
        String sql = "SELECT * FROM interview_exam_tbl WHERE student_id = ? ORDER BY exam_date DESC, interview_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, studentId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> interview = new HashMap<>();
                interview.put("id", rs.getInt("id"));
                interview.put("student_id", rs.getString("student_id"));
                interview.put("company_name", rs.getString("company_name"));
                interview.put("job_title", rs.getString("job_title"));
                interview.put("exam_type", rs.getString("exam_type"));
                interview.put("exam_date", rs.getDate("exam_date"));
                interview.put("exam_venue", rs.getString("exam_venue"));
                interview.put("exam_start_time", rs.getString("exam_start_time"));
                interview.put("exam_end_time", rs.getString("exam_end_time"));
                interview.put("interview_type", rs.getString("interview_type"));
                interview.put("interview_date", rs.getDate("interview_date"));
                interview.put("interview_venue", rs.getString("interview_venue"));
                interview.put("interview_start_time", rs.getString("interview_start_time"));
                interview.put("interview_end_time", rs.getString("interview_end_time"));
                interview.put("notes", rs.getString("notes"));
                interviews.add(interview);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return interviews;
    }
    
    /**
     * 面接・試験情報を更新
     */
    public boolean updateInterviewExam(int id, String companyName, String jobTitle, 
                                     String examType, Date examDate, String examVenue, 
                                     String examStartTime, String examEndTime, String interviewType,
                                     Date interviewDate, String interviewVenue, String interviewStartTime,
                                     String interviewEndTime, String notes) {
        String sql = "UPDATE interview_exam_tbl SET company_name=?, job_title=?, exam_type=?, exam_date=?, exam_venue=?, exam_start_time=?, exam_end_time=?, interview_type=?, interview_date=?, interview_venue=?, interview_start_time=?, interview_end_time=?, notes=? WHERE id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, companyName);
            stmt.setString(2, jobTitle);
            stmt.setString(3, examType);
            stmt.setDate(4, new java.sql.Date(examDate.getTime()));
            stmt.setString(5, examVenue);
            stmt.setString(6, examStartTime);
            stmt.setString(7, examEndTime);
            stmt.setString(8, interviewType);
            stmt.setDate(9, new java.sql.Date(interviewDate.getTime()));
            stmt.setString(10, interviewVenue);
            stmt.setString(11, interviewStartTime);
            stmt.setString(12, interviewEndTime);
            stmt.setString(13, notes);
            stmt.setInt(14, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 面接・試験情報を削除
     */
    public boolean deleteInterviewExam(int id) {
        String sql = "DELETE FROM interview_exam_tbl WHERE id=?";
        
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
     * 全ての面接・試験情報を取得
     */
    public List<Map<String, Object>> getAllInterviewExams() {
        List<Map<String, Object>> interviews = new ArrayList<>();
        String sql = "SELECT ie.*, s.name as student_name FROM interview_exam_tbl ie LEFT JOIN students_tbl s ON ie.student_id = s.student_id ORDER BY ie.exam_date DESC, ie.interview_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> interview = new HashMap<>();
                interview.put("id", rs.getInt("id"));
                interview.put("student_id", rs.getString("student_id"));
                interview.put("student_name", rs.getString("student_name"));
                interview.put("company_name", rs.getString("company_name"));
                interview.put("job_title", rs.getString("job_title"));
                interview.put("exam_type", rs.getString("exam_type"));
                interview.put("exam_date", rs.getDate("exam_date"));
                interview.put("exam_venue", rs.getString("exam_venue"));
                interview.put("exam_start_time", rs.getString("exam_start_time"));
                interview.put("exam_end_time", rs.getString("exam_end_time"));
                interview.put("interview_type", rs.getString("interview_type"));
                interview.put("interview_date", rs.getDate("interview_date"));
                interview.put("interview_venue", rs.getString("interview_venue"));
                interview.put("interview_start_time", rs.getString("interview_start_time"));
                interview.put("interview_end_time", rs.getString("interview_end_time"));
                interview.put("notes", rs.getString("notes"));
                interviews.add(interview);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return interviews;
    }
    
    /**
     * 全ての面接情報を取得（InterviewExamInputServlet用）
     */
    public List<Map<String, Object>> getAllInterviews() {
        return getAllInterviewExams();
    }
    
    /**
     * 面接情報を登録（InterviewExamInputServlet用）
     */
    public boolean addInterview(String studentId, int companyId, Date interviewDate, 
                              String interviewType, String status, String notes) {
        String sql = "INSERT INTO interview_exam_tbl (student_id, company_id, interview_date, interview_type, status, notes) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, studentId);
            stmt.setInt(2, companyId);
            stmt.setDate(3, new java.sql.Date(interviewDate.getTime()));
            stmt.setString(4, interviewType);
            stmt.setString(5, status);
            stmt.setString(6, notes);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
} 