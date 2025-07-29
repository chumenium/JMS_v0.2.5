package servlet;

import java.io.IOException;
import java.util.List;

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
 * 企業一覧サーブレット
 * 企業一覧の表示機能を提供
 */
public class CompanyListServlet extends HttpServlet {
    
    	private CompanyDAO CompanyDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            		CompanyDAO = new CompanyDAO();
        } catch (Exception e) {
            throw new ServletException("CompanyDAOの初期化に失敗しました", e);
        }
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
        if (role == null || (!role.equals("admin") && !role.equals("egd") && !role.equals("student"))) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        try {
            // 企業一覧を取得
            ServletContext sc = getServletContext();
            List<CompanyBean> companies = (List<CompanyBean>)sc.getAttribute("companies");
            request.setAttribute("companies", companies);
            List<Integer> numdata = (List<Integer>)sc.getAttribute("comNumData");
            // 統計情報を取得
            int totalCompanies = numdata.get(0);
		    int recruitmentCompanies = numdata.get(1);
            request.setAttribute("totalCompanies", totalCompanies);
            request.setAttribute("recruitmentCompanies", recruitmentCompanies);
        } catch (Exception e) {
            // エラーが発生した場合は空のリストを設定
            request.setAttribute("companies", new java.util.ArrayList<>());
            request.setAttribute("totalCompanies", 0);
            request.setAttribute("recruitmentCompanies", 0);
            request.setAttribute("errorMessage", "企業データの取得に失敗しました: " + e.getMessage());
        }
        
        // 企業一覧ページにフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/CompanyList.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // POSTリクエストはGETと同じ処理
        doGet(request, response);
    }
} 