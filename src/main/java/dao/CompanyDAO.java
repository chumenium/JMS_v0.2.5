package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import beans.CompanyBean;
import utils.DBConnection;

public class CompanyDAO {
    
    /**
     * 企業IDで企業情報を取得
     */
    public CompanyBean getCompanyById(int companyId) {
        CompanyBean company = null;
        String sql = "SELECT * FROM companies_tbl WHERE company_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, companyId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                company = new CompanyBean();
                company.setCompanyId(rs.getInt("company_id"));
                company.setCompanyName(rs.getString("company_name"));
                company.setPostCode(rs.getString("post_code"));
                company.setAddress(rs.getString("address"));
                company.setTel(rs.getString("tel"));
                company.setMailAddress(rs.getString("mail_address"));
                company.setManagerName(rs.getString("manager_name"));
                company.setRecruitmentResults(rs.getBoolean("recruitment_results"));
                company.setWorkPlaceId(rs.getInt("work_place_id"));
                company.setOccupationId(rs.getInt("occupation_id"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return company;
    }
    
    /**
     * 企業情報を更新
     */
    public boolean updateCompany(CompanyBean company) {
        String sql = "UPDATE companies_tbl SET company_name = ?, post_code = ?, address = ?, " +
                    "tel = ?, mail_address = ?, manager_name = ?, recruitment_results = ?, " +
                    "work_place_id = ?, occupation_id = ? WHERE company_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, company.getCompanyName());
            pstmt.setString(2, company.getPostCode());
            pstmt.setString(3, company.getAddress());
            pstmt.setString(4, company.getTel());
            pstmt.setString(5, company.getMailAddress());
            pstmt.setString(6, company.getManagerName());
            pstmt.setBoolean(7, company.getRecruitmentResults());
            pstmt.setInt(8, company.getWorkPlaceId());
            pstmt.setInt(9, company.getOccupationId());
            pstmt.setInt(10, company.getCompanyId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 全企業情報を取得
     */
    public List<CompanyBean> getAllCompanies() {
        List<CompanyBean> companies = new ArrayList<>();
        String sql = "SELECT * FROM companies_tbl ORDER BY company_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                CompanyBean company = new CompanyBean();
                company.setCompanyId(rs.getInt("company_id"));
                company.setCompanyName(rs.getString("company_name"));
                company.setPostCode(rs.getString("post_code"));
                company.setAddress(rs.getString("address"));
                company.setTel(rs.getString("tel"));
                company.setMailAddress(rs.getString("mail_address"));
                company.setManagerName(rs.getString("manager_name"));
                company.setRecruitmentResults(rs.getBoolean("recruitment_results"));
                company.setWorkPlaceId(rs.getInt("work_place_id"));
                company.setOccupationId(rs.getInt("occupation_id"));
                companies.add(company);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return companies;
    }
    
    /**
     * 勤務地名を取得
     */
    public String getWorkPlaceName(int workPlaceId) {
        String workPlaceName = "";
        String sql = "SELECT work_place_name FROM work_places_tbl WHERE work_place_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, workPlaceId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                workPlaceName = rs.getString("work_place_name");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return workPlaceName;
    }
    
    /**
     * 職種名を取得
     */
    public String getOccupationName(int occupationId) {
        String occupationName = "";
        String sql = "SELECT occupation FROM occupations_tbl WHERE occupation_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, occupationId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                occupationName = rs.getString("occupation");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return occupationName;
    }
    
    /**
     * 勤務地一覧を取得
     */
    public List<String> getWorkPlaces() {
        List<String> workPlaces = new ArrayList<>();
        String sql = "SELECT work_place_name FROM work_places_tbl ORDER BY work_place_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                workPlaces.add(rs.getString("work_place_name"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return workPlaces;
    }
    
    /**
     * 職種一覧を取得
     */
    public List<String> getOccupations() {
        List<String> occupations = new ArrayList<>();
        String sql = "SELECT occupation FROM occupations_tbl WHERE occupation_id != 0 ORDER BY occupation_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                occupations.add(rs.getString("occupation"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        return occupations;
    }
} 