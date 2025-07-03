package servlet;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 企業管理サーブレット
 * 企業情報の管理機能を提供
 */
public class CompanyManagementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 権限チェック（管理者または企業担当者のみ）
        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("admin") && !role.equals("company"))) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        // 企業管理ページにフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/companyManagement.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            // 企業追加処理
            handleAddCompany(request, response);
        } else if ("update".equals(action)) {
            // 企業更新処理
            handleUpdateCompany(request, response);
        } else if ("delete".equals(action)) {
            // 企業削除処理
            handleDeleteCompany(request, response);
        } else {
            // デフォルトは企業管理ページにフォワード
            doGet(request, response);
        }
    }
    
    private void handleAddCompany(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // TODO: 企業追加の実装
        // 現在は基本的なフォワードのみ
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/companyManagement.jsp");
        dispatcher.forward(request, response);
    }
    
    private void handleUpdateCompany(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // TODO: 企業更新の実装
        // 現在は基本的なフォワードのみ
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/companyManagement.jsp");
        dispatcher.forward(request, response);
    }
    
    private void handleDeleteCompany(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // TODO: 企業削除の実装
        // 現在は基本的なフォワードのみ
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/companyManagement.jsp");
        dispatcher.forward(request, response);
    }
} 