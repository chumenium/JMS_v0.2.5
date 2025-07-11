package servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import beans.StudentBeans;
import dao.StudentDAO;

/**
 * 学生表示サーブレット
 * 学生情報の表示機能を提供
 */
public class StudentViewServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 権限チェック
        String role = (String) session.getAttribute("role");
        if (role == null || (!role.equals("admin") && !role.equals("teacher") && 
                           !role.equals("headmaster") && !role.equals("student"))) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
            String studentId = request.getParameter("id");
            
            // 学生の場合は自分の情報のみ閲覧可能
            if ("student".equals(role)) {
                String sessionStudentId = (String) session.getAttribute("id");
                if (studentId == null) {
                    studentId = sessionStudentId;
                } else if (!studentId.equals(sessionStudentId)) {
                    response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
                    return;
                }
            }
            
            if (studentId == null || studentId.trim().isEmpty()) {
                request.setAttribute("error", "学生IDが指定されていません。");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/studentView.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            StudentBeans student = StudentDAO.getStudentById(studentId);
            
            if (student == null) {
                request.setAttribute("error", "指定された学生が見つかりません。");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/studentView.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            request.setAttribute("student", student);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/studentView.jsp");
            dispatcher.forward(request, response);
            
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("error", "システムエラーが発生しました: " + e.getMessage());
//            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/studentView.jsp");
//            dispatcher.forward(request, response);
//        }
    }
} 