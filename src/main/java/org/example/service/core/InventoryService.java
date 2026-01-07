package org.example.service.core;

import org.example.entity.core.Ingredient;
import org.example.repository.IngredientRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped
public class InventoryService {

    @Inject
    private IngredientRepository ingredientRepository;

    public List<Ingredient> getAllIngredients() {
        return ingredientRepository.findAll();
    }

    @Transactional
    public void addIngredient(Ingredient ingredient) {
        ingredientRepository.save(ingredient);
    }

    public Ingredient getIngredientById(Long id) {
        return ingredientRepository.findById(id);
    }

    @Transactional
    public void deleteIngredient(Long id) {
        ingredientRepository.delete(id);
    }

    @Transactional
    public void updateIngredient(Long id, Ingredient updatedIngredient) {
        Ingredient existing = ingredientRepository.findById(id);
        if (existing != null) {
            existing.setName(updatedIngredient.getName());
            existing.setUnit(updatedIngredient.getUnit());
            existing.setCurrentPrice(updatedIngredient.getCurrentPrice());
            existing.setShelfLifeDays(updatedIngredient.getShelfLifeDays());
            existing.setCategory(updatedIngredient.getCategory());
            ingredientRepository.save(existing);
        }
    }

    // Optional: Search method
    public List<Ingredient> searchIngredients(String name, String category) {
        // Implement search logic using Java 11 compatible Stream API
        return ingredientRepository.findAll().stream()
                .filter(i -> name == null || (i.getName() != null &&
                        i.getName().toLowerCase().contains(name.toLowerCase())))
                .filter(i -> category == null || category.isEmpty() ||
                        (i.getCategory() != null && i.getCategory().equals(category)))
                .collect(Collectors.toList()); // Use collect(Collectors.toList()) instead of .toList()
    }
}