package org.example.entity.core;

import jakarta.persistence.*;
import java.util.List;
import org.example.entity.inventory.RestaurantStock;
import jakarta.validation.constraints.*;

@Entity
@Table(name = "ingredients")
public class Ingredient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Name is required")
    @Size(min = 2, max = 100, message = "Name must be between 2 and 100 characters")
    @Column(nullable = false, unique = true)
    private String name;

    @NotBlank(message = "Unit is required")
    private String unit;

    @PositiveOrZero(message = "Price must be positive or zero")
    private Double currentPrice;

    @Min(value = 1, message = "Shelf life must be at least 1 day")
    private Integer shelfLifeDays;

    private String category; // Viande, Légumes, etc.

    @OneToMany(mappedBy = "ingredient", cascade = CascadeType.ALL)
    private List<RestaurantStock> stockPerRestaurant;

    public Ingredient() {}

    public Ingredient(String name, String unit, Double currentPrice, Integer shelfLifeDays, String category) {
        this.name = name;
        this.unit = unit;
        this.currentPrice = currentPrice;
        this.shelfLifeDays = shelfLifeDays;
        this.category = category;
    }

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