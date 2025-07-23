package servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import beans.CompanyBean;
import dao.CompanyDAO;

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
        ServletContext sc = getServletContext();
        List<CompanyBean> companies = (List<CompanyBean>)sc.getAttribute("companies");
        request.setAttribute("companies", companies);
        List<Integer> numdata = CompanyDAO.getCompanyCountRecruitment();
        // 統計情報を取得
        int totalCompanies = numdata.get(0);
        int recruitmentCompanies = numdata.get(1);
        
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

        // 職種リスト
        java.util.List<String> occupations = new java.util.ArrayList<>();
        int maxOccupationIndex = 0;
        try {
            maxOccupationIndex = Integer.parseInt(request.getParameter("maxOccupationIndex"));
        } catch (Exception e) {}
        for (int i = 0; i <= maxOccupationIndex; i++) {
            String occupation = request.getParameter("occupation" + i);
            if (occupation != null && !occupation.trim().isEmpty()) {
                occupations.add(occupation);
            }
        }
        // 勤務地リスト
        java.util.List<String> workPlaces = new java.util.ArrayList<>();
        int maxWorkPlaceIndex = 0;
        try {
            maxWorkPlaceIndex = Integer.parseInt(request.getParameter("maxWorkPlaceIndex"));
        } catch (Exception e) {}
        for (int i = 0; i <= maxWorkPlaceIndex; i++) {
            String workPlace = request.getParameter("workPlace" + i);
            if (workPlace != null && !workPlace.trim().isEmpty()) {
                workPlaces.add(workPlace);
            }
        }

        // バリデーション
        if (companyName == null || companyName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "企業名は必須です。");
            doGet(request, response);
            return;
        }

        // 企業を登録（まず基本情報をinsertし、IDを取得→Beanにセット→updateCompanyBeanで職種・勤務地も登録）
        //int newCompanyId = CompanyDAO.addCompanyAndGetId(companyName, postCode, address, tel, mailAddress, managerName, recruitmentResults);
        boolean success = false;
        //if (newCompanyId > 0) {
            beans.CompanyBean company = new beans.CompanyBean();
            //company.setCompanyId(newCompanyId);
            company.setCompanyName(companyName);
            company.setPostCode(postCode);
            company.setAddress(address);
            company.setTel(tel);
            company.setMailAddress(mailAddress);
            company.setManagerName(managerName);
            company.setRecruitmentResults(recruitmentResults);
            company.setOccupations(occupations);
            company.setWorkPlaces(workPlaces);
            // 職種・勤務地を登録
            CompanyDAO.addCompanyAndGetId(companyName, company);
            success = CompanyDAO.updateCompanyBean(company);
        //}
        if (success) {
            List<CompanyBean> companies = CompanyDAO.getAllCompanies();
            ServletContext sc = getServletContext();
            sc.setAttribute("companies", companies);
            List<Integer> comNumData = CompanyDAO.getCompanyCountRecruitment();
            sc.setAttribute("companies", companies);
            sc.setAttribute("comNumData", comNumData);
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
                CompanyDAO CompanyDAO = new CompanyDAO();
                List<CompanyBean> companies = CompanyDAO.getAllCompanies();
                ServletContext sc = getServletContext();
                sc.setAttribute("companies", companies);
                List<Integer> comNumData = CompanyDAO.getCompanyCountRecruitment();
                sc.setAttribute("comNumData", comNumData);
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
                CompanyDAO CompanyDAO = new CompanyDAO();
                List<CompanyBean> companies = CompanyDAO.getAllCompanies();
                ServletContext sc = getServletContext();
                sc.setAttribute("companies", companies);
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