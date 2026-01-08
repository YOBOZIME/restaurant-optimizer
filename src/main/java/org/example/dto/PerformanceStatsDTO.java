// PerformanceStatsDTO.java
package org.example.dto;

public class PerformanceStatsDTO {
    private int avgStockAgeDays;
    private double stockTurnoverRate;
    private int alertResponseTime;
    private int efficiencyScore;

    // Getters and setters
    public int getAvgStockAgeDays() { return avgStockAgeDays; }
    public void setAvgStockAgeDays(int avgStockAgeDays) { this.avgStockAgeDays = avgStockAgeDays; }

    public double getStockTurnoverRate() { return stockTurnoverRate; }
    public void setStockTurnoverRate(double stockTurnoverRate) { this.stockTurnoverRate = stockTurnoverRate; }

    public int getAlertResponseTime() { return alertResponseTime; }
    public void setAlertResponseTime(int alertResponseTime) { this.alertResponseTime = alertResponseTime; }

    public int getEfficiencyScore() { return efficiencyScore; }
    public void setEfficiencyScore(int efficiencyScore) { this.efficiencyScore = efficiencyScore; }
}