package org.example.repository;

import org.example.entity.inventory.RestaurantStock;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.util.Date;
import java.util.List;

@ApplicationScoped
public class StockRepository {

    @PersistenceContext(unitName = "inventoryPU")
    private EntityManager em;

    @Transactional
    public void save(RestaurantStock stock) {
        em.persist(stock);
    }

    public List<RestaurantStock> findAll() {
        return em.createQuery(
                "SELECT rs FROM RestaurantStock rs " +
                        "JOIN FETCH rs.ingredient " +
                        "JOIN FETCH rs.restaurant " +
                        "ORDER BY rs.expirationDate",
                RestaurantStock.class
        ).getResultList();
    }

    public RestaurantStock findById(Long id) {
        return em.find(RestaurantStock.class, id);
    }

    public List<RestaurantStock> findByRestaurantId(Long restaurantId) {
        return em.createQuery(
                        "SELECT rs FROM RestaurantStock rs " +
                                "JOIN FETCH rs.ingredient " +
                                "WHERE rs.restaurant.id = :restaurantId " +
                                "ORDER BY rs.expirationDate",
                        RestaurantStock.class
                ).setParameter("restaurantId", restaurantId)
                .getResultList();
    }

    public List<RestaurantStock> findNearExpiration() {
        Date threshold = new Date(System.currentTimeMillis() + 48 * 60 * 60 * 1000); // 48h
        return em.createQuery(
                        "SELECT rs FROM RestaurantStock rs " +
                                "WHERE rs.expirationDate <= :threshold " +
                                "ORDER BY rs.expirationDate",
                        RestaurantStock.class
                ).setParameter("threshold", threshold)
                .getResultList();
    }

    // AJOUTER CES NOUVELLES MÉTHODES
    public List<RestaurantStock> findExpiringBetween(Date startDate, Date endDate) {
        return em.createQuery(
                        "SELECT rs FROM RestaurantStock rs " +
                                "WHERE rs.expirationDate BETWEEN :startDate AND :endDate " +
                                "ORDER BY rs.expirationDate",
                        RestaurantStock.class
                ).setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .getResultList();
    }

    public Double getTotalStockValue() {
        try {
            return em.createQuery(
                    "SELECT SUM(rs.quantity * i.currentPrice) " +
                            "FROM RestaurantStock rs " +
                            "JOIN rs.ingredient i",
                    Double.class
            ).getSingleResult();
        } catch (Exception e) {
            return 0.0;
        }
    }

    public List<Object[]> getStockByCategory() {
        return em.createQuery(
                "SELECT i.category, SUM(rs.quantity), SUM(rs.quantity * i.currentPrice) " +
                        "FROM RestaurantStock rs " +
                        "JOIN rs.ingredient i " +
                        "WHERE i.category IS NOT NULL " +
                        "GROUP BY i.category",
                Object[].class
        ).getResultList();
    }

    // Dans StockRepository.java
    public List<RestaurantStock> findByIngredientId(Long ingredientId) {
        return em.createQuery(
                        "SELECT rs FROM RestaurantStock rs " +
                                "JOIN FETCH rs.restaurant " +
                                "WHERE rs.ingredient.id = :ingredientId " +
                                "ORDER BY rs.restaurant.name",
                        RestaurantStock.class
                ).setParameter("ingredientId", ingredientId)
                .getResultList();
    }

    public EntityManager getEm() {
        return em;
    }

    @Transactional
    public void update(RestaurantStock stock) {
        em.merge(stock);
    }

    @Transactional
    public void delete(Long id) {
        RestaurantStock stock = findById(id);
        if (stock != null) {
            em.remove(stock);
        }
    }
}