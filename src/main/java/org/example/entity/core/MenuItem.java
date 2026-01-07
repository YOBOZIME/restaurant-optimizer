package org.example.entity.core;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "menu_items")
public class MenuItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String description;
    private String category;

    @Column(precision = 10, scale = 2, nullable = false)
    private BigDecimal sellingPrice;

    @ManyToOne
    @JoinColumn(name = "restaurant_id")
    private Restaurant restaurant;

    @OneToMany(mappedBy = "menuItem", cascade = CascadeType.ALL, fetch = FetchType.EAGER, orphanRemoval = true)
    private List<RecipeItem> recipeItems = new ArrayList<>();

    private Integer popularityScore = 50;
    private Integer preparationTime;

    @Transient private Double foodCost;
    @Transient private Double profitMargin;
    @Transient private Double foodCostPercentage;

    public MenuItem() {}

    public void calculateCosts() {
        this.foodCost = recipeItems.stream().mapToDouble(RecipeItem::getCost).sum();
        if (sellingPrice != null && sellingPrice.doubleValue() > 0) {
            this.foodCostPercentage = (this.foodCost / sellingPrice.doubleValue()) * 100;
            this.profitMargin = sellingPrice.doubleValue() - this.foodCost;
        }
    }

    public void addIngredient(Ingredient ingredient, Double quantity, String unit) {
        RecipeItem recipeItem = new RecipeItem(this, ingredient, quantity, unit);
        recipeItems.add(recipeItem);
        calculateCosts();
    }

    // === GETTERS AND SETTERS (Fixes the Service Errors) ===
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public BigDecimal getSellingPrice() { return sellingPrice; }
    public void setSellingPrice(BigDecimal sellingPrice) { this.sellingPrice = sellingPrice; calculateCosts(); }

    public Restaurant getRestaurant() { return restaurant; }
    public void setRestaurant(Restaurant restaurant) { this.restaurant = restaurant; }

    public List<RecipeItem> getRecipeItems() { return recipeItems; }
    public void setRecipeItems(List<RecipeItem> recipeItems) { this.recipeItems = recipeItems; calculateCosts(); }

    public Integer getPopularityScore() { return popularityScore; }
    public void setPopularityScore(Integer popularityScore) { this.popularityScore = popularityScore; }

    public Integer getPreparationTime() { return preparationTime; }
    public void setPreparationTime(Integer preparationTime) { this.preparationTime = preparationTime; }

    public Double getFoodCost() { calculateCosts(); return foodCost; }
    public Double getProfitMargin() { calculateCosts(); return profitMargin; }
    public Double getFoodCostPercentage() { calculateCosts(); return foodCostPercentage; }
}