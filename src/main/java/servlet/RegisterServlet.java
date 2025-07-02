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

import utils.DBConnection;

/**
 * Servlet implementation class RegisterServlet
 */
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public RegisterServlet() {
		super();
	}
	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// GETリクエストの場合は新規登録画面にリダイレクト
		response.sendRedirect("register.html");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	
	// パスワードのハッシュ化とソルトの生成（LoginServletと同じ）
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
    
    // ソルト生成（LoginServletと同じ）
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
        
        // パラメータの取得
        String id = request.getParameter("id");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        // バリデーション
        if (id == null || id.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            response.sendRedirect("register.html?error=invalid_input");
            return;
        }

        try (Connection connection = DBConnection.getConnection()) {
            // ユーザーIDの重複チェック
            String checkQuery = "SELECT id FROM users WHERE id = ?";
            PreparedStatement checkStmt = connection.prepareStatement(checkQuery);
            checkStmt.setString(1, id);
            ResultSet checkRs = checkStmt.executeQuery();

            if (checkRs.next()) {
                response.sendRedirect("register.html?error=" + 
                    java.net.URLEncoder.encode("このユーザーIDは既に使用されています", "UTF-8"));
                return;
            }

            // ソルト生成
            String salt = generateSalt();
            
            // パスワードハッシュ化
            String hashedPassword = hashPassword(password, salt);

            // ユーザー登録
            String insertQuery = "INSERT INTO users (id, password, role, salt) VALUES (?, ?, ?, ?)";
            PreparedStatement insertStmt = connection.prepareStatement(insertQuery);
            insertStmt.setString(1, id);
            insertStmt.setString(2, hashedPassword);
            insertStmt.setString(3, role);
            insertStmt.setString(4, salt);

            int result = insertStmt.executeUpdate();

            if (result > 0) {
                // 登録成功
                response.sendRedirect("login.html?success=" + 
                    java.net.URLEncoder.encode("登録が完了しました。ログインしてください。", "UTF-8"));
            } else {
                // 登録失敗
                response.sendRedirect("register.html?error=" + 
                    java.net.URLEncoder.encode("登録に失敗しました", "UTF-8"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.html?error=" + 
                java.net.URLEncoder.encode("システムエラーが発生しました", "UTF-8"));
        }
    }
} 