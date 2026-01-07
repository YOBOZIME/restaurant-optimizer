package org.example.service.alert;

import org.example.events.ExpirationAlertEvent;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.event.Observes;

@ApplicationScoped
public class AlertService {

    public void onExpiration(@Observes ExpirationAlertEvent event) {

        System.out.println("⚠️ EXPIRATION ALERT ⚠️");
        System.out.println("Ingredient: " + event.getIngredient().getName());
        System.out.println("Restaurant: " + event.getRestaurant().getName());
        System.out.println("Expires on: " + event.getExpirationDate());

        // Later:
        // Email / SMS / Dashboard notification
    }
}
