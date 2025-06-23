package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import utils.DBConnection;

public class DropdownDataDAO {
    
    /**
     * クラス一覧を取得
     */
    public List<String> getClassList() throws SQLException, ClassNotFoundException {
        List<String> classList = new ArrayList<>();
        String sql = "SELECT DISTINCT class_name FROM classes ORDER BY class_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                classList.add(rs.getString("class_name"));
            }
        }
        return classList;
    }
    
    /**
     * 在籍状況一覧を取得
     */
    public List<String> getEnrollmentStatusList() throws SQLException, ClassNotFoundException {
        List<String> statusList = new ArrayList<>();
        String sql = "SELECT DISTINCT status_name FROM enrollment_status ORDER BY status_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                statusList.add(rs.getString("status_name"));
            }
        }
        return statusList;
    }
    
    /**
     * 斡旋一覧を取得
     */
    public List<String> getAssistanceList() throws SQLException, ClassNotFoundException {
        List<String> assistanceList = new ArrayList<>();
        String sql = "SELECT DISTINCT assistance_name FROM assistance_types ORDER BY assistance_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                assistanceList.add(rs.getString("assistance_name"));
            }
        }
        return assistanceList;
    }
    
    /**
     * 第一希望業種一覧を取得
     */
    public List<String> getFirstChoiceIndustryList() throws SQLException, ClassNotFoundException {
        List<String> industryList = new ArrayList<>();
        String sql = "SELECT DISTINCT industry_name FROM industries ORDER BY industry_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                industryList.add(rs.getString("industry_name"));
            }
        }
        return industryList;
    }
    
    /**
     * 卒業年一覧を取得
     */
    public List<Integer> getGraduationYearList() throws SQLException, ClassNotFoundException {
        List<Integer> yearList = new ArrayList<>();
        String sql = "SELECT DISTINCT graduation_year FROM students WHERE graduation_year IS NOT NULL ORDER BY graduation_year";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                yearList.add(rs.getInt("graduation_year"));
            }
        }
        return yearList;
    }
} 