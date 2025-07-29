package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import utils.DBConnection;

public class UserDAO {
    
    /**
     * 全ユーザー一覧を取得（権限設定用）
     */
    public List<Map<String, Object>> getAllUsers() {
        List<Map<String, Object>> users = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // まずteacher_tblテーブルが存在するかチェック
            boolean teacherTableExists = checkTableExists(conn, "teacher_tbl");
            
            String sql;
            if (teacherTableExists) {
                sql = "SELECT u.id, u.role, " +
                      "CASE " +
                      "  WHEN u.role = 'student' THEN s.name " +
                      "  WHEN u.role = 'teacher' THEN t.name " +
                      "  ELSE u.id " +
                      "END AS display_name " +
                      "FROM users u " +
                      "LEFT JOIN students_tbl s ON u.id = s.student_id " +
                      "LEFT JOIN teacher_tbl t ON u.id = t.teacher_id " +
                      "ORDER BY u.role, u.id";
            } else {
                sql = "SELECT u.id, u.role, " +
                      "CASE " +
                      "  WHEN u.role = 'student' THEN s.name " +
                      "  ELSE u.id " +
                      "END AS display_name " +
                      "FROM users u " +
                      "LEFT JOIN students_tbl s ON u.id = s.student_id " +
                      "ORDER BY u.role, u.id";
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, Object> user = new HashMap<>();
                    user.put("id", rs.getString("id"));
                    user.put("role", rs.getString("role"));
                    String displayName = rs.getString("display_name");
                    user.put("display_name", displayName != null ? displayName : rs.getString("id"));
                    users.add(user);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * テーブルが存在するかチェック
     */
    private boolean checkTableExists(Connection conn, String tableName) {
        try {
            String sql = "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, tableName);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * ユーザーの権限を更新
     */
    public boolean updateUserRole(String userId, String newRole) {
        String sql = "UPDATE users SET role = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newRole);
            stmt.setString(2, userId);
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 権限別ユーザー数を取得
     */
    public Map<String, Integer> getUserCountByRole() {
        Map<String, Integer> roleCounts = new HashMap<>();
        String sql = "SELECT role, COUNT(*) as count FROM users GROUP BY role";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                roleCounts.put(rs.getString("role"), rs.getInt("count"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return roleCounts;
    }
} 