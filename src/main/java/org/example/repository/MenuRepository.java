package org.example.repository;

import jakarta.transaction.Transactional;
import org.example.entity.core.MenuItem;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@ApplicationScoped
public class MenuRepository {
    @PersistenceContext(unitName = "inventoryPU")
    private EntityManager em;

    public void save(MenuItem item) {
        if (item.getId() == null) em.persist(item);
        else em.merge(item);
    }

    public List<MenuItem> findAll() {
        return em.createQuery("SELECT m FROM MenuItem m ORDER BY m.name", MenuItem.class).getResultList();
    }

    public MenuItem findById(Long id) {
        return em.find(MenuItem.class, id);
    }

    public EntityManager getEm() {
        return em;
    }

    public List<MenuItem> findByRestaurantId(Long restaurantId) {
        return em.createQuery("SELECT m FROM MenuItem m WHERE m.restaurant.id = :id", MenuItem.class)
                .setParameter("id", restaurantId).getResultList();
    }

    public void delete(Long id) {
        MenuItem item = findById(id);
        if (item != null) em.remove(item);
    }

    // Add this to MenuRepository.java
    public List<MenuItem> findByCategory(String category) {
        return em.createQuery("SELECT m FROM MenuItem m WHERE m.category = :category", MenuItem.class)
                .setParameter("category", category)
                .getResultList();
    }

    @Transactional
    public void update(MenuItem menuItem) {
        em.merge(menuItem); // This handles the update logic for JPA
    }
}