package dao;

import java.sql.*;
import java.util.*;
import utils.DBConnection;

/**
 * 企業データアクセスオブジェクト
 * 企業情報のCRUD操作を提供
 */
public class CompanyDAO {
    
    /**
     * 全企業一覧を取得
     */
    public List<Map<String, Object>> getAllCompanies() {
        List<Map<String, Object>> companies = new ArrayList<>();
        String sql = "SELECT * FROM companys_tbl ORDER BY companys_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> company = new HashMap<>();
                company.put("companys_id", rs.getInt("companys_id"));
                company.put("company_name", rs.getString("company_name"));
                company.put("post_code", rs.getString("post_code"));
                company.put("address", rs.getString("address"));
                company.put("tel", rs.getString("tel"));
                company.put("mail_address", rs.getString("mail_address"));
                company.put("manager_name", rs.getString("manager_name"));
                company.put("recruitment_results", rs.getBoolean("recruitment_results"));
                companies.add(company);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return companies;
    }
    
    /**
     * 企業を登録
     */
    public boolean addCompany(String companyName, String postCode, String address, 
                            String tel, String mailAddress, String managerName, boolean recruitmentResults) {
        String sql = "INSERT INTO companys_tbl (company_name, post_code, address, tel, mail_address, manager_name, recruitment_results) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, companyName);
            stmt.setString(2, postCode);
            stmt.setString(3, address);
            stmt.setString(4, tel);
            stmt.setString(5, mailAddress);
            stmt.setString(6, managerName);
            stmt.setBoolean(7, recruitmentResults);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 企業情報を更新
     */
    public boolean updateCompany(int companyId, String companyName, String postCode, String address, 
                               String tel, String mailAddress, String managerName, boolean recruitmentResults) {
        String sql = "UPDATE companys_tbl SET company_name=?, post_code=?, address=?, tel=?, mail_address=?, manager_name=?, recruitment_results=? WHERE companys_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, companyName);
            stmt.setString(2, postCode);
            stmt.setString(3, address);
            stmt.setString(4, tel);
            stmt.setString(5, mailAddress);
            stmt.setString(6, managerName);
            stmt.setBoolean(7, recruitmentResults);
            stmt.setInt(8, companyId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 企業を削除
     */
    public boolean deleteCompany(int companyId) {
        String sql = "DELETE FROM companys_tbl WHERE companys_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, companyId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 企業IDで企業情報を取得
     */
    public Map<String, Object> getCompanyById(int companyId) {
        String sql = "SELECT * FROM companys_tbl WHERE companys_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, companyId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Map<String, Object> company = new HashMap<>();
                company.put("companys_id", rs.getInt("companys_id"));
                company.put("company_name", rs.getString("company_name"));
                company.put("post_code", rs.getString("post_code"));
                company.put("address", rs.getString("address"));
                company.put("tel", rs.getString("tel"));
                company.put("mail_address", rs.getString("mail_address"));
                company.put("manager_name", rs.getString("manager_name"));
                company.put("recruitment_results", rs.getBoolean("recruitment_results"));
                return company;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * 企業数を取得
     */
    public int getCompanyCount() {
        String sql = "SELECT COUNT(*) FROM companys_tbl";
        
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
    
    /**
     * 採用実績のある企業数を取得
     */
    public int getRecruitmentCompanyCount() {
        String sql = "SELECT COUNT(*) FROM companys_tbl WHERE recruitment_results = true";
        
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