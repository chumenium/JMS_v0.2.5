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
        
        String companyIdStr = request.getParameter("companyId");
        if (companyIdStr == null || companyIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/StatusServlet?view=CompanyManagement");
            return;
        }
        
        try {
            int companyId = Integer.parseInt(companyIdStr);
            
            // 企業情報を取得
            Map<String, Object> companyData = CompanyDAO.getCompanyById(companyId);
            if (companyData == null) {
                request.setAttribute("errorMessage", "指定された企業が見つかりません。");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/error/404.html");
                dispatcher.forward(request, response);
                return;
            }
            
            // MapからCompanyBeanに変換
            CompanyBean company = new CompanyBean();
            company.setCompanyId((Integer) companyData.get("companys_id"));
            company.setCompanyName((String) companyData.get("company_name"));
            company.setPostCode((String) companyData.get("post_code"));
            company.setAddress((String) companyData.get("address"));
            company.setTel((String) companyData.get("tel"));
            company.setMailAddress((String) companyData.get("mail_address"));
            company.setManagerName((String) companyData.get("manager_name"));
            company.setRecruitmentResults((Boolean) companyData.get("recruitment_results"));
            
            			// 勤務地・職種名を取得
			String workPlaceName = CompanyDAO.getWorkPlaceName(company.getWorkPlaceId());
			String occupationName = CompanyDAO.getOccupationName(company.getOccupationId());
			
			// プルダウン用データを取得
			List<String> workPlaces = CompanyDAO.getWorkPlaces();
			List<String> occupations = CompanyDAO.getOccupations();
            
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
            
            // JSPにフォワード
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/companyDetail.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/StatusServlet?view=CompanyManagement");
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