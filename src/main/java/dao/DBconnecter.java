package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

//PCが変わるたび変更をすること
public class DBconnecter {
    private static final String URL = "jdbc:mysql://localhost:3306/jms";
    private static final String USER = "root";
    private static final String PASSWORD = "kcsf";

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}