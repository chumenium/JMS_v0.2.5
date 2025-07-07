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
	
	// 繝代せ繝ｯ繝ｼ繝峨・繝上ャ繧ｷ繝･蛹悶→繧ｽ繝ｫ繝医・逕滓・
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
    
    //隴ｦ蜻翫ｒ謚大宛
    @SuppressWarnings("unused")
    //base64繧ｯ繝ｩ繧ｹ繧剃ｽｿ逕ｨ縺励※繧ｽ繝ｫ繝医ｒ
    //繧ｨ繝ｳ繧ｳ繝ｼ繝峨ヵ繧ｩ繝ｼ繝槭ャ繝亥､画峩
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
            // 繧ｽ繝ｫ繝医ｒ繝・・繧ｿ繝吶・繧ｹ縺九ｉ蜿門ｾ・
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
                	HttpSession session = request.getSession();  // 繧ｻ繝・す繝ｧ繝ｳ繧ｹ繧ｳ繝ｼ繝・
                	String userId = rs.getString("id");
                	String userRole = rs.getString("role");
                	
                	// 陦ｨ遉ｺ蜷阪ｒ豎ｺ螳夲ｼ亥ｭｦ逕溘・蝣ｴ蜷医・name縲√◎繧御ｻ･螟悶・id・・
                	String displayName = userId;
                	if ("student".equals(userRole)) {
                		// 蟄ｦ逕溘・蝣ｴ蜷医・students_tbl縺九ｉname繧貞叙蠕・
                		String nameQuery = "SELECT name FROM students_tbl WHERE student_id = ?";
                		PreparedStatement nameStmt = connection.prepareStatement(nameQuery);
                		nameStmt.setString(1, userId);
                		ResultSet nameRs = nameStmt.executeQuery();
                		
                		if (nameRs.next()) {
                			displayName = nameRs.getString("name");
                		}
                	} else if ("teacher".equals(userRole)) {
                		// 謨吝藤縺ｮ蝣ｴ蜷医・teacher_tbl縺九ｉname繧貞叙蠕・
                		String nameQuery = "SELECT name FROM teacher_tbl WHERE teacher_id = ?";
                		PreparedStatement nameStmt = connection.prepareStatement(nameQuery);
                		nameStmt.setString(1, userId);
                		ResultSet nameRs = nameStmt.executeQuery();
                		
                		if (nameRs.next()) {
                			displayName = nameRs.getString("name");
                		}
                	}
                	
                	session.setAttribute("username", displayName); // 陦ｨ遉ｺ蜷阪→縺励※菫晏ｭ・
                	session.setAttribute("id", userId);
                	session.setAttribute("role", userRole);
                	// ・医い繝励Μ繧ｱ繝ｼ繧ｷ繝ｧ繝ｳ繧ｹ繧ｳ繝ｼ繝励↓縺ｯ菴輔ｂ鄂ｮ縺九↑縺・ｼ・

                	// 繝・ヰ繝・げ繝ｭ繧ｰ
                	System.out.println("LoginServlet: 繧ｻ繝・す繝ｧ繝ｳ諠・ｱ險ｭ螳壼ｮ御ｺ・);
                	System.out.println("LoginServlet: username = " + displayName);
                	System.out.println("LoginServlet: id = " + userId);
                	System.out.println("LoginServlet: role = " + userRole);

                    // 繝ｭ繧ｰ繧､繝ｳ謌仙粥譎ゅ・StatusServlet縺ｫ繝ｪ繝繧､繝ｬ繧ｯ繝・
                    response.sendRedirect(request.getContextPath() + "/StatusServlet?view=DashBoard");
                } else {
                    // 繝ｭ繧ｰ繧､繝ｳ螟ｱ謨玲凾縺ｯ繧ｨ繝ｩ繝ｼ繝壹・繧ｸ縺ｫ繝ｪ繝繧､繝ｬ繧ｯ繝・
                    response.sendRedirect("error/login-failed.html?type=invalid_credentials");
                }
            } else {
                // 繝ｦ繝ｼ繧ｶ繝ｼID縺悟ｭ伜惠縺励↑縺・ｴ蜷・
                response.sendRedirect("error/login-failed.html?type=invalid_credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 繝・・繧ｿ繝吶・繧ｹ繧ｨ繝ｩ繝ｼ縺ｮ蝣ｴ蜷・
            response.sendRedirect("error/login-failed.html?type=database_error");
        }
    }
}
	
