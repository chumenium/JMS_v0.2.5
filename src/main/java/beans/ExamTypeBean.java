package beans;

public class ExamTypeBean {
    private int id;
    private String examTypeName;
    
    public ExamTypeBean() {}
    
    public ExamTypeBean(int id, String examTypeName) {
        this.id = id;
        this.examTypeName = examTypeName;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getExamTypeName() {
        return examTypeName;
    }
    
    public void setExamTypeName(String examTypeName) {
        this.examTypeName = examTypeName;
    }
} 