package org.example.test;

import java.sql.*;

public class TestConnection {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://localhost:5432/restaurant_db";
        String user = "simpleuser";
        String password = "simplepassword";

        System.out.println("Testing JDBC connection...");
        System.out.println("URL: " + url);
        System.out.println("User: " + user);

        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("Driver loaded");

            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("✅ JDBC Connection SUCCESS!");

            // Test query
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM restaurant.ingredient");
            if (rs.next()) {
                System.out.println("Found " + rs.getInt(1) + " ingredients in database");
            }

            conn.close();
        } catch (Exception e) {
            System.out.println("❌ JDBC Connection FAILED: " + e.getMessage());
            e.printStackTrace();
        }
    }
}