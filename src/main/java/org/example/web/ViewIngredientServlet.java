package org.example.web;

import org.example.entity.core.Ingredient;
import org.example.entity.inventory.RestaurantStock;
import org.example.service.core.InventoryService;
import org.example.service.core.StockService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/view-ingredient")
public class ViewIngredientServlet extends HttpServlet {

    @Inject
    private InventoryService inventoryService;

    @Inject
    private StockService stockService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String idParam = req.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            resp.sendRedirect("ingredients?error=ID manquant");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            Ingredient ingredient = inventoryService.getIngredientById(id);

            if (ingredient == null) {
                resp.sendRedirect("ingredients?error=Ingrédient non trouvé");
                return;
            }

            // Récupérer les stocks utilisant cet ingrédient
            List<RestaurantStock> ingredientStocks = stockService.getStockByIngredient(id);

            // Calculer les statistiques
            double totalQuantity = ingredientStocks.stream()
                    .mapToDouble(RestaurantStock::getQuantity)
                    .sum();
            double totalValue = totalQuantity * ingredient.getCurrentPrice();

            req.setAttribute("ingredient", ingredient);
            req.setAttribute("stocks", ingredientStocks);
            req.setAttribute("totalQuantity", totalQuantity);
            req.setAttribute("totalValue", totalValue);

            req.getRequestDispatcher("/ingredient-details.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect("ingredients?error=ID invalide");
        } catch (Exception e) {
            resp.sendRedirect("ingredients?error=" + e.getMessage());
        }
    }
}