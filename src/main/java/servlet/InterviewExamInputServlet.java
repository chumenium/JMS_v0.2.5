package servlet;

import dao.SelectionStageDAO;
import dao.CompanyDAO;
import beans.CompanyBean;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class InterviewExamInputServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 企業リストを取得
        CompanyDAO companyDAO = new CompanyDAO();
        List<CompanyBean> companies = companyDAO.getAllCompanies();
        request.setAttribute("companies", companies);

        // 選考ステージリストも（既存処理）
        String companyId = request.getParameter("companyId");
        System.out.println("InterviewExamInputServlet: companyId=" + companyId);
        request.setAttribute("selectedCompanyId", companyId); // 追加
        if (companyId != null && !companyId.isEmpty()) {
            SelectionStageDAO selectionStageDAO = new SelectionStageDAO();
            List<Map<String, Object>> selectionStages = selectionStageDAO.getSelectionStagesByCompanyId(companyId);
            request.setAttribute("selectionStages", selectionStages);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamInput.jsp");
        dispatcher.forward(request, response);
    }
    // doPostも必要なら同様に
}
