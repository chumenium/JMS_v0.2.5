package servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

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
            
            // 企業情報を取得（新しいCompanyBean構造）
            CompanyBean company = CompanyDAO.getCompanyBeanById(companyId);
            System.out.println("CompanyDetailServlet: Retrieved company data = " + company);
            
            if (company == null) {
                System.out.println("CompanyDetailServlet: Company not found");
                request.setAttribute("errorMessage", "指定された企業が見つかりません。");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/error/404.html");
                dispatcher.forward(request, response);
                return;
            }
            
            ServletContext sc = getServletContext();
            // プルダウン用データを取得
            List<String> workPlaceList = null;
            List<String> occupationList = null;
            try {
                workPlaceList = (List<String>)sc.getAttribute("workplaces");
                occupationList = (List<String>)sc.getAttribute("jobtypes");
            } catch (Exception e) {
                System.out.println("CompanyDetailServlet: Error getting dropdown data: " + e.getMessage());
                workPlaceList = new ArrayList<>();
                occupationList = new ArrayList<>();
            }
            
            // リクエストスコープに設定
            request.setAttribute("company", company);
            request.setAttribute("workPlaceList", workPlaceList);
            request.setAttribute("occupationList", occupationList);
            
            // 編集モードかどうかを判定
            String mode = request.getParameter("mode");
            boolean isEditMode = "edit".equals(mode);
            request.setAttribute("isEditMode", isEditMode);
            
            System.out.println("CompanyDetailServlet: Forwarding to JSP, editMode = " + isEditMode);
            
            // モードに応じてJSPを選択
            String jspPath;
            if (isEditMode) {
                // 編集モードの場合はCompanyDetail.jsp
                jspPath = "/WEB-INF/jsp/companyDetail.jsp";
            } else {
                // 表示モードの場合はCompanyView.jsp
                jspPath = "/WEB-INF/jsp/CompanyView.jsp";
            }
            
            // JSPにフォワード
            RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
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
     * 企業更新処理（新しいCompanyBean構造対応）
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
            
            // 職種リストを取得
            List<String> occupations = new ArrayList<>();
            int maxOccupationIndex = Integer.parseInt(request.getParameter("maxOccupationIndex"));
            for (int i = 0; i <= maxOccupationIndex; i++) {
                String occupation = request.getParameter("occupation" + i);
                if (occupation != null && !occupation.trim().isEmpty()) {
                    occupations.add(occupation);
                }
            }
            
            // 勤務地リストを取得
            List<String> workPlaces = new ArrayList<>();
            int maxWorkPlaceIndex = Integer.parseInt(request.getParameter("maxWorkPlaceIndex"));
            for (int i = 0; i <= maxWorkPlaceIndex; i++) {
                String workPlace = request.getParameter("workPlace" + i);
                if (workPlace != null && !workPlace.trim().isEmpty()) {
                    workPlaces.add(workPlace);
                }
            }
            
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
            company.setOccupations(occupations);
            company.setWorkPlaces(workPlaces);
            
            // 更新処理（新しいメソッドを使用）
            boolean success = CompanyDAO.updateCompanyBean(company);
            
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
} 