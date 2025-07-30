package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import beans.ExamineeBean;
import dao.CompanyDAO;
import dao.StudentDAO;

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
		System.out.println("StatusServlet: doGet method called - NEW VERSION");
		try {
			String view = request.getParameter("view");
			System.out.println("StatusServlet: Initial view parameter = " + view);
			if (view == null) {
				view = request.getParameter("status");
				System.out.println("StatusServlet: view was null, trying status parameter = " + view);
			}
	        String nextPage = "/WEB-INF/jsp/status.jsp"; 

	        // デバッグログ
	        System.out.println("StatusServlet: view parameter = " + view);
	        System.out.println("StatusServlet: view parameter length = " + (view != null ? view.length() : "null"));
	        System.out.println("StatusServlet: view parameter equals DashBoard = " + ("DashBoard".equals(view)));
	        if (view != null) {
	            System.out.println("StatusServlet: view parameter bytes = " + java.util.Arrays.toString(view.getBytes()));
	            System.out.println("StatusServlet: view parameter trimmed = '" + view.trim() + "'");
	            System.out.println("StatusServlet: view parameter trimmed equals DashBoard = " + ("DashBoard".equals(view.trim())));
	        }
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
			ServletContext sc = getServletContext();
	        if (view != null) {
	            String trimmedView = view.trim();
	            System.out.println("StatusServlet: Entering switch statement with view = " + view);
	            System.out.println("StatusServlet: Using trimmed view = " + trimmedView);
	            switch (trimmedView) {
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
						ArrayList<ArrayList<String>> students = (ArrayList<ArrayList<String>>)sc.getAttribute("students");
						ArrayList<String> enrollmentStatuss = students.get(3);
						int cnt = 0;
						int allcnt = 0;
						for(String enrollmentStatus : enrollmentStatuss){
							allcnt++;
							if(enrollmentStatus.equals("活動中")){
								cnt++;
							}
						}
						request.setAttribute("allcnt",allcnt);
						request.setAttribute("cnt",cnt);
						CompanyDAO cdao = new CompanyDAO();
						double aaa = cdao.getSyuusyokuritu();
						request.setAttribute("aaa",aaa);
	                    nextPage = "/WEB-INF/jsp/StudentManagement.jsp";
	                    break;
	                case "DashBoard":
						System.out.println("StatusServlet: DashBoard case executed");
						String role2 = (String) session.getAttribute("role");
						System.out.println("StatusServlet: role2 = " + role2);
						if(!role2.equals("student")){
							System.out.println("StatusServlet: Not student role, getting data");
							StudentDAO studentDao2 = new StudentDAO();
							// データベースの日付を確認
							studentDao2.checkDatabaseDate();
							List<ExamineeBean> oneweekData = studentDao2.getExamineeBeanSchedule();
							System.out.println("StatusServlet: oneweekData size = " + (oneweekData != null ? oneweekData.size() : "null"));
							request.setAttribute("oneweekData",oneweekData);
						} else {
							System.out.println("StatusServlet: Student role, skipping data retrieval");
						}
	                    nextPage = "/WEB-INF/jsp/DashBoard.jsp";
	                    break;
	                case "jobHunting":
						List<Integer> numdata2 = (List<Integer>)sc.getAttribute("comNumData");
						// 統計情報を取得
						int totalCompanies2 = numdata2.get(0);
						int recruitmentCompanies2 = numdata2.get(1);
						request.setAttribute("totalCompanies", totalCompanies2);
						request.setAttribute("recruitmentCompanies", recruitmentCompanies2);
						StudentDAO studentDao = new StudentDAO();
						request.setAttribute("examineeNum",studentDao.getExamineeNum());
	                    nextPage = "/WEB-INF/jsp/jobHunting.jsp";
	                    break;
	                case "CompanyManagement":
						List<Integer> numdata = (List<Integer>)sc.getAttribute("comNumData");
						// 統計情報を取得
						int totalCompanies = numdata.get(0);
						int recruitmentCompanies = numdata.get(1);
						request.setAttribute("totalCompanies", totalCompanies);
						request.setAttribute("recruitmentCompanies", recruitmentCompanies);
	                    nextPage = "/WEB-INF/jsp/CompanyManagement.jsp";
	                    break;
	                case "CompanyList":
	                    nextPage = "/WEB-INF/jsp/CompanyList.jsp";
	                    break;
	                case "applicantList":
						StudentDAO StudentDAO = new StudentDAO();
						List<ExamineeBean> examinees= StudentDAO.getExamineeBean();
						request.setAttribute("examinees",examinees);
	                    nextPage = "/WEB-INF/jsp/applicantList.jsp";
	                    break;
	                case "studentList":
	                    nextPage = "/WEB-INF/jsp/StudentList.jsp";
	                    break;
	                case "createStudent":
						//DropdownDataDAO dropdownDAO = new DropdownDataDAO();
						request.setAttribute("jobtypes", sc.getAttribute("jobtypes"));
						System.out.print("アプリケーションスコープのデータを使用");
	                    nextPage = "/WEB-INF/jsp/CreateStudent.jsp";
	                    break;
	                                case "InterviewExamInput.jsp":
                    nextPage = "/WEB-INF/jsp/SelectionStage.jsp";
                    break;
                	case "SelectionStage":
                    nextPage = "/WEB-INF/jsp/SelectionStage.jsp";
                    break;
	                default:
	                    System.out.println("StatusServlet: Default case executed for view = " + trimmedView);
	                    nextPage = "/index.jsp";
	                    break;
					case "CompanyDetail":
						nextPage = "/WEB-INF/jsp/CompanyDetail.jsp";
						break;
					case "CreateCompany":
						nextPage = "/WEB-INF/jsp/CreateCompany.jsp";
						break;
					case "adminDatabase":
						nextPage = "/WEB-INF/jsp/adminDatabase.jsp";
						break;
					case "databaseManagement":
						nextPage = "/WEB-INF/jsp/databaseManagement.jsp";
						break;
				

	            }
	        } else {
	            System.out.println("StatusServlet: view is null, using default nextPage");
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
