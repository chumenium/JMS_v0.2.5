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
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import beans.StudentBeans;
import utils.DBConnection;

/**
 * Servlet implementation class LoginServlet
 */
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public LoginServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	
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
	
	//警告を抑制
	@SuppressWarnings("unused")
	//base64クラスを使用してソルトを
	//エンコードフォーマット変更
	private String generateSalt() {
		SecureRandom sr = new SecureRandom();
		byte[] salt = new byte[16];
		sr.nextBytes(salt);
		return Base64.getEncoder().encodeToString(salt);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		String id = request.getParameter("id");
		String password = request.getParameter("password");

		try (Connection connection = DBConnection.getConnection()) {
			// ソルトをデータベースから取得
			String saltQuery = "SELECT salt FROM users WHERE id = ?";
			try (PreparedStatement saltStmt = connection.prepareStatement(saltQuery)) {
				
				saltStmt.setString(1, id);
				ResultSet saltRs = saltStmt.executeQuery();

				if (saltRs.next()) {
					String salt = saltRs.getString("salt");
					String hashedPassword = hashPassword(password, salt);

					// ユーザー認証
					String authQuery = "SELECT * FROM users WHERE id = ? AND password = ?";
					try (PreparedStatement authStmt = connection.prepareStatement(authQuery)) {
						authStmt.setString(1, id);
						authStmt.setString(2, hashedPassword);
						ResultSet authRs = authStmt.executeQuery();

						if (authRs.next()) {
							HttpSession session = request.getSession();
							String userId = authRs.getString("id");
							String userRole = authRs.getString("role");
							
							// 表示名を決定（学生の場合はname、それ以外はid）
							String displayName = userId;
							if ("student".equals(userRole)) {
								// 学生の場合はstudents_tblからnameを取得
								String studentQuery = "SELECT name FROM students_tbl WHERE student_id = ?";
								try (PreparedStatement studentStmt = connection.prepareStatement(studentQuery)) {
									studentStmt.setString(1, userId);
									ResultSet studentRs = studentStmt.executeQuery();
									
									if (studentRs.next()) {
										displayName = studentRs.getString("name");
									}
								}
							} else if ("teacher".equals(userRole)) {
								// 教員の場合はteacher_tblからnameを取得
								String nameQuery = "SELECT name FROM teacher_tbl WHERE teacher_id = ?";
								try (PreparedStatement nameStmt = connection.prepareStatement(nameQuery)) {
									nameStmt.setString(1, userId);
									ResultSet nameRs = nameStmt.executeQuery();
									
									if (nameRs.next()) {
										displayName = nameRs.getString("name");
									}
								}
							}
							
							session.setAttribute("username", displayName);
							session.setAttribute("id", userId);
							session.setAttribute("role", userRole);

							// デバッグログ
							System.out.println("LoginServlet: セッション接続完了");
							System.out.println("LoginServlet: username = " + displayName);
							System.out.println("LoginServlet: id = " + userId);
							System.out.println("LoginServlet: role = " + userRole);

							// ログイン成功時はStatusServletにリダイレクト

							//学生の場合リクエストスコープに学生情報を保存
							if(userRole.equals("student")){
								//StudentBeans student = StudentDAO.getStudentById(studentId);
								StudentBeans student = null;
								PreparedStatement ps = null;
								ResultSet rs = null;
								String sql = "SELECT student_id, department, class, number, name, name_reading, gender, email, tel, enrollment_status, mediation_status, job_hunting_status, o1.occupation AS 1st,o2.occupation AS 2nd,o3.occupation AS 3rd,graduation_year, remarks FROM students_tbl s LEFT JOIN occupations_tbl o1 ON s.desired_job_type_1st_id = o1.occupation_id LEFT JOIN occupations_tbl o2 ON s.desired_job_type_2nd_id = o2.occupation_id LEFT JOIN occupations_tbl o3 ON s.desired_job_type_3rd_id = o3.occupation_id WHERE student_id = ?";
								ps = connection.prepareStatement(sql);//"student_id, class, number, name, name_reading, gender, email, tel, enrollment_status, mediation_status, job_hunting_status, o1.occupation AS 1st,o2.occupation AS 2nd,o3.occupation AS 3rd,graduation_year, remarks"
								ps.setString(1, id);
								rs = ps.executeQuery();
								if (rs.next()) {
									student = new StudentBeans();
									student.setId(rs.getString("student_id"));
									String dc = rs.getString("department") + rs.getString("class");
									student.setClassName(dc);
									student.setNumber(rs.getString("number"));
									student.setName(rs.getString("name"));
									student.setNameKana(rs.getString("name_reading"));
									student.setGender(rs.getString("gender"));
									student.setEmail(rs.getString("email"));
									student.setTel(rs.getString("tel"));
									student.setEnrollmentStatus(rs.getString("enrollment_status"));
									student.setAssistanceStatus(rs.getString("mediation_status"));
									student.setJobHuntingStatus(rs.getString("job_hunting_status"));
									student.setDesiredJobType1(rs.getString("1st"));
									student.setDesiredJobType2(rs.getString("2nd"));
									student.setDesiredJobType3(rs.getString("3rd"));
									student.setGraduationYear(rs.getString("graduation_year"));
									student.setRemarks(rs.getString("remarks"));
									
									// 希望勤務地を取得
									String workPlaceSql = "SELECT wp.work_place FROM students_work_place_tbl swp JOIN work_place_tbl wp ON swp.work_place_id = wp.id WHERE swp.student_id = ?";
									PreparedStatement workPlacePs = connection.prepareStatement(workPlaceSql);
									workPlacePs.setString(1, id);
									ResultSet workPlaceRs = workPlacePs.executeQuery();
									List<String> wps = new ArrayList<String>();
									while (workPlaceRs.next()) {
										wps.add(workPlaceRs.getString("work_place"));
									}
									student.setDesiredWorkPlace(wps);
								}
								session.setAttribute("student", student);
							}
							response.sendRedirect(request.getContextPath() + "/StatusServlet?view=DashBoard");
						} else {
							// ログイン失敗時はエラーページにリダイレクト
							response.sendRedirect("error/login-failed.html?type=invalid_credentials");
						}
					}
				} else {
					// ユーザーIDが存在しない場合
					response.sendRedirect("error/login-failed.html?type=invalid_credentials");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			// データベースエラーの場合
			response.sendRedirect("error/login-failed.html?type=database_error");
		}
	}
}
	
