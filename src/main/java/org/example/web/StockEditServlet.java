package org.example.web;

import org.example.entity.core.Restaurant;
import org.example.entity.core.Ingredient;
import org.example.entity.inventory.RestaurantStock;
import org.example.service.core.RestaurantService;
import org.example.service.core.InventoryService;
import org.example.service.core.StockService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transactional;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/stock/edit")
public class StockEditServlet extends HttpServlet {

    @Inject
    private StockService stockService;

    @Inject
    private RestaurantService restaurantService;

    @Inject
    private InventoryService inventoryService;

    @Override
    @Transactional // ADD THIS ANNOTATION
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        try {
            String idParam = req.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                resp.sendRedirect("stock");
                return;
            }

            Long stockId = Long.parseLong(idParam);

            // Get stock with eager loading
            RestaurantStock stock = stockService.getStockById(stockId);

            if (stock == null) {
                req.setAttribute("errorMessage", "Stock non trouvé avec l'ID: " + stockId);
                req.getRequestDispatcher("/error.jsp").forward(req, resp);
                return;
            }

            // Access the relationships here, while still in transaction
            Restaurant restaurant = stock.getRestaurant();
            Ingredient ingredient = stock.getIngredient();

            if (restaurant == null || ingredient == null) {
                req.setAttribute("errorMessage", "Données incomplètes pour le stock ID: " + stockId);
                req.getRequestDispatcher("/error.jsp").forward(req, resp);
                return;
            }

            // Format the expiration date for the form
            String expirationDateStr = "";
            if (stock.getExpirationDate() != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                expirationDateStr = sdf.format(stock.getExpirationDate());
            }

            // Récupérer les listes pour le formulaire (pour information seulement)
            List<Restaurant> restaurants = restaurantService.getAllRestaurants();
            List<Ingredient> ingredients = inventoryService.getAllIngredients();

            req.setAttribute("stock", stock);
            req.setAttribute("restaurant", restaurant);
            req.setAttribute("ingredient", ingredient);
            req.setAttribute("expirationDateStr", expirationDateStr);
            req.setAttribute("restaurants", restaurants);
            req.setAttribute("ingredients", ingredients);

            req.getRequestDispatcher("/stock-edit.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }
}