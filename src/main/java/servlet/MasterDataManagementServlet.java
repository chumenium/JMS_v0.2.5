package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
 * マスターデータ管理サーブレット
 * 職種、勤務地などのマスターデータの管理機能を提供
 */
public class MasterDataManagementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 管理者権限チェック
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("occupations".equals(action)) {
                // 職種管理
                getOccupationList(request, response);
            } else if ("workplaces".equals(action)) {
                // 勤務地管理
                getWorkplaceList(request, response);
            } else {
                // デフォルト：職種管理
                getOccupationList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "マスターデータ操作中にエラーが発生しました: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/masterDataManagement.jsp");
            dispatcher.forward(request, response);
        }
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
        
        // 管理者権限チェック
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("addOccupation".equals(action)) {
                addOccupation(request, response);
            } else if ("updateOccupation".equals(action)) {
                updateOccupation(request, response);
            } else if ("deleteOccupation".equals(action)) {
                deleteOccupation(request, response);
            } else if ("addWorkplace".equals(action)) {
                addWorkplace(request, response);
            } else if ("updateWorkplace".equals(action)) {
                updateWorkplace(request, response);
            } else if ("deleteWorkplace".equals(action)) {
                deleteWorkplace(request, response);
            } else {
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "マスターデータ操作中にエラーが発生しました: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/masterDataManagement.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    /**
     * 職種一覧を取得
     */
    private void getOccupationList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Map<String, Object>> occupations = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT * FROM occupations_tbl ORDER BY occupation_id";
            
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, Object> occupation = new HashMap<>();
                    occupation.put("id", rs.getInt("occupation_id"));
                    occupation.put("name", rs.getString("occupation"));
                    occupation.put("description", ""); // descriptionカラムは存在しない
                    occupations.add(occupation);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "職種一覧の取得に失敗しました: " + e.getMessage());
        }
        
        request.setAttribute("occupations", occupations);
        request.setAttribute("currentTab", "occupations");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/masterDataManagement.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * 勤務地一覧を取得
     */
    private void getWorkplaceList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Map<String, Object>> workplaces = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT * FROM work_place_tbl ORDER BY id";
            
            try (PreparedStatement stmt = conn.prepareStatement(query);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    Map<String, Object> workplace = new HashMap<>();
                    workplace.put("id", rs.getInt("id"));
                    workplace.put("name", rs.getString("work_place"));
                    workplace.put("description", ""); // descriptionカラムは存在しない
                    workplaces.add(workplace);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "勤務地一覧の取得に失敗しました: " + e.getMessage());
        }
        
        request.setAttribute("workplaces", workplaces);
        request.setAttribute("currentTab", "workplaces");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/masterDataManagement.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * 職種を追加
     */
    private void addOccupation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "職種名は必須です");
            getOccupationList(request, response);
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            String query = "INSERT INTO occupations_tbl (occupation) VALUES (?)";
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, name.trim());
                stmt.executeUpdate();
                
                request.setAttribute("success", "職種「" + name + "」を追加しました");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getErrorCode() == 1062) { // 重複エラー
                request.setAttribute("error", "職種名「" + name + "」は既に存在します");
            } else {
                request.setAttribute("error", "職種の追加に失敗しました: " + e.getMessage());
            }
        } catch (ClassNotFoundException e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}
        
        getOccupationList(request, response);
    }
    
    /**
     * 職種を更新
     */
    private void updateOccupation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        if (id == null || name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "職種IDと職種名は必須です");
            getOccupationList(request, response);
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            String query = "UPDATE occupations_tbl SET occupation = ? WHERE occupation_id = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, name.trim());
                stmt.setInt(2, Integer.parseInt(id));
                
                int affectedRows = stmt.executeUpdate();
                if (affectedRows > 0) {
                    request.setAttribute("success", "職種を更新しました");
                } else {
                    request.setAttribute("error", "指定された職種が見つかりません");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getErrorCode() == 1062) { // 重複エラー
                request.setAttribute("error", "職種名「" + name + "」は既に存在します");
            } else {
                request.setAttribute("error", "職種の更新に失敗しました: " + e.getMessage());
            }
        } catch (ClassNotFoundException e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}
        
        getOccupationList(request, response);
    }
    
    /**
     * 職種を削除
     */
    private void deleteOccupation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        
        if (id == null) {
            request.setAttribute("error", "職種IDは必須です");
            getOccupationList(request, response);
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            // 外部キー制約チェック
            String checkQuery = "SELECT COUNT(*) FROM students_tbl WHERE desired_job_type_1st_id = ? OR desired_job_type_2nd_id = ? OR desired_job_type_3rd_id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                checkStmt.setInt(1, Integer.parseInt(id));
                checkStmt.setInt(2, Integer.parseInt(id));
                checkStmt.setInt(3, Integer.parseInt(id));
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        request.setAttribute("error", "この職種は使用中のため削除できません");
                        getOccupationList(request, response);
                        return;
                    }
                }
            }
            
            String query = "DELETE FROM occupations_tbl WHERE occupation_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, Integer.parseInt(id));
                
                int affectedRows = stmt.executeUpdate();
                if (affectedRows > 0) {
                    request.setAttribute("success", "職種を削除しました");
                } else {
                    request.setAttribute("error", "指定された職種が見つかりません");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "職種の削除に失敗しました: " + e.getMessage());
        } catch (ClassNotFoundException e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}
        
        getOccupationList(request, response);
    }
    
    /**
     * 勤務地を追加
     */
    private void addWorkplace(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "勤務地名は必須です");
            getWorkplaceList(request, response);
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            String query = "INSERT INTO work_place_tbl (work_place) VALUES (?)";
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, name.trim());
                stmt.executeUpdate();
                
                request.setAttribute("success", "勤務地「" + name + "」を追加しました");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getErrorCode() == 1062) { // 重複エラー
                request.setAttribute("error", "勤務地名「" + name + "」は既に存在します");
            } else {
                request.setAttribute("error", "勤務地の追加に失敗しました: " + e.getMessage());
            }
        } catch (ClassNotFoundException e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}
        
        getWorkplaceList(request, response);
    }
    
    /**
     * 勤務地を更新
     */
    private void updateWorkplace(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        
        if (id == null || name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "勤務地IDと勤務地名は必須です");
            getWorkplaceList(request, response);
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            String query = "UPDATE work_place_tbl SET work_place = ? WHERE id = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, name.trim());
                stmt.setInt(2, Integer.parseInt(id));
                
                int affectedRows = stmt.executeUpdate();
                if (affectedRows > 0) {
                    request.setAttribute("success", "勤務地を更新しました");
                } else {
                    request.setAttribute("error", "指定された勤務地が見つかりません");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getErrorCode() == 1062) { // 重複エラー
                request.setAttribute("error", "勤務地名「" + name + "」は既に存在します");
            } else {
                request.setAttribute("error", "勤務地の更新に失敗しました: " + e.getMessage());
            }
        } catch (ClassNotFoundException e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}
        
        getWorkplaceList(request, response);
    }
    
    /**
     * 勤務地を削除
     */
    private void deleteWorkplace(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String id = request.getParameter("id");
        
        if (id == null) {
            request.setAttribute("error", "勤務地IDは必須です");
            getWorkplaceList(request, response);
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            // 外部キー制約チェック
            String checkQuery = "SELECT COUNT(*) FROM students_work_place_tbl WHERE work_place_id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                checkStmt.setInt(1, Integer.parseInt(id));
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        request.setAttribute("error", "この勤務地は使用中のため削除できません");
                        getWorkplaceList(request, response);
                        return;
                    }
                }
            }
            
            String query = "DELETE FROM work_place_tbl WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, Integer.parseInt(id));
                
                int affectedRows = stmt.executeUpdate();
                if (affectedRows > 0) {
                    request.setAttribute("success", "勤務地を削除しました");
                } else {
                    request.setAttribute("error", "指定された勤務地が見つかりません");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "勤務地の削除に失敗しました: " + e.getMessage());
        } catch (ClassNotFoundException e1) {
			// TODO 自動生成された catch ブロック
			e1.printStackTrace();
		}
        
        getWorkplaceList(request, response);
    }
} 