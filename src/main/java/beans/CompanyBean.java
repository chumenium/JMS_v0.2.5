package beans;

public class CompanyBean {
    private int companyId;
    private String companyName;
    private String postCode;
    private String address;
    private String tel;
    private String mailAddress;
    private String managerName;
    private boolean recruitmentResults;
    private int workPlaceId;
    private int occupationId;
    
    // デフォルトコンストラクタ
    public CompanyBean() {}
    
    // 全フィールドのコンストラクタ
    public CompanyBean(int companyId, String companyName, String postCode, String address, 
                      String tel, String mailAddress, String managerName, boolean recruitmentResults,
                      int workPlaceId, int occupationId) {
        this.companyId = companyId;
        this.companyName = companyName;
        this.postCode = postCode;
        this.address = address;
        this.tel = tel;
        this.mailAddress = mailAddress;
        this.managerName = managerName;
        this.recruitmentResults = recruitmentResults;
        this.workPlaceId = workPlaceId;
        this.occupationId = occupationId;
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
    
    public int getWorkPlaceId() {
        return workPlaceId;
    }
    
    public void setWorkPlaceId(int workPlaceId) {
        this.workPlaceId = workPlaceId;
    }
    
    public int getOccupationId() {
        return occupationId;
    }
    
    public void setOccupationId(int occupationId) {
        this.occupationId = occupationId;
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
                ", workPlaceId=" + workPlaceId +
                ", occupationId=" + occupationId +
                '}';
    }
} 