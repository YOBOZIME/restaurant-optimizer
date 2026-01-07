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

@WebServlet("/edit-ingredient")
public class EditIngredientServlet extends HttpServlet {

    @Inject
    private InventoryService inventoryService;

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

            req.setAttribute("ingredient", ingredient);
            req.setAttribute("isEdit", true);
            req.getRequestDispatcher("/ingredient-form.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect("ingredients?error=ID invalide");
        } catch (Exception e) {
            resp.sendRedirect("ingredients?error=" + e.getMessage());
        }
    }
}