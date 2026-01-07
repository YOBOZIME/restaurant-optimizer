package org.example.entity.core;

import jakarta.persistence.*;
import org.example.entity.inventory.RestaurantStock;  // Ajouter cet import
import java.time.LocalTime;
import java.util.ArrayList;  // Ajouter cet import
import java.util.List;      // Ajouter cet import

@Entity
@Table(name = "restaurants")
public class Restaurant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String city;

    @Column(name = "address")
    private String address;

    @Column(name = "phone")
    private String phone;

    @Column(name = "email")
    private String email;

    @Column(name = "capacity")
    private Integer capacity; // Nombre de places

    @Column(name = "opening_time")
    private LocalTime openingTime;

    @Column(name = "closing_time")
    private LocalTime closingTime;

    @Column(name = "is_active")
    private Boolean isActive = true;

    // Relations avec le stock - CORRIGÉ : ajouter l'import et initialiser
    @OneToMany(mappedBy = "restaurant", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<RestaurantStock> stocks = new ArrayList<>();

    public Restaurant() {}

    public Restaurant(String name, String city) {
        this.name = name;
        this.city = city;
        this.isActive = true;
        this.stocks = new ArrayList<>(); // Initialiser dans le constructeur
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }

    public LocalTime getOpeningTime() { return openingTime; }
    public void setOpeningTime(LocalTime openingTime) { this.openingTime = openingTime; }

    public LocalTime getClosingTime() { return closingTime; }
    public void setClosingTime(LocalTime closingTime) { this.closingTime = closingTime; }

    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }

    public List<RestaurantStock> getStocks() {
        if (stocks == null) {
            stocks = new ArrayList<>();
        }
        return stocks;
    }

    public void setStocks(List<RestaurantStock> stocks) {
        this.stocks = stocks != null ? stocks : new ArrayList<>();
    }

    // Méthode utilitaire pour ajouter du stock
    public void addStock(RestaurantStock stock) {
        if (stocks == null) {
            stocks = new ArrayList<>();
        }
        stock.setRestaurant(this);
        stocks.add(stock);
    }

    // Méthode utilitaire pour supprimer du stock
    public void removeStock(RestaurantStock stock) {
        if (stocks != null) {
            stocks.remove(stock);
            stock.setRestaurant(null);
        }
    }
}