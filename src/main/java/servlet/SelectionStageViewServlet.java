package servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import beans.CompanyBean;
import dao.CompanyDAO;
import dao.SelectionStageDAO;

@WebServlet("/SelectionStageViewServlet")
public class SelectionStageViewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // 企業一覧を取得
        CompanyDAO companyDAO = new CompanyDAO();
        List<CompanyBean> companies = companyDAO.getAllCompanies();
        request.setAttribute("companies", companies);
        
        // 企業IDが指定されている場合、その企業の選考ステージを取得
        String companyId = request.getParameter("companyId");
        System.out.println("SelectionStageViewServlet: companyId=" + companyId);
        request.setAttribute("selectedCompanyId", companyId);
        
        if (companyId != null && !companyId.isEmpty()) {
            SelectionStageDAO selectionStageDAO = new SelectionStageDAO();
            List<Object> selectionStages = selectionStageDAO.getSelectionStagesByCompanyId(companyId);
            request.setAttribute("selectionStages", selectionStages);
        }
        
        // JSPにフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStageView.jsp");
        dispatcher.forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 