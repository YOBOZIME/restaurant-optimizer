package org.example.test;

import java.sql.*;

public class DatabaseTest {
    public static void main(String[] args) {
        System.out.println("=== Testing Database Connection ===");

        String url = "jdbc:postgresql://localhost:5432/restaurant_db";
        String user = "simpleuser";
        String password = "simplepassword";

        try {
            // 1. Test driver
            Class.forName("org.postgresql.Driver");
            System.out.println("✅ PostgreSQL Driver loaded");

            // 2. Test connection
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("✅ Database connection successful!");

            // 3. Test schema exists
            DatabaseMetaData meta = conn.getMetaData();
            ResultSet tables = meta.getTables(null, "restaurant", "ingredient", null);
            if (tables.next()) {
                System.out.println("✅ Table 'restaurant.ingredient' exists");
            } else {
                System.out.println("❌ Table 'restaurant.ingredient' NOT found");
            }

            // 4. Test data exists
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM restaurant.ingredient");
            if (rs.next()) {
                int count = rs.getInt("count");
                System.out.println("✅ Found " + count + " ingredients in database");

                // Show sample data
                ResultSet data = stmt.executeQuery("SELECT id, name, unit FROM restaurant.ingredient LIMIT 3");
                System.out.println("Sample data:");
                while (data.next()) {
                    System.out.println("  - " + data.getInt("id") + ": " +
                            data.getString("name") + " (" + data.getString("unit") + ")");
                }
            }

            // 5. Test JPA entity mapping
            System.out.println("\n=== Testing JPA Configuration ===");
            ResultSet columns = meta.getColumns(null, "restaurant", "ingredient", null);
            System.out.println("Table columns:");
            while (columns.next()) {
                System.out.println("  - " + columns.getString("COLUMN_NAME") +
                        " (" + columns.getString("TYPE_NAME") + ")");
            }

            conn.close();
            System.out.println("\n✅ All database tests passed!");

        } catch (ClassNotFoundException e) {
            System.out.println("❌ PostgreSQL Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("❌ Database error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}