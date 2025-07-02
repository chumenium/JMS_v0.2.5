package servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class statusServlet
 */
//@WebServlet("/StatusServlet")
public class StatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public StatusServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	
	
	
	/**
	 * すべての参照jspをここに集約
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			String view = request.getParameter("view");
			if (view == null) {
				view = request.getParameter("status");
			}
	        String nextPage = "/WEB-INF/jsp/status.jsp"; 

	        // デバッグログ
	        System.out.println("StatusServlet: view parameter = " + view);
	        System.out.println("StatusServlet: request URI = " + request.getRequestURI());
	        System.out.println("StatusServlet: context path = " + request.getContextPath());

	        // セッション情報のデバッグ
	        jakarta.servlet.http.HttpSession session = request.getSession(false);
	        if (session != null) {
	            String username = (String) session.getAttribute("username");
	            String role = (String) session.getAttribute("role");
	            String id = (String) session.getAttribute("id");
	            System.out.println("StatusServlet: session username = " + username);
	            System.out.println("StatusServlet: session role = " + role);
	            System.out.println("StatusServlet: session id = " + id);
	        } else {
	            System.out.println("StatusServlet: session is null");
	        }

	        java.util.Map<String, String[]> paramMap = request.getParameterMap();
	        for (String key : paramMap.keySet()) {
	            System.out.println("StatusServlet: param " + key + " = " + java.util.Arrays.toString(paramMap.get(key)));
	        }

	        if (view != null) {
	            switch (view) {
	                case "index":
	                    nextPage = "/WEB-INF/jsp/index.jsp";
	                    break;
	                case "1":
	                    nextPage = "/WEB-INF/jsp/1.jsp";
	                    break;
	                case "2":
	                    nextPage = "/WEB-INF/jsp/2.jsp";
	                    break;
	                case "3":
	                    nextPage = "/WEB-INF/jsp/3.jsp";
	                    break;
	                case "studentManagement":
	                    nextPage = "/WEB-INF/jsp/StudentManagement.jsp";
	                    break;
	                case "DashBoard":
	                    nextPage = "/WEB-INF/jsp/DashBoard.jsp";
	                    break;
	                case "jobHunting":
	                    nextPage = "/WEB-INF/jsp/jobHunting.jsp";
	                    break;
	                case "CompanyManagement":
	                    nextPage = "/WEB-INF/jsp/CompanyManagement.jsp";
	                    break;
	                case "applicantList":
	                    nextPage = "/WEB-INF/jsp/applicantList.jsp";
	                    break;
	                case "studentList":
	                    nextPage = "/WEB-INF/jsp/StudentList.jsp";
	                    break;
	                case "createStudent":
	                    nextPage = "/WEB-INF/jsp/CreateStudent.jsp";
	                    break;
	                default:
	                    nextPage = "/index.jsp";
	                    break;
	            }
	        }

	        // デバッグログ
	        System.out.println("StatusServlet: nextPage = " + nextPage);

	        RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
	        dispatcher.forward(request, response);
		} catch (Exception e) {
			System.err.println("StatusServlet Error: " + e.getMessage());
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			response.getWriter().println("Error: " + e.getMessage());
		}
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
