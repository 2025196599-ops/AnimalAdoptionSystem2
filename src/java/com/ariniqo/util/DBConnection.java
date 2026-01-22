package com.ariniqo.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Derby network URL
    private static final String URL  = "jdbc:derby://localhost:1527/AnimalAdoptionDB";
    private static final String USER = "app";
    private static final String PASS = "app";

    static {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Derby ClientDriver not found. Add derbyclient.jar to Libraries.", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
