package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import utils.DBConnection;

/**
 * 就活情報検索サーブレット
 * 企業名、職種、選考段階などで就活情報を検索する機能を提供
 */
public class JobHuntingSearchServlet extends HttpServlet {
    
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
                           !role.equals("headmaster") && !role.equals("egd") && !role.equals("student"))) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        // 学生の場合は自分の情報のみ検索可能
        String studentId = null;
        if ("student".equals(role)) {
            studentId = (String) session.getAttribute("id");
        }
        
        try {
            // 検索パラメータを取得
            String companyName = request.getParameter("companyName");
            String jobTitle = request.getParameter("jobTitle");
            String selectionStage = request.getParameter("selectionStage");
            String activityStatus = request.getParameter("activityStatus");
            String studentName = request.getParameter("studentName");
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");
            
            // デバッグ用ログ
            System.out.println("=== 就活情報検索開始 ===");
            System.out.println("企業名: " + companyName);
            System.out.println("職種: " + jobTitle);
            System.out.println("選考段階: " + selectionStage);
            System.out.println("活動状況: " + activityStatus);
            System.out.println("学生名: " + studentName);
            System.out.println("期間開始: " + dateFrom);
            System.out.println("期間終了: " + dateTo);
            
            // 検索結果を取得
            List<Map<String, Object>> searchResults = searchJobHuntingInfo(
                companyName, jobTitle, selectionStage, activityStatus, 
                studentName, dateFrom, dateTo, studentId, role
            );
            
            // 検索結果をリクエストに設定
            request.setAttribute("searchResults", searchResults);
            
            System.out.println("検索結果件数: " + searchResults.size());
            System.out.println("=== 就活情報検索完了 ===");
            
            // JSPにフォワード
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/jobHuntingSearch.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            System.err.println("就活情報検索エラー: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "検索中にエラーが発生しました: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/jobHuntingSearch.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * 就活情報を検索する
     */
    private List<Map<String, Object>> searchJobHuntingInfo(
            String companyName, String jobTitle, String selectionStage, 
            String activityStatus, String studentName, String dateFrom, 
            String dateTo, String currentStudentId, String role) {
        
        List<Map<String, Object>> results = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            
            // 動的SQLの構築
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT ");
            sql.append("    ja.student_id, ");
            sql.append("    ja.companys_id, ");
            sql.append("    ja.activity_status, ");
            sql.append("    ja.reporte_date, ");
            sql.append("    c.company_name, ");
            sql.append("    s.name as student_name, ");
            sql.append("    s.class as student_class, ");
            sql.append("    s.number as student_number ");
            sql.append("FROM job_activity_tbl ja ");
            sql.append("JOIN companys_tbl c ON ja.companys_id = c.companys_id ");
            sql.append("JOIN students_tbl s ON ja.student_id = s.student_id ");
            sql.append("WHERE 1=1 ");
            
            List<Object> parameters = new ArrayList<>();
            int paramIndex = 1;
            
            // 学生の場合は自分の情報のみ
            if ("student".equals(role) && currentStudentId != null) {
                sql.append("AND ja.student_id = ? ");
                parameters.add(currentStudentId);
                paramIndex++;
            }
            
            // 企業名での検索
            if (companyName != null && !companyName.trim().isEmpty()) {
                sql.append("AND c.company_name LIKE ? ");
                parameters.add("%" + companyName.trim() + "%");
                paramIndex++;
            }
            
            // 学生名での検索
            if (studentName != null && !studentName.trim().isEmpty()) {
                sql.append("AND s.name LIKE ? ");
                parameters.add("%" + studentName.trim() + "%");
                paramIndex++;
            }
            
            // 活動状況での検索
            if (activityStatus != null && !activityStatus.trim().isEmpty()) {
                sql.append("AND ja.activity_status = ? ");
                parameters.add(activityStatus.trim());
                paramIndex++;
            }
            
            // 期間での検索
            if (dateFrom != null && !dateFrom.trim().isEmpty()) {
                sql.append("AND ja.reporte_date >= ? ");
                parameters.add(dateFrom.trim());
                paramIndex++;
            }
            
            if (dateTo != null && !dateTo.trim().isEmpty()) {
                sql.append("AND ja.reporte_date <= ? ");
                parameters.add(dateTo.trim());
                paramIndex++;
            }
            
            sql.append("ORDER BY ja.reporte_date DESC, c.company_name ASC ");
            
            System.out.println("実行SQL: " + sql.toString());
            System.out.println("パラメータ数: " + parameters.size());
            
            ps = conn.prepareStatement(sql.toString());
            
            // パラメータを設定
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> result = new HashMap<>();
                result.put("student_id", rs.getString("student_id"));
                result.put("company_id", rs.getString("companys_id"));
                result.put("activity_status", rs.getString("activity_status"));
                result.put("report_date", rs.getString("reporte_date"));
                result.put("company_name", rs.getString("company_name"));
                result.put("student_name", rs.getString("student_name"));
                result.put("student_class", rs.getString("student_class"));
                result.put("student_number", rs.getString("student_number"));
                
                // 職種情報を取得（job_activity_detail_tblから）
                String jobTitleInfo = getJobTitleInfo(conn, rs.getString("student_id"), rs.getString("companys_id"));
                result.put("job_title", jobTitleInfo);
                
                // 選考段階情報を取得
                String selectionStageInfo = getSelectionStageInfo(conn, rs.getString("student_id"), rs.getString("companys_id"));
                result.put("selection_stage", selectionStageInfo);
                
                // 活動IDを設定（詳細表示用）
                result.put("activity_id", rs.getString("student_id") + "_" + rs.getString("companys_id"));
                
                results.add(result);
            }
            
        } catch (Exception e) {
            System.err.println("就活情報検索エラー: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        
        return results;
    }
    
    /**
     * 職種情報を取得
     */
    private String getJobTitleInfo(Connection conn, String studentId, String companyId) {
        String jobTitle = "";
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            // 学生の希望職種を取得
            String sql = "SELECT o.occupation FROM students_tbl s " +
                        "LEFT JOIN occupations_tbl o ON s.desired_job_type_1st_id = o.occupation_id " +
                        "WHERE s.student_id = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, studentId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                jobTitle = rs.getString("occupation");
            }
            
        } catch (Exception e) {
            System.err.println("職種情報取得エラー: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
        }
        
        return jobTitle != null ? jobTitle : "未設定";
    }
    
    /**
     * 選考段階情報を取得
     */
    private String getSelectionStageInfo(Connection conn, String studentId, String companyId) {
        String selectionStage = "";
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            // 最新の選考段階を取得
            String sql = "SELECT st.selection_name FROM job_activity_detail_tbl jad " +
                        "JOIN selection_tbl st ON jad.selection_id = st.selection_id " +
                        "WHERE jad.student_id = ? AND jad.companys_id = ? " +
                        "ORDER BY jad.date DESC, jad.time DESC LIMIT 1";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, studentId);
            ps.setString(2, companyId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                selectionStage = rs.getString("selection_name");
            }
            
        } catch (Exception e) {
            System.err.println("選考段階情報取得エラー: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
        }
        
        return selectionStage != null ? selectionStage : "未設定";
    }
} 