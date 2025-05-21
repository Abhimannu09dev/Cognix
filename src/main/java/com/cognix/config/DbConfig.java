package com.cognix.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConfig {
	private static final String URL = "jdbc:mysql://localhost:3307/CogniX";
  private static final String USERNAME = "root";
  private static final String PASSWORD = "";

  static {
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
    } catch (ClassNotFoundException e) {
      // fatal — no JDBC driver on classpath
      throw new ExceptionInInitializerError(e);
    }
  }

  /** Now only throws SQLException. */
  public static Connection getDbConnection() throws SQLException {
    return DriverManager.getConnection(URL, USERNAME, PASSWORD);
  }
}
