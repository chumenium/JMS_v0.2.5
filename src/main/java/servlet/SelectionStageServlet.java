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

import beans.CompanyBean;
import dao.CompanyDAO;
import dao.SelectionStageDAO;
import dao.StudentDAO;

/**
 * 選考ステージ登録サーブレット
 * 選考ステージの登録・管理機能を提供
 */
public class SelectionStageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 権限チェック（教員、校長・教務部長、就職指導部、システム管理者、学生）
        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("admin") && !role.equals("teacher") && 
                           !role.equals("headmaster") && !role.equals("egd") && !role.equals("student"))) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        try {
            // DAOを使用してデータを取得
            SelectionStageDAO selectionStageDAO = new SelectionStageDAO();
            StudentDAO studentDAO = new StudentDAO();
            CompanyDAO companyDAO = new CompanyDAO();
            
            // 選考ステージ一覧を取得
            List<Object> selectionStages = selectionStageDAO.getAllSelectionStages();
            request.setAttribute("selectionStages", selectionStages);
            
            // 学生一覧を取得
            List<Map<String, Object>> students = studentDAO.getAllStudents();
            request.setAttribute("students", students);
            
            // 企業一覧を取得
            List<CompanyBean> companies = companyDAO.getAllCompanies();
            request.setAttribute("companies", companies);
            
        } catch (Exception e) {
            e.printStackTrace();
            // エラーが発生しても画面は表示
        }
        
        // 選考ステージ登録ページにフォワード
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
        
        // 権限チェック
        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("admin") && !role.equals("teacher") && 
                           !role.equals("headmaster") && !role.equals("egd") && !role.equals("student"))) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        // 選考ステージ登録処理
        handleSelectionStageRegistration(request, response);
    }
    
    /**
     * 選考ステージ登録処理
     */
    private void handleSelectionStageRegistration(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // リクエストパラメータを取得
            String companyId = request.getParameter("companyId");
            String studentId = request.getParameter("studentId");
            String companyName = request.getParameter("companyName");
            String studentName = request.getParameter("studentName");
            String selectionStatus = request.getParameter("selectionStatus");
            
            // 選考ステージの配列パラメータを取得
            String[] stageTypes = request.getParameterValues("stages.type");
            String[] stageDates = request.getParameterValues("stages.date");
            String[] stageTimes = request.getParameterValues("stages.time");
            String[] stageFormats = request.getParameterValues("stages.format");
            
            // デバッグ用ログ
            System.out.println("=== 選考ステージ登録開始 ===");
            System.out.println("企業ID: " + companyId);
            System.out.println("学生ID: " + studentId);
            System.out.println("企業名: " + companyName);
            System.out.println("学生名: " + studentName);
            System.out.println("選考ステータス: " + selectionStatus);
            
            if (stageTypes != null) {
                System.out.println("選考ステージ数: " + stageTypes.length);
                for (int i = 0; i < stageTypes.length; i++) {
                    System.out.println("ステージ " + (i + 1) + ": " + stageTypes[i]);
                }
            }
            
            // バリデーション
            if (companyName == null || companyName.trim().isEmpty() ||
                studentName == null || studentName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "企業名と学生名は必須項目です。");
                doGet(request, response);
                return;
            }
            
            if (stageTypes == null || stageTypes.length == 0) {
                request.setAttribute("errorMessage", "少なくとも1つの選考ステージを追加してください。");
                doGet(request, response);
                return;
            }
            
            // 選考ステージDAOを使用してデータベースに登録
            SelectionStageDAO selectionStageDAO = new SelectionStageDAO();
            boolean success = selectionStageDAO.addSelectionStages(
                companyId, studentId, companyName, studentName, selectionStatus,
                stageTypes, stageDates, stageTimes, stageFormats
            );
            
            if (success) {
                request.setAttribute("successMessage", "選考ステージの登録が完了しました。");
            } else {
                request.setAttribute("errorMessage", "選考ステージの登録に失敗しました。");
            }
            
            System.out.println("=== 選考ステージ登録完了 ===");
            
        } catch (Exception e) {
            System.err.println("選考ステージ登録エラー: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "システムエラーが発生しました: " + e.getMessage());
        }
        
        // 選考ステージ登録ページにフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStage.jsp");
        dispatcher.forward(request, response);
    }
} 