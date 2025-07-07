package dao;

import java.sql.*;
import java.util.*;
import utils.DBConnection;

/**
 * 学生データアクセスオブジェクト
 * 学生情報のCRUD操作を提供
 */
public class StudentDAO {
    /**
     * 全学生一覧を取得
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
                student.put("department", rs.getString("department"));
                student.put("class", rs.getString("class"));
                student.put("number", rs.getString("number"));
                student.put("name", rs.getString("name"));
                student.put("name_reading", rs.getString("name_reading"));
                student.put("gender", rs.getString("gender"));
                student.put("enrollment_status", rs.getString("enrollment_status"));
                student.put("mediation_status", rs.getString("mediation_status"));
                student.put("desired_job_type_1st_id", rs.getInt("desired_job_type_1st_id"));
                student.put("desired_job_type_2nd_id", rs.getInt("desired_job_type_2nd_id"));
                student.put("desired_job_type_3rd_id", rs.getInt("desired_job_type_3rd_id"));
                student.put("graduation_year", rs.getInt("graduation_year"));
                student.put("email", rs.getString("email"));
                student.put("tel", rs.getString("tel"));
                student.put("remarks", rs.getString("remarks"));
                student.put("job_hunting_status", rs.getString("job_hunting_status"));
                students.add(student);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return students;
    }

    /**
     * 学生を登録
     */
    public boolean addStudent(Map<String, Object> student) {
        String sql = "INSERT INTO students_tbl (student_id, department, class, number, name, name_reading, gender, enrollment_status, mediation_status, desired_job_type_1st_id, desired_job_type_2nd_id, desired_job_type_3rd_id, graduation_year, email, tel, remarks, job_hunting_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, (String)student.get("student_id"));
            stmt.setString(2, (String)student.get("department"));
            stmt.setString(3, (String)student.get("class"));
            stmt.setString(4, (String)student.get("number"));
            stmt.setString(5, (String)student.get("name"));
            stmt.setString(6, (String)student.get("name_reading"));
            stmt.setString(7, (String)student.get("gender"));
            stmt.setString(8, (String)student.get("enrollment_status"));
            stmt.setString(9, (String)student.get("mediation_status"));
            stmt.setObject(10, student.get("desired_job_type_1st_id"));
            stmt.setObject(11, student.get("desired_job_type_2nd_id"));
            stmt.setObject(12, student.get("desired_job_type_3rd_id"));
            stmt.setObject(13, student.get("graduation_year"));
            stmt.setString(14, (String)student.get("email"));
            stmt.setString(15, (String)student.get("tel"));
            stmt.setString(16, (String)student.get("remarks"));
            stmt.setString(17, (String)student.get("job_hunting_status"));
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 学生情報を更新
     */
    public boolean updateStudent(Map<String, Object> student) {
        String sql = "UPDATE students_tbl SET department=?, class=?, number=?, name=?, name_reading=?, gender=?, enrollment_status=?, mediation_status=?, desired_job_type_1st_id=?, desired_job_type_2nd_id=?, desired_job_type_3rd_id=?, graduation_year=?, email=?, tel=?, remarks=?, job_hunting_status=? WHERE student_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, (String)student.get("department"));
            stmt.setString(2, (String)student.get("class"));
            stmt.setString(3, (String)student.get("number"));
            stmt.setString(4, (String)student.get("name"));
            stmt.setString(5, (String)student.get("name_reading"));
            stmt.setString(6, (String)student.get("gender"));
            stmt.setString(7, (String)student.get("enrollment_status"));
            stmt.setString(8, (String)student.get("mediation_status"));
            stmt.setObject(9, student.get("desired_job_type_1st_id"));
            stmt.setObject(10, student.get("desired_job_type_2nd_id"));
            stmt.setObject(11, student.get("desired_job_type_3rd_id"));
            stmt.setObject(12, student.get("graduation_year"));
            stmt.setString(13, (String)student.get("email"));
            stmt.setString(14, (String)student.get("tel"));
            stmt.setString(15, (String)student.get("remarks"));
            stmt.setString(16, (String)student.get("job_hunting_status"));
            stmt.setString(17, (String)student.get("student_id"));
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 学生を削除
     */
    public boolean deleteStudent(String studentId) {
        String sql = "DELETE FROM students_tbl WHERE student_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, studentId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 学生IDで学生情報を取得
     */
    public Map<String, Object> getStudentById(String studentId) {
        String sql = "SELECT * FROM students_tbl WHERE student_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, studentId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Map<String, Object> student = new HashMap<>();
                student.put("student_id", rs.getString("student_id"));
                student.put("department", rs.getString("department"));
                student.put("class", rs.getString("class"));
                student.put("number", rs.getString("number"));
                student.put("name", rs.getString("name"));
                student.put("name_reading", rs.getString("name_reading"));
                student.put("gender", rs.getString("gender"));
                student.put("enrollment_status", rs.getString("enrollment_status"));
                student.put("mediation_status", rs.getString("mediation_status"));
                student.put("desired_job_type_1st_id", rs.getInt("desired_job_type_1st_id"));
                student.put("desired_job_type_2nd_id", rs.getInt("desired_job_type_2nd_id"));
                student.put("desired_job_type_3rd_id", rs.getInt("desired_job_type_3rd_id"));
                student.put("graduation_year", rs.getInt("graduation_year"));
                student.put("email", rs.getString("email"));
                student.put("tel", rs.getString("tel"));
                student.put("remarks", rs.getString("remarks"));
                student.put("job_hunting_status", rs.getString("job_hunting_status"));
                return student;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 学生数を取得
     */
    public int getStudentCount() {
        String sql = "SELECT COUNT(*) FROM students_tbl";
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
     * 指定卒業年の学生数を取得（例）
     */
    public int getGraduationYearCount(int year) {
        String sql = "SELECT COUNT(*) FROM students_tbl WHERE graduation_year = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, year);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return 0;
    }
} 