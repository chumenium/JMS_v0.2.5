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
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
    		 ArrayList<String> classs = new ArrayList<String>();
    		 ArrayList<String> studentid = new ArrayList<String>();
             String sql = "SELECT student_id, class FROM students_tbl WHERE enrollment_status = ?";
             PreparedStatement stmt = conn.prepareStatement(sql);
             stmt.setString(1, enrollmentStatus);
             ResultSet rs = stmt.executeQuery();
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
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            if ("add".equals(action)) {
                // 学生を新規追加する（パスワード管理と学年期間を適用）
    	        String student_id = request.getParameter("student_id");
    	        String password = request.getParameter("password");
    	        String student_class = request.getParameter("class");
    	        String department = null;
    	        String studentClass = null;
    	        if (student_class != null && !student_class.trim().isEmpty()) {
    	            department = student_class.substring(0, 2);
    	            studentClass = student_class.substring(2);
    	        }
    	        String number = request.getParameter("number");
    	        String name = request.getParameter("name");
    	        String name_reading = request.getParameter("name_reading");
    	        String gender = request.getParameter("gender");
    	        String enrollment_status = "在籍";// = request.getParameter("enrollment_status");
    	        String graduation_year_str = request.getParameter("graduation_year");
    	        int graduation_year = 0;
    	        if (graduation_year_str != null && !graduation_year_str.trim().isEmpty()) {
    	            graduation_year = Integer.parseInt(graduation_year_str);
    	        }
    	        
    	        
    	        // ソルトを生成
    	        String salt = generateSalt();
    	        // パスワードをハッシュ化
    	        String hashedPassword = hashPassword(password, salt);
    	        //データ挿入クエリ生成
    	        String registerQuery = "INSERT INTO users (id, password, role, salt) VALUES (?, ?, ?, ?);";
    	        PreparedStatement usersStatement = conn.prepareStatement(registerQuery);
    	        usersStatement.setString(1, student_id);
    	        usersStatement.setString(2, hashedPassword);
    	        usersStatement.setString(3, "student");
    	        usersStatement.setString(4, salt);

    	        String studentQuery = "INSERT INTO students_tbl "
    	        	    + "(student_id, department, class, number, name, name_reading, gender, enrollment_status, mediation_status, "
    	        	    + "desired_job_type_1st_id, desired_job_type_2nd_id, desired_job_type_3rd_id, graduation_year) "
    	        	    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";

                PreparedStatement studentStatement = conn.prepareStatement(studentQuery);
                
                studentStatement.setString(1, student_id);
                studentStatement.setString(2, department);
                studentStatement.setString(3, studentClass);
                studentStatement.setString(4, number);
                studentStatement.setString(5, name);
                studentStatement.setString(6, name_reading);
                studentStatement.setString(7, gender);
                studentStatement.setString(8, enrollment_status);
                studentStatement.setNull(9, java.sql.Types.VARCHAR);
                studentStatement.setNull(10, java.sql.Types.VARCHAR);
                studentStatement.setNull(11, java.sql.Types.VARCHAR);
                studentStatement.setNull(12, java.sql.Types.VARCHAR);
                if (graduation_year > 0) {
                    studentStatement.setInt(13, graduation_year);
                } else {
                    studentStatement.setNull(13, java.sql.Types.INTEGER);
                }
                
                int rowsInserted1 = usersStatement.executeUpdate();
                int rowsInserted2 = studentStatement.executeUpdate();
                
                //初期データ例：23105,   S3A1,  21, 山田 太郎, ヤマダ タロウ, 男,    在籍,   NULL,     NULL,     NULL,     NULL ,  2026
                //             学籍番号,クラス,番号,   名前,     名前読み,   性別,在籍状況,斡旋状況,希望職種1,希望職種2,希望職種3,卒業年
                if (rowsInserted1 > 0 && rowsInserted2 > 0) {
                	//データ登録成功
                	request.getRequestDispatcher("/WEB-INF/jsp/StudentManagement.jsp").forward(request, response);
                } else {
                    //データ登録失敗
                }

            
            //-------------------------------完成-------------------------------
            } else if ("update".equals(action)) {
                // 学生情報を更新する
    	        String student_id = request.getParameter("student_id");
    	        String student_class = request.getParameter("class");
    	        String department = null;
    	        String studentClass = null;
    	        if (student_class != null && !student_class.trim().isEmpty()) {
    	            department = student_class.substring(0, 2);
    	            studentClass = student_class.substring(2);
    	        }
    	        String number = request.getParameter("number");
    	        String name = request.getParameter("name");
    	        String name_reading = request.getParameter("name_reading");
    	        String gender = request.getParameter("gender");
    	        String enrollment_status = request.getParameter("enrollment_status");
    	        String mediation_status = request.getParameter("mediation_status");
    	        String desired_job_type_1st = request.getParameter("desired_job_type_1st");
    	        String desired_job_type_2nd = request.getParameter("desired_job_type_2nd");
    	        String desired_job_type_3rd = request.getParameter("desired_job_type_3rd");
    	        String graduation_year = request.getParameter("graduation_year");
    	        
    	        String studentQuery = "UPDATE students_tbl SET "
    	        	    + "department = ?, class = ?, number = ?, name = ?, name_reading = ?, gender = ?, "
    	        	    + "enrollment_status = ?, mediation_status = ?, desired_job_type_1st_id = ?, "
    	        	    + "desired_job_type_2nd_id = ?, desired_job_type_3rd_id = ?, graduation_year = ? "
    	        	    + "WHERE student_id = ?;";

                PreparedStatement studentStatement = conn.prepareStatement(studentQuery);
    	        
    	        if(mediation_status == null || mediation_status.trim().isEmpty()) {
    	        	studentStatement.setNull(8, java.sql.Types.VARCHAR);
    	        }else {
    	        	studentStatement.setString(8, mediation_status);
    	        }
    	        if(desired_job_type_1st == null || desired_job_type_1st.trim().isEmpty()) {
                    studentStatement.setNull(9, java.sql.Types.VARCHAR);
                    studentStatement.setNull(10, java.sql.Types.VARCHAR);
                    studentStatement.setNull(11, java.sql.Types.VARCHAR);
    	        }else if(desired_job_type_2nd == null || desired_job_type_2nd.trim().isEmpty()){
    	        	studentStatement.setInt(9, getDesiredJobId(desired_job_type_1st));
                    studentStatement.setNull(10, java.sql.Types.VARCHAR);
                    studentStatement.setNull(11, java.sql.Types.VARCHAR);
    	        }else if(desired_job_type_3rd == null || desired_job_type_3rd.trim().isEmpty()) {
    	        	studentStatement.setInt(9, getDesiredJobId(desired_job_type_1st));
                    studentStatement.setInt(10, getDesiredJobId(desired_job_type_2nd));
                    studentStatement.setNull(11, java.sql.Types.VARCHAR);
    	        }else {
    	        	studentStatement.setInt(9, getDesiredJobId(desired_job_type_1st));
                    studentStatement.setInt(10, getDesiredJobId(desired_job_type_2nd));
                    studentStatement.setInt(11, getDesiredJobId(desired_job_type_3rd));
    	        }
    	        //退学の場合卒業年をNULLにする
    	        if((enrollment_status != null && enrollment_status.equals("退学")) || graduation_year == null || graduation_year.trim().isEmpty()) {
    	        	studentStatement.setNull(12, java.sql.Types.VARCHAR);
    	        }else {
    	        	studentStatement.setInt(12, Integer.parseInt(graduation_year));
    	        }
    	        
                studentStatement.setString(1, department);
                studentStatement.setString(2, studentClass);
                studentStatement.setString(3, number);
                studentStatement.setString(4, name);
                studentStatement.setString(5, name_reading);
                studentStatement.setString(6, gender);
                studentStatement.setString(7, enrollment_status);
                studentStatement.setString(13, student_id);
                
                int rowsInserted1 = studentStatement.executeUpdate();
                if (rowsInserted1 > 0) {
                	//データ更新成功
                    request.getRequestDispatcher("/WEB-INF/jsp/StudentManagement.jsp").forward(request, response);
                } else {
                    //データ更新失敗
                }

            //-------------------------------完成-------------------------------
            } else if ("delete".equals(action)) {
                // 学生情報を削除する（`studentClass` で削除）
            	String student_id = request.getParameter("student_id");

                String sql = "DELETE FROM students_tbl WHERE student_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, student_id);
                int rowsInserted1 = stmt.executeUpdate();
                if (rowsInserted1 > 0) {
                	//データ更新成功
                	request.getRequestDispatcher("/WEB-INF/jsp/StudentManagement.jsp").forward(request, response);
                } else {
                    //データ更新失敗
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
                
            } else if ("viewStudents".equals(action)) {
    	        String student_id = request.getParameter("student_id");
    	        String student_class = request.getParameter("class");
    	        String department = null;
    	        String studentClass = null;
    	        if (student_class != null && !student_class.trim().isEmpty()) {
    	            department = student_class.substring(0, 2);
    	            studentClass = student_class.substring(2);
    	        }
    	        String number = request.getParameter("number");
    	        String name_reading = request.getParameter("name_reading");
    	        String gender = request.getParameter("gender");
    	        String enrollment_status = request.getParameter("enrollment_status");
    	        String mediation_status = request.getParameter("mediation_status");
    	        String desired_job_type_1st = request.getParameter("desired_job_type_1st");
    	        String graduation_year = request.getParameter("graduation_year");
    	        String sql = "SELECT * FROM students_tbl ";
    	        int i = 0;
    	        if(student_id != null && !student_id.trim().isEmpty()) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"student_id = ? ";
    	        	i++;
    	        }
    	        if(student_class != null && !student_class.trim().isEmpty()) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"department = ? AND class = ? ";
    	        	i++;
    	        	i++;
    	        }
    	        if(number != null && !number.trim().isEmpty()) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"number = ? ";
    	        	i++;
    	        }
    	        if(name_reading != null && !name_reading.trim().isEmpty()) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"name_reading = ? ";
    	        	i++;
    	        }
    	        if(gender != null && !gender.trim().isEmpty()) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"gender = ? ";
    	        	i++;
    	        }
    	        if(enrollment_status != null && !enrollment_status.trim().isEmpty()) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"enrollment_status = ? ";
    	        	i++;
    	        }
    	        if(mediation_status != null && !mediation_status.trim().isEmpty()) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"mediation_status = ? ";
    	        	i++;
    	        }
    	        if(desired_job_type_1st != null && !desired_job_type_1st.trim().isEmpty()) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"desired_job_type_1st_id = ? ";
    	        	i++;
    	        }
    	        if(graduation_year != null && !graduation_year.trim().isEmpty()) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"graduation_year = ? ";
    	        	i++;
    	        }
    	        sql = sql + ";";

                
                PreparedStatement stmt = conn.prepareStatement(sql);


    	        if(graduation_year != null && !graduation_year.trim().isEmpty()) {
    	        	stmt.setInt(i, Integer.parseInt(graduation_year));
    	        	i--;
    	        }
    	        if(desired_job_type_1st != null && !desired_job_type_1st.trim().isEmpty()) {
    	        	stmt.setInt(i, Integer.parseInt(desired_job_type_1st));
    	        	i--;
    	        }
    	        if(mediation_status != null && !mediation_status.trim().isEmpty()) {
    	        	stmt.setString(i, mediation_status);
    	        	i--;
    	        }
    	        if(enrollment_status != null && !enrollment_status.trim().isEmpty()) {
    	        	stmt.setString(i, enrollment_status);
    	        	i--;
    	        }
    	        if(gender != null && !gender.trim().isEmpty()) {
    	        	stmt.setString(i, gender);
    	        	i--;
    	        }
    	        if(name_reading != null && !name_reading.trim().isEmpty()) {
    	        	stmt.setString(i, name_reading);
    	        	i--;
    	        }
    	        if(number != null && !number.trim().isEmpty()) {
    	        	stmt.setString(i, number);
    	        	i--;
    	        }
    	        if(student_class != null && !student_class.trim().isEmpty()) {
    	        	stmt.setString(i, studentClass);
    	        	stmt.setString(i, department);
    	        	i--;
    	        	i--;
    	        }
    	        if(student_id != null && !student_id.trim().isEmpty()) {
    	        	stmt.setString(i, student_id);
    	        	i--;
    	        }
                
                ResultSet rs = stmt.executeQuery();
    	        
                ArrayList<ArrayList<String>> students = new ArrayList<>();
                ArrayList<String> studentids = new ArrayList<>();
                ArrayList<String> classs = new ArrayList<>();
                ArrayList<String> numbers = new ArrayList<>();
                ArrayList<String> names = new ArrayList<>();
                ArrayList<String> nameReadings = new ArrayList<>();
                ArrayList<String> genders = new ArrayList<>();
                ArrayList<String> enrollmentStatuss = new ArrayList<>();
                ArrayList<String> mediationStatuss = new ArrayList<>();
                ArrayList<String> DJTs1 = new ArrayList<>();
                ArrayList<String> DJTs2 = new ArrayList<>();
                ArrayList<String> DJTs3 = new ArrayList<>();
                ArrayList<String> graduationYears = new ArrayList<>();
                
                while (rs.next()) {
                	studentids.add(rs.getString("student_id"));
                	String class_num = rs.getString("department") + rs.getString("class");
                	classs.add(class_num);
                	numbers.add(rs.getString("number"));
                	names.add(rs.getString("name"));
                	nameReadings.add(rs.getString("name_reading"));
                	genders.add(rs.getString("gender"));
                	enrollmentStatuss.add(rs.getString("enrollment_status"));
                	mediationStatuss.add(rs.getString("mediation_status"));
                	DJTs1.add(String.valueOf(rs.getInt("desired_job_type_1st_id")));
                	DJTs2.add(String.valueOf(rs.getInt("desired_job_type_2nd_id")));
                	DJTs3.add(String.valueOf(rs.getInt("desired_job_type_3rd_id")));
                	graduationYears.add(String.valueOf(rs.getInt("graduation_year")));
                }
                students.add(studentids);
                students.add(classs);
                students.add(numbers);
                students.add(names);
                students.add(nameReadings);
                students.add(genders);
                students.add(enrollmentStatuss);
                students.add(mediationStatuss);
                students.add(DJTs1);
                students.add(DJTs2);
                students.add(DJTs3);
                students.add(graduationYears);

                request.setAttribute("students", students);
                request.getRequestDispatcher("/WEB-INF/jsp/StudentManagement.jsp").forward(request, response);
                
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
        // デバッグログ
        System.out.println("StudentServlet doGet: アクセス開始");
        System.out.println("StudentServlet: request URI = " + request.getRequestURI());
        System.out.println("StudentServlet: context path = " + request.getContextPath());
        
        try {
            // 検索キーワードとページ番号を取得
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
            try (Connection conn = DBConnection.getConnection()) {
                System.out.println("StudentServlet: データベース接続成功");
                
                // まずテーブル構造を確認するためのシンプルなクエリ
                String countSql = "SELECT COUNT(*) FROM students_tbl";
                PreparedStatement countStmt = conn.prepareStatement(countSql);
                ResultSet countRs = countStmt.executeQuery();
                if (countRs.next()) {
                    totalCount = countRs.getInt(1);
                    System.out.println("StudentServlet: 総学生数 = " + totalCount);
                }

                // 件数取得用SQL
                String where = "";
                if (keyword != null && !keyword.trim().isEmpty()) {
                    where = " WHERE student_id LIKE ? OR name LIKE ? OR CONCAT(department, class) LIKE ? ";
                }
                countSql += where;
                PreparedStatement countStmt2 = conn.prepareStatement(countSql);
                if (!where.isEmpty()) {
                    String like = "%" + keyword + "%";
                    countStmt2.setString(1, like);
                    countStmt2.setString(2, like);
                    countStmt2.setString(3, like);
                }
                ResultSet countRs2 = countStmt2.executeQuery();
                if (countRs2.next()) {
                    totalCount = countRs2.getInt(1);
                }

                // 学生一覧取得SQL（シンプル版）
                String sql = "SELECT student_id, name, department, class, enrollment_status FROM students_tbl ORDER BY student_id LIMIT ? OFFSET ?";
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
                    enrollmentStatuss.add(rs.getString("enrollment_status"));
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
            request.setAttribute("students", students);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("keyword", keyword);
            
            System.out.println("StudentServlet: JSPフォワード開始 - StudentList.jsp");
            System.out.println("StudentServlet: 学生数 = " + students.get(0).size());
            System.out.println("StudentServlet: 現在ページ = " + page);
            System.out.println("StudentServlet: 総ページ数 = " + totalPages);
            
            request.getRequestDispatcher("/WEB-INF/jsp/StudentList.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("General error in StudentServlet doGet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}