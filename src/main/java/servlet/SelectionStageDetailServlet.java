package servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import beans.CompanyBean;
import beans.ExamineeBean;
import dao.CompanyDAO;
import dao.SelectionStageDAO;
import dao.StudentDAO;

/**
 * 選考ステージ詳細サーブレット
 * 選考ステージの詳細情報表示を提供
 */
public class SelectionStageDetailServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // セッションの確認
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }
        
        String studentId = request.getParameter("studentId");
        String companyId = request.getParameter("companyId");
        
        System.out.println("SelectionStageDetailServlet - studentId: " + studentId);
        System.out.println("SelectionStageDetailServlet - companyId: " + companyId);
        
        if (studentId == null || companyId == null || studentId.trim().isEmpty() || companyId.trim().isEmpty()) {
            request.setAttribute("errorMessage", "学生IDまたは企業IDが正しく取得できませんでした。");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStageDetail.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        try {
            // 選考ステージ情報の取得
            SelectionStageDAO selectionStageDAO = new SelectionStageDAO();
            List<Object> selectionStages = selectionStageDAO.getSelectionStagesByCompanyAndStudent(companyId, studentId);
            
            if (selectionStages == null || selectionStages.isEmpty()) {
                request.setAttribute("errorMessage", "選考ステージが見つかりませんでした。");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStageDetail.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            Map<String, Object> selectionStage = (Map<String, Object>) selectionStages.get(0);
            
            // 企業情報の取得
            CompanyBean company = null;
            try {
                CompanyDAO companyDAO = new CompanyDAO();
                company = companyDAO.getCompanyBeanById(Integer.parseInt(companyId));
            } catch (Exception e) {
                System.out.println("企業情報の取得に失敗: " + e.getMessage());
            }
            
            // 学生情報の取得
            ExamineeBean student = null;
            try {
                StudentDAO studentDAO = new StudentDAO();
                student = studentDAO.getExamineeById(Integer.parseInt(studentId));
            } catch (Exception e) {
                System.out.println("学生情報の取得に失敗: " + e.getMessage());
            }
            
            // リクエストに属性を設定
            request.setAttribute("selectionStage", selectionStage);
            request.setAttribute("company", company);
            request.setAttribute("student", student);
            
            // 詳細画面にフォワード
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStageDetail.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            System.out.println("選考ステージ詳細取得エラー: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "選考ステージの詳細取得に失敗しました: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStageDetail.jsp");
            dispatcher.forward(request, response);
        }
    }
} 