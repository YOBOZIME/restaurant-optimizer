package org.example.config;

import jakarta.enterprise.context.ApplicationScoped;
import java.util.ResourceBundle;

@ApplicationScoped
public class AppConfig {

    private static final ResourceBundle bundle =
            ResourceBundle.getBundle("application");

    public String getProperty(String key) {
        return bundle.getString(key);
    }

    public int getExpirationWarningDays() {
        return Integer.parseInt(getProperty("expiration.warning.days"));
    }

    public double getMaxFoodCostPercentage() {
        return Double.parseDouble(getProperty("menu.max.foodcost.percentage"));
    }
}