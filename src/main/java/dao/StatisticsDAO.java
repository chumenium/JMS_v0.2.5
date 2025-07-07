package dao;

import java.sql.*;
import java.util.*;
import utils.DBConnection;

/**
 * 統計データアクセスオブジェクト
 * ダッシュボード用の統計情報を提供
 */
public class StatisticsDAO {
    
    /**
     * ダッシュボード用の統計情報を取得
     */
    public Map<String, Object> getDashboardStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // 学生数
            stats.put("studentCount", getStudentCount(conn));
            
            // 企業数
            stats.put("companyCount", getCompanyCount(conn));
            
            // 採用実績のある企業数
            stats.put("recruitmentCompanyCount", getRecruitmentCompanyCount(conn));
            
            // 面接数
            stats.put("interviewCount", getInterviewCount(conn));
            
            // 就職活動状況別の学生数
            stats.put("jobHuntingStats", getJobHuntingStatistics(conn));
            
            // 学科別の学生数
            stats.put("departmentStats", getDepartmentStatistics(conn));
            
            // 卒業年別の学生数
            stats.put("graduationYearStats", getGraduationYearStatistics(conn));
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return stats;
    }
    
    /**
     * 学生数を取得
     */
    private int getStudentCount(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM students_tbl";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * 企業数を取得
     */
    private int getCompanyCount(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM companys_tbl";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * 採用実績のある企業数を取得
     */
    private int getRecruitmentCompanyCount(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM companys_tbl WHERE recruitment_results = true";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * 面接数を取得
     */
    private int getInterviewCount(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM interviews_tbl";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * 就職活動状況別の統計を取得
     */
    private List<Map<String, Object>> getJobHuntingStatistics(Connection conn) throws SQLException {
        List<Map<String, Object>> stats = new ArrayList<>();
        String sql = "SELECT job_hunting_status, COUNT(*) as count FROM students_tbl GROUP BY job_hunting_status";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> stat = new HashMap<>();
                stat.put("status", rs.getString("job_hunting_status"));
                stat.put("count", rs.getInt("count"));
                stats.add(stat);
            }
        }
        return stats;
    }
    
    /**
     * 学科別の統計を取得
     */
    private List<Map<String, Object>> getDepartmentStatistics(Connection conn) throws SQLException {
        List<Map<String, Object>> stats = new ArrayList<>();
        String sql = "SELECT department, COUNT(*) as count FROM students_tbl GROUP BY department";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> stat = new HashMap<>();
                stat.put("department", rs.getString("department"));
                stat.put("count", rs.getInt("count"));
                stats.add(stat);
            }
        }
        return stats;
    }
    
    /**
     * 卒業年別の統計を取得
     */
    private List<Map<String, Object>> getGraduationYearStatistics(Connection conn) throws SQLException {
        List<Map<String, Object>> stats = new ArrayList<>();
        String sql = "SELECT graduation_year, COUNT(*) as count FROM students_tbl GROUP BY graduation_year ORDER BY graduation_year";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> stat = new HashMap<>();
                stat.put("year", rs.getInt("graduation_year"));
                stat.put("count", rs.getInt("count"));
                stats.add(stat);
            }
        }
        return stats;
    }
    
    /**
     * 最近の面接情報を取得
     */
    public List<Map<String, Object>> getRecentInterviews(int limit) {
        List<Map<String, Object>> interviews = new ArrayList<>();
        String sql = "SELECT i.*, s.name as student_name, c.company_name FROM interviews_tbl i " +
                    "LEFT JOIN students_tbl s ON i.student_id = s.student_id " +
                    "LEFT JOIN companys_tbl c ON i.company_id = c.companys_id " +
                    "ORDER BY i.interview_date DESC LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> interview = new HashMap<>();
                interview.put("interview_id", rs.getInt("interview_id"));
                interview.put("student_id", rs.getString("student_id"));
                interview.put("student_name", rs.getString("student_name"));
                interview.put("company_id", rs.getInt("company_id"));
                interview.put("company_name", rs.getString("company_name"));
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
     * 月別の面接数を取得
     */
    public List<Map<String, Object>> getMonthlyInterviewStats(int year) {
        List<Map<String, Object>> stats = new ArrayList<>();
        String sql = "SELECT MONTH(interview_date) as month, COUNT(*) as count " +
                    "FROM interviews_tbl WHERE YEAR(interview_date) = ? " +
                    "GROUP BY MONTH(interview_date) ORDER BY month";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, year);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> stat = new HashMap<>();
                stat.put("month", rs.getInt("month"));
                stat.put("count", rs.getInt("count"));
                stats.add(stat);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return stats;
    }
} 