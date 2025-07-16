package beans;

import java.sql.Timestamp;

public class InterviewExamContentBean {
    private int id;
    private int companysId;
    private String contentType;
    private int contentNumber;
    private Integer examTypeId;    // 外部キーID
    private String examType;       // 表示用の種別名
    private String examSubject;
    private String examContent;
    private Integer interviewTypeId; // 外部キーID
    private String interviewType;    // 表示用の種別名
    private String interviewQuestions;
    private String interviewNotes;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public InterviewExamContentBean() {}
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getCompanysId() {
        return companysId;
    }
    
    public void setCompanysId(int companysId) {
        this.companysId = companysId;
    }
    
    public String getContentType() {
        return contentType;
    }
    
    public void setContentType(String contentType) {
        this.contentType = contentType;
    }
    
    public int getContentNumber() {
        return contentNumber;
    }
    
    public void setContentNumber(int contentNumber) {
        this.contentNumber = contentNumber;
    }
    
    public Integer getExamTypeId() {
        return examTypeId;
    }
    
    public void setExamTypeId(Integer examTypeId) {
        this.examTypeId = examTypeId;
    }
    
    public String getExamType() {
        return examType;
    }
    
    public void setExamType(String examType) {
        this.examType = examType;
    }
    
    public String getExamSubject() {
        return examSubject;
    }
    
    public void setExamSubject(String examSubject) {
        this.examSubject = examSubject;
    }
    
    public String getExamContent() {
        return examContent;
    }
    
    public void setExamContent(String examContent) {
        this.examContent = examContent;
    }
    
    public Integer getInterviewTypeId() {
        return interviewTypeId;
    }
    
    public void setInterviewTypeId(Integer interviewTypeId) {
        this.interviewTypeId = interviewTypeId;
    }
    
    public String getInterviewType() {
        return interviewType;
    }
    
    public void setInterviewType(String interviewType) {
        this.interviewType = interviewType;
    }
    
    public String getInterviewQuestions() {
        return interviewQuestions;
    }
    
    public void setInterviewQuestions(String interviewQuestions) {
        this.interviewQuestions = interviewQuestions;
    }
    
    public String getInterviewNotes() {
        return interviewNotes;
    }
    
    public void setInterviewNotes(String interviewNotes) {
        this.interviewNotes = interviewNotes;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
} 