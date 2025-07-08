package servlet;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.SelectionStageDAO;

/**
 * 選考段階管理サーブレット
 * 選考プロセスの管理機能を提供
 */
public class SelectionStageServlet extends HttpServlet {
    
    private SelectionStageDAO selectionStageDAO = new SelectionStageDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 権限チェック（学生、管理者、企業担当者）
        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("admin") && !role.equals("student") && !role.equals("company"))) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        // 学生IDを取得
        String studentId = (String) session.getAttribute("id");
        
        // 選考段階一覧を取得
        List<Map<String, Object>> selectionStages;
        if ("admin".equals(role)) {
            // 管理者の場合は全ての選考段階を取得
            selectionStages = selectionStageDAO.getAllSelectionStages();
        } else {
            // 学生の場合は自分の選考段階のみ取得
            selectionStages = selectionStageDAO.getSelectionStagesByStudentId(studentId);
        }
        
        // 統計情報を取得
        Map<String, Integer> statistics = selectionStageDAO.getSelectionStageStatistics();
        
        request.setAttribute("selectionStages", selectionStages);
        request.setAttribute("statistics", statistics);
        
        // 選考段階管理ページにフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStage.jsp");
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
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String currentStage = request.getParameter("currentStage");
            String notes = request.getParameter("notes");
            
            boolean success = selectionStageDAO.updateSelectionStage(id, currentStage, notes);
            
            if (success) {
                request.setAttribute("message", "選考段階を更新しました。");
            } else {
                request.setAttribute("error", "選考段階の更新に失敗しました。");
            }
        } catch (Exception e) {
            request.setAttribute("error", "選考段階の更新中にエラーが発生しました。");
        }
        
        doGet(request, response);
    }
    
    private void handleAdvanceSelectionStage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String newStage = request.getParameter("newStage");
            
            boolean success = selectionStageDAO.advanceSelectionStage(id, newStage);
            
            if (success) {
                request.setAttribute("message", "選考段階を進行させました。");
            } else {
                request.setAttribute("error", "選考段階の進行に失敗しました。");
            }
        } catch (Exception e) {
            request.setAttribute("error", "選考段階の進行中にエラーが発生しました。");
        }
        
        doGet(request, response);
    }
    
    private void handleRejectSelectionStage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            boolean success = selectionStageDAO.rejectSelectionStage(id);
            
            if (success) {
                request.setAttribute("message", "選考を不合格にしました。");
            } else {
                request.setAttribute("error", "選考の不合格処理に失敗しました。");
            }
        } catch (Exception e) {
            request.setAttribute("error", "選考の不合格処理中にエラーが発生しました。");
        }
        
        doGet(request, response);
    }
} 