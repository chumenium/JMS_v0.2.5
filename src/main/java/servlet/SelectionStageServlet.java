package servlet;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 選考段階管理サーブレット
 * 選考プロセスの管理機能を提供
 */
public class SelectionStageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 権限チェック（学生、管理者、企業担当者）
        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("admin") && !role.equals("student") && !role.equals("company"))) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        // 選考段階管理ページにフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStage.jsp");
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
        
        if ("update".equals(action)) {
            // 選考段階更新処理
            handleUpdateSelectionStage(request, response);
        } else if ("advance".equals(action)) {
            // 選考段階進行処理
            handleAdvanceSelectionStage(request, response);
        } else if ("reject".equals(action)) {
            // 選考段階却下処理
            handleRejectSelectionStage(request, response);
        } else {
            // デフォルトは選考段階管理ページにフォワード
            doGet(request, response);
        }
    }
    
    private void handleUpdateSelectionStage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // TODO: 選考段階更新の実装
        // 現在は基本的なフォワードのみ
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStage.jsp");
        dispatcher.forward(request, response);
    }
    
    private void handleAdvanceSelectionStage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // TODO: 選考段階進行の実装
        // 現在は基本的なフォワードのみ
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStage.jsp");
        dispatcher.forward(request, response);
    }
    
    private void handleRejectSelectionStage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // TODO: 選考段階却下の実装
        // 現在は基本的なフォワードのみ
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStage.jsp");
        dispatcher.forward(request, response);
    }
} 