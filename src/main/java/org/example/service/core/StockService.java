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
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.JoinType;

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

    public RestaurantStock getStockById(Long id) {
        return stockRepository.findById(id);
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

    // Fixed searchStock method using JPQL (Simpler approach)
    public List<RestaurantStock> searchStock(Long restaurantId, Long ingredientId,
                                             String expirationFrom, String expirationTo,
                                             Double minQuantity, Double maxQuantity,
                                             String category) {

        LOGGER.info("=== StockService.searchStock() ===");
        LOGGER.info("Params: restaurantId=" + restaurantId +
                ", ingredientId=" + ingredientId +
                ", expirationFrom=" + expirationFrom +
                ", expirationTo=" + expirationTo +
                ", minQuantity=" + minQuantity +
                ", maxQuantity=" + maxQuantity +
                ", category=" + category);

        try {
            // Build base query with proper JOIN FETCH syntax
            StringBuilder jpql = new StringBuilder(
                    "SELECT DISTINCT rs FROM RestaurantStock rs " +
                            "LEFT JOIN FETCH rs.ingredient i " +
                            "LEFT JOIN FETCH rs.restaurant r " +
                            "WHERE 1=1"
            );

            // Add filters
            Map<String, Object> parameters = new HashMap<>();

            if (restaurantId != null) {
                jpql.append(" AND rs.restaurant.id = :restaurantId");
                parameters.put("restaurantId", restaurantId);
            }

            if (ingredientId != null) {
                jpql.append(" AND rs.ingredient.id = :ingredientId");
                parameters.put("ingredientId", ingredientId);
            }

            if (minQuantity != null) {
                jpql.append(" AND rs.quantity >= :minQuantity");
                parameters.put("minQuantity", minQuantity);
            }

            if (maxQuantity != null) {
                jpql.append(" AND rs.quantity <= :maxQuantity");
                parameters.put("maxQuantity", maxQuantity);
            }

            if (category != null && !category.isEmpty()) {
                jpql.append(" AND i.category = :category");
                parameters.put("category", category);
            }

            // Handle date filters
            if (expirationFrom != null && !expirationFrom.isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date fromDate = sdf.parse(expirationFrom);
                    jpql.append(" AND rs.expirationDate >= :fromDate");
                    parameters.put("fromDate", fromDate);
                } catch (ParseException e) {
                    LOGGER.warning("Invalid expirationFrom date: " + expirationFrom);
                }
            }

            if (expirationTo != null && !expirationTo.isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date toDate = sdf.parse(expirationTo);
                    jpql.append(" AND rs.expirationDate <= :toDate");
                    parameters.put("toDate", toDate);
                } catch (ParseException e) {
                    LOGGER.warning("Invalid expirationTo date: " + expirationTo);
                }
            }

            // Add ordering
            jpql.append(" ORDER BY rs.expirationDate ASC NULLS LAST, r.name ASC, i.name ASC");

            LOGGER.info("JPQL query: " + jpql.toString());

            // Create query
            jakarta.persistence.TypedQuery<RestaurantStock> query =
                    stockRepository.getEm().createQuery(jpql.toString(), RestaurantStock.class);

            // Set parameters
            for (Map.Entry<String, Object> entry : parameters.entrySet()) {
                query.setParameter(entry.getKey(), entry.getValue());
            }

            List<RestaurantStock> result = query.getResultList();
            LOGGER.info("Found " + result.size() + " stock items");
            return result;

        } catch (Exception e) {
            LOGGER.severe("Error in searchStock: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    // Alternative search method using Criteria API
    public List<RestaurantStock> searchStockCriteria(Long restaurantId, Long ingredientId,
                                                     String expirationFrom, String expirationTo,
                                                     Double minQuantity, Double maxQuantity,
                                                     String category) {

        LOGGER.info("=== StockService.searchStockCriteria() ===");

        try {
            CriteriaBuilder cb = stockRepository.getEm().getCriteriaBuilder();
            CriteriaQuery<RestaurantStock> cq = cb.createQuery(RestaurantStock.class);
            Root<RestaurantStock> stock = cq.from(RestaurantStock.class);

            // Join with related entities (no alias in fetch)
            stock.fetch("ingredient", JoinType.LEFT);
            stock.fetch("restaurant", JoinType.LEFT);

            List<Predicate> predicates = new ArrayList<>();

            if (restaurantId != null) {
                predicates.add(cb.equal(stock.get("restaurant").get("id"), restaurantId));
            }

            if (ingredientId != null) {
                predicates.add(cb.equal(stock.get("ingredient").get("id"), ingredientId));
            }

            if (minQuantity != null) {
                predicates.add(cb.ge(stock.get("quantity"), minQuantity));
            }

            if (maxQuantity != null) {
                predicates.add(cb.le(stock.get("quantity"), maxQuantity));
            }

            if (category != null && !category.isEmpty()) {
                predicates.add(cb.equal(stock.get("ingredient").get("category"), category));
            }

            // Handle date filters
            if (expirationFrom != null && !expirationFrom.isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date fromDate = sdf.parse(expirationFrom);
                    predicates.add(cb.greaterThanOrEqualTo(stock.get("expirationDate"), fromDate));
                } catch (ParseException e) {
                    LOGGER.warning("Invalid expirationFrom date: " + expirationFrom);
                }
            }

            if (expirationTo != null && !expirationTo.isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date toDate = sdf.parse(expirationTo);
                    predicates.add(cb.lessThanOrEqualTo(stock.get("expirationDate"), toDate));
                } catch (ParseException e) {
                    LOGGER.warning("Invalid expirationTo date: " + expirationTo);
                }
            }

            if (!predicates.isEmpty()) {
                cq.where(cb.and(predicates.toArray(new Predicate[0])));
            }

            // Add ordering with null handling
            cq.orderBy(
                    cb.asc(cb.selectCase()
                            .when(cb.isNull(stock.get("expirationDate")), 1)
                            .otherwise(0)),
                    cb.asc(stock.get("expirationDate")),
                    cb.asc(stock.get("restaurant").get("name")),
                    cb.asc(stock.get("ingredient").get("name"))
            );

            List<RestaurantStock> result = stockRepository.getEm().createQuery(cq).getResultList();
            LOGGER.info("Found " + result.size() + " stock items using Criteria API");
            return result;

        } catch (Exception e) {
            LOGGER.severe("Error in searchStockCriteria: " + e.getMessage());
            e.printStackTrace();
            // Fall back to JPQL method
            return searchStock(restaurantId, ingredientId, expirationFrom, expirationTo,
                    minQuantity, maxQuantity, category);
        }
    }

    public Map<String, Object> getStockSummary() {
        Map<String, Object> summary = new HashMap<>();

        // Total value
        Double totalValue = calculateTotalStockValue();
        summary.put("totalValue", totalValue != null ? totalValue : 0.0);

        // Count by restaurant
        try {
            List<Object[]> byRestaurant = stockRepository.getEm().createQuery(
                    "SELECT r.name, COUNT(rs), SUM(rs.quantity * i.currentPrice) " +
                            "FROM RestaurantStock rs " +
                            "JOIN rs.restaurant r " +
                            "JOIN rs.ingredient i " +
                            "GROUP BY r.name",
                    Object[].class
            ).getResultList();
            summary.put("byRestaurant", byRestaurant);
        } catch (Exception e) {
            LOGGER.warning("Error getting byRestaurant summary: " + e.getMessage());
            summary.put("byRestaurant", new ArrayList<>());
        }

        // Count by category
        try {
            List<Object[]> byCategory = stockRepository.getEm().createQuery(
                    "SELECT i.category, COUNT(rs), SUM(rs.quantity), SUM(rs.quantity * i.currentPrice) " +
                            "FROM RestaurantStock rs " +
                            "JOIN rs.ingredient i " +
                            "WHERE i.category IS NOT NULL " +
                            "GROUP BY i.category",
                    Object[].class
            ).getResultList();
            summary.put("byCategory", byCategory);
        } catch (Exception e) {
            LOGGER.warning("Error getting byCategory summary: " + e.getMessage());
            summary.put("byCategory", new ArrayList<>());
        }

        // Expiring soon (within 3 days)
        try {
            Date threeDaysLater = new Date(System.currentTimeMillis() + 3 * 24 * 60 * 60 * 1000);
            Long expiringCount = stockRepository.getEm().createQuery(
                    "SELECT COUNT(rs) FROM RestaurantStock rs " +
                            "WHERE rs.expirationDate <= :date AND rs.expirationDate >= CURRENT_DATE",
                    Long.class
            ).setParameter("date", threeDaysLater).getSingleResult();
            summary.put("expiringCount", expiringCount != null ? expiringCount : 0L);
        } catch (Exception e) {
            LOGGER.warning("Error getting expiringCount: " + e.getMessage());
            summary.put("expiringCount", 0L);
        }

        // Low stock (quantity < 5)
        try {
            Long lowStockCount = stockRepository.getEm().createQuery(
                    "SELECT COUNT(rs) FROM RestaurantStock rs " +
                            "WHERE rs.quantity < 5",
                    Long.class
            ).getSingleResult();
            summary.put("lowStockCount", lowStockCount != null ? lowStockCount : 0L);
        } catch (Exception e) {
            LOGGER.warning("Error getting lowStockCount: " + e.getMessage());
            summary.put("lowStockCount", 0L);
        }

        return summary;
    }

    public List<String> getUniqueCategories() {
        try {
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

    // Utility method for searching with String quantity parameters
    public List<RestaurantStock> searchStockWithStringParams(Long restaurantId, Long ingredientId,
                                                             String expirationFrom, String expirationTo,
                                                             String minQuantityStr, String maxQuantityStr,
                                                             String category) {

        // Parse quantity strings
        Double minQuantity = parseQuantity(minQuantityStr);
        Double maxQuantity = parseQuantity(maxQuantityStr);

        // Use either JPQL or Criteria API method
        return searchStockCriteria(restaurantId, ingredientId, expirationFrom, expirationTo,
                minQuantity, maxQuantity, category);
    }
}