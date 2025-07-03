package servlet;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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
        if (session == null || session.getAttribute("user_id") == null) {
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
        String userId = (String) session.getAttribute("user_id");
        request.setAttribute("user_id", userId);
        request.setAttribute("user_role", role);
        
        // ダッシュボードページにフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/DashBoard.jsp");
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
} 