package servlet;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 面接・試験入力サーブレット
 * 面接や試験の記録入力機能を提供
 */
public class InterviewExamInputServlet extends HttpServlet {
    
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
        
        // 面接・試験入力ページにフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamInput.jsp");
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
            // 面接・試験記録追加処理
            handleAddInterviewExam(request, response);
        } else if ("update".equals(action)) {
            // 面接・試験記録更新処理
            handleUpdateInterviewExam(request, response);
        } else if ("delete".equals(action)) {
            // 面接・試験記録削除処理
            handleDeleteInterviewExam(request, response);
        } else {
            // デフォルトは面接・試験入力ページにフォワード
            doGet(request, response);
        }
    }
    
    private void handleAddInterviewExam(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // TODO: 面接・試験記録追加の実装
        // 現在は基本的なフォワードのみ
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamInput.jsp");
        dispatcher.forward(request, response);
    }
    
    private void handleUpdateInterviewExam(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // TODO: 面接・試験記録更新の実装
        // 現在は基本的なフォワードのみ
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamInput.jsp");
        dispatcher.forward(request, response);
    }
    
    private void handleDeleteInterviewExam(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // TODO: 面接・試験記録削除の実装
        // 現在は基本的なフォワードのみ
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamInput.jsp");
        dispatcher.forward(request, response);
    }
} 