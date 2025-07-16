package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.CompanyBean;
import beans.ExamTypeBean;
import beans.InterviewTypeBean;
import utils.DBConnection;

@WebServlet("/InterviewExamInputServlet")
public class InterviewExamInputServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // セッションから学生IDを取得
            String studentId = (String) request.getSession().getAttribute("student_id");
            String role = (String) request.getSession().getAttribute("role");
            
            // 企業一覧を取得（学生の場合は登録済み企業のみ、教員・管理者の場合は全企業）
            List<CompanyBean> companies;
            if ("student".equals(role) && studentId != null) {
                companies = getCompaniesByStudent(studentId);
            } else if ("teacher".equals(role) || "headmaster".equals(role) || "egd".equals(role) || "admin".equals(role)) {
                companies = getAllCompanies();
            } else {
                companies = new ArrayList<>();
            }
            request.setAttribute("companies", companies);
            
            // 試験種別一覧を取得
            List<ExamTypeBean> examTypes = getExamTypes();
            request.setAttribute("examTypes", examTypes);
            
            // 面接種別一覧を取得
            List<InterviewTypeBean> interviewTypes = getInterviewTypes();
            request.setAttribute("interviewTypes", interviewTypes);
            
            request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamInput.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "データの取得に失敗しました: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamInput.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "予期しないエラーが発生しました: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamInput.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if ("register".equals(action)) {
            registerContent(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    private void registerContent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String companyIdParam = request.getParameter("companyId");
            String contentType = request.getParameter("contentType");
            
            // バリデーション
            if (companyIdParam == null || companyIdParam.trim().isEmpty()) {
                request.setAttribute("message", "企業を選択してください。");
                request.setAttribute("messageType", "danger");
                doGet(request, response);
                return;
            }
            
            if (contentType == null || contentType.trim().isEmpty()) {
                request.setAttribute("message", "内容種別を選択してください。");
                request.setAttribute("messageType", "danger");
                doGet(request, response);
                return;
            }
            
            int companyId = Integer.parseInt(companyIdParam);
            
            // 企業IDごとの連番を取得
            int contentNumber = getNextContentNumber(companyId, contentType);
            
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO interview_exam_content (companys_id, content_type, content_number, " +
                        "exam_type_id, exam_subject, exam_content, interview_type_id, interview_questions, interview_notes) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, companyId);
            pstmt.setString(2, contentType);
            pstmt.setInt(3, contentNumber);
            
            if ("試験".equals(contentType)) {
                String examTypeId = request.getParameter("examType");
                pstmt.setObject(4, examTypeId != null && !examTypeId.isEmpty() ? Integer.parseInt(examTypeId) : null);
                pstmt.setString(5, request.getParameter("examSubject"));
                pstmt.setString(6, request.getParameter("examContent"));
                pstmt.setObject(7, null);
                pstmt.setString(8, null);
                pstmt.setString(9, null);
            } else {
                pstmt.setObject(4, null);
                pstmt.setString(5, null);
                pstmt.setString(6, null);
                String interviewTypeId = request.getParameter("interviewType");
                pstmt.setObject(7, interviewTypeId != null && !interviewTypeId.isEmpty() ? Integer.parseInt(interviewTypeId) : null);
                pstmt.setString(8, request.getParameter("interviewQuestions"));
                pstmt.setString(9, request.getParameter("interviewNotes"));
            }
            
            pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            
            request.setAttribute("message", "試験・面接内容を登録しました。");
            request.setAttribute("messageType", "success");
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "登録に失敗しました: " + e.getMessage());
            request.setAttribute("messageType", "danger");
        } catch (NumberFormatException e) {
            request.setAttribute("message", "企業IDが正しくありません。");
            request.setAttribute("messageType", "danger");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "予期しないエラーが発生しました: " + e.getMessage());
            request.setAttribute("messageType", "danger");
        }
        
        doGet(request, response);
    }
    
    private int getNextContentNumber(int companyId, String contentType) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT MAX(content_number) FROM interview_exam_content " +
                    "WHERE companys_id = ? AND content_type = ?";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, companyId);
        pstmt.setString(2, contentType);
        
        ResultSet rs = pstmt.executeQuery();
        int nextNumber = 1;
        
        if (rs.next()) {
            int maxNumber = rs.getInt(1);
            if (maxNumber > 0) {
                nextNumber = maxNumber + 1;
            }
        }
        
        rs.close();
        pstmt.close();
        conn.close();
        
        return nextNumber;
    }
    
    private List<CompanyBean> getAllCompanies() throws SQLException {
        List<CompanyBean> companies = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT companys_id, company_name FROM companys_tbl ORDER BY company_name";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            CompanyBean company = new CompanyBean();
            company.setCompanysId(rs.getInt("companys_id"));
            company.setCompanyName(rs.getString("company_name"));
            companies.add(company);
        }
        
        rs.close();
        pstmt.close();
        conn.close();
        
        return companies;
    }
    
    private List<CompanyBean> getCompaniesByStudent(String studentId) throws SQLException {
        List<CompanyBean> companies = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT DISTINCT c.companys_id, c.company_name " +
                    "FROM companys_tbl c " +
                    "INNER JOIN job_activity_tbl ja ON c.companys_id = ja.companys_id " +
                    "WHERE ja.student_id = ? " +
                    "ORDER BY c.company_name";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, studentId);
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            CompanyBean company = new CompanyBean();
            company.setCompanysId(rs.getInt("companys_id"));
            company.setCompanyName(rs.getString("company_name"));
            companies.add(company);
        }
        
        rs.close();
        pstmt.close();
        conn.close();
        
        return companies;
    }
    
    private List<ExamTypeBean> getExamTypes() throws SQLException {
        List<ExamTypeBean> examTypes = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT id, exam_type_name FROM exam_types ORDER BY exam_type_name";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            ExamTypeBean examType = new ExamTypeBean();
            examType.setId(rs.getInt("id"));
            examType.setExamTypeName(rs.getString("exam_type_name"));
            examTypes.add(examType);
        }
        
        rs.close();
        pstmt.close();
        conn.close();
        
        return examTypes;
    }
    
    private List<InterviewTypeBean> getInterviewTypes() throws SQLException {
        List<InterviewTypeBean> interviewTypes = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT id, interview_type_name FROM interview_types ORDER BY interview_type_name";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            InterviewTypeBean interviewType = new InterviewTypeBean();
            interviewType.setId(rs.getInt("id"));
            interviewType.setInterviewTypeName(rs.getString("interview_type_name"));
            interviewTypes.add(interviewType);
        }
        
        rs.close();
        pstmt.close();
        conn.close();
        
        return interviewTypes;
    }
}
