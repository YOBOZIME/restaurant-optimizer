package org.example.service.core;

import org.example.entity.core.Supplier;
import org.example.repository.SupplierRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.util.List;

@ApplicationScoped
@Transactional
public class SupplierService {

    @Inject
    private SupplierRepository supplierRepository;

    public List<Supplier> getAllSuppliers() {
        return supplierRepository.findAll();
    }

    public Supplier getSupplierById(Long id) {
        return supplierRepository.findById(id);
    }

    public void addSupplier(Supplier supplier) {
        if (supplier.getName() == null || supplier.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom du fournisseur est requis");
        }
        supplierRepository.save(supplier);
    }

    public void updateSupplier(Long id, Supplier updatedSupplier) {
        Supplier existing = supplierRepository.findById(id);
        if (existing != null) {
            existing.setName(updatedSupplier.getName());
            existing.setContactPerson(updatedSupplier.getContactPerson());
            existing.setEmail(updatedSupplier.getEmail());
            existing.setPhone(updatedSupplier.getPhone());
            existing.setAddress(updatedSupplier.getAddress());
            existing.setRating(updatedSupplier.getRating());
            existing.setCategory(updatedSupplier.getCategory());
        } else {
            throw new IllegalArgumentException("Fournisseur non trouvé avec l'ID: " + id);
        }
    }

    public void deleteSupplier(Long id) {
        supplierRepository.delete(id);
    }

    public List<Supplier> getSuppliersByCategory(String category) {
        return supplierRepository.findByCategory(category);
    }

    public Double calculateSupplierScore(Supplier supplier) {
        // Calculer un score basé sur plusieurs critères
        double score = 5.0; // Base

        if (supplier.getRating() != null) {
            score = supplier.getRating();
        }

        // Ajouter des bonus/malus selon d'autres critères
        return score;
    }
}