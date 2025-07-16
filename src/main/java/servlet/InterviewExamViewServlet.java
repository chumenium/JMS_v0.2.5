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
import beans.InterviewExamContentBean;
import utils.DBConnection;

@WebServlet("/InterviewExamViewServlet")
public class InterviewExamViewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String companyIdParam = request.getParameter("companyId");
        
        if (companyIdParam == null || companyIdParam.trim().isEmpty()) {
            request.setAttribute("message", "企業IDが指定されていません。");
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamView.jsp").forward(request, response);
            return;
        }
        
        try {
            int companyId = Integer.parseInt(companyIdParam);
            
            // セッションから学生IDを取得
            String studentId = (String) request.getSession().getAttribute("student_id");
            String role = (String) request.getSession().getAttribute("role");
            
            // 企業情報を取得
            CompanyBean company = getCompany(companyId);
            if (company == null) {
                request.setAttribute("message", "指定された企業が見つかりません。");
                request.setAttribute("messageType", "danger");
                request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamView.jsp").forward(request, response);
                return;
            }
            
            // 学生の場合は、その企業に登録しているかチェック
            if ("student".equals(role) && studentId != null) {
                if (!isStudentRegisteredToCompany(studentId, companyId)) {
                    request.setAttribute("message", "この企業には登録していません。");
                    request.setAttribute("messageType", "danger");
                    request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamView.jsp").forward(request, response);
                    return;
                }
            }
            
            request.setAttribute("company", company);
            
            // 試験・面接内容を取得
            List<InterviewExamContentBean> examContents = getExamContents(companyId);
            List<InterviewExamContentBean> interviewContents = getInterviewContents(companyId);
            
            request.setAttribute("examContents", examContents);
            request.setAttribute("interviewContents", interviewContents);
            
            request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamView.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("message", "企業IDが正しくありません。");
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamView.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "データの取得に失敗しました: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamView.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "予期しないエラーが発生しました: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/WEB-INF/jsp/InterviewExamView.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private CompanyBean getCompany(int companyId) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT companys_id, company_name FROM companys_tbl WHERE companys_id = ?";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, companyId);
        
        ResultSet rs = pstmt.executeQuery();
        CompanyBean company = null;
        
        if (rs.next()) {
            company = new CompanyBean();
            company.setCompanysId(rs.getInt("companys_id"));
            company.setCompanyName(rs.getString("company_name"));
        }
        
        rs.close();
        pstmt.close();
        conn.close();
        
        return company;
    }
    
    private boolean isStudentRegisteredToCompany(String studentId, int companyId) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT COUNT(*) FROM job_activity_tbl WHERE student_id = ? AND companys_id = ?";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, studentId);
        pstmt.setInt(2, companyId);
        
        ResultSet rs = pstmt.executeQuery();
        boolean isRegistered = false;
        
        if (rs.next()) {
            isRegistered = rs.getInt(1) > 0;
        }
        
        rs.close();
        pstmt.close();
        conn.close();
        
        return isRegistered;
    }
    
    private List<InterviewExamContentBean> getExamContents(int companyId) throws SQLException {
        List<InterviewExamContentBean> contents = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT c.id, c.content_number, c.exam_subject, c.exam_content, c.created_at, " +
                    "et.exam_type_name " +
                    "FROM interview_exam_content c " +
                    "LEFT JOIN exam_types et ON c.exam_type_id = et.id " +
                    "WHERE c.companys_id = ? AND c.content_type = '試験' " +
                    "ORDER BY c.content_number";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, companyId);
        
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            InterviewExamContentBean content = new InterviewExamContentBean();
            content.setId(rs.getInt("id"));
            content.setContentNumber(rs.getInt("content_number"));
            content.setExamType(rs.getString("exam_type_name"));
            content.setExamSubject(rs.getString("exam_subject"));
            content.setExamContent(rs.getString("exam_content"));
            content.setCreatedAt(rs.getTimestamp("created_at"));
            contents.add(content);
        }
        
        rs.close();
        pstmt.close();
        conn.close();
        
        return contents;
    }
    
    private List<InterviewExamContentBean> getInterviewContents(int companyId) throws SQLException {
        List<InterviewExamContentBean> contents = new ArrayList<>();
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT c.id, c.content_number, c.interview_questions, c.interview_notes, c.created_at, " +
                    "it.interview_type_name " +
                    "FROM interview_exam_content c " +
                    "LEFT JOIN interview_types it ON c.interview_type_id = it.id " +
                    "WHERE c.companys_id = ? AND c.content_type = '面接' " +
                    "ORDER BY c.content_number";
        
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, companyId);
        
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            InterviewExamContentBean content = new InterviewExamContentBean();
            content.setId(rs.getInt("id"));
            content.setContentNumber(rs.getInt("content_number"));
            content.setInterviewType(rs.getString("interview_type_name"));
            content.setInterviewQuestions(rs.getString("interview_questions"));
            content.setInterviewNotes(rs.getString("interview_notes"));
            content.setCreatedAt(rs.getTimestamp("created_at"));
            contents.add(content);
        }
        
        rs.close();
        pstmt.close();
        conn.close();
        
        return contents;
    }
} 