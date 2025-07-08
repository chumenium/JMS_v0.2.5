package beans;

import java.io.Serializable;

public class StudentBeans implements Serializable {
    private String id; // 学生ID
    private String className; // クラス
    private String number; // 出席番号
    private String name; // 氏名
    private String nameKana; // カナ
    private String gender; // 性別
    private String email; // メールアドレス
    private String tel; // 電話番号
    private String enrollmentStatus; // 在籍状況
    private String assistanceStatus; // 斡旋状況
    private String jobHuntingStatus; // 就活状況
    private String desiredJobType1; // 希望職種1
    private String desiredJobType2; // 希望職種2
    private String desiredJobType3; // 希望職種3
    private String desiredWorkPlace; // 希望勤務地
    private String graduationYear; // 卒業年
    private String remarks; // 備考

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }

    public String getNumber() { return number; }
    public void setNumber(String number) { this.number = number; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getNameKana() { return nameKana; }
    public void setNameKana(String nameKana) { this.nameKana = nameKana; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTel() { return tel; }
    public void setTel(String tel) { this.tel = tel; }

    public String getEnrollmentStatus() { return enrollmentStatus; }
    public void setEnrollmentStatus(String enrollmentStatus) { this.enrollmentStatus = enrollmentStatus; }

    public String getAssistanceStatus() { return assistanceStatus; }
    public void setAssistanceStatus(String assistanceStatus) { this.assistanceStatus = assistanceStatus; }

    public String getJobHuntingStatus() { return jobHuntingStatus; }
    public void setJobHuntingStatus(String jobHuntingStatus) { this.jobHuntingStatus = jobHuntingStatus; }

    public String getDesiredJobType1() { return desiredJobType1; }
    public void setDesiredJobType1(String desiredJobType1) { this.desiredJobType1 = desiredJobType1; }

    public String getDesiredJobType2() { return desiredJobType2; }
    public void setDesiredJobType2(String desiredJobType2) { this.desiredJobType2 = desiredJobType2; }

    public String getDesiredJobType3() { return desiredJobType3; }
    public void setDesiredJobType3(String desiredJobType3) { this.desiredJobType3 = desiredJobType3; }

    public String getDesiredWorkPlace() { return desiredWorkPlace; }
    public void setDesiredWorkPlace(String desiredWorkPlace) { this.desiredWorkPlace = desiredWorkPlace; }

    public String getGraduationYear() { return graduationYear; }
    public void setGraduationYear(String graduationYear) { this.graduationYear = graduationYear; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }
} 