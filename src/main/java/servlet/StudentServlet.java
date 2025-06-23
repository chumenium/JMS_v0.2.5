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
    	        String department = student_class.substring(0, 2);
    	        String studentClass = student_class.substring(2);
    	        String number = request.getParameter("number");
    	        String name = request.getParameter("name");
    	        String name_reading = request.getParameter("name_reading");
    	        String gender = request.getParameter("gender");
    	        String enrollment_status = "在籍";// = request.getParameter("enrollment_status");
    	        int graduation_year = Integer.parseInt(request.getParameter("graduation_year"));//送信元が未入力だとエラーが発生する
    	        
    	        
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
                studentStatement.setInt(13, graduation_year);
                
                int rowsInserted1 = usersStatement.executeUpdate();
                int rowsInserted2 = studentStatement.executeUpdate();
                
                //初期データ例：23105,   S3A1,  21, 山田 太郎, ヤマダ タロウ, 男,    在籍,   NULL,     NULL,     NULL,     NULL ,  2026
                //             学籍番号,クラス,番号,   名前,     名前読み,   性別,在籍状況,斡旋状況,希望職種1,希望職種2,希望職種3,卒業年
                if (rowsInserted1 > 0 && rowsInserted2 > 0) {
                	//データ登録成功
                	request.getRequestDispatcher("/WEB-INF/jsp/???.jsp").forward(request, response);
                } else {
                    //データ登録失敗
                }

            
            //-------------------------------完成-------------------------------
            } else if ("update".equals(action)) {
                // 学生情報を更新する
    	        String student_id = request.getParameter("student_id");
    	        String student_class = request.getParameter("class");
    	        String department = student_class.substring(0, 2);
    	        String studentClass = student_class.substring(2);
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
    	        
    	        String studentQuery = "INSERT INTO students_tbl "
    	        	    + "(student_id, department, class, number, name, name_reading, gender, enrollment_status, mediation_status, "
    	        	    + "desired_job_type_1st_id, desired_job_type_2nd_id, desired_job_type_3rd_id, graduation_year) "
    	        	    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";

                PreparedStatement studentStatement = conn.prepareStatement(studentQuery);
    	        
    	        if(mediation_status == null) {
    	        	studentStatement.setNull(9, java.sql.Types.VARCHAR);
    	        }else {
    	        	studentStatement.setString(9, mediation_status);
    	        }
    	        if(desired_job_type_1st == null) {
                    studentStatement.setNull(10, java.sql.Types.VARCHAR);
                    studentStatement.setNull(11, java.sql.Types.VARCHAR);
                    studentStatement.setNull(12, java.sql.Types.VARCHAR);
    	        }else if(desired_job_type_2nd == null){
    	        	studentStatement.setInt(10, getDesiredJobId(desired_job_type_1st));
                    studentStatement.setNull(11, java.sql.Types.VARCHAR);
                    studentStatement.setNull(12, java.sql.Types.VARCHAR);
    	        }else if(desired_job_type_3rd == null) {
    	        	studentStatement.setInt(10, getDesiredJobId(desired_job_type_1st));
                    studentStatement.setInt(11, getDesiredJobId(desired_job_type_2nd));
                    studentStatement.setNull(12, java.sql.Types.VARCHAR);
    	        }else {
    	        	studentStatement.setInt(10, getDesiredJobId(desired_job_type_1st));
                    studentStatement.setInt(11, getDesiredJobId(desired_job_type_2nd));
                    studentStatement.setInt(12, getDesiredJobId(desired_job_type_3rd));
    	        }
    	        //退学の場合卒業年をNULLにする
    	        if(enrollment_status.equals("退学") || graduation_year == null) {
    	        	studentStatement.setNull(13, java.sql.Types.VARCHAR);
    	        }else {
    	        	studentStatement.setInt(13, Integer.parseInt(graduation_year));
    	        }
    	        
                studentStatement.setString(1, student_id);
                studentStatement.setString(2, department);
                studentStatement.setString(3, studentClass);
                studentStatement.setString(4, number);
                studentStatement.setString(5, name);
                studentStatement.setString(6, name_reading);
                studentStatement.setString(7, gender);
                studentStatement.setString(8, enrollment_status);
                //studentStatement.setInt(12, graduation_year);
                
                int rowsInserted1 = studentStatement.executeUpdate();
                if (rowsInserted1 > 0) {
                	//データ更新成功
                    request.getRequestDispatcher("/WEB-INF/jsp/???.jsp").forward(request, response);
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
                	request.getRequestDispatcher("/WEB-INF/jsp/???.jsp").forward(request, response);
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
            				}else if(gradeUpLimits[i] > Integer.parseInt(cn)) {
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
            	
                String sql1 = "UPDATE students_tbl SET enrollment_status = CASE student_id "
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

                request.getRequestDispatcher("/WEB-INF/jsp/???.jsp").forward(request, response);
                
            //-------------------------------完成-------------------------------
            } else if ("viewStudents".equals(action)) {
    	        String student_id = request.getParameter("student_id");
    	        String student_class = request.getParameter("class");
    	        String department = student_class.substring(0, 2);
    	        String studentClass = student_class.substring(2);
    	        String number = request.getParameter("number");
    	        String name_reading = request.getParameter("name_reading");
    	        String gender = request.getParameter("gender");
    	        String enrollment_status = request.getParameter("enrollment_status");
    	        String mediation_status = request.getParameter("mediation_status");
    	        String desired_job_type_1st = request.getParameter("desired_job_type_1st");
    	        String graduation_year = request.getParameter("graduation_year");
    	        String sql = "SELECT * FROM students ";
    	        int i = 0;
    	        if(student_id != null) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"student_id = ? ";
    	        	i++;
    	        }
    	        if(student_class != null) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"department = ? AND class = ? ";
    	        	i++;
    	        	i++;
    	        }
    	        if(number != null) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"number = ? ";
    	        	i++;
    	        }
    	        if(name_reading != null) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"name_reading = ? ";
    	        	i++;
    	        }
    	        if(gender != null) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"gender = ? ";
    	        	i++;
    	        }
    	        if(enrollment_status != null) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"enrollment_status = ? ";
    	        	i++;
    	        }
    	        if(mediation_status != null) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"mediation_status = ? ";
    	        	i++;
    	        }
    	        if(desired_job_type_1st != null) {
    	        	if(i == 0) {
    	        		sql = sql + "WHERE ";
    	        	}else {
    	        		sql = sql + "AND ";
    	        	}
    	        	sql = sql+"desired_job_type_1st_id = ? ";
    	        	i++;
    	        }
    	        if(graduation_year != null) {
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


    	        if(graduation_year != null) {
    	        	stmt.setInt(i, Integer.parseInt(graduation_year));
    	        	i--;
    	        }
    	        if(desired_job_type_1st != null) {
    	        	stmt.setInt(i, Integer.parseInt(desired_job_type_1st));
    	        	i--;
    	        }
    	        if(mediation_status != null) {
    	        	stmt.setString(i, mediation_status);
    	        	i--;
    	        }
    	        if(enrollment_status != null) {
    	        	stmt.setString(i, enrollment_status);
    	        	i--;
    	        }
    	        if(gender != null) {
    	        	stmt.setString(i, gender);
    	        	i--;
    	        }
    	        if(name_reading != null) {
    	        	stmt.setString(i, name_reading);
    	        	i--;
    	        }
    	        if(number != null) {
    	        	stmt.setString(i, number);
    	        	i--;
    	        }
    	        if(student_class != null) {
    	        	stmt.setString(i, studentClass);
    	        	stmt.setString(i, department);
    	        	i--;
    	        	i--;
    	        }
    	        if(student_id != null) {
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
                request.getRequestDispatcher("/WEB-INF/jsp/???.jsp").forward(request, response);
                
            } else if ("getInputData".equals(action)) {
            	String sql1 = "SELECT occupation FROM occupations_tbl;";
            	PreparedStatement stmt1 = conn.prepareStatement(sql1);
            	ResultSet rs1 = stmt1.executeQuery();
            	
            	String sql2 = "SELECT work_place FROM work_place_tbl;;";
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
					enrollmentStatuss.add(rs1.getString("enrollment_status"));
				}
				while (rs4.next()) {
					graduationYears.add(rs1.getString("graduation_year"));
				}
                request.setAttribute("occupations", occupations);
                request.setAttribute("workPlaces", workPlaces);
                request.setAttribute("enrollmentStatuss", enrollmentStatuss);
                request.setAttribute("graduationYears", graduationYears);
                request.getRequestDispatcher("/WEB-INF/jsp/???.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("students.jsp?error=db");
        }
    }
}