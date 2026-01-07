package org.example.repository;

import org.example.entity.core.Supplier;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.util.List;

@ApplicationScoped
public class SupplierRepository {

    @PersistenceContext(unitName = "inventoryPU")
    private EntityManager em;

    @Transactional
    public void save(Supplier supplier) {
        em.persist(supplier);
    }

    public List<Supplier> findAll() {
        return em.createQuery(
                "SELECT s FROM Supplier s ORDER BY s.name",
                Supplier.class
        ).getResultList();
    }

    public Supplier findById(Long id) {
        return em.find(Supplier.class, id);
    }

    public List<Supplier> findByCategory(String category) {
        return em.createQuery(
                        "SELECT s FROM Supplier s WHERE s.category = :category ORDER BY s.rating DESC",
                        Supplier.class
                ).setParameter("category", category)
                .getResultList();
    }

    public EntityManager getEm() {
        return em;
    }

    @Transactional
    public void update(Supplier supplier) {
        em.merge(supplier);
    }

    @Transactional
    public void delete(Long id) {
        Supplier supplier = findById(id);
        if (supplier != null) {
            em.remove(supplier);
        }
    }
}