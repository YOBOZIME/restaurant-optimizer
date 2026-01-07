package org.example.service.core;

import org.example.entity.waste.WasteLog;
import org.example.repository.WasteRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.util.List;

@ApplicationScoped
@Transactional
public class WasteService {

    @Inject
    private WasteRepository wasteRepository;

    public List<WasteLog> getAllWasteLogs() {
        return wasteRepository.findAll();
    }

    public List<WasteLog> getWasteLogsByRestaurant(Long restaurantId) {
        return wasteRepository.findByRestaurantId(restaurantId);
    }

    public List<WasteLog> getWasteLogsByReason(String reason) {
        return wasteRepository.findByReason(reason);
    }

    public WasteLog getWasteLogById(Long id) {
        return wasteRepository.findById(id);
    }

    public void addWasteLog(WasteLog wasteLog) {
        wasteRepository.save(wasteLog);
    }

    public void updateWasteLog(WasteLog wasteLog) {
        wasteRepository.update(wasteLog);
    }

    public void deleteWasteLog(Long id) {
        wasteRepository.delete(id);
    }
}