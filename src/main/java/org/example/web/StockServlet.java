package org.example.web;

import org.example.entity.inventory.RestaurantStock;
import org.example.entity.core.Restaurant;
import org.example.service.core.RestaurantService;
import org.example.service.core.StockService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transactional;
import java.io.IOException;
import java.util.List;

@WebServlet("/stock")
public class StockServlet extends HttpServlet {

    @Inject
    private StockService stockService;

    @Inject
    private RestaurantService restaurantService;

    @Override
    @Transactional
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        try {
            // Récupérer le paramètre de filtre restaurant
            String restaurantIdParam = req.getParameter("restaurantId");
            Long restaurantId = null;

            if (restaurantIdParam != null && !restaurantIdParam.isEmpty()) {
                restaurantId = Long.parseLong(restaurantIdParam);
            }

            List<RestaurantStock> stockList;
            String selectedRestaurantName = "Tous les restaurants";

            if (restaurantId != null) {
                // Use the regular method - JOIN FETCH should work now
                stockList = stockService.getStockByRestaurant(restaurantId);

                // Get restaurant name for display
                Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
                if (restaurant != null) {
                    selectedRestaurantName = restaurant.getName();
                }
            } else {
                // Récupérer tout le stock
                stockList = stockService.getAllStock();
            }

            // Force initialization of lazy relationships while still in transaction
            for (RestaurantStock stock : stockList) {
                // Access the properties to load them
                if (stock.getIngredient() != null) {
                    stock.getIngredient().getName(); // This loads the ingredient
                }
                if (stock.getRestaurant() != null) {
                    stock.getRestaurant().getName(); // This loads the restaurant
                }
            }

            System.out.println("Nombre d'items de stock chargés: " + stockList.size());
            req.setAttribute("stockList", stockList);
            req.setAttribute("selectedRestaurantName", selectedRestaurantName);

            // Récupérer la liste de tous les restaurants pour le filtre
            List<Restaurant> restaurants = restaurantService.getAllRestaurants();
            req.setAttribute("restaurants", restaurants);

            // Passer l'ID du restaurant sélectionné
            req.setAttribute("selectedRestaurantId", restaurantId);

            // Calculer la valeur totale
            double totalValue = 0;
            for (RestaurantStock stock : stockList) {
                if (stock.getIngredient() != null && stock.getIngredient().getCurrentPrice() != null) {
                    totalValue += stock.getQuantity() * stock.getIngredient().getCurrentPrice();
                }
            }
            req.setAttribute("stockValue", totalValue);

            // Afficher la page JSP
            req.getRequestDispatcher("/stock.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }
}