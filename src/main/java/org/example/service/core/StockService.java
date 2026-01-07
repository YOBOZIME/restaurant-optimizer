package org.example.service.core;

import jakarta.enterprise.event.Event;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import org.example.entity.inventory.RestaurantStock;
import org.example.events.ExpirationAlertEvent;
import org.example.repository.StockRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.logging.Logger;

@ApplicationScoped
@Transactional
public class StockService {

    private static final Logger LOGGER = Logger.getLogger(StockService.class.getName());

    @Inject
    private StockRepository stockRepository;

    @Inject
    private Event<ExpirationAlertEvent> event;

    @Inject
    private jakarta.validation.Validator validator;

    @Transactional
    public void checkAndTriggerExpirations() {
        List<RestaurantStock> expiring = stockRepository.findNearExpiration();
        for (RestaurantStock stock : expiring) {
            event.fire(new ExpirationAlertEvent(
                    stock.getIngredient(),
                    stock.getRestaurant(),
                    stock.getExpirationDate()
            ));
        }
    }

    public Double calculateTotalStockValue() {
        return stockRepository.getTotalStockValue();
    }

    public Map<String, Object> getStockAnalytics() {
        Map<String, Object> analytics = new HashMap<>();
        analytics.put("totalValue", calculateTotalStockValue());
        analytics.put("itemsCount", getAllStock().size());
        analytics.put("expiringCount", getNearExpirationStock().size());

        // Add category breakdown
        List<Object[]> byCategory = stockRepository.getStockByCategory();
        Map<String, Double> categoryValue = new HashMap<>();
        for (Object[] row : byCategory) {
            categoryValue.put((String) row[0], (Double) row[2]);
        }
        analytics.put("categoryValue", categoryValue);

        return analytics;
    }

    public List<RestaurantStock> getStockByIngredient(Long ingredientId) {
        return stockRepository.findByIngredientId(ingredientId);
    }

    public List<RestaurantStock> getAllStock() {
        return stockRepository.findAll();
    }

    public List<RestaurantStock> getStockByRestaurant(Long restaurantId) {
        return stockRepository.findByRestaurantId(restaurantId);
    }

    public List<RestaurantStock> getNearExpirationStock() {
        return stockRepository.findNearExpiration();
    }

    public StockRepository getStockRepository() {
        return stockRepository;
    }

    public RestaurantStock getStockById(Long id) {
        LOGGER.info("Getting stock with ID: " + id);
        RestaurantStock stock = stockRepository.findByIdWithRelations(id);
        if (stock != null) {
            LOGGER.info("Stock found: " + stock.getId() +
                    ", Restaurant: " + (stock.getRestaurant() != null ? stock.getRestaurant().getName() : "null") +
                    ", Ingredient: " + (stock.getIngredient() != null ? stock.getIngredient().getName() : "null"));
        } else {
            LOGGER.warning("Stock not found with ID: " + id);
        }
        return stock;
    }

    @Transactional
    public void addStock(RestaurantStock stock) {
        LOGGER.info("=== StockService.addStock() ===");
        LOGGER.info("Stock reçu: restaurantId=" + stock.getRestaurant().getId() +
                ", ingredientId=" + stock.getIngredient().getId() +
                ", quantity=" + stock.getQuantity());

        try {
            // Valider avant de sauvegarder
            LOGGER.info("Validation de l'entité...");
            Set<ConstraintViolation<RestaurantStock>> violations = validator.validate(stock);
            if (!violations.isEmpty()) {
                LOGGER.severe("Violations de validation trouvées:");
                for (ConstraintViolation<RestaurantStock> violation : violations) {
                    LOGGER.severe("  - " + violation.getPropertyPath() + ": " + violation.getMessage());
                }
                throw new ConstraintViolationException(violations);
            }
            LOGGER.info("Validation OK");

            // S'assurer que restaurant et ingredient existent
            LOGGER.info("Vérification des entités...");
            if (stock.getRestaurant() == null || stock.getRestaurant().getId() == null) {
                throw new IllegalArgumentException("Restaurant est requis");
            }
            if (stock.getIngredient() == null || stock.getIngredient().getId() == null) {
                throw new IllegalArgumentException("Ingrédient est requis");
            }
            LOGGER.info("Entités OK");

            LOGGER.info("Sauvegarde dans le repository...");
            stockRepository.save(stock);
            LOGGER.info("Stock sauvegardé avec ID: " + stock.getId());

        } catch (Exception e) {
            LOGGER.severe("ERREUR dans StockService.addStock(): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    @Transactional
    public void updateStock(RestaurantStock stock) {
        LOGGER.info("=== StockService.updateStock() ===");
        LOGGER.info("Mise à jour du stock ID: " + stock.getId());

        try {
            // Valider l'entité
            Set<ConstraintViolation<RestaurantStock>> violations = validator.validate(stock);
            if (!violations.isEmpty()) {
                throw new ConstraintViolationException(violations);
            }

            stockRepository.update(stock);
            LOGGER.info("Stock mis à jour avec succès");

        } catch (Exception e) {
            LOGGER.severe("ERREUR dans StockService.updateStock(): " + e.getMessage());
            throw e;
        }
    }

    @Transactional
    public void deleteStock(Long id) {
        LOGGER.info("=== StockService.deleteStock() ===");
        LOGGER.info("Suppression du stock ID: " + id);

        try {
            stockRepository.delete(id);
            LOGGER.info("Stock supprimé avec succès");

        } catch (Exception e) {
            LOGGER.severe("ERREUR dans StockService.deleteStock(): " + e.getMessage());
            throw e;
        }
    }

    public List<RestaurantStock> findExpiringBetween(java.util.Date startDate, java.util.Date endDate) {
        return stockRepository.findExpiringBetween(startDate, endDate);
    }

    public List<Object[]> getStockByCategory() {
        return stockRepository.getStockByCategory();
    }

    // Fix the getStockSummary method
    public Map<String, Object> getStockSummary() {
        Map<String, Object> summary = new HashMap<>();

        // Total value
        Double totalValue = calculateTotalStockValue();
        summary.put("totalValue", totalValue != null ? totalValue : 0.0);

        // Count by restaurant with proper value calculation
        try {
            // FIXED: Use EntityManager directly with proper syntax
            List<Object[]> byRestaurant = stockRepository.getEm().createQuery(
                    "SELECT r.name, COUNT(rs), COALESCE(SUM(rs.quantity * i.currentPrice), 0) " +
                            "FROM RestaurantStock rs " +
                            "JOIN rs.restaurant r " +
                            "JOIN rs.ingredient i " +
                            "GROUP BY r.name " +
                            "ORDER BY COALESCE(SUM(rs.quantity * i.currentPrice), 0) DESC",
                    Object[].class
            ).getResultList();

            LOGGER.info("Restaurant distribution data:");
            for (Object[] row : byRestaurant) {
                LOGGER.info("  " + row[0] + ": " + row[2] + " €");
            }

            summary.put("byRestaurant", byRestaurant);
        } catch (Exception e) {
            LOGGER.warning("Error getting byRestaurant summary: " + e.getMessage());
            summary.put("byRestaurant", new ArrayList<>());
        }

        // Count by category
        try {
            // FIXED: Use EntityManager directly with proper syntax
            List<Object[]> byCategory = stockRepository.getEm().createQuery(
                    "SELECT i.category, COUNT(rs), COALESCE(SUM(rs.quantity), 0), COALESCE(SUM(rs.quantity * i.currentPrice), 0) " +
                            "FROM RestaurantStock rs " +
                            "JOIN rs.ingredient i " +
                            "WHERE i.category IS NOT NULL " +
                            "GROUP BY i.category " +
                            "ORDER BY COALESCE(SUM(rs.quantity * i.currentPrice), 0) DESC",
                    Object[].class
            ).getResultList();
            summary.put("byCategory", byCategory);
        } catch (Exception e) {
            LOGGER.warning("Error getting byCategory summary: " + e.getMessage());
            summary.put("byCategory", new ArrayList<>());
        }

        return summary;
    }

    public List<String> getUniqueCategories() {
        try {
            // FIXED: Use EntityManager directly with proper syntax
            return stockRepository.getEm().createQuery(
                    "SELECT DISTINCT i.category FROM RestaurantStock rs " +
                            "JOIN rs.ingredient i " +
                            "WHERE i.category IS NOT NULL " +
                            "ORDER BY i.category",
                    String.class
            ).getResultList();
        } catch (Exception e) {
            LOGGER.warning("Error getting unique categories: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    // Utility method for parsing quantity with locale support
    public Double parseQuantity(String quantityStr) {
        if (quantityStr == null || quantityStr.trim().isEmpty()) {
            return null;
        }
        try {
            // Handle both comma and dot decimal separators
            quantityStr = quantityStr.replace(',', '.');
            return Double.parseDouble(quantityStr);
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid quantity format: " + quantityStr);
            return null;
        }
    }
}