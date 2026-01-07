package org.example.entity.core;

import jakarta.persistence.*;

@Entity
@Table(name = "recipe_items")
public class RecipeItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "menu_item_id", nullable = false)
    private MenuItem menuItem;

    @ManyToOne
    @JoinColumn(name = "ingredient_id", nullable = false)
    private Ingredient ingredient;

    private Double quantity;
    private String unit;

    public RecipeItem() {}

    public RecipeItem(MenuItem menuItem, Ingredient ingredient, Double quantity, String unit) {
        this.menuItem = menuItem;
        this.ingredient = ingredient;
        this.quantity = quantity;
        this.unit = unit;
    }

    public Double getCost() {
        if (ingredient != null && ingredient.getCurrentPrice() != null) {
            return ingredient.getCurrentPrice() * quantity;
        }
        return 0.0;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Ingredient getIngredient() { return ingredient; }
    public void setIngredient(Ingredient ingredient) { this.ingredient = ingredient; }
    public Double getQuantity() { return quantity; }
    public void setQuantity(Double quantity) { this.quantity = quantity; }
    public MenuItem getMenuItem() { return menuItem; }
    public void setMenuItem(MenuItem menuItem) { this.menuItem = menuItem; }
}