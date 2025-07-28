package beans;

import java.io.Serializable;

public class ExamineeBean implements Serializable {
    private int studentID;
    private String studentName;
    private String className;
    private String companyName;
    private String selection;
    private String data;

    // デフォルトコンストラクタ
    public ExamineeBean() {}
    
    // 全フィールドのコンストラクタ
    public ExamineeBean(int studentID, String studentName, String className, String companyName, 
                      String selection, String data) {
        this.studentID = studentID;
        this.studentName = studentName;
        this.className = className;
        this.companyName = companyName;
        this.selection = selection;
        this.data = data;
    }
    
    // Getter・Setterメソッド
    public int getStudentId() {
        return studentID;
    }
    
    public void setStudentId(int studentID) {
        this.studentID = studentID;
    }

    public String getStudentName() {
        return studentName;
    }
    
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getClassName() {
        return className;
    }
    
    public void setClassName(String className) {
        this.className = className;
    }

    public String getCompanyName() {
        return companyName;
    }
    
    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getSelection() {
        return selection;
    }
    
    public void setSelection(String selection) {
        this.selection = selection;
    }

    public String getData() {
        return data;
    }
    
    public void setData(String data) {
        this.data = data;
    }
}