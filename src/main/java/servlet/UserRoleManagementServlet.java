package servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.UserDAO;

/**
 * ユーザー権限管理サーブレット
 * ユーザーの権限設定機能を提供
 */
public class UserRoleManagementServlet extends HttpServlet {
    
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
        
        // ユーザー一覧と権限統計を取得
        UserDAO userDAO = new UserDAO();
        List<Map<String, Object>> users = userDAO.getAllUsers();
        Map<String, Integer> roleCounts = userDAO.getUserCountByRole();
        
        request.setAttribute("users", users);
        request.setAttribute("roleCounts", roleCounts);
        
        // 権限設定画面にフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/userRoleManagement.jsp");
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
        
        // 管理者権限チェック
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("updateRole".equals(action)) {
            updateUserRole(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    /**
     * ユーザー権限を更新
     */
    private void updateUserRole(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userId = request.getParameter("userId");
        String newRole = request.getParameter("newRole");
        
        if (userId == null || newRole == null || userId.trim().isEmpty() || newRole.trim().isEmpty()) {
            request.setAttribute("error", "ユーザーIDまたは権限が指定されていません");
            doGet(request, response);
            return;
        }
        
        // admin権限の変更を防ぐ
        if ("admin".equals(userId)) {
            request.setAttribute("error", "管理者（admin）の権限は変更できません");
            doGet(request, response);
            return;
        }
        
        // 権限の妥当性チェック
        String[] validRoles = {"student", "teacher", "headmaster", "egd", "admin"};
        boolean validRole = false;
        for (String role : validRoles) {
            if (role.equals(newRole)) {
                validRole = true;
                break;
            }
        }
        
        if (!validRole) {
            request.setAttribute("error", "無効な権限が指定されました: " + newRole);
            doGet(request, response);
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.updateUserRole(userId, newRole);
        
        if (success) {
            // 権限名を日本語に変換
            String roleDisplay = "";
            switch(newRole) {
                case "student": roleDisplay = "学生"; break;
                case "teacher": roleDisplay = "教員"; break;
                case "headmaster": roleDisplay = "校長・教務部長"; break;
                case "egd": roleDisplay = "就職指導部"; break;
                case "admin": roleDisplay = "システム管理者"; break;
                default: roleDisplay = newRole; break;
            }
            request.setAttribute("success", "ユーザー " + userId + " の権限を「" + roleDisplay + "」に更新しました");
        } else {
            request.setAttribute("error", "権限の更新に失敗しました。ユーザーIDが存在しない可能性があります。");
        }
        
        doGet(request, response);
    }
} 