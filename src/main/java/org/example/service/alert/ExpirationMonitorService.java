package org.example.service.alert;

import org.example.events.ExpirationAlertEvent;
import org.example.repository.StockRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.enterprise.event.Event;
import java.util.Date;
import java.util.concurrent.TimeUnit;

@ApplicationScoped
public class ExpirationMonitorService {

    @Inject
    private StockRepository stockRepository;

    @Inject
    private Event<ExpirationAlertEvent> event;

    public void checkExpiringStock() {
        // Check for items expiring in next 48 hours
        Date threshold = new Date(System.currentTimeMillis() +
                TimeUnit.HOURS.toMillis(48));

        stockRepository.findExpiringBetween(new Date(), threshold)
                .forEach(stock -> {
                    event.fire(new ExpirationAlertEvent(
                            stock.getIngredient(),
                            stock.getRestaurant(),
                            stock.getExpirationDate()
                    ));
                });
    }

    // Scheduled method (add @Scheduled if using Quarkus scheduler)
    // @Scheduled(every = "1h")
    public void scheduledCheck() {
        checkExpiringStock();
    }
}