package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


//PCが変わるたび変更をすること
public class DBConnection {
  private static final String URL = "jdbc:mysql://35.200.16.205:3306/jms";
  private static final String USER = "root";
  private static final String PASSWORD = "";

  public static Connection getConnection() throws SQLException, ClassNotFoundException {
      Class.forName("com.mysql.cj.jdbc.Driver");
      return DriverManager.getConnection(URL, USER, PASSWORD);
  }
}