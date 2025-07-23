package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import beans.CompanyBean;
import utils.DBConnection;

/**
 * 企業データアクセスオブジェクト
 * 企業情報のCRUD操作を提供
 */
public class CompanyDAO {
    
    /**
     * 全企業一覧を取得
     */
    public List<CompanyBean> getAllCompanies() {
        List<CompanyBean> companies = new ArrayList<>();
        String sql = "SELECT * FROM companys_tbl ORDER BY companys_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            int companyId = 0;
            while (rs.next()) {
                CompanyBean company = new CompanyBean();
                companyId = rs.getInt("companys_id");
                company.setCompanyId(rs.getInt("companys_id"));
                company.setCompanyName(rs.getString("company_name"));
                company.setPostCode(rs.getString("post_code"));
                company.setAddress(rs.getString("address"));
                company.setTel(rs.getString("tel"));
                company.setMailAddress(rs.getString("mail_address"));
                company.setManagerName(rs.getString("manager_name"));
                company.setRecruitmentResults(rs.getBoolean("recruitment_results"));

                List<String> occupations = new ArrayList<>();
                String sqloc = "SELECT o.occupation FROM company_occupation_tbl co JOIN occupations_tbl o ON co.occupation_id = o.occupation_id WHERE co.companys_id = ?";
                PreparedStatement stmtoc = conn.prepareStatement(sqloc);
                stmtoc.setInt(1, companyId);
                ResultSet rsoc = stmtoc.executeQuery();
                while (rsoc.next()) {
                    occupations.add(rsoc.getString("occupation"));
                }

                List<String> workPlaces = new ArrayList<>();
                String sqlwp = "SELECT wp.work_place FROM company_work_place_tbl cwp JOIN work_place_tbl wp ON cwp.work_place_id = wp.id WHERE cwp.companys_id = ?";
                PreparedStatement stmtwp = conn.prepareStatement(sqlwp);
                
                stmtwp.setInt(1, companyId);
                ResultSet rswp = stmtwp.executeQuery();
                
                while (rswp.next()) {
                    workPlaces.add(rswp.getString("work_place"));
                }
                company.setOccupations(occupations);
                company.setWorkPlaces(workPlaces);
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
        String sql2 = "DELETE FROM company_occupation_tbl WHERE companys_id=?";
        String sql3 = "DELETE FROM company_work_place_tbl WHERE companys_id=?";
        System.out.println("CompanyDAO: deleteCompany called with ID = " + companyId);
        
        try (Connection conn = DBConnection.getConnection()){
            PreparedStatement stmt = conn.prepareStatement(sql);
            PreparedStatement stmt2 = conn.prepareStatement(sql2);
            PreparedStatement stmt3 = conn.prepareStatement(sql3);
            stmt.setInt(1, companyId);
            stmt2.setInt(1, companyId);
            stmt3.setInt(1, companyId);
            int result2 = stmt2.executeUpdate();
            int result3 = stmt3.executeUpdate();
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
     * 企業IDで企業情報を取得（新しいCompanyBean構造対応）
     */
    public beans.CompanyBean getCompanyBeanById(int companyId) {
        String sql = "SELECT * FROM companys_tbl WHERE companys_id=?";
        System.out.println("CompanyDAO: getCompanyBeanById called with ID = " + companyId);
        
        try (Connection conn = DBConnection.getConnection()){
             PreparedStatement stmt = conn.prepareStatement(sql);
            
            System.out.println("CompanyDAO: Database connection established");
            stmt.setInt(1, companyId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                beans.CompanyBean company = new beans.CompanyBean();
                company.setCompanyId(rs.getInt("companys_id"));
                company.setCompanyName(rs.getString("company_name"));
                company.setPostCode(rs.getString("post_code"));
                company.setAddress(rs.getString("address"));
                company.setTel(rs.getString("tel"));
                company.setMailAddress(rs.getString("mail_address"));
                company.setManagerName(rs.getString("manager_name"));
                company.setRecruitmentResults(rs.getBoolean("recruitment_results"));
                
                // 職種と勤務地のリストを取得
                List<String> occupations = new ArrayList<>();
                String sql2 = "SELECT o.occupation FROM company_occupation_tbl co " +
                            "JOIN occupations_tbl o ON co.occupation_id = o.occupation_id " +
                            "WHERE co.companys_id = ?";
                     PreparedStatement stmt2 = conn.prepareStatement(sql2);
                    
                    stmt2.setInt(1, companyId);
                    ResultSet rs2 = stmt2.executeQuery();
                    
                    while (rs2.next()) {
                        occupations.add(rs2.getString("occupation"));
                    }

                List<String> workPlaces = new ArrayList<>();
                String sql3 = "SELECT wp.work_place FROM company_work_place_tbl cwp " +
                            "JOIN work_place_tbl wp ON cwp.work_place_id = wp.id " +
                            "WHERE cwp.companys_id = ?";
                
                PreparedStatement stmt3 = conn.prepareStatement(sql3);
                stmt3.setInt(1, companyId);
                ResultSet rs3 = stmt3.executeQuery();
                
                while (rs3.next()) {
                    workPlaces.add(rs3.getString("work_place"));
                }
                //List<String> occupations = getCompanyOccupations(companyId);
                //List<String> workPlaces = getCompanyWorkPlaces(companyId);
                company.setOccupations(occupations);
                company.setWorkPlaces(workPlaces);
                
                System.out.println("CompanyDAO: Found company data = " + company);
                return company;
            } else {
                System.out.println("CompanyDAO: No company found with ID = " + companyId);
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("CompanyDAO: Error in getCompanyBeanById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * 企業IDで企業情報を取得（従来のMap形式）
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
     * 企業の職種リストを取得
     */
    public List<String> getCompanyOccupations(int companyId) {
        List<String> occupations = new ArrayList<>();
        String sql = "SELECT o.occupation FROM company_occupation_tbl co " +
                    "JOIN occupations_tbl o ON co.occupation_id = o.occupation_id " +
                    "WHERE co.companys_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, companyId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                occupations.add(rs.getString("occupation"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return occupations;
    }
    
    /**
     * 企業の勤務地リストを取得
     */
    public List<String> getCompanyWorkPlaces(int companyId) {
        List<String> workPlaces = new ArrayList<>();
        String sql = "SELECT wp.work_place FROM company_work_place_tbl cwp " +
                    "JOIN work_place_tbl wp ON cwp.work_place_id = wp.id " +
                    "WHERE cwp.companys_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, companyId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                workPlaces.add(rs.getString("work_place"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return workPlaces;
    }
    
    /**
     * 企業情報を更新（新しいCompanyBean構造対応）
     */
    public boolean updateCompanyBean(beans.CompanyBean company) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // 企業基本情報を更新（remarksカラムは存在しないため除外）
            String updateSql = "UPDATE companys_tbl SET company_name=?, post_code=?, address=?, tel=?, mail_address=?, manager_name=?, recruitment_results=? WHERE companys_id=?";
            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                stmt.setString(1, company.getCompanyName());
                stmt.setString(2, company.getPostCode());
                stmt.setString(3, company.getAddress());
                stmt.setString(4, company.getTel());
                stmt.setString(5, company.getMailAddress());
                stmt.setString(6, company.getManagerName());
                stmt.setBoolean(7, company.getRecruitmentResults());
                stmt.setInt(8, company.getCompanyId());
                
                int result = stmt.executeUpdate();
                if (result == 0) {
                    conn.rollback();
                    return false;
                }
            }
            
            // 既存の職種・勤務地を削除
            String deleteOccupationsSql = "DELETE FROM company_occupation_tbl WHERE companys_id=?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteOccupationsSql)) {
                stmt.setInt(1, company.getCompanyId());
                stmt.executeUpdate();
            }
            
            String deleteWorkPlacesSql = "DELETE FROM company_work_place_tbl WHERE companys_id=?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteWorkPlacesSql)) {
                stmt.setInt(1, company.getCompanyId());
                stmt.executeUpdate();
            }
            
            // 新しい職種を登録
            if (company.getOccupations() != null) {
                String insertOccupationSql = "INSERT INTO company_occupation_tbl (companys_id, occupation_id) VALUES (?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(insertOccupationSql)) {
                    for (String occupation : company.getOccupations()) {
                        if (occupation != null && !occupation.trim().isEmpty()) {
                            int occupationId = 0;//getOccupationIdByName(occupation);
                            //職種IDをget
                            String sql1 = "SELECT occupation_id FROM occupations_tbl WHERE occupation = ?";
                            PreparedStatement stmt1 = conn.prepareStatement(sql1);
                            
                            stmt1.setString(1, occupation);
                            ResultSet rs1 = stmt1.executeQuery();
                            
                            if (rs1.next()) {
                                occupationId = rs1.getInt("occupation_id");
                            }
                            //ここまで
                            if (occupationId > 0) {
                                stmt.setInt(1, company.getCompanyId());
                                stmt.setInt(2, occupationId);
                                stmt.executeUpdate();
                            }
                        }
                    }
                }
            }
            
            // 新しい勤務地を登録
            if (company.getWorkPlaces() != null) {
                String insertWorkPlaceSql = "INSERT INTO company_work_place_tbl (companys_id, work_place_id) VALUES (?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(insertWorkPlaceSql)) {
                    for (String workPlace : company.getWorkPlaces()) {
                        if (workPlace != null && !workPlace.trim().isEmpty()) {
                            int workPlaceId = 0;//getWorkPlaceIdByName(workPlace);
                            //勤務地IDをget
                            String sql2 = "SELECT id FROM work_place_tbl WHERE work_place = ?";
                            PreparedStatement stmt2 = conn.prepareStatement(sql2);
                            stmt2.setString(1, workPlace);
                            ResultSet rs2 = stmt2.executeQuery();
                            if (rs2.next()) {
                                workPlaceId = rs2.getInt("id");
                            }
                            //ここまで
                            if (workPlaceId > 0) {
                                stmt.setInt(1, company.getCompanyId());
                                stmt.setInt(2, workPlaceId);
                                stmt.executeUpdate();
                            }
                        }
                    }
                }
            }
            
            conn.commit();
            return true;
            
        } catch (SQLException | ClassNotFoundException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * 職種名からIDを取得
     */
    private int getOccupationIdByName(String occupationName) {
        String sql = "SELECT occupation_id FROM occupations_tbl WHERE occupation = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, occupationName);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("occupation_id");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * 勤務地名からIDを取得
     */
    private int getWorkPlaceIdByName(String workPlaceName) {
        String sql = "SELECT id FROM work_place_tbl WHERE work_place = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, workPlaceName);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("id");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * 企業数を取得
     */
    public List<Integer> getCompanyCountRecruitment() {
        String sql = "SELECT COUNT(*) FROM companys_tbl";
        String sql2 = "SELECT COUNT(*) FROM companys_tbl WHERE recruitment_results = true";
        List<Integer> data = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()){
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                data.add(rs.getInt(1));
            }

            PreparedStatement stmt2 = conn.prepareStatement(sql2);
            ResultSet rs2 = stmt2.executeQuery();
            if (rs2.next()) {
                data.add(rs2.getInt(1));
            }
            return data;
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
     * 企業情報を更新（従来の方法）
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
     * CompanyBeanを使用して企業情報を更新（従来の方法）
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

    /**
     * 企業を登録し、登録したIDを返す
     */
    public boolean addCompanyAndGetId(String companyName,CompanyBean company){//, String postCode, String address, 
                            //String tel, String mailAddress, String managerName, boolean recruitmentResults) {
        //String sql = "INSERT INTO companys_tbl (company_name, post_code, address, tel, mail_address, manager_name, recruitment_results) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sql = "INSERT INTO companys_tbl (company_name) VALUES (?)";
        
        try (Connection conn = utils.DBConnection.getConnection()){
            java.sql.PreparedStatement stmt = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, companyName);
            // stmt.setString(2, postCode);
            // stmt.setString(3, address);
            // stmt.setString(4, tel);
            // stmt.setString(5, mailAddress);
            // stmt.setString(6, managerName);
            // stmt.setBoolean(7, recruitmentResults);
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                return false;
            }
            int companyId = 0;
            try (java.sql.ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    companyId = generatedKeys.getInt(1);
                } else {
                    return false;
                }
            }
            company.setCompanyId(companyId);
            // 企業基本情報を更新（remarksカラムは存在しないため除外）
            String updateSql = "UPDATE companys_tbl SET company_name=?, post_code=?, address=?, tel=?, mail_address=?, manager_name=?, recruitment_results=? WHERE companys_id=?";
                PreparedStatement stmt2 = conn.prepareStatement(updateSql);
                stmt2.setString(1, company.getCompanyName());
                stmt2.setString(2, company.getPostCode());
                stmt2.setString(3, company.getAddress());
                stmt2.setString(4, company.getTel());
                stmt2.setString(5, company.getMailAddress());
                stmt2.setString(6, company.getManagerName());
                stmt2.setBoolean(7, company.getRecruitmentResults());
                stmt2.setInt(8, company.getCompanyId());
                
                int result = stmt2.executeUpdate();
                if (result == 0) {
                    conn.rollback();
                    return false;
                }
            
            
            // 既存の職種・勤務地を削除
            String deleteOccupationsSql = "DELETE FROM company_occupation_tbl WHERE companys_id=?";
            try (PreparedStatement stmt3 = conn.prepareStatement(deleteOccupationsSql)) {
                stmt3.setInt(1, company.getCompanyId());
                stmt3.executeUpdate();
            }
            
            String deleteWorkPlacesSql = "DELETE FROM company_work_place_tbl WHERE companys_id=?";
            try (PreparedStatement stmt4 = conn.prepareStatement(deleteWorkPlacesSql)) {
                stmt4.setInt(1, company.getCompanyId());
                stmt4.executeUpdate();
            }
            
            // 新しい職種を登録
            if (company.getOccupations() != null) {
                String insertOccupationSql = "INSERT INTO company_occupation_tbl (companys_id, occupation_id) VALUES (?, ?)";
                try (PreparedStatement stmt5 = conn.prepareStatement(insertOccupationSql)) {
                    for (String occupation : company.getOccupations()) {
                        if (occupation != null && !occupation.trim().isEmpty()) {
                            int occupationId = getOccupationIdByName(occupation);
                            if (occupationId > 0) {
                                stmt5.setInt(1, company.getCompanyId());
                                stmt5.setInt(2, occupationId);
                                stmt5.executeUpdate();
                            }
                        }
                    }
                }
            }
            
            // 新しい勤務地を登録
            if (company.getWorkPlaces() != null) {
                String insertWorkPlaceSql = "INSERT INTO company_work_place_tbl (companys_id, work_place_id) VALUES (?, ?)";
                try (PreparedStatement stmt6 = conn.prepareStatement(insertWorkPlaceSql)) {
                    for (String workPlace : company.getWorkPlaces()) {
                        if (workPlace != null && !workPlace.trim().isEmpty()) {
                            int workPlaceId = getWorkPlaceIdByName(workPlace);
                            if (workPlaceId > 0) {
                                stmt6.setInt(1, company.getCompanyId());
                                stmt6.setInt(2, workPlaceId);
                                stmt6.executeUpdate();
                            }
                        }
                    }
                }
            }
            
            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
} 