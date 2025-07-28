package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.CompanyDAO;
import dao.SelectionStageDAO;
import dao.StudentDAO;
import beans.CompanyBean;
import beans.ExamineeBean;

/**
 * 選考ステージ確認画面用Servlet
 */
public class SelectionStageViewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // 編集アクションの場合
        if ("edit".equals(action)) {
            handleEditAction(request, response);
            return;
        }
        
        System.out.println("=== 選考ステージ確認画面開始 ===");
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        String username = (String) session.getAttribute("id");
        
        System.out.println("SelectionStageViewServlet - username: " + username);
        System.out.println("SelectionStageViewServlet - role: " + role);
        
        try {
            // DAOの初期化
            SelectionStageDAO selectionStageDAO = new SelectionStageDAO();
            CompanyDAO companyDAO = new CompanyDAO();
            StudentDAO studentDAO = new StudentDAO();
            
            // 企業一覧と学生一覧を取得
            List<CompanyBean> companies = companyDAO.getAllCompanies();
            List<ExamineeBean> students = studentDAO.getExamineeBean();
            
            // 選考ステージ種類を取得
            List<Map<String, Object>> selectionTypes = selectionStageDAO.getAllSelectionTypes();
            
            request.setAttribute("companies", companies);
            request.setAttribute("students", students);
            request.setAttribute("selectionTypes", selectionTypes);
            
            // ロールに応じた選考ステージデータの取得
            List<Object> selectionStages = null;
            
            if ("student".equals(role)) {
                // 学生の場合は自分の選考ステージのみ表示
                String studentId = (String) session.getAttribute("student_id");
                System.out.println("SelectionStageViewServlet - studentId: " + studentId);
                
                if (studentId != null && !studentId.isEmpty()) {
                    selectionStages = selectionStageDAO.getSelectionStagesByStudentId(studentId);
                }
            } else {
                // 管理者系の場合は検索条件に応じて表示
                String companyId = request.getParameter("companyId");
                String studentId = request.getParameter("studentId");
                String selectionType = request.getParameter("selectionType");
                
                System.out.println("SelectionStageViewServlet - companyId: " + companyId);
                System.out.println("SelectionStageViewServlet - studentId: " + studentId);
                System.out.println("SelectionStageViewServlet - selectionType: " + selectionType);
                
                if (companyId != null && !companyId.isEmpty() && studentId != null && !studentId.isEmpty()) {
                    // 企業と学生の両方が指定されている場合
                    selectionStages = selectionStageDAO.getSelectionStagesByCompanyAndStudent(companyId, studentId);
                } else if (companyId != null && !companyId.isEmpty()) {
                    // 企業のみ指定されている場合
                    selectionStages = selectionStageDAO.getSelectionStagesByCompanyId(companyId);
                } else if (studentId != null && !studentId.isEmpty()) {
                    // 学生のみ指定されている場合
                    selectionStages = selectionStageDAO.getSelectionStagesByStudentId(studentId);
                } else if (selectionType != null && !selectionType.isEmpty()) {
                    // 選考ステージ種類が指定されている場合
                    selectionStages = selectionStageDAO.getSelectionStagesByType(selectionType);
                } else {
                    // 何も指定されていない場合は全件取得
                    selectionStages = selectionStageDAO.getAllSelectionStages();
                }
            }
            
            request.setAttribute("selectionStages", selectionStages);
            
            System.out.println("SelectionStageViewServlet - selectionStages size: " + 
                (selectionStages != null ? selectionStages.size() : 0));
            
            // JSPにフォワード
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStageView.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            System.err.println("SelectionStageViewServlet エラー: " + e.getMessage());
            e.printStackTrace();
            
            // エラーメッセージを設定
            request.setAttribute("errorMessage", "選考ステージデータの取得中にエラーが発生しました: " + e.getMessage());
            
            // 空のリストを設定してエラーを回避
            request.setAttribute("companies", new ArrayList<>());
            request.setAttribute("students", new ArrayList<>());
            request.setAttribute("selectionStages", new ArrayList<>());
            
            // JSPにフォワード
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStageView.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // POSTリクエストはGETと同じ処理
        doGet(request, response);
    }
    
    private void handleEditAction(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentId = request.getParameter("studentId");
        String companyId = request.getParameter("companyId");
        
        System.out.println("=== 選考ステージ編集画面開始 ===");
        System.out.println("SelectionStageViewServlet - studentId: " + studentId);
        System.out.println("SelectionStageViewServlet - companyId: " + companyId);
        
        // nullや"null"文字列の場合はエラー扱い
        if (studentId == null || companyId == null || "null".equals(studentId) || "null".equals(companyId)) {
            System.out.println("SelectionStageViewServlet - パラメータが不足しています");
            request.setAttribute("errorMessage", "学生IDまたは企業IDが正しく取得できませんでした。");
            response.sendRedirect(request.getContextPath() + "/SelectionStageViewServlet");
            return;
        }
        
        try {
            SelectionStageDAO selectionStageDAO = new SelectionStageDAO();
            
            // 選考ステージの基本情報を取得
            Map<String, Object> selectionStage = selectionStageDAO.getSelectionStageById(
                Integer.parseInt(studentId), 
                Integer.parseInt(companyId), 
                0
            );
            
            if (selectionStage == null) {
                request.setAttribute("errorMessage", "選考ステージが見つかりませんでした。");
                response.sendRedirect(request.getContextPath() + "/SelectionStageViewServlet");
                return;
            }
            
            // 選考ステージの詳細情報を取得
            List<Map<String, Object>> selectionStages = selectionStageDAO.getSelectionStageDetails(
                Integer.parseInt(studentId), 
                Integer.parseInt(companyId)
            );
            
            // 選考ステージタイプを取得
            List<Map<String, Object>> selectionTypes = selectionStageDAO.getAllSelectionTypes();
            
            request.setAttribute("selectionStage", selectionStage);
            request.setAttribute("selectionStages", selectionStages);
            request.setAttribute("selectionTypes", selectionTypes);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStageEdit.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "選考ステージの取得に失敗しました。");
            response.sendRedirect(request.getContextPath() + "/SelectionStageViewServlet");
        }
    }
} 