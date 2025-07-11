package servlet;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.StudentDAO;
import utils.DBConnection;

//@WebServlet("/studentServlet")



public class StudentServlet extends HttpServlet {
    //@Override
    
	// パスワードのハッシュ化とソルトの生成
    private String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest((password + salt).getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
    //ソルトを生成
    private String generateSalt() {
        SecureRandom sr = new SecureRandom();
        byte[] salt = new byte[16];
        sr.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }
    
    //引数の希望職種のidを返す
    private int getDesiredJobId(String jobName) {
    	try (Connection conn = DBConnection.getConnection()) {
	    	String sql = "SELECT occupation_id FROM occupations_tbl WHERE occupation = ?";
	        PreparedStatement stmt = conn.prepareStatement(sql);
	        stmt.setString(1, jobName);
	        ResultSet rs = stmt.executeQuery();
	        int id = 0;
	        while (rs.next()) {
	        	id = rs.getInt("occupation_id");
	        }
	        return id;
    	} catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    //引数で渡したステータスの学生すべてを取得する
    private ArrayList<ArrayList<String>> getStudentEnrollment(String enrollmentStatus) {
    	try (Connection conn = DBConnection.getConnection()) {
    		String sql = "SELECT student_id, class FROM students_tbl WHERE enrollment_status = ?";
    		PreparedStatement stmt = conn.prepareStatement(sql);
    		stmt.setString(1, enrollmentStatus);
    		ResultSet rs = stmt.executeQuery();
    		
    		ArrayList<String> classs = new ArrayList<String>();
    		ArrayList<String> studentid = new ArrayList<String>();
    		
    		while (rs.next()) {
    			studentid.add(rs.getString("student_id"));
    			classs.add(rs.getString("class"));
    		}
    		
    		ArrayList<ArrayList<String>> studentList = new ArrayList<>();
    		studentList.add(studentid);
    		studentList.add(classs);
    		
    		return studentList;
    	} catch (Exception e) {
    		e.printStackTrace();
    		return null;
    	}
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        if("setDropdown".equals(request.getParameter("action"))){
            ServletContext sc = getServletContext();
            if(sc.getAttribute("jobtypes") == null){
                // StudentDAO dropdownDAO = new StudentDAO();
                // List<List<String>> jobtypesWorkplaces = dropdownDAO.getJobtypesWorkplaces();

                try {
                    String pageParam = request.getParameter("page");
                    int page = 1;
                    int pageSize = 10; // 1ページあたりの表示件数
                    if (pageParam != null) {
                        try {
                            page = Integer.parseInt(pageParam);
                        } catch (NumberFormatException e) {
                            page = 1;
                        }
                    }
                    ArrayList<ArrayList<String>> students = new ArrayList<>();
                    int totalCount = 0;
                    try (Connection conn = DBConnection.getConnection()) {
                        String sqloc = "SELECT DISTINCT occupation FROM occupations_tbl WHERE occupation_id != 0";
                        String sqlwp = "SELECT work_place FROM work_place_tbl ORDER BY id";
                        List<String> jobtypes = new ArrayList<>();
                        List<String> workplaces = new ArrayList<>();
                        PreparedStatement pstmtoc = conn.prepareStatement(sqloc);
                        ResultSet rsoc = pstmtoc.executeQuery();
                        while (rsoc.next()) {
                            jobtypes.add(rsoc.getString("occupation"));
                        }
                        PreparedStatement pstmtwp = conn.prepareStatement(sqlwp);
                        ResultSet rswp = pstmtwp.executeQuery();
                        while (rswp.next()) {
                            workplaces.add(rswp.getString("work_place"));
                        }
                        sc.setAttribute("jobtypes", jobtypes);
                        sc.setAttribute("workplaces", workplaces);
                        System.out.println("ドロップダウンのデータをセット");

                        System.out.println("StudentServlet: データベース接続成功");
                        
                        // まずテーブル構造を確認するためのシンプルなクエリ
                        String countSql = "SELECT COUNT(*) FROM students_tbl";
                        PreparedStatement countStmt = conn.prepareStatement(countSql);
                        ResultSet countRs = countStmt.executeQuery();
                        if (countRs.next()) {
                            totalCount = countRs.getInt(1);
                            System.out.println("StudentServlet: 総学生数 = " + totalCount);
                        }

                        // 学生一覧取得SQL（シンプル版）
                        String sql = "SELECT student_id, name, department, class, job_hunting_status FROM students_tbl ORDER BY student_id LIMIT ? OFFSET ?";
                        PreparedStatement stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, pageSize);
                        stmt.setInt(2, (page - 1) * pageSize);
                        ResultSet rs = stmt.executeQuery();

                        ArrayList<String> studentids = new ArrayList<>();
                        ArrayList<String> names = new ArrayList<>();
                        ArrayList<String> classs = new ArrayList<>();
                        ArrayList<String> enrollmentStatuss = new ArrayList<>();
                        while (rs.next()) {
                            studentids.add(rs.getString("student_id"));
                            names.add(rs.getString("name"));
                            classs.add(rs.getString("department") + rs.getString("class"));
                            enrollmentStatuss.add(rs.getString("job_hunting_status"));
                        }
                        students.add(studentids);
                        students.add(names);
                        students.add(classs);
                        students.add(enrollmentStatuss);
                    } catch (Exception e) {
                        System.err.println("Database error in StudentServlet doGet: " + e.getMessage());
                        e.printStackTrace();
                        // エラーが発生した場合でも空のリストを設定
                        students.add(new ArrayList<>());
                        students.add(new ArrayList<>());
                        students.add(new ArrayList<>());
                        students.add(new ArrayList<>());
                        totalCount = 0;
                    }
                    int totalPages = (int) Math.ceil((double) totalCount / pageSize);
                    sc.setAttribute("students", students);
                    sc.setAttribute("currentPage", page);
                    sc.setAttribute("totalPages", totalPages);

                } catch (Exception e) {
                    System.err.println("General error in StudentServlet doGet: " + e.getMessage());
                    e.printStackTrace();
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().println("Error: " + e.getMessage());
                }

            }else{
                System.out.println("ドロップダウンのデータセット済み");
            }
        }
        // セッションの確認
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 権限チェック（教員、校長・教務部長、管理者のみ）
        String role = (String) session.getAttribute("role");
        if (role == null || (!"teacher".equals(role) && !"headmaster".equals(role) && !"admin".equals(role))) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        String action = request.getParameter("action");


        try (Connection conn = DBConnection.getConnection()) {
            if(action.equals("getStudentId")) {
                String student_id1 = request.getParameter("student_id");
                String sql1 = "SELECT MAX(student_id) AS max_id FROM students_tbl WHERE student_id LIKE ?";
                PreparedStatement stmt1 = conn.prepareStatement(sql1);
                stmt1.setString(1, student_id1 + "%");
                ResultSet rs1 = stmt1.executeQuery();
                if(rs1.next()) {
                    if(rs1.getString("max_id") == null) {
                        response.getWriter().println("0");
                    }else {
                        response.getWriter().println(rs1.getString("max_id"));
                    }
                }else {
                    response.getWriter().println("0");
                }
            }
                
            if ("add".equals(action)) {
                // 学生を新規追加する（パスワード管理と学年期間を適用）
                String student_id = request.getParameter("studentId");//学籍番号
                String student_class = request.getParameter("className");//クラス名S3A1
                String department = null;
                String studentClass = null;
                if (student_class != null && !student_class.trim().isEmpty()) {
                    department = student_class.substring(0, 2);
                    studentClass = student_class.substring(2);
                }
                String number = request.getParameter("attendanceNo");//出席番号
                String name = request.getParameter("name");//名前
                String name_reading = request.getParameter("kana");//カナ
                String gender = request.getParameter("gender");
                String email = request.getParameter("email");
                String tel = request.getParameter("tel");
                String enrollment_status = "在籍";
                String jobHuntingStatus = request.getParameter("jobHuntingStatus");
                String admission_year_str = request.getParameter("admissionYear");
                String class_grade = request.getParameter("classGrade");
                String[] departments = {"G","J","M","R","S"};
                int[] gradeUpLimits = {2,2,3,4,3};
                int plus_num = 0;
                for(int i = 0; i < departments.length; i++) {
                    if(departments[i].equals(student_class.substring(0, 1))) {
                        plus_num = gradeUpLimits[i];
                    }
                }
                int graduation_year = 0;
                if (admission_year_str != null && !admission_year_str.trim().isEmpty()) {
                    graduation_year = Integer.parseInt(admission_year_str) + plus_num;
                }
                String desired_job_type_1st = request.getParameter("targetIndustry1");
                String desired_job_type_2nd = request.getParameter("targetIndustry2");
                String desired_job_type_3rd = request.getParameter("targetIndustry3");
                String remarks = request.getParameter("remarks");
                // ソルトを生成
                String salt = generateSalt();
                // パスワードをハッシュ化
                String hashedPassword = hashPassword("123456", salt);
                // usersテーブルへのinsert（現状維持）
                String registerQuery = "INSERT INTO users (id, password, role, salt) VALUES (?, ?, ?, ?);";
                PreparedStatement usersStatement = conn.prepareStatement(registerQuery);
                usersStatement.setString(1, student_id);
                usersStatement.setString(2, hashedPassword);
                usersStatement.setString(3, "student");
                usersStatement.setString(4, salt);
                int rowsInserted1 = usersStatement.executeUpdate();
                // students_tblへのinsertはDAO経由に
                Map<String, Object> student = new HashMap<>();
                student.put("student_id", student_id);
                student.put("department", department);
                student.put("class", studentClass);
                student.put("number", number);
                student.put("name", name);
                student.put("name_reading", name_reading);
                student.put("gender", gender);
                student.put("email", email);
                student.put("tel", tel);
                student.put("enrollment_status", enrollment_status);
                student.put("mediation_status", null);
                student.put("job_hunting_status", jobHuntingStatus);
                student.put("desired_job_type_1st_id", Integer.parseInt(desired_job_type_1st));
                student.put("desired_job_type_2nd_id", Integer.parseInt(desired_job_type_2nd));
                student.put("desired_job_type_3rd_id", Integer.parseInt(desired_job_type_3rd));
                student.put("graduation_year", graduation_year);
                student.put("remarks", remarks);
                if(remarks == null){
                    remarks = "";
                    System.out.print("remarksはNULL");
                }
                // students_tblへのinsert
                String studentQuery = "INSERT INTO students_tbl (student_id, department, class, number, name, name_reading, gender, email, tel, enrollment_status, mediation_status, job_hunting_status, desired_job_type_1st_id, desired_job_type_2nd_id, desired_job_type_3rd_id, graduation_year, remarks) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement studentStatement = conn.prepareStatement(studentQuery);
                studentStatement.setString(1, student_id);
                studentStatement.setString(2, department);
                studentStatement.setString(3, studentClass);
                studentStatement.setString(4, number);
                studentStatement.setString(5, name);
                studentStatement.setString(6, name_reading);
                studentStatement.setString(7, gender);
                studentStatement.setString(8, email);
                studentStatement.setString(9, tel);
                studentStatement.setString(10, enrollment_status);
                studentStatement.setNull(11, java.sql.Types.VARCHAR);
                studentStatement.setString(12, jobHuntingStatus);
                studentStatement.setInt(13, Integer.parseInt(desired_job_type_1st));
                studentStatement.setInt(14, Integer.parseInt(desired_job_type_2nd));
                studentStatement.setInt(15, Integer.parseInt(desired_job_type_3rd));
                studentStatement.setInt(16, graduation_year);
                studentStatement.setString(17, remarks);
                int rowsInserted2 = studentStatement.executeUpdate();
                
                if (rowsInserted1 > 0 && rowsInserted2 > 0) {
                    ServletContext sc = getServletContext();
                    try {
                        String pageParam = request.getParameter("page");
                        int page = 1;
                        int pageSize = 10; // 1ページあたりの表示件数
                        if (pageParam != null) {
                            try {
                                page = Integer.parseInt(pageParam);
                            } catch (NumberFormatException e) {
                                page = 1;
                            }
                        }
                        ArrayList<ArrayList<String>> students = new ArrayList<>();
                        int totalCount = 0;
                        // まずテーブル構造を確認するためのシンプルなクエリ
                        String countSql = "SELECT COUNT(*) FROM students_tbl";
                        PreparedStatement countStmt = conn.prepareStatement(countSql);
                        ResultSet countRs = countStmt.executeQuery();
                        if (countRs.next()) {
                            totalCount = countRs.getInt(1);
                            System.out.println("StudentServlet: 総学生数 = " + totalCount);
                        }

                        // 学生一覧取得SQL（シンプル版）
                        String getstudentsql = "SELECT student_id, name, department, class, job_hunting_status FROM students_tbl ORDER BY student_id LIMIT ? OFFSET ?";
                        PreparedStatement getstudentstmt = conn.prepareStatement(getstudentsql);
                        getstudentstmt.setInt(1, pageSize);
                        getstudentstmt.setInt(2, (page - 1) * pageSize);
                        ResultSet rs = getstudentstmt.executeQuery();

                        ArrayList<String> studentids = new ArrayList<>();
                        ArrayList<String> names = new ArrayList<>();
                        ArrayList<String> classs = new ArrayList<>();
                        ArrayList<String> enrollmentStatuss = new ArrayList<>();
                        while (rs.next()) {
                            studentids.add(rs.getString("student_id"));
                            names.add(rs.getString("name"));
                            classs.add(rs.getString("department") + rs.getString("class"));
                            enrollmentStatuss.add(rs.getString("job_hunting_status"));
                        }
                        students.add(studentids);
                        students.add(names);
                        students.add(classs);
                        students.add(enrollmentStatuss);
                        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
                        sc.setAttribute("students", students);
                        sc.setAttribute("currentPage", page);
                        sc.setAttribute("totalPages", totalPages);

                    } catch (Exception e) {
                        System.err.println("General error in StudentServlet doGet: " + e.getMessage());
                        e.printStackTrace();
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        response.getWriter().println("Error: " + e.getMessage());
                    }
                    request.getRequestDispatcher("/WEB-INF/jsp/StudentManagement.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "データ登録に失敗しました。" );
                    StudentDAO dropdownDAO = new StudentDAO();
                    request.setAttribute("jobtypes", dropdownDAO.getJobtypes());
                    request.getRequestDispatcher("/WEB-INF/jsp/CreateStudent.jsp").forward(request, response);
                }
            //学生情報の詳細を取得する
            }else if ("detail".equals(action)) {
                String student_id = request.getParameter("student_id");
                String sql = "SELECT * FROM students_tbl WHERE student_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, student_id);
                ResultSet rs = stmt.executeQuery();
                if(rs.next()) {
                    request.setAttribute("student_id", rs.getString("student_id"));
                    request.setAttribute("student_class", rs.getString("class"));
                    request.setAttribute("department", rs.getString("department"));
                    request.setAttribute("number", rs.getString("number"));
                    request.setAttribute("name", rs.getString("name"));
                    request.setAttribute("name_reading", rs.getString("name_reading"));
                    request.setAttribute("gender", rs.getString("gender"));
                    request.setAttribute("email", rs.getString("email"));
                    request.setAttribute("tel", rs.getString("tel"));
                    request.setAttribute("enrollment_status", rs.getString("enrollment_status"));
                    request.setAttribute("mediation_status", rs.getString("mediation_status"));
                    request.setAttribute("job_hunting_status", rs.getString("job_hunting_status"));
                    request.setAttribute("desired_job_type_1st", rs.getString("desired_job_type_1st"));
                    request.setAttribute("desired_job_type_2nd", rs.getString("desired_job_type_2nd"));
                    request.setAttribute("desired_job_type_3rd", rs.getString("desired_job_type_3rd"));
                    request.setAttribute("graduation_year", rs.getString("graduation_year"));
                    request.setAttribute("remarks", rs.getString("remarks"));
                }
                String sql2 = "SELECT wp.work_place FROM students_work_place_tbl swp JOIN work_place_tbl wp ON swp.work_place_id = wp.id WHERE swp.student_id = ?";
                PreparedStatement stmt2 = conn.prepareStatement(sql2);
                stmt2.setString(1, student_id);
                ResultSet rs2 = stmt2.executeQuery();
                ArrayList<String> work_place = new ArrayList<String>();
                while(rs2.next()) {
                    work_place.add(rs2.getString("work_place"));
                }
                request.setAttribute("work_place", work_place);
                request.getRequestDispatcher("/WEB-INF/jsp/StudentDetail.jsp").forward(request, response);
            //-------------------------------完成-------------------------------
            // } else if ("update".equals(action)) {
            //     // 学生情報を更新する
    	    //     String student_id = request.getParameter("student_id");
    	    //     String student_class = request.getParameter("class");
    	    //     String department = null;
    	    //     String studentClass = null;
    	    //     if (student_class != null && !student_class.trim().isEmpty()) {
    	    //         department = student_class.substring(0, 2);
    	    //         studentClass = student_class.substring(2);
    	    //     }
    	    //     String number = request.getParameter("number");
    	    //     String name = request.getParameter("name");
    	    //     String name_reading = request.getParameter("name_reading");
    	    //     String gender = request.getParameter("gender");
    	    //     String enrollment_status = request.getParameter("enrollment_status");
    	    //     String mediation_status = request.getParameter("mediation_status");
    	    //     String desired_job_type_1st = request.getParameter("desired_job_type_1st");
    	    //     String desired_job_type_2nd = request.getParameter("desired_job_type_2nd");
    	    //     String desired_job_type_3rd = request.getParameter("desired_job_type_3rd");
    	    //     String graduation_year = request.getParameter("graduation_year");
    	        
    	    //     String studentQuery = "UPDATE students_tbl SET "
    	    //     	    + "department = ?, class = ?, number = ?, name = ?, name_reading = ?, gender = ?, "
    	    //     	    + "enrollment_status = ?, mediation_status = ?, desired_job_type_1st_id = ?, "
    	    //     	    + "desired_job_type_2nd_id = ?, desired_job_type_3rd_id = ?, graduation_year = ? "
    	    //     	    + "WHERE student_id = ?;";

            //     PreparedStatement studentStatement = conn.prepareStatement(studentQuery);
    	        
    	    //     if(mediation_status == null || mediation_status.trim().isEmpty()) {
    	    //     	studentStatement.setNull(8, java.sql.Types.VARCHAR);
    	    //     }else {
    	    //     	studentStatement.setString(8, mediation_status);
    	    //     }
    	    //     if(desired_job_type_1st == null || desired_job_type_1st.trim().isEmpty()) {
            //         studentStatement.setNull(9, java.sql.Types.VARCHAR);
            //         studentStatement.setNull(10, java.sql.Types.VARCHAR);
            //         studentStatement.setNull(11, java.sql.Types.VARCHAR);
    	    //     }else if(desired_job_type_2nd == null || desired_job_type_2nd.trim().isEmpty()){
    	    //     	studentStatement.setInt(9, getDesiredJobId(desired_job_type_1st));
            //         studentStatement.setNull(10, java.sql.Types.VARCHAR);
            //         studentStatement.setNull(11, java.sql.Types.VARCHAR);
    	    //     }else if(desired_job_type_3rd == null || desired_job_type_3rd.trim().isEmpty()) {
    	    //     	studentStatement.setInt(9, getDesiredJobId(desired_job_type_1st));
            //         studentStatement.setInt(10, getDesiredJobId(desired_job_type_2nd));
            //         studentStatement.setNull(11, java.sql.Types.VARCHAR);
    	    //     }else {
    	    //     	studentStatement.setInt(9, getDesiredJobId(desired_job_type_1st));
            //         studentStatement.setInt(10, getDesiredJobId(desired_job_type_2nd));
            //         studentStatement.setInt(11, getDesiredJobId(desired_job_type_3rd));
    	    //     }
    	    //     //退学の場合卒業年をNULLにする
    	    //     if((enrollment_status != null && enrollment_status.equals("退学")) || graduation_year == null || graduation_year.trim().isEmpty()) {
    	    //     	studentStatement.setNull(12, java.sql.Types.VARCHAR);
    	    //     }else {
    	    //     	studentStatement.setInt(12, Integer.parseInt(graduation_year));
    	    //     }
    	        
            //     studentStatement.setString(1, department);
            //     studentStatement.setString(2, studentClass);
            //     studentStatement.setString(3, number);
            //     studentStatement.setString(4, name);
            //     studentStatement.setString(5, name_reading);
            //     studentStatement.setString(6, gender);
            //     studentStatement.setString(7, enrollment_status);
            //     studentStatement.setString(13, student_id);
                
            //     int rowsInserted1 = studentStatement.executeUpdate();
            //     if (rowsInserted1 > 0) {
            //     	//データ更新成功
            //         request.getRequestDispatcher("/WEB-INF/jsp/StudentManagement.jsp").forward(request, response);
            //     } else {
            //         //データ更新失敗
            //     }

            //-------------------------------完成-------------------------------
            } else if ("delete".equals(action)) {
                // 学生情報を削除する（`studentClass` で削除）
            	String student_id = request.getParameter("student_id");

                String sql = "DELETE FROM students_tbl WHERE student_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, student_id);
                int rowsInserted1 = stmt.executeUpdate();

                String sql2 = "DELETE FROM users WHERE id = ?";
                System.out.println(sql+sql2+","+student_id);
                PreparedStatement stmt2 = conn.prepareStatement(sql2);
                stmt2.setString(1, student_id);
                int rowsInserted2 = stmt2.executeUpdate();
                System.out.println(rowsInserted1);
                System.out.println(rowsInserted2);
                if (rowsInserted2 > 0) {
                	//データ更新成功
                    System.out.print("削除処理実行");
                    ServletContext sc = getServletContext();
                    try {
                        String pageParam = request.getParameter("page");
                        int page = 1;
                        int pageSize = 10; // 1ページあたりの表示件数
                        if (pageParam != null) {
                            try {
                                page = Integer.parseInt(pageParam);
                            } catch (NumberFormatException e) {
                                page = 1;
                            }
                        }
                        ArrayList<ArrayList<String>> students = new ArrayList<>();
                        int totalCount = 0;
                        // まずテーブル構造を確認するためのシンプルなクエリ
                        String countSql = "SELECT COUNT(*) FROM students_tbl";
                        PreparedStatement countStmt = conn.prepareStatement(countSql);
                        ResultSet countRs = countStmt.executeQuery();
                        if (countRs.next()) {
                            totalCount = countRs.getInt(1);
                            System.out.println("StudentServlet: 総学生数 = " + totalCount);
                        }

                        // 学生一覧取得SQL（シンプル版）
                        String getstudentsql = "SELECT student_id, name, department, class, job_hunting_status FROM students_tbl ORDER BY student_id LIMIT ? OFFSET ?";
                        PreparedStatement getstudentstmt = conn.prepareStatement(getstudentsql);
                        getstudentstmt.setInt(1, pageSize);
                        getstudentstmt.setInt(2, (page - 1) * pageSize);
                        ResultSet rs = getstudentstmt.executeQuery();

                        ArrayList<String> studentids = new ArrayList<>();
                        ArrayList<String> names = new ArrayList<>();
                        ArrayList<String> classs = new ArrayList<>();
                        ArrayList<String> enrollmentStatuss = new ArrayList<>();
                        while (rs.next()) {
                            studentids.add(rs.getString("student_id"));
                            names.add(rs.getString("name"));
                            classs.add(rs.getString("department") + rs.getString("class"));
                            enrollmentStatuss.add(rs.getString("job_hunting_status"));
                        }
                        students.add(studentids);
                        students.add(names);
                        students.add(classs);
                        students.add(enrollmentStatuss);
                        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
                        sc.setAttribute("students", students);
                        sc.setAttribute("currentPage", page);
                        sc.setAttribute("totalPages", totalPages);

                    } catch (Exception e) {
                        System.err.println("General error in StudentServlet doGet: " + e.getMessage());
                        e.printStackTrace();
                        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        response.getWriter().println("Error: " + e.getMessage());
                    }
                	//request.getRequestDispatcher("/WEB-INF/jsp/StudentList.jsp").forward(request, response);
                    //request.getRequestDispatcher("/WEB-INF/jsp/StudentList.jsp").forward(request, response);
                } else {
                    //データ更新失敗
                    System.out.println("削除失敗");
                    request.getRequestDispatcher("/WEB-INF/jsp/StudentList.jsp").forward(request, response);
                }
            
                
            //-------------------------------完成---しばらく触らない----------------------
            } else if ("promote".equals(action)) {
                // 進級+卒業処理(進学中の学生のみ対象)
            	String[] departments = {"G","J","M","R","S"};//G2,J2,M3,R4,S3
            	int[] gradeUpLimits = {2,2,3,4,3};
            	//studentListの[0]が学籍番号,[1]がクラス
            	ArrayList<ArrayList<String>> studentList = getStudentEnrollment("在籍");
            	ArrayList<String> classList = studentList.get(1);
            	ArrayList<String> studentidList = studentList.get(0);
            	ArrayList<String> graduationList = new ArrayList<String>();
            	ArrayList<String> advancementList = new ArrayList<String>();
            	for(int j = 0; j < classList.size(); j++) {
            		String gakka = String.valueOf(classList.get(j).charAt(0));
            		String cn = String.valueOf(classList.get(j).charAt(1));
            		for (int i = 0; i < departments.length; i++) {
            			if(departments[i].equals(gakka)) {
            				if(gradeUpLimits[i] > Integer.parseInt(cn)) {//進級する学生の学籍番号をリストにまとめる
            					advancementList.add(studentidList.get(j));
            				}else if(gradeUpLimits[i] == Integer.parseInt(cn)) {
            					graduationList.add(studentidList.get(j));//卒業した学生の学籍番号を一つのリストにまとめる
            				}
            			}
            		}
            	}
            	
				String sql2 = "UPDATE students_tbl SET enrollment_status = '卒業' WHERE student_id IN ("
						+graduationList.stream().map(s -> "?").collect(Collectors.joining(", "))
						+ ")";
				PreparedStatement stmt2 = conn.prepareStatement(sql2);
				for (int i = 0; i < graduationList.size(); i++) {
				    stmt2.setString(i + 1, graduationList.get(i));
				}
				stmt2.executeUpdate();
            	
                String sql1 = "UPDATE students_tbl SET class = CASE class "
                		+ " WHEN 'G1' THEN 'G2' "
                		+ " WHEN 'J1' THEN 'J2' "
                		+ " WHEN 'M1' THEN 'M2' "
                		+ " WHEN 'M2' THEN 'R1' "
                		+ " WHEN 'R1' THEN 'R2' "
                		+ " WHEN 'R2' THEN 'R3' "
                		+ " WHEN 'R3' THEN 'R4' "
                		+ " WHEN 'S1' THEN 'S2' "
                		+ " WHEN 'S2' THEN 'S3' "
                		+ "END "
                		+ "WHERE student_id IN ("
                		+ advancementList.stream().map(s -> "?").collect(Collectors.joining(", "))
                		+ ")";
                PreparedStatement stmt1 = conn.prepareStatement(sql1);
				for (int i = 0; i < advancementList.size(); i++) {
				    stmt1.setString(i + 1, advancementList.get(i));
				}
                stmt1.executeUpdate();

                request.getRequestDispatcher("/WEB-INF/jsp/StudentManagement.jsp").forward(request, response);
            }else if ("search".equals(action)) {
                System.out.println("searchの処理をします");
                String keyword = request.getParameter("keyword");
                String pageParam = request.getParameter("page");
                int page = 1;
                int pageSize = 10; // 1ページあたりの表示件数
                
                if (pageParam != null) {
                    try {
                        page = Integer.parseInt(pageParam);
                    } catch (NumberFormatException e) {
                        page = 1;
                    }
                }

                ArrayList<ArrayList<String>> students = new ArrayList<>();
                int totalCount = 0;
                
                try (Connection conn2 = DBConnection.getConnection()) {
                    // 検索条件に基づくWHERE句の構築
                    String whereClause = "";
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        whereClause = " WHERE student_id LIKE ? OR name LIKE ? OR CONCAT(department, class) LIKE ? OR job_hunting_status LIKE ?";
                    }
                    
                    // 総件数取得
                    String countSql = "SELECT COUNT(*) FROM students_tbl" + whereClause;
                    PreparedStatement countStmt = conn2.prepareStatement(countSql);
                    
                    if (!whereClause.isEmpty()) {
                        String likePattern = "%" + keyword + "%";
                        countStmt.setString(1, likePattern);
                        countStmt.setString(2, likePattern);
                        countStmt.setString(3, likePattern);
                        countStmt.setString(4, likePattern);
                    }
                    
                    ResultSet countRs = countStmt.executeQuery();
                    if (countRs.next()) {
                        totalCount = countRs.getInt(1);
                    }
                    
                    // 学生データ取得
                    String sql = "SELECT student_id, name, department, class, job_hunting_status, number, name_reading, gender, enrollment_status, mediation_status, o1.occupation AS 1st,o2.occupation AS 2nd,o3.occupation AS 3rd,graduation_year FROM students_tbl s LEFT JOIN occupations_tbl o1 ON s.desired_job_type_1st_id = o1.occupation_id LEFT JOIN occupations_tbl o2 ON s.desired_job_type_2nd_id = o2.occupation_id LEFT JOIN occupations_tbl o3 ON s.desired_job_type_3rd_id = o3.occupation_id";
                    PreparedStatement stmt = conn2.prepareStatement(sql);
                    ResultSet rs = stmt.executeQuery();
                    //ArrayList<ArrayList<String>> students = new ArrayList<>();
                    ArrayList<String> studentids = new ArrayList<>();
                    ArrayList<String> names = new ArrayList<>();
                    ArrayList<String> classs = new ArrayList<>();
                    ArrayList<String> enrollmentStatuss = new ArrayList<>();
                    ArrayList<String> numbers = new ArrayList<>();
                    ArrayList<String> nameReadings = new ArrayList<>();
                    ArrayList<String> genders = new ArrayList<>();
                    ArrayList<String> mediationStatuss = new ArrayList<>();
                    ArrayList<String> DJTs1 = new ArrayList<>();
                    ArrayList<String> DJTs2 = new ArrayList<>();
                    ArrayList<String> DJTs3 = new ArrayList<>();
                    ArrayList<String> graduationYears = new ArrayList<>();
                    while(rs.next()) {
                        studentids.add(rs.getString("student_id"));
                        names.add(rs.getString("name"));
                        classs.add(rs.getString("department") + rs.getString("class"));
                        enrollmentStatuss.add(rs.getString("job_hunting_status"));
                        numbers.add(rs.getString("number"));
                        nameReadings.add(rs.getString("name_reading"));
                        genders.add(rs.getString("gender"));
                        enrollmentStatuss.add(rs.getString("enrollment_status"));
                        mediationStatuss.add(rs.getString("mediation_status"));
                        DJTs1.add(rs.getString("1st"));
                        DJTs2.add(rs.getString("2nd"));
                        DJTs3.add(rs.getString("3rd"));
                        graduationYears.add(rs.getString("graduation_year"));
                    }
                    ArrayList<String> studentids2 = new ArrayList<>();
                    ArrayList<String> names2 = new ArrayList<>();
                    ArrayList<String> classs2 = new ArrayList<>();
                    ArrayList<String> enrollmentStatuss2 = new ArrayList<>();
                    String[] keywords = keyword.split(" ");
                    for(int i = 0; i < studentids.size(); i++) {
                        for(int j = 0; j < keywords.length; j++) {
                            String date = studentids.get(i)+names.get(i)+classs.get(i)+enrollmentStatuss.get(i)+numbers.get(i)+nameReadings.get(i)+genders.get(i)+mediationStatuss.get(i)+DJTs1.get(i)+DJTs2.get(i)+DJTs3.get(i)+graduationYears.get(i);
                            if(date.matches(".*"+keywords[j]+".*")) {
                                studentids2.add(studentids.get(i));
                                names2.add(names.get(i));
                                classs2.add(classs.get(i));
                                enrollmentStatuss2.add(enrollmentStatuss.get(i));
                            }
                            System.out.println(studentids.get(i)+names.get(i)+classs.get(i)+enrollmentStatuss.get(i));
                        }
                    }

                    students.add(studentids2);
                    students.add(names2);
                    students.add(classs2);
                    students.add(enrollmentStatuss2);
                    
                } catch (Exception e) {
                    System.err.println("Database error in search: " + e.getMessage());
                    e.printStackTrace();
                    // エラーが発生した場合でも空のリストを設定
                    students.add(new ArrayList<>());
                    students.add(new ArrayList<>());
                    students.add(new ArrayList<>());
                    students.add(new ArrayList<>());
                    totalCount = 0;
                }
                
                int totalPages = (int) Math.ceil((double) totalCount / pageSize);
                request.setAttribute("students", students);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("keyword", keyword);

                request.getRequestDispatcher("/WEB-INF/jsp/StudentList.jsp").forward(request, response);
                
            } else if ("getInputData".equals(action)) {
            	String sql1 = "SELECT occupation FROM occupations_tbl;";
            	PreparedStatement stmt1 = conn.prepareStatement(sql1);
            	ResultSet rs1 = stmt1.executeQuery();
            	
            	String sql2 = "SELECT work_place FROM work_place_tbl;";
            	PreparedStatement stmt2 = conn.prepareStatement(sql2);
            	ResultSet rs2 = stmt2.executeQuery();
            	
            	String sql3 = "SELECT DISTINCT(enrollment_status) FROM students_tbl;";
            	PreparedStatement stmt3 = conn.prepareStatement(sql3);
            	ResultSet rs3 = stmt3.executeQuery();
            	
            	String sql4 = "SELECT DISTINCT(graduation_year) FROM students_tbl;";
            	PreparedStatement stmt4 = conn.prepareStatement(sql4);
            	ResultSet rs4 = stmt4.executeQuery();
            	
            	
            	ArrayList<String> occupations = new ArrayList<>();
            	ArrayList<String> workPlaces = new ArrayList<>();
            	ArrayList<String> enrollmentStatuss = new ArrayList<>();
            	ArrayList<String> graduationYears = new ArrayList<>();
            	while (rs1.next()) {
            		occupations.add(rs1.getString("occupation"));
            	}
				while (rs2.next()) {
					workPlaces.add(rs2.getString("work_place"));
				}
				while (rs3.next()) {
					enrollmentStatuss.add(rs3.getString("enrollment_status"));
				}
				while (rs4.next()) {
					graduationYears.add(rs4.getString("graduation_year"));
				}
                request.setAttribute("occupations", occupations);
                request.setAttribute("workPlaces", workPlaces);
                request.setAttribute("enrollmentStatuss", enrollmentStatuss);
                request.setAttribute("graduationYears", graduationYears);
                request.getRequestDispatcher("/WEB-INF/jsp/StudentManagement.jsp").forward(request, response);
            } else if ("create".equals(action)) {
                // 新規学生登録処理
                String admissionYear = request.getParameter("admissionYear");
                String className = request.getParameter("className");
                String attendanceNo = request.getParameter("attendanceNo");
                String studentIdClient = request.getParameter("studentId");
                String name = request.getParameter("name");
                String kana = request.getParameter("kana");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String birthDate = request.getParameter("birthDate");
                String department = request.getParameter("department");
                String grade = request.getParameter("grade");
                String major = request.getParameter("major");
                String jobHuntingStatus = request.getParameter("jobHuntingStatus");
                String targetIndustry = request.getParameter("targetIndustry");
                String notes = request.getParameter("notes");

                // クラスごとの中2桁マッピング
                java.util.Map<String, String> classCodeMap = new java.util.HashMap<>();
                classCodeMap.put("RxAx", "11");
                classCodeMap.put("SxAx", "21");
                classCodeMap.put("MxGx", "22");
                classCodeMap.put("JxSx", "31");
                classCodeMap.put("GxGx", "32");
                // 学籍番号自動生成
                String studentIdServer = "";
                if (admissionYear != null && className != null && attendanceNo != null &&
                    !admissionYear.isEmpty() && !className.isEmpty() && !attendanceNo.isEmpty()) {
                    String yy = admissionYear.substring(admissionYear.length() - 2);
                    String code = classCodeMap.getOrDefault(className, "");
                    String no = String.format("%02d", Integer.parseInt(attendanceNo));
                    studentIdServer = yy + code + no;
                }
                // バリデーション
                if (!studentIdServer.equals(studentIdClient)) {
                    request.setAttribute("errorMessage", "学籍番号の自動生成に失敗しました。入力値を確認してください。");
                    request.getRequestDispatcher("/WEB-INF/jsp/CreateStudent.jsp").forward(request, response);
                    return;
                }
                String defaultPassword = studentIdServer;
                String salt = generateSalt();
                String hashedPassword = hashPassword(defaultPassword, salt);
                // クラス情報を生成（学部 + 学年）
                String studentClass = department + grade;
                try {
                    conn.setAutoCommit(false);
                    String userQuery = "INSERT INTO users (id, password, role, salt) VALUES (?, ?, ?, ?)";
                    PreparedStatement userStmt = conn.prepareStatement(userQuery);
                    userStmt.setString(1, studentIdServer);
                    userStmt.setString(2, hashedPassword);
                    userStmt.setString(3, "student");
                    userStmt.setString(4, salt);
                    int userResult = userStmt.executeUpdate();
                    String studentQuery = "INSERT INTO students_tbl (student_id, department, class, number, name, name_reading, gender, enrollment_status, mediation_status, desired_job_type_1st_id, desired_job_type_2nd_id, desired_job_type_3rd_id, graduation_year) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    PreparedStatement studentStmt = conn.prepareStatement(studentQuery);
                    studentStmt.setString(1, studentIdServer);
                    studentStmt.setString(2, department);
                    studentStmt.setString(3, grade);
                    studentStmt.setString(4, attendanceNo); // 出席番号
                    studentStmt.setString(5, name);
                    studentStmt.setString(6, kana);
                    studentStmt.setString(7, "未設定"); // 性別は未設定
                    studentStmt.setString(8, "在籍");
                    studentStmt.setNull(9, java.sql.Types.VARCHAR); // mediation_status
                    studentStmt.setNull(10, java.sql.Types.INTEGER); // desired_job_type_1st_id
                    studentStmt.setNull(11, java.sql.Types.INTEGER); // desired_job_type_2nd_id
                    studentStmt.setNull(12, java.sql.Types.INTEGER); // desired_job_type_3rd_id
                    studentStmt.setInt(13, 2026); // 卒業年は2026年をデフォルト
                    int studentResult = studentStmt.executeUpdate();
                    if (userResult > 0 && studentResult > 0) {
                        conn.commit();
                        request.setAttribute("successMessage", "学生の登録が完了しました。学籍番号: " + studentIdServer + ", パスワード: " + defaultPassword);
                        request.getRequestDispatcher("/WEB-INF/jsp/StudentManagement.jsp").forward(request, response);
                    } else {
                        conn.rollback();
                        request.setAttribute("errorMessage", "学生の登録に失敗しました。");
                        request.getRequestDispatcher("/WEB-INF/jsp/CreateStudent.jsp").forward(request, response);
                    }
                } catch (Exception e) {
                    conn.rollback();
                    e.printStackTrace();
                    request.setAttribute("errorMessage", "データベースエラーが発生しました: " + e.getMessage());
                    request.getRequestDispatcher("/WEB-INF/jsp/CreateStudent.jsp").forward(request, response);
                } finally {
                    conn.setAutoCommit(true);
                }
            
            //-------------------------------完成-------------------------------

            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("StudentManagement.jsp?error=db");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // セッションの確認
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        // 権限チェック（教員、校長・教務部長、管理者のみ）
        String role = (String) session.getAttribute("role");
        if (role == null || (!"teacher".equals(role) && !"headmaster".equals(role) && !"admin".equals(role))) {
            response.sendRedirect(request.getContextPath() + "/error/access-denied.html");
            return;
        }
        
        // // デバッグログ
        // System.out.println("StudentServlet doGet: アクセス開始");
        // System.out.println("StudentServlet: request URI = " + request.getRequestURI());
        // System.out.println("StudentServlet: context path = " + request.getContextPath());
        
        // try {
        //     // 検索キーワードとページ番号を取得
        //     String keyword = request.getParameter("keyword");
        //     String pageParam = request.getParameter("page");
        //     int page = 1;
        //     int pageSize = 10; // 1ページあたりの表示件数
        //     if (pageParam != null) {
        //         try {
        //             page = Integer.parseInt(pageParam);
        //         } catch (NumberFormatException e) {
        //             page = 1;
        //         }
        //     }

        //     ArrayList<ArrayList<String>> students = new ArrayList<>();
        //     int totalCount = 0;
        //     try (Connection conn = DBConnection.getConnection()) {
        //         System.out.println("StudentServlet: データベース接続成功");
                
        //         // まずテーブル構造を確認するためのシンプルなクエリ
        //         String countSql = "SELECT COUNT(*) FROM students_tbl";
        //         PreparedStatement countStmt = conn.prepareStatement(countSql);
        //         ResultSet countRs = countStmt.executeQuery();
        //         if (countRs.next()) {
        //             totalCount = countRs.getInt(1);
        //             System.out.println("StudentServlet: 総学生数 = " + totalCount);
        //         }

        //         // 件数取得用SQL
        //         String where = "";
        //         if (keyword != null && !keyword.trim().isEmpty()) {
        //             where = " WHERE student_id LIKE ? OR name LIKE ? OR CONCAT(department, class) LIKE ? ";
        //         }
        //         countSql += where;
        //         PreparedStatement countStmt2 = conn.prepareStatement(countSql);
        //         if (!where.isEmpty()) {
        //             String like = "%" + keyword + "%";
        //             countStmt2.setString(1, like);
        //             countStmt2.setString(2, like);
        //             countStmt2.setString(3, like);
        //         }
        //         ResultSet countRs2 = countStmt2.executeQuery();
        //         if (countRs2.next()) {
        //             totalCount = countRs2.getInt(1);
        //         }

        //         // 学生一覧取得SQL（シンプル版）
        //         String sql = "SELECT student_id, name, department, class, job_hunting_status FROM students_tbl ORDER BY student_id LIMIT ? OFFSET ?";
        //         PreparedStatement stmt = conn.prepareStatement(sql);
        //         stmt.setInt(1, pageSize);
        //         stmt.setInt(2, (page - 1) * pageSize);
        //         ResultSet rs = stmt.executeQuery();

        //         ArrayList<String> studentids = new ArrayList<>();
        //         ArrayList<String> names = new ArrayList<>();
        //         ArrayList<String> classs = new ArrayList<>();
        //         ArrayList<String> enrollmentStatuss = new ArrayList<>();
        //         while (rs.next()) {
        //             studentids.add(rs.getString("student_id"));
        //             names.add(rs.getString("name"));
        //             classs.add(rs.getString("department") + rs.getString("class"));
        //             enrollmentStatuss.add(rs.getString("job_hunting_status"));
        //         }
        //         students.add(studentids);
        //         students.add(names);
        //         students.add(classs);
        //         students.add(enrollmentStatuss);
        //     } catch (Exception e) {
        //         System.err.println("Database error in StudentServlet doGet: " + e.getMessage());
        //         e.printStackTrace();
        //         // エラーが発生した場合でも空のリストを設定
        //         students.add(new ArrayList<>());
        //         students.add(new ArrayList<>());
        //         students.add(new ArrayList<>());
        //         students.add(new ArrayList<>());
        //         totalCount = 0;
        //     }
        //     int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        //     request.setAttribute("students", students);
        //     request.setAttribute("currentPage", page);
        //     request.setAttribute("totalPages", totalPages);
        //     request.setAttribute("keyword", keyword);
            
        //     // System.out.println("StudentServlet: JSPフォワード開始 - StudentList.jsp");
        //     // System.out.println("StudentServlet: 学生数 = " + students.get(0).size());
        //     // System.out.println("StudentServlet: 現在ページ = " + page);
        //     // System.out.println("StudentServlet: 総ページ数 = " + totalPages);
            
            request.getRequestDispatcher("/WEB-INF/jsp/StudentList.jsp").forward(request, response);
        // } catch (Exception e) {
        //     System.err.println("General error in StudentServlet doGet: " + e.getMessage());
        //     e.printStackTrace();
        //     response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        //     response.getWriter().println("Error: " + e.getMessage());
        // }
    }
}