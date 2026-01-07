package org.example.test;

import java.sql.*;

public class TestJdbcConnection {
    public static void main(String[] args) {
        System.out.println("=== TEST JDBC CONNECTION ===");

        // ESSAYEZ CES COMBINAISONS
        String[][] credentials = {
                {"jdbc:postgresql://localhost:5432/restaurant_db", "postgres", "postgres"},
                {"jdbc:postgresql://localhost:5432/postgres", "postgres", "postgres"},
                {"jdbc:postgresql://localhost:5432/restaurant_db", "simpleuser", "simplepassword"}
        };

        for (String[] cred : credentials) {
            String url = cred[0];
            String user = cred[1];
            String password = cred[2];

            System.out.println("\nTesting: " + url);
            System.out.println("User: " + user);

            try {
                Connection conn = DriverManager.getConnection(url, user, password);
                System.out.println("✅ SUCCESS!");

                // Test query
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT current_database(), current_user");
                if (rs.next()) {
                    System.out.println("Database: " + rs.getString(1));
                    System.out.println("User: " + rs.getString(2));
                }

                // Test our table
                try {
                    ResultSet data = stmt.executeQuery("SELECT COUNT(*) FROM restaurant.ingredient");
                    if (data.next()) {
                        System.out.println("Ingredients: " + data.getInt(1));
                    }
                } catch (Exception e) {
                    System.out.println("Table test: " + e.getMessage());
                }

                conn.close();
                break; // Stop at first success

            } catch (SQLException e) {
                System.out.println("❌ FAILED: " + e.getMessage());
            }
        }
    }
}