package ua.itea;

import java.sql.*;

public class DBWorker {

	private final static String GET_USERS = "SELECT * FROM users";
	private Connection conn;
	private Statement statement;
	private String result;

	public DBWorker() {
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			System.out.println("Driver loaded ");
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		System.out.println("try to connect.....");
		try {
			conn = DriverManager.getConnection("jdbc:mysql://localhost/itea?" + "user=root&password=");
			System.out.println("Connection obtained. ");
			statement = conn.createStatement();
		} catch (Exception ex) {
			System.out.println("failed...");
			System.out.println("SQLException: " + ex.getMessage());
		}
	}


	public String getRows() {
		StringBuilder sb = new StringBuilder();
		sb.append("<table border='1'>");
		try {
			System.out.println("statement == null ? " + (statement == null));
			ResultSet rs = statement.executeQuery(GET_USERS);
			while (rs.next()) {
				sb.append("<tr><td>" + rs.getString(1) + "</td><td>" + rs.getString(2) + "</td><td>" + rs.getString(3)
						+ "</td></tr>");
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		sb.append("</table>");
		result = sb.toString();
		System.out.println("GOT after executeQuery:   " + result);
		return result;
	}

	public void close() {
		try {
			if (conn != null)
				conn.close();
			if (statement != null)
				statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		System.out.println("connection was closed.....");
	}
}
