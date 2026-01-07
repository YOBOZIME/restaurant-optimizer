package org.example.web;

import org.example.entity.core.Ingredient;
import org.example.entity.core.Restaurant;
import org.example.entity.inventory.RestaurantStock;
import org.example.service.core.InventoryService;
import org.example.service.core.RestaurantService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.service.core.StockService;

import java.io.IOException;
import java.util.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/stock/add")
public class AddStockServlet extends HttpServlet {

    @Inject
    private RestaurantService restaurantService;

    @Inject
    private InventoryService InventoryService;

    @Inject
    private StockService stockService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Récupérer la liste des restaurants et ingrédients
        List<Restaurant> restaurants = restaurantService.getAllRestaurants();
        List<Ingredient> ingredients = InventoryService.getAllIngredients();

        req.setAttribute("restaurants", restaurants);
        req.setAttribute("ingredients", ingredients);

        req.getRequestDispatcher("/stock-add.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        try {
            Long restaurantId = Long.parseLong(req.getParameter("restaurantId"));
            Long ingredientId = Long.parseLong(req.getParameter("ingredientId"));
            Double quantity = Double.parseDouble(req.getParameter("quantity"));

            Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);
            Ingredient ingredient = InventoryService.getIngredientById(ingredientId);

            if (restaurant == null || ingredient == null) {
                throw new IllegalArgumentException("Restaurant ou ingrédient invalide");
            }

            RestaurantStock stock = new RestaurantStock();
            stock.setRestaurant(restaurant);
            stock.setIngredient(ingredient);
            stock.setQuantity(quantity);

            // Gérer la date d'expiration
            String expirationDateStr = req.getParameter("expirationDate");
            if (expirationDateStr != null && !expirationDateStr.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date expirationDate = sdf.parse(expirationDateStr);
                stock.setExpirationDate(expirationDate);
            }

            // Numéro de lot
            String batchNumber = req.getParameter("batchNumber");
            if (batchNumber != null && !batchNumber.isEmpty()) {
                stock.setBatchNumber(batchNumber);
            }

            stockService.addStock(stock);

            resp.sendRedirect(req.getContextPath() + "/stock");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }
}