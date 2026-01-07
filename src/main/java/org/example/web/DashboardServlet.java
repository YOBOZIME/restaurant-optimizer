package org.example.web;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.repository.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Inject private IngredientRepository ingredientRepo;
    @Inject private RestaurantRepository restaurantRepo;
    @Inject private StockRepository stockRepo;
    @Inject private WasteRepository wasteRepo;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        // 1. Fetch Basic Counts
        req.setAttribute("ingredientsCount", ingredientRepo.findAll().size());
        req.setAttribute("restaurantsCount", restaurantRepo.findAll().size());

        // 2. Fetch Stock Metrics
        req.setAttribute("expiringSoonCount", stockRepo.findNearExpiration().size());
        req.setAttribute("expiringSoonDetails", stockRepo.findNearExpiration());
        req.setAttribute("stockValue", stockRepo.getTotalStockValue());

        // 3. Waste Calculations (Dummy values for now until PredictionService is ready)
        req.setAttribute("totalWasteCost", 145.50);
        req.setAttribute("wasteReduction", 12);
        req.setAttribute("predictionAccuracy", 94);
        req.setAttribute("inventoryTurnover", 4.2);

        // 4. Data for Charts (Pie Chart: Waste by Category)
        Map<String, Double> wasteByIngredient = new HashMap<>();
        wasteByIngredient.put("Viandes", 45.0);
        wasteByIngredient.put("Légumes", 30.0);
        wasteByIngredient.put("Produits Laitiers", 25.0);
        req.setAttribute("wasteByIngredient", wasteByIngredient);

        // 5. Stock Alerts per Restaurant (Bar Chart)
        Map<String, Integer> stockAlerts = new HashMap<>();
        restaurantRepo.findAll().forEach(r -> {
            stockAlerts.put(r.getName(), stockRepo.findByRestaurantId(r.getId()).size());
        });
        req.setAttribute("stockAlerts", stockAlerts);

        // 6. Static Recommendations
        req.setAttribute("recommendations", new String[]{
                "⚠️ Le stock de Tomates est critique au Restaurant Paris.",
                "📈 Prévoyez +10% de stock pour le week-end prochain.",
                "📦 Commande suggérée : 20kg de Poulet chez 'BioSupplier'."
        });

        req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
    }
}