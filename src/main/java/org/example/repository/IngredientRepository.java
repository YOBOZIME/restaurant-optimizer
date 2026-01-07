package org.example.repository;

import org.example.entity.core.Ingredient;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.util.List;

@ApplicationScoped
public class IngredientRepository {

    @PersistenceContext(unitName = "inventoryPU")
    private EntityManager em;

    @Transactional
    public void save(Ingredient ingredient) {
        if (ingredient.getId() == null) {
            em.persist(ingredient);
        } else {
            em.merge(ingredient);
        }
    }

    public List<Ingredient> findAll() {
        return em.createQuery("SELECT i FROM Ingredient i", Ingredient.class).getResultList();
    }

    public Ingredient findById(Long id) {
        return em.find(Ingredient.class, id);
    }

    // FIXED: Add a proper delete method
    @Transactional
    public void delete(Long id) {
        Ingredient ingredient = findById(id);
        if (ingredient != null) {
            // Remove any references first if needed
            em.remove(ingredient);
        }
    }

    // FIXED: Add getter for EntityManager if really needed (but better to avoid)
    public EntityManager getEntityManager() {
        return em;
    }
}