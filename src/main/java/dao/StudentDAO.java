package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import beans.StudentBeans;
import utils.DBConnection;

public class StudentDAO {

    public List<String> getClasses() {
        List<String> classes = new ArrayList<>();
        String sql = "SELECT DISTINCT department, class FROM students_tbl ORDER BY department, class";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                classes.add(rs.getString("department") + " " + rs.getString("class"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return classes;
    }

    public List<String> getEnrollmentStatuses() {
        List<String> statuses = new ArrayList<>();
        String sql = "SELECT DISTINCT enrollment_status FROM students_tbl ORDER BY enrollment_status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                statuses.add(rs.getString("enrollment_status"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return statuses;
    }

    public List<String> getMediationStatuses() {
        List<String> mediations = new ArrayList<>();
        mediations.add("受理");
        mediations.add("辞退");
        return mediations;
    }

    public List<String> getIndustries() {
        List<String> industries = new ArrayList<>();
        String sql = "SELECT DISTINCT industry_name FROM occupations_tbl ORDER BY industry_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                industries.add(rs.getString("industry_name"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return industries;
    }

    public List<Integer> getGraduationYears() {
        List<Integer> years = new ArrayList<>();
        String sql = "SELECT DISTINCT graduation_year FROM students_tbl ORDER BY graduation_year DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                years.add(rs.getInt("graduation_year"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return years;
    }

    public List<String> getJobtypes() {
        List<String> jobtypes = new ArrayList<>();
        String sql = "SELECT DISTINCT occupation FROM occupations_tbl WHERE occupation_id != 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                jobtypes.add(rs.getString("occupation"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return jobtypes;
    }

    public List<String> getWorkplaces() {
        List<String> workplaces = new ArrayList<>();
        String sql = "SELECT work_place FROM work_place_tbl ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                workplaces.add(rs.getString("work_place"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return workplaces;
    }

    public List<List<String>> getJobtypesWorkplaces() {
        List<List<String>> jobtypesWorkplaces = new ArrayList<>();
        String sql = "SELECT DISTINCT occupation FROM occupations_tbl WHERE occupation_id != 0";
        String sql2 = "SELECT work_place FROM work_place_tbl ORDER BY id";
        List<String> jobtypes = new ArrayList<>();
        List<String> workplaces = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                jobtypes.add(rs.getString("occupation"));
            }
            PreparedStatement pstmt2 = conn.prepareStatement(sql2);
            ResultSet rs2 = pstmt2.executeQuery();
            while (rs2.next()) {
                workplaces.add(rs2.getString("work_place"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        jobtypesWorkplaces.add(jobtypes);
        jobtypesWorkplaces.add(workplaces);
        return jobtypesWorkplaces;
    }

    public static StudentBeans getStudentById(String id) {
        StudentBeans student = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT student_id, department, class, number, name, name_reading, gender, email, tel, enrollment_status, mediation_status, job_hunting_status, o1.occupation AS 1st,o2.occupation AS 2nd,o3.occupation AS 3rd,graduation_year, remarks FROM students_tbl s LEFT JOIN occupations_tbl o1 ON s.desired_job_type_1st_id = o1.occupation_id LEFT JOIN occupations_tbl o2 ON s.desired_job_type_2nd_id = o2.occupation_id LEFT JOIN occupations_tbl o3 ON s.desired_job_type_3rd_id = o3.occupation_id WHERE student_id = ?";
            ps = conn.prepareStatement(sql);//"student_id, class, number, name, name_reading, gender, email, tel, enrollment_status, mediation_status, job_hunting_status, o1.occupation AS 1st,o2.occupation AS 2nd,o3.occupation AS 3rd,graduation_year, remarks"
            ps.setString(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                student = new StudentBeans();
                student.setId(rs.getString("student_id"));
                String dc = rs.getString("department") + rs.getString("class");
                student.setClassName(dc);
                student.setNumber(rs.getString("number"));
                student.setName(rs.getString("name"));
                student.setNameKana(rs.getString("name_reading"));
                student.setGender(rs.getString("gender"));
                student.setEmail(rs.getString("email"));
                student.setTel(rs.getString("tel"));
                student.setEnrollmentStatus(rs.getString("enrollment_status"));
                student.setAssistanceStatus(rs.getString("mediation_status"));
                student.setJobHuntingStatus(rs.getString("job_hunting_status"));
                student.setDesiredJobType1(rs.getString("1st"));
                student.setDesiredJobType2(rs.getString("2nd"));
                student.setDesiredJobType3(rs.getString("3rd"));
                student.setGraduationYear(rs.getString("graduation_year"));
                student.setRemarks(rs.getString("remarks"));
                
                // 希望勤務地を取得
                String workPlaceSql = "SELECT wp.work_place FROM students_work_place_tbl swp JOIN work_place_tbl wp ON swp.work_place_id = wp.id WHERE swp.student_id = ?";
                PreparedStatement workPlacePs = conn.prepareStatement(workPlaceSql);
                workPlacePs.setString(1, id);
                ResultSet workPlaceRs = workPlacePs.executeQuery();
                List<String> wps = new ArrayList<String>();
                while (workPlaceRs.next()) {
                    wps.add(workPlaceRs.getString("work_place"));
                }
                student.setDesiredWorkPlace(wps);
                workPlaceRs.close();
                workPlacePs.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return student;
    }

    public static void updateStudent(StudentBeans student) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            System.out.println("=== データベース更新開始 ===");
            System.out.println("学生ID: " + student.getId());
            System.out.println("氏名: " + student.getName());
            System.out.println("性別: " + student.getGender());
            System.out.println("在籍状況: " + student.getEnrollmentStatus());
            System.out.println("斡旋状況: " + student.getAssistanceStatus());
            System.out.println("就活状況: " + student.getJobHuntingStatus());
            System.out.println("希望職種1: " + student.getDesiredJobType1());
            System.out.println("希望職種2: " + student.getDesiredJobType2());
            System.out.println("希望職種3: " + student.getDesiredJobType3());
            System.out.println("希望勤務地: " + student.getDesiredWorkPlace());
            
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // students_tblを更新
            String sql = "UPDATE students_tbl SET department=?, class=?, number=?, name=?, name_reading=?, gender=?, email=?, tel=?, enrollment_status=?, mediation_status=?, job_hunting_status=?, desired_job_type_1st_id=?, desired_job_type_2nd_id=?, desired_job_type_3rd_id=?, graduation_year=?, remarks=? WHERE student_id=?";
            ps = conn.prepareStatement(sql);
            String className = student.getClassName();
            ps.setString(1, className.substring(0, 2));
            ps.setString(2, className.substring(className.length() - 2));
            ps.setString(3, student.getNumber());
            ps.setString(4, student.getName());
            ps.setString(5, student.getNameKana());
            ps.setString(6, student.getGender());
            ps.setString(7, student.getEmail());
            ps.setString(8, student.getTel());
            ps.setString(9, student.getEnrollmentStatus());
            ps.setString(10, student.getAssistanceStatus());
            ps.setString(11, student.getJobHuntingStatus());
            ps.setString(12, student.getDesiredJobType1());
            ps.setString(13, student.getDesiredJobType2());
            ps.setString(14, student.getDesiredJobType3());
            ps.setString(15, student.getGraduationYear());
            ps.setString(16, student.getRemarks());
            ps.setString(17, student.getId());
            
            int updateCount = ps.executeUpdate();
            System.out.println("students_tbl更新件数: " + updateCount);
            
            // 希望勤務地を更新
            if (student.getDesiredWorkPlace() != null && !student.getDesiredWorkPlace().isEmpty()) {
                // 既存の希望勤務地を削除
                String deleteSql = "DELETE FROM students_work_place_tbl WHERE student_id = ?";
                PreparedStatement deletePs = conn.prepareStatement(deleteSql);
                deletePs.setString(1, student.getId());
                int deleteCount = deletePs.executeUpdate();
                System.out.println("既存勤務地削除件数: " + deleteCount);
                deletePs.close();
                
                // 新しい希望勤務地を追加
                String workPlaceSql = "SELECT id FROM work_place_tbl WHERE work_place = ?";
                PreparedStatement workPlacePs = conn.prepareStatement(workPlaceSql);
                List<String> wps = student.getDesiredWorkPlace();
                for(String wp : wps){
                    System.out.println("student内希望勤務地"+wp);
                    workPlacePs.setString(1, wp);
                    ResultSet workPlaceRs = workPlacePs.executeQuery();
                    if (workPlaceRs.next()) {
                        int workPlaceId = workPlaceRs.getInt("id");
                        System.out.println(workPlaceId);
                        String insertSql = "INSERT INTO students_work_place_tbl (student_id, work_place_id) VALUES (?, ?)";
                        PreparedStatement insertPs = conn.prepareStatement(insertSql);
                        insertPs.setString(1, student.getId());
                        insertPs.setInt(2, workPlaceId);
                        int insertCount = insertPs.executeUpdate();
                        System.out.println("新規勤務地追加件数: " + insertCount);
                        insertPs.close();
                    }
                }
                //workPlaceRs.close();
                workPlacePs.close();
            } else {
                // 希望勤務地が空の場合は既存のデータを削除
                String deleteSql = "DELETE FROM students_work_place_tbl WHERE student_id = ?";
                PreparedStatement deletePs = conn.prepareStatement(deleteSql);
                deletePs.setString(1, student.getId());
                int deleteCount = deletePs.executeUpdate();
                System.out.println("勤務地削除件数: " + deleteCount);
                deletePs.close();
            }
            
            conn.commit();
            System.out.println("=== データベース更新完了 ===");
        } catch (Exception e) {
            try { conn.rollback(); } catch (Exception ex) {}
            System.out.println("データベース更新エラー: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    public static String getOccupationNameById(int occupationId) {
        String occupationName = "";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT occupation FROM occupations_tbl WHERE occupation_id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, occupationId);
            rs = ps.executeQuery();
            if (rs.next()) {
                occupationName = rs.getString("occupation");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return occupationName;
    }
    
    /**
     * 全ての学生情報を取得
     */
    public List<Map<String, Object>> getAllStudents() {
        List<Map<String, Object>> students = new ArrayList<>();
        String sql = "SELECT * FROM students_tbl ORDER BY student_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> student = new HashMap<>();
                student.put("student_id", rs.getString("student_id"));
                student.put("name", rs.getString("name"));
                student.put("class", rs.getString("class"));
                student.put("number", rs.getString("number"));
                student.put("name_reading", rs.getString("name_reading"));
                student.put("gender", rs.getString("gender"));
                student.put("email", rs.getString("email"));
                student.put("tel", rs.getString("tel"));
                student.put("enrollment_status", rs.getString("enrollment_status"));
                student.put("mediation_status", rs.getString("mediation_status"));
                student.put("job_hunting_status", rs.getString("job_hunting_status"));
                student.put("graduation_year", rs.getString("graduation_year"));
                student.put("remarks", rs.getString("remarks"));
                students.add(student);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return students;
    }
} 