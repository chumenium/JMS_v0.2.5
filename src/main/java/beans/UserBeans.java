package beans;

import java.io.Serializable;

public class UserBeans implements Serializable {
	
	private String id,pass,point;
	
	public UserBeans(String id,String pass,String point) {
		
		setId(id);
		setPass(pass);
		setPoint(point);
		
		}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPass() {
		return pass;
	}

	public void setPass(String pass) {
		this.pass = pass;
	}
	
	public String getPoint() {
		return point;
	}
	
	public void setPoint(String point) {
		 this.point = point;
	}
	

}
