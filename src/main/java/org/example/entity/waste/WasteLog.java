package org.example.entity.waste;

import org.example.entity.core.Ingredient;
import org.example.entity.core.Restaurant;
import org.example.entity.enums.WasteReason;
import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "waste_logs")
public class WasteLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Date date;
    private Double quantity;

    @Enumerated(EnumType.STRING)
    private WasteReason reason;

    private String notes;  // Add this

    @ManyToOne
    private Ingredient ingredient;

    @ManyToOne
    private Restaurant restaurant;

    // ===== GETTERS & SETTERS =====
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }
    public Double getQuantity() { return quantity; }
    public void setQuantity(Double quantity) { this.quantity = quantity; }
    public WasteReason getReason() { return reason; }
    public void setReason(WasteReason reason) { this.reason = reason; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public Ingredient getIngredient() { return ingredient; }
    public void setIngredient(Ingredient ingredient) { this.ingredient = ingredient; }
    public Restaurant getRestaurant() { return restaurant; }
    public void setRestaurant(Restaurant restaurant) { this.restaurant = restaurant; }
}