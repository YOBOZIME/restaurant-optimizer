package org.example.web;

import org.example.entity.inventory.RestaurantStock;
import org.example.entity.core.Restaurant; // IMPORTANT: Ajouter cette ligne
import org.example.service.core.RestaurantService; // IMPORTANT: Ajouter cette ligne
import org.example.service.core.StockService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/stock")
public class StockServlet extends HttpServlet {

    @Inject
    private StockService stockService;

    @Inject // IMPORTANT: Ajouter cette injection
    private RestaurantService restaurantService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        try {
            // Récupérer tout le stock
            List<RestaurantStock> stockList = stockService.getAllStock();
            System.out.println("Nombre d'items de stock chargés: " + stockList.size());
            req.setAttribute("stockList", stockList);

            // Récupérer la liste des restaurants pour les filtres
            List<Restaurant> restaurants = restaurantService.getAllRestaurants(); // IMPORTANT
            req.setAttribute("restaurants", restaurants);

            // Calculer la valeur totale
            double totalValue = 0;
            for (RestaurantStock stock : stockList) {
                if (stock.getIngredient() != null && stock.getIngredient().getCurrentPrice() != null) {
                    totalValue += stock.getQuantity() * stock.getIngredient().getCurrentPrice();
                }
            }
            String action = req.getParameter("action");
            if ("summary".equals(action)) {
                req.getRequestDispatcher("/stock-summary.jsp").forward(req, resp);
                return;
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