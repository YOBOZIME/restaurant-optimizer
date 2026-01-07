package org.example.web;

import org.example.entity.core.Restaurant;
import org.example.entity.inventory.RestaurantStock;
import org.example.service.core.RestaurantService;
import org.example.service.core.StockService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

@WebServlet("/view-restaurant")
public class ViewRestaurantServlet extends HttpServlet {

    @Inject
    private RestaurantService restaurantService;

    @Inject
    private StockService stockService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        String idParam = req.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            resp.sendRedirect("restaurants?error=ID manquant");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);

            System.out.println("=== CHARGEMENT DÉTAILS RESTAURANT ===");
            System.out.println("ID: " + id);

            // Récupérer le restaurant
            Restaurant restaurant = restaurantService.getRestaurantById(id);

            if (restaurant == null) {
                resp.sendRedirect("restaurants?error=Restaurant non trouvé");
                return;
            }

            System.out.println("Restaurant trouvé: " + restaurant.getName());

            // Récupérer le stock de ce restaurant
            List<RestaurantStock> stockList = stockService.getStockByRestaurant(id);
            System.out.println("Stock trouvé: " + stockList.size() + " items");

            // Simuler des alertes (à remplacer par vraie logique plus tard)
            List<Map<String, String>> alerts = generateAlerts(stockList, restaurant);

            // Passer les données au JSP
            req.setAttribute("restaurant", restaurant);
            req.setAttribute("stockList", stockList);
            req.setAttribute("alerts", alerts);

            req.getRequestDispatcher("/restaurant-details.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            resp.sendRedirect("restaurants?error=ID invalide");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("restaurants?error=" + e.getMessage());
        }
    }

    private List<Map<String, String>> generateAlerts(List<RestaurantStock> stockList, Restaurant restaurant) {
        List<Map<String, String>> alerts = new ArrayList<>();

        // Alertes pour stocks critiques
        int criticalCount = 0;
        for (RestaurantStock stock : stockList) {
            if (stock.getQuantity() < 2) {
                criticalCount++;
            }
        }

        if (criticalCount > 0) {
            Map<String, String> alert = new HashMap<>();
            alert.put("title", "Stocks critiques");
            alert.put("message", criticalCount + " ingrédient(s) en stock critique (< 2 unités)");
            alert.put("date", new Date().toString());
            alerts.add(alert);
        }

        // Alertes pour expiration proche
        int expiringCount = 0;
        Date now = new Date();
        Date threeDaysFromNow = new Date(now.getTime() + 3 * 24 * 60 * 60 * 1000);

        for (RestaurantStock stock : stockList) {
            if (stock.getExpirationDate() != null &&
                    stock.getExpirationDate().before(threeDaysFromNow) &&
                    stock.getExpirationDate().after(now)) {
                expiringCount++;
            }
        }

        if (expiringCount > 0) {
            Map<String, String> alert = new HashMap<>();
            alert.put("title", "Produits périssables");
            alert.put("message", expiringCount + " produit(s) expire(nt) dans moins de 3 jours");
            alert.put("date", new Date().toString());
            alerts.add(alert);
        }

        return alerts;
    }
}