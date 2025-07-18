package beans;

import java.io.Serializable;
import java.util.List;

public class CompanyBean implements Serializable {
    private int companyId;
    private String companyName;
    private String postCode;
    private String address;
    private String tel;
    private String mailAddress;
    private String managerName;
    private boolean recruitmentResults;
    private List<String> occupations; // 職種リスト
    private List<String> workPlaces; // 勤務地リスト

    // デフォルトコンストラクタ
    public CompanyBean() {}
    
    // 全フィールドのコンストラクタ
    public CompanyBean(int companyId, String companyName, String postCode, String address, 
                      String tel, String mailAddress, String managerName, boolean recruitmentResults,
                      List<String> occupations, List<String> workPlaces) {
        this.companyId = companyId;
        this.companyName = companyName;
        this.postCode = postCode;
        this.address = address;
        this.tel = tel;
        this.mailAddress = mailAddress;
        this.managerName = managerName;
        this.recruitmentResults = recruitmentResults;
        this.occupations = occupations;
        this.workPlaces = workPlaces;
    }
    
    // Getter・Setterメソッド
    public int getCompanyId() {
        return companyId;
    }
    
    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }
    
    public String getCompanyName() {
        return companyName;
    }
    
    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
    
    public String getPostCode() {
        return postCode;
    }
    
    public void setPostCode(String postCode) {
        this.postCode = postCode;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getTel() {
        return tel;
    }
    
    public void setTel(String tel) {
        this.tel = tel;
    }
    
    public String getMailAddress() {
        return mailAddress;
    }
    
    public void setMailAddress(String mailAddress) {
        this.mailAddress = mailAddress;
    }
    
    public String getManagerName() {
        return managerName;
    }
    
    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }
    
    public boolean getRecruitmentResults() {
        return recruitmentResults;
    }
    
    public void setRecruitmentResults(boolean recruitmentResults) {
        this.recruitmentResults = recruitmentResults;
    }
    
    public List<String> getOccupations() {
        return occupations;
    }
    
    public void setOccupations(List<String> occupations) {
        this.occupations = occupations;
    }
    
    public List<String> getWorkPlaces() {
        return workPlaces;
    }
    
    public void setWorkPlaces(List<String> workPlaces) {
        this.workPlaces = workPlaces;
    }
    

    
    @Override
    public String toString() {
        return "CompanyBean{" +
                "companyId=" + companyId +
                ", companyName='" + companyName + '\'' +
                ", postCode='" + postCode + '\'' +
                ", address='" + address + '\'' +
                ", tel='" + tel + '\'' +
                ", mailAddress='" + mailAddress + '\'' +
                ", managerName='" + managerName + '\'' +
                ", recruitmentResults=" + recruitmentResults +
                ", occupations=" + occupations +
                ", workPlaces=" + workPlaces +
                '}';
    }
} 