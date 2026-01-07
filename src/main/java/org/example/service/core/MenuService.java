package org.example.service.core;

import org.example.entity.core.MenuItem;
import org.example.entity.core.Ingredient;
import org.example.repository.MenuRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@ApplicationScoped
@Transactional
public class MenuService {

    @Inject
    private MenuRepository menuRepository;

    public List<MenuItem> getAllMenuItems() {
        return menuRepository.findAll();
    }

    public MenuItem getMenuItemById(Long id) {
        return menuRepository.findById(id);
    }

    public void saveMenuItem(MenuItem menuItem) {
        menuItem.calculateCosts(); // Make sure costs are calculated
        menuRepository.save(menuItem);
    }

    public void deleteMenuItem(Long id) {
        menuRepository.delete(id);
    }

    // Add this method
    public List<MenuItem> getMenuItemsByRestaurant(Long restaurantId) {
        return menuRepository.findByRestaurantId(restaurantId);
    }

    // Keep existing methods...
    public List<MenuItem> getMostProfitableItems(int limit) {
        List<MenuItem> allItems = menuRepository.findAll();
        allItems.sort((a, b) -> Double.compare(b.getProfitMargin(), a.getProfitMargin()));
        return allItems.stream().limit(limit).collect(Collectors.toList());
    }

    public List<MenuItem> getItemsNeedingOptimization() {
        return menuRepository.findAll().stream()
                .filter(item -> item.getFoodCostPercentage() > 40)
                .collect(Collectors.toList());
    }
}