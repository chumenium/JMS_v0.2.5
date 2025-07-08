package servlet;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import beans.StudentBeans;
import dao.StudentDAO;

@WebServlet("/StudentViewServlet")
public class StudentViewServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String studentId = request.getParameter("id");
        StudentBeans student = StudentDAO.getStudentById(studentId);
        
        // 職種IDを職種名に変換
        if (student != null) {
            try {
                if (student.getDesiredJobType1() != null && !student.getDesiredJobType1().isEmpty()) {
                    String jobType1Name = StudentDAO.getOccupationNameById(Integer.parseInt(student.getDesiredJobType1()));
                    student.setDesiredJobType1(jobType1Name);
                }
                if (student.getDesiredJobType2() != null && !student.getDesiredJobType2().isEmpty()) {
                    String jobType2Name = StudentDAO.getOccupationNameById(Integer.parseInt(student.getDesiredJobType2()));
                    student.setDesiredJobType2(jobType2Name);
                }
                if (student.getDesiredJobType3() != null && !student.getDesiredJobType3().isEmpty()) {
                    String jobType3Name = StudentDAO.getOccupationNameById(Integer.parseInt(student.getDesiredJobType3()));
                    student.setDesiredJobType3(jobType3Name);
                }
            } catch (NumberFormatException e) {
                // 既に職種名が設定されている場合は何もしない
            }
        }
        
        request.setAttribute("student", student);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/studentView.jsp");
        dispatcher.forward(request, response);
    }
} 