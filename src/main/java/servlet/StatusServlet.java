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
		String view = request.getParameter("view");
        String nextPage = "/WEB-INF/jsp/status.jsp"; 

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
                default:
                    nextPage = "/index.jsp";
                    break;
            }
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
        dispatcher.forward(request, response);
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
