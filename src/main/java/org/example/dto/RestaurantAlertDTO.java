// RestaurantAlertDTO.java
package org.example.dto;

public class RestaurantAlertDTO {
    private String name;
    private int criticalCount;
    private int warningCount;
    private String alertLevel;

    // Getters and setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getCriticalCount() { return criticalCount; }
    public void setCriticalCount(int criticalCount) { this.criticalCount = criticalCount; }

    public int getWarningCount() { return warningCount; }
    public void setWarningCount(int warningCount) { this.warningCount = warningCount; }

    public String getAlertLevel() { return alertLevel; }
    public void setAlertLevel(String alertLevel) { this.alertLevel = alertLevel; }
}



