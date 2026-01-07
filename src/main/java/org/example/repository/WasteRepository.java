package org.example.repository;

import org.example.entity.waste.WasteLog;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.util.List;

@ApplicationScoped
public class WasteRepository {

    @PersistenceContext(unitName = "inventoryPU")
    private EntityManager em;

    @Transactional
    public void save(WasteLog wasteLog) {
        em.persist(wasteLog);
    }

    public List<WasteLog> findAll() {
        return em.createQuery(
                "SELECT wl FROM WasteLog wl " +
                        "JOIN FETCH wl.ingredient " +
                        "JOIN FETCH wl.restaurant " +
                        "ORDER BY wl.date DESC",
                WasteLog.class
        ).getResultList();
    }

    public WasteLog findById(Long id) {
        return em.find(WasteLog.class, id);
    }

    public List<WasteLog> findByRestaurantId(Long restaurantId) {
        return em.createQuery(
                        "SELECT wl FROM WasteLog wl " +
                                "WHERE wl.restaurant.id = :restaurantId " +
                                "ORDER BY wl.date DESC",
                        WasteLog.class
                ).setParameter("restaurantId", restaurantId)
                .getResultList();
    }

    public List<WasteLog> findByReason(String reason) {
        return em.createQuery(
                        "SELECT wl FROM WasteLog wl " +
                                "WHERE wl.reason = :reason " +
                                "ORDER BY wl.date DESC",
                        WasteLog.class
                ).setParameter("reason", reason)
                .getResultList();
    }

    public EntityManager getEm() {
        return em;
    }

    @Transactional
    public void update(WasteLog wasteLog) {
        em.merge(wasteLog);
    }

    @Transactional
    public void delete(Long id) {
        WasteLog wasteLog = findById(id);
        if (wasteLog != null) {
            em.remove(wasteLog);
        }
    }
}