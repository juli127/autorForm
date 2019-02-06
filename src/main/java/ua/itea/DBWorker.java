package ua.itea;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.Properties;

public class DBWorker {

    private final static String GET_USER_BY_LOGIN_PASS = "SELECT * FROM users WHERE login = ? AND  password = ?";
    private final static String GET_ALL_USERS = "SELECT * FROM users;";
    private final static String GET_RECORD_BY_LOGIN = "SELECT * FROM users WHERE login = ?";
    private final static String GET_USER_COUNT_BY_LOGIN = "SELECT COUNT(*) FROM users WHERE login = ?";
    private final static String INSERT_USER = "INSERT INTO users (login, password, name, age, gender, address, comment, agree) VALUES (?,?,?,?,?,?,?,?);";
    private final static String tableTitle =
            "<br><center><table border='1'><tr><td>login</td><td>name</td><td>age</td><td>gender</td><td>address</td><td>comment</td><td>agree</td></tr>";
    private Connection conn;
    StringBuilder log = new StringBuilder();

    public DBWorker() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        log.append("<br>DBWorker: Driver loaded.   ");
        System.out.println("DBWorker: Driver loaded");

        /// properties ////////////////////////////////
//        String connStr = "jdbc:mysql://localhost/itea?user=root&password=";
//        String connStr = "jdbc:mysql://172.17.18.45/test?user=guest&password=";
        String host = "";
        String db = "";
        String usr = "";
        String psw = "";
        Path FIRST_PROP_FILE_PATH = Paths.get(".", "/src/main/resources/config.properties").toAbsolutePath().normalize();

        //get properties for connection ////////////////////
        try {
            Properties properties = new Properties();
            try {
                String configPath = FIRST_PROP_FILE_PATH.toString();
                log.append("<br>DBWorker: configPath: " + configPath);
                System.out.println("DBWorker: configPath: " + configPath);
                properties.load(new FileInputStream(FIRST_PROP_FILE_PATH.toString()));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            Path REAL_PROP_FILE_PATH = Paths.get(".", "/src/main/resources/" + properties.getProperty("configName")).toAbsolutePath().normalize();
            log.append("<br>DBWorker: what config will be loaded: " + REAL_PROP_FILE_PATH.toString());
            System.out.println("DBWorker: what config will be loaded: " + REAL_PROP_FILE_PATH.toString());
            properties = new Properties();
            try {
                properties.load(new FileInputStream(REAL_PROP_FILE_PATH.toString()));
                host = properties.getProperty("host");
                db = properties.getProperty("db");
                usr = properties.getProperty("user");
                psw = properties.getProperty("psw");
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        String connStr = new StringBuilder("jdbc:mysql://").append(host)
                .append("/").append(db).append("?").append("user=").append(usr)
                .append("&").append("password=").append(psw).toString();

        log.append("<br>DBWorker: connString: " + connStr);
        System.out.println("DBWorker: connString: " + connStr);
        ///////////////end properties///////////////////////////////

        System.out.println("DBWorker: try to connect.....");
        try {
            conn = DriverManager.getConnection(connStr);
            System.out.println("DBWorker: Connection obtained");
            log.append("<br>DBWorker: Connection obtained  <br>");
        } catch (Exception ex) {
            System.out.println("failed to get connection...");
            System.out.println("SQLException: " + ex.getMessage());
        }
    }

    public String getLog() {
        return log.toString();
    }

    static String hashString(String hash) {
        MessageDigest md5 = null;
        try {
            md5 = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        md5.update(StandardCharsets.UTF_8.encode(hash));
        return String.format("%032x", new BigInteger(md5.digest()));
    }

    public String getAllUsers() {
        StringBuilder sb = new StringBuilder();
        sb.append(tableTitle);
        try (Statement statement = conn.createStatement();
             ResultSet rs = statement.executeQuery(GET_ALL_USERS)) {
            while (rs.next()) {
                sb.append("<tr><td>" + rs.getString(2) +
                        "</td><td>" + rs.getString(4) +
                        "</td><td>" + rs.getString(5) +
                        "</td><td>" + rs.getString(6) +
                        "</td><td>" + rs.getString(7) +
                        "</td><td>" + rs.getString(8) +
                        "</td><td>" + rs.getString(9) +
                        "</td></tr>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        sb.append("</table>");
        return sb.toString();
    }

    public int addUser(String login, String pass,
                       String name, String age, String gender,
                       String address, String comment, String agree) {
        int insertedCount = 0;
        try (PreparedStatement statement = conn.prepareStatement(INSERT_USER)){
            statement.setString(1, login);
            statement.setString(2, hashString(pass));
            statement.setString(3, name);
            statement.setInt(4, Integer.parseInt(age));
            statement.setString(5, gender);
            statement.setString(6, address);
            statement.setString(7, comment);
            statement.setString(8, agree);
            insertedCount = statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("Inserted records:"  + insertedCount);
        return insertedCount;
    }

    public boolean userExists(String login){
        boolean present = false;
        try (PreparedStatement statement = conn.prepareStatement(GET_USER_COUNT_BY_LOGIN)){
            statement.setString(1, login);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                present = (Integer.parseInt(rs.getString(1)) > 0);
            }
            closeResultSet(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        //log.append("userExists: return = " + present + "<br>");
        return present;
    }

    public boolean correctPass(String login, String pass) {
        boolean correct = false;
        try (PreparedStatement statement = conn.prepareStatement(GET_RECORD_BY_LOGIN)){
            statement.setString(1, login);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                correct = rs.getString("password").equals(hashString(pass));
            }
            closeResultSet(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return correct;
    }

    public String getName(String login, String pass) {
        String name = null;
        try (PreparedStatement statement = conn.prepareStatement(GET_USER_BY_LOGIN_PASS)){
            statement.setString(1, login);
            statement.setString(2, hashString(pass));
            ResultSet rs = statement.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
            }
            closeResultSet(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return name;
    }

    public void close() {
        try {
            if (conn != null)
                conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("connection was closed.....");
    }

    private void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException ex) {}
        }
    }
}
