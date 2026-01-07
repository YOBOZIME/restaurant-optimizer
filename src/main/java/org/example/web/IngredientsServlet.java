package org.example.web;

import org.example.entity.core.Ingredient;
import org.example.service.core.InventoryService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/ingredients")
public class IngredientsServlet extends HttpServlet {

    @Inject
    private InventoryService inventoryService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        try {
            // Récupérer l'action
            String action = req.getParameter("action");

            if ("add".equals(action)) {
                // Afficher le formulaire d'ajout
                req.getRequestDispatcher("/ingredient-form.jsp").forward(req, resp);
                return;
            }

            // Récupérer tous les ingrédients
            List<Ingredient> ingredients = inventoryService.getAllIngredients();
            req.setAttribute("ingredients", ingredients);

            // Afficher la page ingredients.jsp
            req.getRequestDispatcher("/ingredients.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors du chargement des ingrédients: " + e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        try {
            String idParam = req.getParameter("id");
            String name = req.getParameter("name");
            String unit = req.getParameter("unit"); // Récupérer l'unité
            String category = req.getParameter("category");
            String priceStr = req.getParameter("currentPrice");
            String shelfLifeStr = req.getParameter("shelfLifeDays");

            System.out.println("=== DO POST INGREDIENT ===");
            System.out.println("ID: " + idParam);
            System.out.println("Nom: " + name);
            System.out.println("Unité: " + unit); // Debug
            System.out.println("Catégorie: " + category);
            System.out.println("Prix: " + priceStr);
            System.out.println("Conservation: " + shelfLifeStr);

            // Validation
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Le nom est requis");
            }
            if (unit == null || unit.trim().isEmpty()) {
                throw new IllegalArgumentException("L'unité est requise");
            }
            if (priceStr == null || priceStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Le prix est requis");
            }
            if (shelfLifeStr == null || shelfLifeStr.trim().isEmpty()) {
                throw new IllegalArgumentException("La durée de conservation est requise");
            }

            Double currentPrice = Double.parseDouble(priceStr);
            Integer shelfLifeDays = Integer.parseInt(shelfLifeStr);

            Ingredient ingredient = new Ingredient(name, unit, currentPrice, shelfLifeDays, category);

            if (idParam != null && !idParam.isEmpty()) {
                // MISE À JOUR
                Long id = Long.parseLong(idParam);
                ingredient.setId(id);
                inventoryService.updateIngredient(id, ingredient);
                resp.sendRedirect("ingredients?success=Ingrédient mis à jour avec succès");
            } else {
                // AJOUT
                inventoryService.addIngredient(ingredient);
                resp.sendRedirect("ingredients?success=Ingrédient ajouté avec succès");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("ingredients?error=" + e.getMessage());
        }
    }
}