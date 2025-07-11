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

/**
 * 企業詳細・編集サーブレット
 */
public class CompanyDetailServlet extends HttpServlet {
    
    	private CompanyDAO CompanyDAO = new CompanyDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 詳細なデバッグ情報
        System.out.println("=== CompanyDetailServlet Debug Info ===");
        System.out.println("Request URL: " + request.getRequestURL());
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Servlet Path: " + request.getServletPath());
        System.out.println("Query String: " + request.getQueryString());
        System.out.println("Method: " + request.getMethod());
        
        // パラメータ情報
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        System.out.println("Parameters:");
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println("  " + paramName + " = " + paramValue);
        }
        
        // セッション確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            System.out.println("CompanyDetailServlet: Session invalid, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 権限チェック（就職指導部・システム管理者のみ）
        String role = (String) session.getAttribute("role");
        System.out.println("CompanyDetailServlet: User role = " + role);
        if (role == null || (!role.equals("egd") && !role.equals("admin"))) {
            System.out.println("CompanyDetailServlet: Access denied, redirecting to 403");
            response.sendRedirect(request.getContextPath() + "/error/403.html");
            return;
        }
        
        String companyIdStr = request.getParameter("companyId");
        System.out.println("CompanyDetailServlet: companyId parameter = " + companyIdStr);
        if (companyIdStr == null || companyIdStr.trim().isEmpty()) {
            System.out.println("CompanyDetailServlet: No companyId provided, redirecting to CompanyManagement");
            response.sendRedirect(request.getContextPath() + "/StatusServlet?view=CompanyManagement");
            return;
        }
        
        try {
            int companyId = Integer.parseInt(companyIdStr);
            System.out.println("CompanyDetailServlet: Parsed companyId = " + companyId);
            
            // 企業情報を取得
            Map<String, Object> companyData = CompanyDAO.getCompanyById(companyId);
            System.out.println("CompanyDetailServlet: Retrieved company data = " + companyData);
            
            if (companyData == null) {
                System.out.println("CompanyDetailServlet: Company not found");
                request.setAttribute("errorMessage", "指定された企業が見つかりません。");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/error/404.html");
                dispatcher.forward(request, response);
                return;
            }
            
            // MapからCompanyBeanに変換（null安全）
            CompanyBean company = new CompanyBean();
            
            // null安全な値設定
            Integer companyIdFromDb = (Integer) companyData.get("companys_id");
            if (companyIdFromDb != null) {
                company.setCompanyId(companyIdFromDb);
            }
            
            String companyName = (String) companyData.get("company_name");
            company.setCompanyName(companyName != null ? companyName : "");
            
            String postCode = (String) companyData.get("post_code");
            company.setPostCode(postCode != null ? postCode : "");
            
            String address = (String) companyData.get("address");
            company.setAddress(address != null ? address : "");
            
            String tel = (String) companyData.get("tel");
            company.setTel(tel != null ? tel : "");
            
            String mailAddress = (String) companyData.get("mail_address");
            company.setMailAddress(mailAddress != null ? mailAddress : "");
            
            String managerName = (String) companyData.get("manager_name");
            company.setManagerName(managerName != null ? managerName : "");
            
            Boolean recruitmentResults = (Boolean) companyData.get("recruitment_results");
            company.setRecruitmentResults(recruitmentResults != null ? recruitmentResults : false);
            
            // 勤務地・職種IDを設定（データベースから取得した場合）
            if (companyData.get("work_place_id") != null) {
                company.setWorkPlaceId((Integer) companyData.get("work_place_id"));
            }
            if (companyData.get("occupation_id") != null) {
                company.setOccupationId((Integer) companyData.get("occupation_id"));
            }
            
            System.out.println("CompanyDetailServlet: Created CompanyBean = " + company);
            
            // 勤務地・職種名を取得
            String workPlaceName = "";
            String occupationName = "";
            try {
                if (company.getWorkPlaceId() > 0) {
                    workPlaceName = CompanyDAO.getWorkPlaceName(company.getWorkPlaceId());
                }
                if (company.getOccupationId() > 0) {
                    occupationName = CompanyDAO.getOccupationName(company.getOccupationId());
                }
            } catch (Exception e) {
                System.out.println("CompanyDetailServlet: Error getting place/occupation names: " + e.getMessage());
            }
            
            // プルダウン用データを取得
            List<String> workPlaces = null;
            List<String> occupations = null;
            try {
                workPlaces = CompanyDAO.getWorkPlaces();
                occupations = CompanyDAO.getOccupations();
            } catch (Exception e) {
                System.out.println("CompanyDetailServlet: Error getting dropdown data: " + e.getMessage());
                workPlaces = new java.util.ArrayList<>();
                occupations = new java.util.ArrayList<>();
            }
            
            // リクエストスコープに設定
            request.setAttribute("company", company);
            request.setAttribute("workPlaceName", workPlaceName);
            request.setAttribute("occupationName", occupationName);
            request.setAttribute("workPlaces", workPlaces);
            request.setAttribute("occupations", occupations);
            
            // 編集モードかどうかを判定
            String mode = request.getParameter("mode");
            boolean isEditMode = "edit".equals(mode);
            request.setAttribute("isEditMode", isEditMode);
            
            System.out.println("CompanyDetailServlet: Forwarding to JSP, editMode = " + isEditMode);
            
            // JSPにフォワード
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/companyDetail.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            System.out.println("CompanyDetailServlet: NumberFormatException: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/StatusServlet?view=CompanyManagement");
        } catch (Exception e) {
            System.out.println("CompanyDetailServlet: Unexpected error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "システムエラーが発生しました: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/error/500.html");
            dispatcher.forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッション確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 権限チェック（就職指導部・システム管理者のみ）
        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("egd") && !role.equals("admin"))) {
            response.sendRedirect(request.getContextPath() + "/error/403.html");
            return;
        }
        
        // アクションを取得
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            // 削除処理
            handleDelete(request, response);
        } else {
            // 更新処理
            handleUpdate(request, response);
        }
    }
    
    /**
     * 企業削除処理
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int companyId = Integer.parseInt(request.getParameter("companyId"));
            System.out.println("CompanyDetailServlet: handleDelete called with companyId = " + companyId);
            
            // 企業削除
            boolean success = CompanyDAO.deleteCompany(companyId);
            System.out.println("CompanyDetailServlet: deleteCompany result = " + success);
            
            if (success) {
                // 削除成功 - 企業一覧にリダイレクト
                System.out.println("CompanyDetailServlet: Delete successful, redirecting to CompanyListServlet");
                response.sendRedirect(request.getContextPath() + "/CompanyListServlet?message=deleted");
            } else {
                // 削除失敗 - エラーメッセージと共に詳細画面に戻る
                System.out.println("CompanyDetailServlet: Delete failed");
                request.setAttribute("errorMessage", "企業の削除に失敗しました。");
                response.sendRedirect(request.getContextPath() + "/CompanyDetailServlet?companyId=" + companyId + "&error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            System.out.println("CompanyDetailServlet: NumberFormatException in handleDelete: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/StatusServlet?view=CompanyManagement");
        }
    }
    
    /**
     * 企業更新処理
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // フォームデータを取得
            int companyId = Integer.parseInt(request.getParameter("companyId"));
            String companyName = request.getParameter("companyName");
            String postCode = request.getParameter("postCode");
            String address = request.getParameter("address");
            String tel = request.getParameter("tel");
            String mailAddress = request.getParameter("mailAddress");
            String managerName = request.getParameter("managerName");
            boolean recruitmentResults = "true".equals(request.getParameter("recruitmentResults"));
            
            // 勤務地・職種をIDに変換
            int workPlaceId = getWorkPlaceId(request.getParameter("workPlace"));
            int occupationId = getOccupationId(request.getParameter("occupation"));
            
            // CompanyBeanに設定
            CompanyBean company = new CompanyBean();
            company.setCompanyId(companyId);
            company.setCompanyName(companyName);
            company.setPostCode(postCode);
            company.setAddress(address);
            company.setTel(tel);
            company.setMailAddress(mailAddress);
            company.setManagerName(managerName);
            company.setRecruitmentResults(recruitmentResults);
            company.setWorkPlaceId(workPlaceId);
            company.setOccupationId(occupationId);
            
            // 更新処理
            boolean success = CompanyDAO.updateCompany(company);
            
            if (success) {
                request.setAttribute("successMessage", "企業情報を更新しました。");
            } else {
                request.setAttribute("errorMessage", "企業情報の更新に失敗しました。");
            }
            
            // 詳細画面に戻る
            response.sendRedirect(request.getContextPath() + "/CompanyDetailServlet?companyId=" + companyId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "入力データに不正な値が含まれています。");
            doGet(request, response);
        } catch (Exception e) {
            System.out.println("CompanyDetailServlet: Update error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "更新処理中にエラーが発生しました: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    /**
     * 勤務地名からIDを取得
     */
    private int getWorkPlaceId(String workPlaceName) {
        if (workPlaceName == null || workPlaceName.trim().isEmpty()) {
            return 0;
        }
        
        		// 簡易的な実装（実際はDAOで検索）
		List<String> workPlaces = CompanyDAO.getWorkPlaces();
        for (int i = 0; i < workPlaces.size(); i++) {
            if (workPlaces.get(i).equals(workPlaceName)) {
                return i + 1; // IDは1から始まると仮定
            }
        }
        return 0;
    }
    
    /**
     * 職種名からIDを取得
     */
    private int getOccupationId(String occupationName) {
        if (occupationName == null || occupationName.trim().isEmpty()) {
            return 0;
        }
        
        		// 簡易的な実装（実際はDAOで検索）
		List<String> occupations = CompanyDAO.getOccupations();
        for (int i = 0; i < occupations.size(); i++) {
            if (occupations.get(i).equals(occupationName)) {
                return i + 1; // IDは1から始まると仮定
            }
        }
        return 0;
    }
} 