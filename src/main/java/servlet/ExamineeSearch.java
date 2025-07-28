package servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import beans.ExamineeBean;
import dao.StudentDAO;

/**
 * Servlet implementation class ExamineeSearch
 */
@WebServlet("/ExamineeSearch")
public class ExamineeSearch extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ExamineeSearch() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StudentDAO StudentDAO = new StudentDAO();
        List<ExamineeBean> examinees= StudentDAO.getExamineeBean();
        String companyName = request.getParameter("searchCompany");
        String studentName = request.getParameter("searchStudent");
        String selection = request.getParameter("searchStatus");
        String className = request.getParameter("searchClass");
        System.out.println(companyName);
        System.out.println(studentName);
        System.out.println(selection);
        System.out.println(className);

        request.setAttribute("examinees",examinees);
        String nextPage = "/WEB-INF/jsp/applicantList.jsp";
        RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
        dispatcher.forward(request, response);
	}

}
