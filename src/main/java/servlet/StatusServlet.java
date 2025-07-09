package servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.DropdownDataDAO;

/**
 * Servlet implementation class StatusServlet
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
			// セッションの確認
			HttpSession session = request.getSession(false);
			if (session == null || session.getAttribute("id") == null) {
				response.sendRedirect(request.getContextPath() + "/login.html");
				return;
			}
			
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
	        String username = (String) session.getAttribute("username");
	        String role = (String) session.getAttribute("role");
	        String id = (String) session.getAttribute("id");
	        System.out.println("StatusServlet: session username = " + username);
	        System.out.println("StatusServlet: session role = " + role);
	        System.out.println("StatusServlet: session id = " + id);

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
	                    // 権限チェック（教員、校長・教務部長、管理者のみ）
	                    if (role == null || (!"teacher".equals(role) && !"headmaster".equals(role) && !"admin".equals(role))) {
	                        response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
	                        return;
	                    }
	                    nextPage = "/WEB-INF/jsp/StudentManagement.jsp";
	                    break;
	                case "DashBoard":
	                    nextPage = "/WEB-INF/jsp/DashBoard.jsp";
	                    break;
	                case "jobHunting":
	                    nextPage = "/WEB-INF/jsp/jobHunting.jsp";
	                    break;
	                                case "CompanyManagement":
                    // 権限チェック（就職指導部、管理者のみ）
                    if (role == null || (!"egd".equals(role) && !"admin".equals(role))) {
                        response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
                        return;
                    }
                    nextPage = "/WEB-INF/jsp/CompanyManagement.jsp";
                    break;
	                case "CompanyList":
	                    // 権限チェック（就職指導部、管理者のみ）
	                    if (role == null || (!"egd".equals(role) && !"admin".equals(role))) {
	                        response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
	                        return;
	                    }
	                    nextPage = "/WEB-INF/jsp/CompanyList.jsp";
	                    break;
	                case "applicantList":
	                    // 権限チェック（教員、校長・教務部長、就職指導部、管理者のみ）
	                    if (role == null || (!"teacher".equals(role) && !"headmaster".equals(role) && !"egd".equals(role) && !"admin".equals(role))) {
	                        response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
	                        return;
	                    }
	                    nextPage = "/WEB-INF/jsp/applicantList.jsp";
	                    break;
	                case "studentList":
	                    // 権限チェック（教員、校長・教務部長、管理者のみ）
	                    if (role == null || (!"teacher".equals(role) && !"headmaster".equals(role) && !"admin".equals(role))) {
	                        response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
	                        return;
	                    }
	                    nextPage = "/WEB-INF/jsp/StudentList.jsp";
	                    break;
	                case "createStudent":
	                    // 権限チェック（教員、校長・教務部長、管理者のみ）
	                    if (role == null || (!"teacher".equals(role) && !"headmaster".equals(role) && !"admin".equals(role))) {
	                        response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
	                        return;
	                    }
						DropdownDataDAO DropdownDataDAO = new DropdownDataDAO();
	request.setAttribute("jobtypes", DropdownDataDAO.getJobtypes());
	                    nextPage = "/WEB-INF/jsp/CreateStudent.jsp";
	                    break;
	                case "studentDetail":
	                    // 権限チェック（教員、校長・教務部長、管理者、学生のみ）
	                    if (role == null || (!"teacher".equals(role) && !"headmaster".equals(role) && !"admin".equals(role) && !"student".equals(role))) {
	                        response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
	                        return;
	                    }
	                    nextPage = "/WEB-INF/jsp/studentDetail.jsp";
	                    break;
	                case "studentView":
	                    // 権限チェック（教員、校長・教務部長、管理者、学生のみ）
	                    if (role == null || (!"teacher".equals(role) && !"headmaster".equals(role) && !"admin".equals(role) && !"student".equals(role))) {
	                        response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
	                        return;
	                    }
	                    nextPage = "/WEB-INF/jsp/studentView.jsp";
	                    break;
	                case "interviewExamInput":
	                    // 権限チェック（全ユーザー）
	                    if (role == null) {
	                        response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
	                        return;
	                    }
	                    nextPage = "/WEB-INF/jsp/InterviewExamInput.jsp";
	                    break;
	                case "selectionStage":
	                    // 権限チェック（全ユーザー）
	                    if (role == null) {
	                        response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
	                        return;
	                    }
	                    nextPage = "/WEB-INF/jsp/SelectionStage.jsp";
	                    break;
	                case "adminDatabase.jsp":
	                    // 権限チェック（管理者のみ）
	                    if (role == null || !"admin".equals(role)) {
	                        response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
	                        return;
	                    }
	                    nextPage = "/WEB-INF/jsp/adminDatabase.jsp";
	                    break;
	                default:
	                    // デフォルトはダッシュボードに遷移
	                    nextPage = "/WEB-INF/jsp/DashBoard.jsp";
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
