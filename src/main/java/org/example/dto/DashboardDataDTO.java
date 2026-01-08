package org.example.dto;

import java.util.List;
import java.util.Map;

public class DashboardDataDTO {
    private Map<String, Integer> ingredientsByCategory;
    private List<RestaurantAlertDTO> restaurantStockLevels;
    private Map<String, Integer> expirationTimeline;
    private List<StockAlertDTO> criticalAlerts;
    private List<StockAlertDTO> warningAlerts;
    private List<StockAlertDTO> infoAlerts;
    private PerformanceStatsDTO performanceStats;

    // Getters and setters
    public Map<String, Integer> getIngredientsByCategory() { return ingredientsByCategory; }
    public void setIngredientsByCategory(Map<String, Integer> ingredientsByCategory) { this.ingredientsByCategory = ingredientsByCategory; }

    public List<RestaurantAlertDTO> getRestaurantStockLevels() { return restaurantStockLevels; }
    public void setRestaurantStockLevels(List<RestaurantAlertDTO> restaurantStockLevels) { this.restaurantStockLevels = restaurantStockLevels; }

    public Map<String, Integer> getExpirationTimeline() { return expirationTimeline; }
    public void setExpirationTimeline(Map<String, Integer> expirationTimeline) { this.expirationTimeline = expirationTimeline; }

    public List<StockAlertDTO> getCriticalAlerts() { return criticalAlerts; }
    public void setCriticalAlerts(List<StockAlertDTO> criticalAlerts) { this.criticalAlerts = criticalAlerts; }

    public List<StockAlertDTO> getWarningAlerts() { return warningAlerts; }
    public void setWarningAlerts(List<StockAlertDTO> warningAlerts) { this.warningAlerts = warningAlerts; }

    public List<StockAlertDTO> getInfoAlerts() { return infoAlerts; }
    public void setInfoAlerts(List<StockAlertDTO> infoAlerts) { this.infoAlerts = infoAlerts; }

    public PerformanceStatsDTO getPerformanceStats() { return performanceStats; }
    public void setPerformanceStats(PerformanceStatsDTO performanceStats) { this.performanceStats = performanceStats; }
}

