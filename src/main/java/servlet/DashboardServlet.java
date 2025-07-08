package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.DBConnection;

/**
 * ダッシュボードサーブレット
 * 就活状況の概要表示機能を提供
 */
public class DashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 権限チェック（全ユーザー）
        String role = (String) session.getAttribute("role");
        if (role == null) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        // ユーザーIDを取得
        String userId = (String) session.getAttribute("id");
        request.setAttribute("user_id", userId);
        request.setAttribute("user_role", role);
        
        // 統計情報を取得
        try (Connection connection = DBConnection.getConnection()) {
            Map<String, Object> dashboardStats = getDashboardStatistics(connection);
            request.setAttribute("dashboardStats", dashboardStats);
            
            // 最近の面接情報を取得
            request.setAttribute("recentInterviews", getRecentInterviews(connection, 5));
            
        } catch (Exception e) {
            e.printStackTrace();
            // エラーが発生してもダッシュボードは表示
        }
        
        // ダッシュボードページにフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/DashBoard.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("refresh".equals(action)) {
            // ダッシュボード更新処理
            handleRefreshDashboard(request, response);
        } else if ("export".equals(action)) {
            // データエクスポート処理
            handleExportData(request, response);
        } else {
            // デフォルトはダッシュボードページにフォワード
            doGet(request, response);
        }
    }
    
    private void handleRefreshDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // TODO: ダッシュボード更新の実装
        // 現在は基本的なフォワードのみ
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/DashBoard.jsp");
        dispatcher.forward(request, response);
    }
    
    private void handleExportData(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // TODO: データエクスポートの実装
        // 現在は基本的なフォワードのみ
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/DashBoard.jsp");
        dispatcher.forward(request, response);
    }
    
    private Map<String, Object> getDashboardStatistics(Connection connection) throws Exception {
        Map<String, Object> stats = new HashMap<>();
        
        // 学生総数
        String studentCountQuery = "SELECT COUNT(*) FROM students_tbl";
        try (PreparedStatement stmt = connection.prepareStatement(studentCountQuery)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalStudents", rs.getInt(1));
            }
        }
        
        // 企業総数
        String companyCountQuery = "SELECT COUNT(*) FROM company_tbl";
        try (PreparedStatement stmt = connection.prepareStatement(companyCountQuery)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalCompanies", rs.getInt(1));
            }
        }
        
        // 面接総数
        String interviewCountQuery = "SELECT COUNT(*) FROM interview_tbl";
        try (PreparedStatement stmt = connection.prepareStatement(interviewCountQuery)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalInterviews", rs.getInt(1));
            }
        }
        
        // 内定者数
        String offerCountQuery = "SELECT COUNT(*) FROM interview_tbl WHERE status = '内定'";
        try (PreparedStatement stmt = connection.prepareStatement(offerCountQuery)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalOffers", rs.getInt(1));
            }
        }
        
        return stats;
    }
    
    private List<Map<String, Object>> getRecentInterviews(Connection connection, int limit) throws Exception {
        List<Map<String, Object>> interviews = new ArrayList<>();
        
        String query = "SELECT i.*, s.name as student_name, c.company_name " +
                      "FROM interview_tbl i " +
                      "LEFT JOIN students_tbl s ON i.student_id = s.student_id " +
                      "LEFT JOIN company_tbl c ON i.company_id = c.company_id " +
                      "ORDER BY i.interview_date DESC LIMIT ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> interview = new HashMap<>();
                interview.put("interview_id", rs.getInt("interview_id"));
                interview.put("student_name", rs.getString("student_name"));
                interview.put("company_name", rs.getString("company_name"));
                interview.put("interview_date", rs.getDate("interview_date"));
                interview.put("status", rs.getString("status"));
                interviews.add(interview);
            }
        }
        
        return interviews;
    }
} 