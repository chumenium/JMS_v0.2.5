package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.SelectionStageDAO;
import utils.DBConnection;

public class SelectionStageEditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentId = request.getParameter("studentId");
        String companyId = request.getParameter("companyId");
        String selectionId = request.getParameter("selectionId");
        
        // デバッグ情報を出力
        System.out.println("=== 選考ステージ編集画面開始 ===");
        System.out.println("SelectionStageEditServlet - studentId: " + studentId);
        System.out.println("SelectionStageEditServlet - companyId: " + companyId);
        System.out.println("SelectionStageEditServlet - selectionId: " + selectionId);
        
        if (studentId == null || companyId == null) {
            System.out.println("SelectionStageEditServlet - パラメータが不足しています");
            response.sendRedirect(request.getContextPath() + "/SelectionStageViewServlet");
            return;
        }
        
        try {
            SelectionStageDAO selectionStageDAO = new SelectionStageDAO();
            
            // 選考ステージの基本情報を取得
            Map<String, Object> selectionStage = selectionStageDAO.getSelectionStageById(
                Integer.parseInt(studentId), 
                Integer.parseInt(companyId), 
                selectionId != null ? Integer.parseInt(selectionId) : 0
            );
            
            if (selectionStage == null) {
                request.setAttribute("errorMessage", "選考ステージが見つかりませんでした。");
                response.sendRedirect(request.getContextPath() + "/SelectionStageViewServlet");
                return;
            }
            
            // 選考ステージの詳細情報を取得
            List<Map<String, Object>> selectionStages = selectionStageDAO.getSelectionStageDetails(
                Integer.parseInt(studentId), 
                Integer.parseInt(companyId)
            );
            
            // 選考ステージタイプを取得
            List<Map<String, Object>> selectionTypes = selectionStageDAO.getAllSelectionTypes();
            
            request.setAttribute("selectionStage", selectionStage);
            request.setAttribute("selectionStages", selectionStages);
            request.setAttribute("selectionTypes", selectionTypes);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/SelectionStageEdit.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "選考ステージの取得に失敗しました。");
            response.sendRedirect(request.getContextPath() + "/SelectionStageViewServlet");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            deleteSelectionStage(request, response);
        } else {
            updateSelectionStage(request, response);
        }
    }
    
    private void updateSelectionStage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentId = request.getParameter("studentId");
        String companyId = request.getParameter("companyId");
        String status = request.getParameter("status");
        String[] stageTypes = request.getParameterValues("stages[].type");
        String[] stageDates = request.getParameterValues("stages[].date");
        String[] stageTimes = request.getParameterValues("stages[].time");
        String[] stageVenues = request.getParameterValues("stages[].venue");
        String[] stageRemarks = request.getParameterValues("stages[].remarks");
        
        System.out.println("SelectionStageEditServlet - 更新処理開始");
        System.out.println("SelectionStageEditServlet - studentId: " + studentId);
        System.out.println("SelectionStageEditServlet - companyId: " + companyId);
        System.out.println("SelectionStageEditServlet - status: " + status);
        
        if (studentId == null || companyId == null || status == null || 
            stageTypes == null || stageDates == null || stageTimes == null) {
            request.setAttribute("errorMessage", "必要な情報が不足しています。");
            doGet(request, response);
            return;
        }
        
        try {
            SelectionStageDAO selectionStageDAO = new SelectionStageDAO();
            
            // 選考ステータスを更新
            boolean statusUpdated = selectionStageDAO.updateJobActivityStatus(
                Integer.parseInt(studentId), 
                Integer.parseInt(companyId), 
                status
            );
            
            // 既存の選考ステージ詳細を削除
            selectionStageDAO.deleteSelectionStageDetails(
                Integer.parseInt(studentId), 
                Integer.parseInt(companyId)
            );
            
            // 新しい選考ステージ詳細を追加
            boolean detailsUpdated = true;
            for (int i = 0; i < stageTypes.length; i++) {
                if (stageTypes[i] != null && !stageTypes[i].trim().isEmpty()) {
                    boolean success = selectionStageDAO.addSelectionStageDetail(
                        Integer.parseInt(studentId),
                        Integer.parseInt(companyId),
                        stageTypes[i],
                        stageDates[i],
                        stageTimes[i],
                        stageVenues[i] != null ? stageVenues[i] : "",
                        stageRemarks[i] != null ? stageRemarks[i] : ""
                    );
                    if (!success) {
                        detailsUpdated = false;
                        break;
                    }
                }
            }
            
            if (statusUpdated && detailsUpdated) {
                request.setAttribute("successMessage", "選考ステージが正常に更新されました。");
            } else {
                request.setAttribute("errorMessage", "選考ステージの更新に失敗しました。");
            }
            
            // 更新後の情報を再取得して画面を表示
            doGet(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "選考ステージの更新中にエラーが発生しました。");
            doGet(request, response);
        }
    }
    
    private void deleteSelectionStage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentId = request.getParameter("studentId");
        String companyId = request.getParameter("companyId");
        
        if (studentId == null || companyId == null) {
            response.sendRedirect(request.getContextPath() + "/SelectionStageViewServlet");
            return;
        }
        
        try {
            SelectionStageDAO selectionStageDAO = new SelectionStageDAO();
            
            // 選考ステージ詳細を削除
            boolean detailsDeleted = selectionStageDAO.deleteSelectionStageDetails(
                Integer.parseInt(studentId), 
                Integer.parseInt(companyId)
            );
            
            // 選考ステージ基本情報を削除
            boolean stageDeleted = selectionStageDAO.deleteJobActivity(
                Integer.parseInt(studentId), 
                Integer.parseInt(companyId)
            );
            
            if (detailsDeleted && stageDeleted) {
                request.setAttribute("successMessage", "選考ステージが正常に削除されました。");
            } else {
                request.setAttribute("errorMessage", "選考ステージの削除に失敗しました。");
            }
            
            response.sendRedirect(request.getContextPath() + "/SelectionStageViewServlet");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "選考ステージの削除中にエラーが発生しました。");
            response.sendRedirect(request.getContextPath() + "/SelectionStageViewServlet");
        }
    }
} 