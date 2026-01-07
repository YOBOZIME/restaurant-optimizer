package org.example.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.util.Date;

public class StockCreateDTO {

    @NotNull(message = "Restaurant ID is required")
    private Long restaurantId;

    @NotNull(message = "Ingredient ID is required")
    private Long ingredientId;

    @NotNull(message = "Quantity is required")
    @Positive(message = "Quantity must be positive")
    private Double quantity;

    private Date expirationDate;
    private String batchNumber;

    // Getters and Setters
    public Long getRestaurantId() { return restaurantId; }
    public void setRestaurantId(Long restaurantId) { this.restaurantId = restaurantId; }

    public Long getIngredientId() { return ingredientId; }
    public void setIngredientId(Long ingredientId) { this.ingredientId = ingredientId; }

    public Double getQuantity() { return quantity; }
    public void setQuantity(Double quantity) { this.quantity = quantity; }

    public Date getExpirationDate() { return expirationDate; }
    public void setExpirationDate(Date expirationDate) { this.expirationDate = expirationDate; }

    public String getBatchNumber() { return batchNumber; }
    public void setBatchNumber(String batchNumber) { this.batchNumber = batchNumber; }
}