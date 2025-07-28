package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DBConnection;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String searchType = request.getParameter("type"); // "company" または "student"
        String searchTerm = request.getParameter("term");
        
        // 検索結果画面を表示
        request.setAttribute("searchType", searchType);
        request.setAttribute("searchTerm", searchTerm);
        request.getRequestDispatcher("/WEB-INF/jsp/SearchResults.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private List<SearchResult> searchCompanies(Connection conn, String searchTerm) throws Exception {
        List<SearchResult> results = new ArrayList<>();
        
        String sql = "SELECT companys_id, company_name, manager_name FROM companys_tbl WHERE company_name LIKE ? ORDER BY company_name LIMIT 10";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + searchTerm + "%");
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    SearchResult result = new SearchResult();
                    result.setId(String.valueOf(rs.getInt("companys_id")));
                    result.setName(rs.getString("company_name"));
                    
                    String managerName = rs.getString("manager_name");
                    if (managerName != null && !managerName.isEmpty()) {
                        result.setDescription("担当者: " + managerName);
                    } else {
                        result.setDescription("担当者: 未設定");
                    }
                    
                    results.add(result);
                }
            }
        }
        
        return results;
    }
    
    private List<SearchResult> searchStudents(Connection conn, String searchTerm) throws Exception {
        List<SearchResult> results = new ArrayList<>();
        
        String sql = "SELECT student_id, name, department, class, number FROM students_tbl WHERE name LIKE ? OR name_reading LIKE ? ORDER BY name LIMIT 10";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + searchTerm + "%");
            pstmt.setString(2, "%" + searchTerm + "%");
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    SearchResult result = new SearchResult();
                    result.setId(rs.getString("student_id"));
                    result.setName(rs.getString("name"));
                    
                    String department = rs.getString("department");
                    String className = rs.getString("class");
                    String number = rs.getString("number");
                    
                    String description = "";
                    if (department != null && !department.isEmpty()) {
                        description += department + "科";
                    }
                    if (className != null && !className.isEmpty()) {
                        description += className + "組";
                    }
                    if (number != null && !number.isEmpty()) {
                        description += number + "番";
                    }
                    
                    if (description.isEmpty()) {
                        description = "学生情報";
                    }
                    
                    result.setDescription(description);
                    results.add(result);
                }
            }
        }
        
        return results;
    }
    
    private String convertToJson(List<SearchResult> results) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < results.size(); i++) {
            SearchResult result = results.get(i);
            json.append("{");
            json.append("\"id\":\"").append(result.getId()).append("\",");
            json.append("\"name\":\"").append(result.getName()).append("\",");
            json.append("\"description\":\"").append(result.getDescription()).append("\"");
            json.append("}");
            if (i < results.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        return json.toString();
    }
    
    // 内部クラス：検索結果を保持
    public static class SearchResult {
        private String id;
        private String name;
        private String description;
        
        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
    }
} 