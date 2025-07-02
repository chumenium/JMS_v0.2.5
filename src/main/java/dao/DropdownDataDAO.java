package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import utils.DBConnection;

public class DropdownDataDAO {

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
        mediations.add("学校斡旋");
        mediations.add("自己応募");
        mediations.add("縁故");
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
}