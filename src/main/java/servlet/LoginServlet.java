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

import dao.DBconnecter;

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

        try (Connection connection = DBconnecter.getConnection()) {
            // ソルトをデータベースから取得
            String saltQuery = "SELECT salt FROM users WHERE id = ?";
            PreparedStatement saltStmt = connection.prepareStatement(saltQuery);
            saltStmt.setString(1, id);
            ResultSet saltRs = saltStmt.executeQuery();

            if (saltRs.next()) {
                String salt = saltRs.getString("salt");
                String hashedPassword = hashPassword(password, salt);

                String query = "SELECT username, id, role FROM users WHERE id = ? AND password = ?";
                PreparedStatement statement = connection.prepareStatement(query);
                statement.setString(1, id);
                statement.setString(2, hashedPassword);

                ResultSet rs = statement.executeQuery();

                if (rs.next()) {
                	// LoginServlet#doPost(...)
                	HttpSession session = request.getSession();  // セッションスコープ
                	session.setAttribute("username", rs.getString("username"));
                	session.setAttribute("id",       rs.getString("id"));
                	session.setAttribute("role",     rs.getString("role"));
                	// （アプリケーションスコープには何も置かない）


                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp");
                    dispatcher.forward(request, response);
                } else {
                    RequestDispatcher dispatcher = request.getRequestDispatcher("login.html");
                    dispatcher.forward(request, response);
                }
            } else {
                RequestDispatcher dispatcher = request.getRequestDispatcher("login.html");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
	