package servlet;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import utils.DBConnection;

/**
 * Servlet implementation class LoginServlet
 */
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
/**
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public LoginServlet() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	//JMS
	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
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
            PreparedStatement saltStmt = connection.prepareStatement(saltQuery);
            saltStmt.setString(1, id);
            ResultSet saltRs = saltStmt.executeQuery();

            if (saltRs.next()) {
                String salt = saltRs.getString("salt");
                String hashedPassword = hashPassword(password, salt);

                String query = "SELECT id, role FROM users WHERE id = ? AND password = ?";
                PreparedStatement statement = connection.prepareStatement(query);
                statement.setString(1, id);
                statement.setString(2, hashedPassword);

                ResultSet rs = statement.executeQuery();

                if (rs.next()) {
                	// LoginServlet#doPost(...)
                	HttpSession session = request.getSession();  // セッションスコープ
                	String userId = rs.getString("id");
                	String userRole = rs.getString("role");
                	
                	// 表示名を決定（学生の場合はname、それ以外はid）
                	String displayName = userId;
                	if ("student".equals(userRole)) {
                		// 学生の場合はstudents_tblからnameを取得
                		String nameQuery = "SELECT name FROM students_tbl WHERE student_id = ?";
                		PreparedStatement nameStmt = connection.prepareStatement(nameQuery);
                		nameStmt.setString(1, userId);
                		ResultSet nameRs = nameStmt.executeQuery();
                		
                		if (nameRs.next()) {
                			displayName = nameRs.getString("name");
                		}
                	} else if ("teacher".equals(userRole)) {
                		// 教員の場合はteacher_tblからnameを取得
                		String nameQuery = "SELECT name FROM teacher_tbl WHERE teacher_id = ?";
                		PreparedStatement nameStmt = connection.prepareStatement(nameQuery);
                		nameStmt.setString(1, userId);
                		ResultSet nameRs = nameStmt.executeQuery();
                		
                		if (nameRs.next()) {
                			displayName = nameRs.getString("name");
                		}
                	}
                	
                	session.setAttribute("username", displayName); // 表示名として保存
                	session.setAttribute("id", userId);
                	session.setAttribute("role", userRole);
                	// （アプリケーションスコープには何も置かない）

                	// デバッグログ
                	System.out.println("LoginServlet: セッション情報設定完了");
                	System.out.println("LoginServlet: username = " + displayName);
                	System.out.println("LoginServlet: id = " + userId);
                	System.out.println("LoginServlet: role = " + userRole);

                    // ログイン成功時はStatusServletにリダイレクト
                    response.sendRedirect(request.getContextPath() + "/StatusServlet?view=DashBoard");
                } else {
                    // ログイン失敗時はエラーページにリダイレクト
                    response.sendRedirect("error/login-failed.html?type=invalid_credentials");
                }
            } else {
                // ユーザーIDが存在しない場合
                response.sendRedirect("error/login-failed.html?type=invalid_credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // データベースエラーの場合
            response.sendRedirect("error/login-failed.html?type=database_error");
        }
    }
}
	