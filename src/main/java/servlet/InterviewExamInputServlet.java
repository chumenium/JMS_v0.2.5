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
import dao.InterviewDAO;
import dao.StudentDAO;
import dao.CompanyDAO;

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
        
        try {
            // DAOを使用してデータを取得
            InterviewDAO interviewDAO = new InterviewDAO();
            StudentDAO studentDAO = new StudentDAO();
            CompanyDAO companyDAO = new CompanyDAO();
            
            // 面接一覧を取得
            List<Map<String, Object>> interviews = interviewDAO.getAllInterviews();
            request.setAttribute("interviews", interviews);
            
            // 学生一覧を取得
            List<Map<String, Object>> students = studentDAO.getAllStudents();
            request.setAttribute("students", students);
            
            // 企業一覧を取得
            List<Map<String, Object>> companies = companyDAO.getAllCompanies();
            request.setAttribute("companies", companies);
            
        } catch (Exception e) {
            e.printStackTrace();
            // エラーが発生しても画面は表示
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
        if (session == null || session.getAttribute("id") == null) {
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
        try {
            InterviewDAO interviewDAO = new InterviewDAO();
            
            // リクエストパラメータを取得
            String studentId = request.getParameter("student_id");
            String companyIdStr = request.getParameter("company_id");
            String interviewDateStr = request.getParameter("interview_date");
            String interviewType = request.getParameter("interview_type");
            String status = request.getParameter("status");
            String notes = request.getParameter("notes");
            
            // バリデーション
            if (studentId == null || studentId.trim().isEmpty() ||
                companyIdStr == null || companyIdStr.trim().isEmpty() ||
                interviewDateStr == null || interviewDateStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "必須項目が入力されていません。");
                doGet(request, response);
                return;
            }
            
            // データ型変換
            int companyId = Integer.parseInt(companyIdStr);
            Date interviewDate = Date.valueOf(interviewDateStr);
            
            // 面接情報を登録
            boolean success = interviewDAO.addInterview(studentId, companyId, interviewDate, interviewType, status, notes);
            
            if (success) {
                request.setAttribute("successMessage", "面接情報の登録が完了しました。");
            } else {
                request.setAttribute("errorMessage", "面接情報の登録に失敗しました。");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "システムエラーが発生しました: " + e.getMessage());
        }
        
        doGet(request, response);
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