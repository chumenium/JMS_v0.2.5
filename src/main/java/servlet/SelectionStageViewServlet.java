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
        
        // 詳細アクションの場合（最初にチェック）
        String action = request.getParameter("action");
        String detailStudentId = request.getParameter("detailStudentId");
        String detailCompanyId = request.getParameter("detailCompanyId");
        
        System.out.println("SelectionStageViewServlet - action: " + action);
        System.out.println("SelectionStageViewServlet - 全パラメータ: " + request.getQueryString());
        System.out.println("SelectionStageViewServlet - detailStudentId: " + detailStudentId);
        System.out.println("SelectionStageViewServlet - detailCompanyId: " + detailCompanyId);
        System.out.println("SelectionStageViewServlet - action == 'detail': " + ("detail".equals(action)));
        System.out.println("SelectionStageViewServlet - detailStudentId != null: " + (detailStudentId != null));
        
        if ("detail".equals(action) || detailStudentId != null || detailCompanyId != null) {
            System.out.println("SelectionStageViewServlet - 詳細アクションを実行します");
            System.out.println("SelectionStageViewServlet - action: " + action);
            System.out.println("SelectionStageViewServlet - detailStudentId: " + detailStudentId);
            System.out.println("SelectionStageViewServlet - detailCompanyId: " + detailCompanyId);
            handleDetailAction(request, response);
            return;
        }
        
        // 編集アクションの場合
        if ("edit".equals(action)) {
            System.out.println("SelectionStageViewServlet - 編集アクションを実行します");
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
    
    /**
     * 詳細アクション処理
     */
    private void handleDetailAction(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentId = request.getParameter("detailStudentId");
        String companyId = request.getParameter("detailCompanyId");
        
        System.out.println("=== 選考ステージ詳細画面開始 ===");
        System.out.println("SelectionStageViewServlet - studentId: " + studentId);
        System.out.println("SelectionStageViewServlet - companyId: " + companyId);
        
        // nullや"null"文字列の場合はエラー扱い
        if (studentId == null || companyId == null || "null".equals(studentId) || "null".equals(companyId)) {
            System.out.println("SelectionStageViewServlet - パラメータが不足しています");
            request.setAttribute("errorMessage", "学生IDまたは企業IDが正しく取得できませんでした。");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStageDetail.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        try {
            System.out.println("SelectionStageViewServlet - DAOの初期化を開始");
            SelectionStageDAO selectionStageDAO = new SelectionStageDAO();
            CompanyDAO companyDAO = new CompanyDAO();
            StudentDAO studentDAO = new StudentDAO();
            
            // 選考ステージの基本情報を取得
            System.out.println("SelectionStageViewServlet - 選考ステージ情報を取得中...");
            List<Object> selectionStages = selectionStageDAO.getSelectionStagesByCompanyAndStudent(
                companyId, studentId
            );
            
            System.out.println("SelectionStageViewServlet - 選考ステージ取得結果: " + 
                (selectionStages != null ? selectionStages.size() : "null") + "件");
            
            Map<String, Object> selectionStage = null;
            if (selectionStages != null && !selectionStages.isEmpty()) {
                selectionStage = (Map<String, Object>) selectionStages.get(0);
                System.out.println("SelectionStageViewServlet - 選考ステージ情報取得成功: " + selectionStage);
            } else {
                System.out.println("SelectionStageViewServlet - 選考ステージが見つかりませんでした");
                request.setAttribute("errorMessage", "選考ステージが見つかりませんでした。");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStageDetail.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            // 企業情報を取得
            CompanyBean company = null;
            try {
                company = companyDAO.getCompanyBeanById(Integer.parseInt(companyId));
                System.out.println("SelectionStageViewServlet - 企業情報取得成功: " + (company != null ? company.getCompanyName() : "null"));
            } catch (Exception e) {
                System.err.println("SelectionStageViewServlet - 企業情報取得エラー: " + e.getMessage());
            }
            
            // 学生情報を取得
            ExamineeBean student = null;
            try {
                student = studentDAO.getExamineeById(Integer.parseInt(studentId));
                System.out.println("SelectionStageViewServlet - 学生情報取得成功: " + (student != null ? student.getStudentName() : "null"));
            } catch (Exception e) {
                System.err.println("SelectionStageViewServlet - 学生情報取得エラー: " + e.getMessage());
            }
            
            // データをリクエストに設定（nullでも設定）
            request.setAttribute("selectionStage", selectionStage);
            request.setAttribute("company", company);
            request.setAttribute("student", student);
            
            System.out.println("SelectionStageViewServlet - SelectionStageDetail.jspに遷移します");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStageDetail.jsp");
            dispatcher.forward(request, response);
            System.out.println("SelectionStageViewServlet - 遷移完了");
            
        } catch (Exception e) {
            System.err.println("SelectionStageViewServlet - 詳細画面遷移エラー: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "選考ステージの詳細取得に失敗しました: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStageDetail.jsp");
            dispatcher.forward(request, response);
        }
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