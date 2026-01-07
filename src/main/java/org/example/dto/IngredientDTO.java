package org.example.dto;

import jakarta.validation.constraints.*;

public class IngredientDTO {

    private Long id;

    @NotBlank(message = "Name is required")
    @Size(min = 2, max = 100, message = "Name must be between 2 and 100 characters")
    private String name;

    @NotBlank(message = "Unit is required")
    private String unit;

    @PositiveOrZero(message = "Price must be positive or zero")
    private Double currentPrice;

    @Min(value = 1, message = "Shelf life must be at least 1 day")
    private Integer shelfLifeDays;

    private String category;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public Double getCurrentPrice() { return currentPrice; }
    public void setCurrentPrice(Double currentPrice) { this.currentPrice = currentPrice; }
    public Integer getShelfLifeDays() { return shelfLifeDays; }
    public void setShelfLifeDays(Integer shelfLifeDays) { this.shelfLifeDays = shelfLifeDays; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
}