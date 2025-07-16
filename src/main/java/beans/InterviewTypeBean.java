package beans;

public class InterviewTypeBean {
    private int id;
    private String interviewTypeName;
    
    public InterviewTypeBean() {}
    
    public InterviewTypeBean(int id, String interviewTypeName) {
        this.id = id;
        this.interviewTypeName = interviewTypeName;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getInterviewTypeName() {
        return interviewTypeName;
    }
    
    public void setInterviewTypeName(String interviewTypeName) {
        this.interviewTypeName = interviewTypeName;
    }
} 