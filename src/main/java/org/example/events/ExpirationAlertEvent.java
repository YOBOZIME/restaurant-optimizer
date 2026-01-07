package org.example.events;

import org.example.entity.core.Ingredient;
import org.example.entity.core.Restaurant;

import java.util.Date;

public class ExpirationAlertEvent {

    private Ingredient ingredient;
    private Restaurant restaurant;
    private Date expirationDate;

    public ExpirationAlertEvent(Ingredient ingredient, Restaurant restaurant, Date expirationDate) {
        this.ingredient = ingredient;
        this.restaurant = restaurant;
        this.expirationDate = expirationDate;
    }

    public Ingredient getIngredient() {
        return ingredient;
    }

    public Restaurant getRestaurant() {
        return restaurant;
    }

    public Date getExpirationDate() {
        return expirationDate;
    }
}
