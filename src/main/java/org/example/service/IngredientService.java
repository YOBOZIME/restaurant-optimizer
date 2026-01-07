package org.example.service;

import jakarta.transaction.Transactional;
import org.example.entity.core.Ingredient;
import org.example.repository.IngredientRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import java.util.Date;
import java.util.List;

@ApplicationScoped
public class IngredientService {

    @Inject
    private IngredientRepository ingredientRepository;

    @Transactional
    public void addIngredient(Ingredient ingredient) {
        ingredientRepository.save(ingredient);
    }

    @Transactional
    public void updateIngredient(Ingredient ingredient) {
        ingredientRepository.save(ingredient);
    }

    @Transactional
    public void deleteIngredient(Long id) {
        // FIXED: Now using repository's delete method
        ingredientRepository.delete(id);
    }

    public List<Ingredient> getAllIngredients() {
        return ingredientRepository.findAll();
    }

    public Ingredient getIngredientById(Long id) {
        return ingredientRepository.findById(id);
    }

    public boolean isNearExpiration(Date expirationDate) {
        if (expirationDate == null) return false;
        long diff = expirationDate.getTime() - System.currentTimeMillis();
        return diff <= (48 * 60 * 60 * 1000); // 48 hours
    }

    // Add this method for business logic
    public Double getIngredientCost(Long ingredientId) {
        Ingredient ingredient = getIngredientById(ingredientId);
        return ingredient != null ? ingredient.getCurrentPrice() : 0.0;
    }
}