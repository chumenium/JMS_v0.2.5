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
     * 企業を削除
     */
    public boolean deleteCompany(int companyId) {
        String sql = "DELETE FROM companys_tbl WHERE companys_id=?";
        System.out.println("CompanyDAO: deleteCompany called with ID = " + companyId);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, companyId);
            int result = stmt.executeUpdate();
            System.out.println("CompanyDAO: DELETE executed, affected rows = " + result);
            return result > 0;
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("CompanyDAO: Error in deleteCompany: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 企業IDで企業情報を取得
     */
    public Map<String, Object> getCompanyById(int companyId) {
        String sql = "SELECT * FROM companys_tbl WHERE companys_id=?";
        System.out.println("CompanyDAO: getCompanyById called with ID = " + companyId);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            System.out.println("CompanyDAO: Database connection established");
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
                System.out.println("CompanyDAO: Found company data = " + company);
                return company;
            } else {
                System.out.println("CompanyDAO: No company found with ID = " + companyId);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("CompanyDAO: Error in getCompanyById: " + e.getMessage());
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
    
    /**
     * 勤務地IDから勤務地名を取得
     */
    public String getWorkPlaceName(int workPlaceId) {
        String sql = "SELECT work_place FROM work_place_tbl WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, workPlaceId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("work_place");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return "";
    }
    
    /**
     * 職種IDから職種名を取得
     */
    public String getOccupationName(int occupationId) {
        String sql = "SELECT occupation FROM occupations_tbl WHERE occupation_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, occupationId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("occupation");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return "";
    }
    
    /**
     * 全勤務地一覧を取得
     */
    public List<String> getWorkPlaces() {
        List<String> workPlaces = new ArrayList<>();
        String sql = "SELECT work_place FROM work_place_tbl ORDER BY id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                workPlaces.add(rs.getString("work_place"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return workPlaces;
    }
    
    /**
     * 全職種一覧を取得
     */
    public List<String> getOccupations() {
        List<String> occupations = new ArrayList<>();
        String sql = "SELECT occupation FROM occupations_tbl ORDER BY occupation_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                occupations.add(rs.getString("occupation"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return occupations;
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
     * CompanyBeanを使用して企業情報を更新
     */
    public boolean updateCompany(beans.CompanyBean company) {
        String sql = "UPDATE companys_tbl SET company_name=?, post_code=?, address=?, tel=?, mail_address=?, manager_name=?, recruitment_results=? WHERE companys_id=?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, company.getCompanyName());
            stmt.setString(2, company.getPostCode());
            stmt.setString(3, company.getAddress());
            stmt.setString(4, company.getTel());
            stmt.setString(5, company.getMailAddress());
            stmt.setString(6, company.getManagerName());
            stmt.setBoolean(7, company.getRecruitmentResults());
            stmt.setInt(8, company.getCompanyId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
} 