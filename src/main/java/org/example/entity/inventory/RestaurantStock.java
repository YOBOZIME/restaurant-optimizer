package org.example.entity.inventory;

import jakarta.persistence.*;
import org.example.entity.core.Ingredient;
import org.example.entity.core.Restaurant;
import java.util.Date;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

@Entity
@Table(name = "restaurant_stock")
public class RestaurantStock {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // FIXED: Remove duplicate declarations, add annotations to existing fields
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "restaurant_id", nullable = false)
    private Restaurant restaurant;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ingredient_id", nullable = false)
    private Ingredient ingredient;

    @NotNull(message = "La quantité est obligatoire")
    @PositiveOrZero(message = "La quantité ne peut pas être négative")
    @Column(nullable = false)
    private Double quantity;

    @Temporal(TemporalType.DATE)
    private Date expirationDate;

    private String batchNumber;



    // Add constructors
    public RestaurantStock() {}

    public RestaurantStock(Restaurant restaurant, Ingredient ingredient, Double quantity, Date expirationDate) {
        this.restaurant = restaurant;
        this.ingredient = ingredient;
        this.quantity = quantity;
        this.expirationDate = expirationDate;
    }

    // Alternative constructor with batch number
    public RestaurantStock(Restaurant restaurant, Ingredient ingredient, Double quantity,
                           Date expirationDate, String batchNumber) {
        this.restaurant = restaurant;
        this.ingredient = ingredient;
        this.quantity = quantity;
        this.expirationDate = expirationDate;
        this.batchNumber = batchNumber;
    }

    //getter nd setters
    public Long getId() {
        return id;
    }

    public Restaurant getRestaurant() {
        return restaurant;
    }

    public Ingredient getIngredient() {
        return ingredient;
    }

    public Double getQuantity() {
        return quantity;
    }

    public Date getExpirationDate() {
        return expirationDate;
    }

    public String getBatchNumber() {
        return batchNumber;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setRestaurant(Restaurant restaurant) {
        this.restaurant = restaurant;
    }

    public void setIngredient(Ingredient ingredient) {
        this.ingredient = ingredient;
    }

    public void setQuantity(Double quantity) {
        this.quantity = quantity;
    }

    public void setExpirationDate(Date expirationDate) {
        this.expirationDate = expirationDate;
    }

    public void setBatchNumber(String batchNumber) {
        this.batchNumber = batchNumber;
    }
}