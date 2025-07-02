package servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.DropdownDataDAO;

/**
 * Servlet implementation class StudentManagementServlet
 */

public class StudentManagementServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StudentManagementServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// セッションから権限を取得
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        // 権限チェック
        if (role == null || 
            (!"teacher".equals(role) && 
             !"headmaster".equals(role) && 
             !"admin".equals(role))) {
            response.sendRedirect("login.html");
            return;
        }
        
		DropdownDataDAO dao = new DropdownDataDAO();
        List<String> classes = dao.getClasses();
        List<String> statuses = dao.getEnrollmentStatuses();
        List<String> mediations = dao.getMediationStatuses();
        List<String> industries = dao.getIndustries();
        List<Integer> years = dao.getGraduationYears();

        request.setAttribute("classes", classes);
        request.setAttribute("statuses", statuses);
        request.setAttribute("mediations", mediations);
        request.setAttribute("industries", industries);
        request.setAttribute("years", years);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/StudentManagement.jsp");
        dispatcher.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 