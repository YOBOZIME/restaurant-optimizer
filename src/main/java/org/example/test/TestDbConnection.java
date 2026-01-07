package org.example.test;

import java.sql.Connection;
import java.sql.DriverManager;

public class TestDbConnection {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://localhost:5432/restaurant_db";
        String user = "restaurant_user";
        String password = "restaurant_pass";

        System.out.println("Testing connection...");
        System.out.println("URL: " + url);
        System.out.println("User: " + user);
        System.out.println("Password: " + password);

        try {
            Class.forName("org.postgresql.Driver");
            System.out.println("Driver loaded successfully");

            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("✅ Connection successful!");

            var stmt = conn.createStatement();
            var rs = stmt.executeQuery("SELECT * FROM restaurant.ingredient");
            int count = 0;
            while (rs.next()) {
                count++;
                System.out.println("Row " + count + ": " + rs.getString("name"));
            }
            System.out.println("Found " + count + " ingredients");

            conn.close();
        } catch (Exception e) {
            System.out.println("❌ Connection failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}