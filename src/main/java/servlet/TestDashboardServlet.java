package servlet;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * テスト用ダッシュボードサーブレット
 * 権限チェックをバイパスして各JSPページに直接アクセスできる
 * 本番環境では使用しないこと！
 */
public class TestDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // テスト用のセッションを作成（権限チェックをバイパス）
        HttpSession session = request.getSession(true);
        session.setAttribute("test_mode", true);
        session.setAttribute("user_id", "test_user");
        session.setAttribute("role", "admin");
        
        String page = request.getParameter("page");
        
        if (page == null || page.isEmpty()) {
            // パラメータがない場合はテストダッシュボードを表示
            response.sendRedirect(request.getContextPath() + "/test-dashboard.html");
            return;
        }
        
        String jspPath = "/WEB-INF/jsp/";
        RequestDispatcher dispatcher = null;
        
        switch (page) {
            case "StudentManagement":
                dispatcher = request.getRequestDispatcher(jspPath + "StudentManagement.jsp");
                break;
            case "StudentList":
                dispatcher = request.getRequestDispatcher(jspPath + "StudentList.jsp");
                break;
            case "CreateStudent":
                dispatcher = request.getRequestDispatcher(jspPath + "CreateStudent.jsp");
                break;
            case "DashBoard":
                dispatcher = request.getRequestDispatcher(jspPath + "DashBoard.jsp");
                break;
            case "companyManagement":
                dispatcher = request.getRequestDispatcher(jspPath + "companyManagement.jsp");
                break;
            case "InterviewExamInput":
                dispatcher = request.getRequestDispatcher(jspPath + "InterviewExamInput.jsp");
                break;
            case "SelectionStage":
                dispatcher = request.getRequestDispatcher(jspPath + "SelectionStage.jsp");
                break;
            case "temp_jms":
                dispatcher = request.getRequestDispatcher(jspPath + "temp_jms.jsp");
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "指定されたページが見つかりません: " + page);
                return;
        }
        
        if (dispatcher != null) {
            // テストモードであることを示すメッセージをリクエストに設定
            request.setAttribute("test_message", "【テストモード】このページは権限チェックをバイパスして表示されています。");
            dispatcher.forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 