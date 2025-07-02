package test;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * UI確認用のテストサーブレット
 * ログイン認証をバイパスして各画面を表示します
 */
public class TestUIServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public TestUIServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // UI確認用のダミーセッション情報を設定
        HttpSession session = request.getSession();
        
        // パラメータからページとロールを取得
        String page = request.getParameter("page");
        String role = request.getParameter("role");
        
        // ロールが指定されていない場合はteacherをデフォルトに
        if (role == null || role.isEmpty()) {
            role = "teacher";
        }
        
        // ダミーのセッション情報を設定（すべての権限をバイパス）
        session.setAttribute("role", role);
        session.setAttribute("username", "テストユーザー（" + role + "）");
        session.setAttribute("id", "test_user_" + role);
        
        // 追加のセッション属性（一部のページで必要）
        session.setAttribute("loggedIn", true);
        session.setAttribute("userRole", role);
        session.setAttribute("isAdmin", true); // 管理者権限もバイパス
        
        // ダミーのユーザー情報
        if ("student".equals(role)) {
            session.setAttribute("studentId", "TEST2024001");
            session.setAttribute("studentName", "テスト学生");
            session.setAttribute("class", "S3A1");
        } else {
            session.setAttribute("teacherId", "TEST_TEACHER_001");
            session.setAttribute("teacherName", "テスト教員");
            session.setAttribute("department", "情報システム科");
        }
        
        // ページに応じて適切なJSPにフォワード
        String jspPath = "";
        switch (page) {
            case "dashboard":
                jspPath = "/WEB-INF/jsp/DashBoard.jsp";
                break;
            case "studentList":
                jspPath = "/WEB-INF/jsp/StudentList.jsp";
                break;
            case "createStudent":
                jspPath = "/WEB-INF/jsp/CreateStudent.jsp";
                break;
            case "studentManagement":
                jspPath = "/WEB-INF/jsp/StudentManagement.jsp";
                break;
            case "companyManagement":
                jspPath = "/WEB-INF/jsp/companyManagement.jsp";
                break;
            case "interviewExam":
                jspPath = "/WEB-INF/jsp/InterviewExamInput.jsp";
                break;
            case "selectionStage":
                jspPath = "/WEB-INF/jsp/SelectionStage.jsp";
                break;
            case "tempJms":
                jspPath = "/WEB-INF/jsp/temp_jms.jsp";
                break;
            default:
                // デフォルトはテストダッシュボードに戻る
                response.sendRedirect(request.getContextPath() + "/test/TestDashboard.jsp");
                return;
        }
        
        // エラー処理をバイパスするためのリクエスト属性も設定
        request.setAttribute("bypassAuth", true);
        request.setAttribute("testMode", true);
        
        // リクエストディスパッチャーを使ってJSPにフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POSTリクエストもGETと同じ処理を行う（フォーム送信のテスト用）
        doGet(request, response);
    }
} 