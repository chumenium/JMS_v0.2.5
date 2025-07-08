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
import dao.DropdownDataDAO;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/StudentDetailServlet")
public class StudentDetailServlet extends HttpServlet {
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
        
        // プルダウン用のデータを取得
        StudentDAO dropdownDAO = new StudentDAO();
        request.setAttribute("jobtypes", dropdownDAO.getJobtypes());
        request.setAttribute("workplaces", dropdownDAO.getWorkplaces());
        
        request.setAttribute("student", student);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/studentDetail.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // フォームからデータを取得
        String studentId = request.getParameter("studentId");
        String className = request.getParameter("className");
        String number = request.getParameter("number");
        String name = request.getParameter("name");
        String nameKana = request.getParameter("nameKana");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String tel = request.getParameter("tel");
        String enrollmentStatus = request.getParameter("enrollmentStatus");
        String assistanceStatus = request.getParameter("assistanceStatus");
        String jobHuntingStatus = request.getParameter("jobHuntingStatus");
        String desiredJobType1 = request.getParameter("desiredJobType1");
        String desiredJobType2 = request.getParameter("desiredJobType2");
        String desiredJobType3 = request.getParameter("desiredJobType3");
        String graduationYear = request.getParameter("graduationYear");
        String remarks = request.getParameter("remarks");
        String desiredWorkPlace = request.getParameter("desiredWorkPlace");
        
        // デバッグ用ログ
        System.out.println("=== フォームデータ受信 ===");
        System.out.println("studentId: " + studentId);
        System.out.println("name: " + name);
        System.out.println("gender: " + gender);
        System.out.println("enrollmentStatus: " + enrollmentStatus);
        System.out.println("assistanceStatus: " + assistanceStatus);
        System.out.println("jobHuntingStatus: " + jobHuntingStatus);
        System.out.println("desiredJobType1: " + desiredJobType1);
        System.out.println("desiredJobType2: " + desiredJobType2);
        System.out.println("desiredJobType3: " + desiredJobType3);
        System.out.println("desiredWorkPlace: " + desiredWorkPlace);
        System.out.println("remarks: " + remarks);
        
        // 職種名を職種IDに変換
        if (desiredJobType1 != null && !desiredJobType1.isEmpty()) {
            String originalJobType1 = desiredJobType1;
            desiredJobType1 = getOccupationIdByName(desiredJobType1);
            System.out.println("職種1変換: " + originalJobType1 + " -> " + desiredJobType1);
        }
        if (desiredJobType2 != null && !desiredJobType2.isEmpty()) {
            String originalJobType2 = desiredJobType2;
            desiredJobType2 = getOccupationIdByName(desiredJobType2);
            System.out.println("職種2変換: " + originalJobType2 + " -> " + desiredJobType2);
        }
        if (desiredJobType3 != null && !desiredJobType3.isEmpty()) {
            String originalJobType3 = desiredJobType3;
            desiredJobType3 = getOccupationIdByName(desiredJobType3);
            System.out.println("職種3変換: " + originalJobType3 + " -> " + desiredJobType3);
        }
        
        // StudentBeansに設定
        StudentBeans student = new StudentBeans();
        student.setId(studentId);
        student.setClassName(className);
        student.setNumber(number);
        student.setName(name);
        student.setNameKana(nameKana);
        student.setGender(gender);
        student.setEmail(email);
        student.setTel(tel);
        student.setEnrollmentStatus(enrollmentStatus);
        student.setAssistanceStatus(assistanceStatus);
        student.setJobHuntingStatus(jobHuntingStatus);
        student.setDesiredJobType1(desiredJobType1);
        student.setDesiredJobType2(desiredJobType2);
        student.setDesiredJobType3(desiredJobType3);
        student.setGraduationYear(graduationYear);
        student.setRemarks(remarks);
        student.setDesiredWorkPlace(desiredWorkPlace);
        
        // データベースを更新
        try {
            StudentDAO.updateStudent(student);
            System.out.println("データベース更新成功");
        } catch (Exception e) {
            System.out.println("データベース更新エラー: " + e.getMessage());
            e.printStackTrace();
        }
        
        // 更新後、詳細画面にリダイレクト
        response.sendRedirect("StudentDetailServlet?id=" + studentId);
    }
    
    // 職種名から職種IDを取得するメソッド
    private String getOccupationIdByName(String occupationName) {
        if (occupationName == null || occupationName.isEmpty() || occupationName.trim().isEmpty()) {
            return null; // nullを返すことで、データベースでNULLとして扱われる
        }
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT occupation_id FROM occupations_tbl WHERE occupation = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, occupationName.trim());
            rs = ps.executeQuery();
            if (rs.next()) {
                return String.valueOf(rs.getInt("occupation_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return null;
    }
} 