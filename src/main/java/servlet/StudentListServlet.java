package servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.StudentDAO;

/**
 * 学生一覧サーブレット
 * 学生一覧の表示機能を提供
 */
public class StudentListServlet extends HttpServlet {
    
    	private StudentDAO StudentDAO = new StudentDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 権限チェック（管理者、教員のみ）
        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("admin") && !role.equals("teacher") && !role.equals("headmaster"))) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        try {
            // 学生一覧を取得
            		List<Map<String, Object>> students = StudentDAO.getAllStudents();
            request.setAttribute("students", students);
            
            // 検索パラメータがある場合の処理
            String searchClass = request.getParameter("searchClass");
            String searchStatus = request.getParameter("searchStatus");
            String searchName = request.getParameter("searchName");
            
            if (searchClass != null || searchStatus != null || searchName != null) {
                // 検索条件に基づいて学生を絞り込み
                students = filterStudents(students, searchClass, searchStatus, searchName);
                request.setAttribute("students", students);
            }
            
            // ドロップダウン用のデータを取得
            		List<String> classes = StudentDAO.getClasses();
		List<String> statuses = StudentDAO.getEnrollmentStatuses();
            
            request.setAttribute("classes", classes);
            request.setAttribute("statuses", statuses);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "学生一覧の取得中にエラーが発生しました。");
        }
        
        // 学生一覧ページにフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/StudentList.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * 検索条件に基づいて学生を絞り込み
     */
    private List<Map<String, Object>> filterStudents(List<Map<String, Object>> students, 
                                                   String searchClass, String searchStatus, String searchName) {
        return students.stream()
                .filter(student -> {
                    boolean match = true;
                    
                    if (searchClass != null && !searchClass.trim().isEmpty()) {
                        String studentClass = (String) student.get("class");
                        match = match && (studentClass != null && studentClass.contains(searchClass));
                    }
                    
                    if (searchStatus != null && !searchStatus.trim().isEmpty()) {
                        String studentStatus = (String) student.get("enrollment_status");
                        match = match && (studentStatus != null && studentStatus.equals(searchStatus));
                    }
                    
                    if (searchName != null && !searchName.trim().isEmpty()) {
                        String studentName = (String) student.get("name");
                        match = match && (studentName != null && studentName.contains(searchName));
                    }
                    
                    return match;
                })
                .collect(java.util.stream.Collectors.toList());
    }
} 