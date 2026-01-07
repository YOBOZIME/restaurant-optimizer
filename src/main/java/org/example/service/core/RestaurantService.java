package org.example.service.core;

import org.example.entity.core.Restaurant;
import org.example.repository.RestaurantRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.util.List;

@ApplicationScoped
@Transactional
public class RestaurantService {

    @Inject
    private RestaurantRepository restaurantRepository;

    public List<Restaurant> getAllRestaurants() {
        return restaurantRepository.findAll();
    }

    public Restaurant getRestaurantById(Long id) {
        Restaurant restaurant = restaurantRepository.findById(id);
        System.out.println("Service - Restaurant trouvé pour ID " + id + ": " +
                (restaurant != null ? restaurant.getName() : "null"));
        return restaurant;
    }

    @Transactional
    public void addRestaurant(Restaurant restaurant) {
        if (restaurant.getName() == null || restaurant.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom du restaurant est requis");
        }
        System.out.println("Service - Ajout du restaurant: " + restaurant.getName());
        restaurantRepository.save(restaurant);
        System.out.println("Service - Restaurant ajouté, ID: " + restaurant.getId());
    }

    @Transactional
    public void updateRestaurant(Long id, Restaurant updated) {
        System.out.println("Service - Mise à jour du restaurant ID: " + id);
        Restaurant existing = restaurantRepository.findById(id);
        if (existing == null) {
            System.out.println("Service - Restaurant non trouvé pour ID: " + id);
            throw new IllegalArgumentException("Restaurant non trouvé avec l'ID: " + id);
        }

        // Mettre à jour tous les champs
        existing.setName(updated.getName());
        existing.setCity(updated.getCity());
        existing.setAddress(updated.getAddress());
        existing.setPhone(updated.getPhone());
        existing.setEmail(updated.getEmail());
        existing.setCapacity(updated.getCapacity());
        existing.setOpeningTime(updated.getOpeningTime());
        existing.setClosingTime(updated.getClosingTime());
        existing.setIsActive(updated.getIsActive());

        restaurantRepository.save(existing);
        System.out.println("Service - Restaurant mis à jour avec succès");
    }

    @Transactional
    public void deleteRestaurant(Long id) {
        System.out.println("Service - Suppression du restaurant ID: " + id);
        Restaurant restaurant = restaurantRepository.findById(id);
        if (restaurant == null) {
            System.out.println("Service - Restaurant non trouvé pour suppression ID: " + id);
            throw new IllegalArgumentException("Restaurant non trouvé avec l'ID: " + id);
        }
        System.out.println("Service - Suppression du restaurant: " + restaurant.getName());
        restaurantRepository.delete(id);
        System.out.println("Service - Restaurant supprimé avec succès");
    }

    public List<Restaurant> getRestaurantsByCity(String city) {
        return restaurantRepository.findByCity(city);
    }
}