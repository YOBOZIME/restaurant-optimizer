package org.example.repository;

import org.example.entity.core.Restaurant;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;

@ApplicationScoped
public class RestaurantRepository {

    @PersistenceContext(unitName = "inventoryPU")
    private EntityManager em;

    public void save(Restaurant restaurant) {
        if (restaurant.getId() == null) {
            em.persist(restaurant);
        } else {
            em.merge(restaurant);
        }
    }

    public List<Restaurant> findAll() {
        return em.createQuery("SELECT r FROM Restaurant r ORDER BY r.name", Restaurant.class)
                .getResultList();
    }

    public Restaurant findById(Long id) {
        return em.find(Restaurant.class, id);
    }

    public EntityManager getEm() {
        return em;
    }

    public void delete(Long id) {
        Restaurant restaurant = findById(id);
        if (restaurant != null) {
            // CORRECTION : Utiliser getEm() ou em directement
            getEm().remove(restaurant);
            // OU : em.remove(restaurant);
        }
    }

    public List<Restaurant> findByCity(String city) {
        return em.createQuery("SELECT r FROM Restaurant r WHERE r.city = :city ORDER BY r.name", Restaurant.class)
                .setParameter("city", city)
                .getResultList();
    }
}