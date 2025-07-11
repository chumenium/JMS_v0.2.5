package servlet;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.CompanyDAO;
import java.util.List;
import java.util.Map;

/**
 * 企業管理サーブレット
 * 企業情報の管理機能を提供
 */
public class CompanyManagementServlet extends HttpServlet {
    
    	private CompanyDAO CompanyDAO;
    
    @Override
    public void init() throws ServletException {
        		CompanyDAO = new CompanyDAO();
    }   
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 権限チェック（就職指導部または管理者のみ）
        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("admin") && !role.equals("egd"))) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        // 企業一覧を取得
        		List<Map<String, Object>> companies = CompanyDAO.getAllCompanies();
        request.setAttribute("companies", companies);
        
        // 統計情報を取得
        		int totalCompanies = CompanyDAO.getCompanyCount();
		int recruitmentCompanies = CompanyDAO.getRecruitmentCompanyCount();
        request.setAttribute("totalCompanies", totalCompanies);
        request.setAttribute("recruitmentCompanies", recruitmentCompanies);
        
        // 企業管理ページにフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/CompanyManagement.jsp");
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
        if (role == null || (!role.equals("admin") && !role.equals("egd"))) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
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
        
        // リクエストパラメータを取得
        String companyName = request.getParameter("company_name");
        String postCode = request.getParameter("post_code");
        String address = request.getParameter("address");
        String tel = request.getParameter("tel");
        String mailAddress = request.getParameter("mail_address");
        String managerName = request.getParameter("manager_name");

        boolean recruitmentResults = "true".equals(request.getParameter("recruitment_results"));
        
        // バリデーション
        if (companyName == null || companyName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "企業名は必須です。");
            doGet(request, response);
            return;
        }
        
        // 企業を登録
        		boolean success = CompanyDAO.addCompany(companyName, postCode, address, tel, mailAddress, managerName, recruitmentResults);
        
        if (success) {
            request.setAttribute("successMessage", "企業の登録が完了しました。");
        } else {
            request.setAttribute("errorMessage", "企業の登録に失敗しました。");
        }
        
        doGet(request, response);
    }
    
    private void handleUpdateCompany(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // リクエストパラメータを取得
        String companyIdStr = request.getParameter("company_id");
        String companyName = request.getParameter("company_name");
        String postCode = request.getParameter("post_code");
        String address = request.getParameter("address");
        String tel = request.getParameter("tel");
        String mailAddress = request.getParameter("mail_address");
        String managerName = request.getParameter("manager_name");
        boolean recruitmentResults = "true".equals(request.getParameter("recruitment_results"));
        
        // バリデーション
        if (companyIdStr == null || companyIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "企業IDが指定されていません。");
            doGet(request, response);
            return;
        }
        
        if (companyName == null || companyName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "企業名は必須です。");
            doGet(request, response);
            return;
        }
        
        try {
            int companyId = Integer.parseInt(companyIdStr);
            		boolean success = CompanyDAO.updateCompany(companyId, companyName, postCode, address, tel, mailAddress, managerName, recruitmentResults);
            
            if (success) {
                request.setAttribute("successMessage", "企業情報の更新が完了しました。");
            } else {
                request.setAttribute("errorMessage", "企業情報の更新に失敗しました。");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "無効な企業IDです。");
        }
        
        doGet(request, response);
    }
    
    private void handleDeleteCompany(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // リクエストパラメータを取得
        String companyIdStr = request.getParameter("company_id");
        
        // バリデーション
        if (companyIdStr == null || companyIdStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "企業IDが指定されていません。");
            doGet(request, response);
            return;
        }
        
        try {
            int companyId = Integer.parseInt(companyIdStr);
            		boolean success = CompanyDAO.deleteCompany(companyId);
            
            if (success) {
                request.setAttribute("successMessage", "企業の削除が完了しました。");
            } else {
                request.setAttribute("errorMessage", "企業の削除に失敗しました。");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "無効な企業IDです。");
        }
        
        doGet(request, response);
    }
} 