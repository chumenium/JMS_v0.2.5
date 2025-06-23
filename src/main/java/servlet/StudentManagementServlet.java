package servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.DropdownDataDAO;

/**
 * 学生管理画面用Servlet
 */
public class StudentManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private DropdownDataDAO dropdownDataDAO;
    
    @Override
    public void init() throws ServletException {
        dropdownDataDAO = new DropdownDataDAO();
    }
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
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
        
        try {
            // プルダウン用のデータを取得
            List<String> classList = dropdownDataDAO.getClassList();
            List<String> enrollmentStatusList = dropdownDataDAO.getEnrollmentStatusList();
            List<String> assistanceList = dropdownDataDAO.getAssistanceList();
            List<String> firstChoiceIndustryList = dropdownDataDAO.getFirstChoiceIndustryList();
            List<Integer> graduationYearList = dropdownDataDAO.getGraduationYearList();
            
            // リクエストスコープにデータを設定
            request.setAttribute("classList", classList);
            request.setAttribute("enrollmentStatusList", enrollmentStatusList);
            request.setAttribute("assistanceList", assistanceList);
            request.setAttribute("firstChoiceIndustryList", firstChoiceIndustryList);
            request.setAttribute("graduationYearList", graduationYearList);
            
            // JSPにフォワード
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/StudentManagement.jsp");
            dispatcher.forward(request, response);
            
        } catch (SQLException | ClassNotFoundException e) {
            // エラーハンドリング
            request.setAttribute("errorMessage", "データの取得に失敗しました: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/StudentManagement.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 