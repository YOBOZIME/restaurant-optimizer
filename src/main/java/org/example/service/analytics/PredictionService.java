package org.example.service.analytics;

import org.example.entity.waste.WasteLog;
import org.example.repository.WasteRepository;
import org.example.repository.StockRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@ApplicationScoped
public class PredictionService {

    @Inject
    private WasteRepository wasteRepository;

    @Inject
    private StockRepository stockRepository;

    public Map<String, Object> getWastePredictions(Long restaurantId) {
        Map<String, Object> predictions = new HashMap<>();

        // Get historical waste data
        List<WasteLog> wasteLogs = wasteRepository.findByRestaurantId(restaurantId);

        // Simple prediction algorithm
        double totalWaste = wasteLogs.stream()
                .mapToDouble(WasteLog::getQuantity)
                .sum();

        double avgDailyWaste = totalWaste / Math.max(wasteLogs.size(), 1);

        predictions.put("predictedDailyWaste", avgDailyWaste);
        predictions.put("confidenceLevel", 85.5); // Example value
        predictions.put("suggestedOrderReduction", calculateOrderReduction(wasteLogs));

        return predictions;
    }

    private double calculateOrderReduction(List<WasteLog> wasteLogs) {
        // Simple logic: reduce orders by 10% of average waste
        double avgWaste = wasteLogs.stream()
                .mapToDouble(WasteLog::getQuantity)
                .average()
                .orElse(0.0);

        return avgWaste * 0.1;
    }

    public Map<String, Double> calculateWasteCostByCategory() {
        // This would calculate actual waste costs from the database
        Map<String, Double> wasteCosts = new HashMap<>();

        // Placeholder logic - implement actual database queries
        wasteCosts.put("Meat", 450.75);
        wasteCosts.put("Vegetables", 320.50);
        wasteCosts.put("Dairy", 210.25);

        return wasteCosts;
    }
}