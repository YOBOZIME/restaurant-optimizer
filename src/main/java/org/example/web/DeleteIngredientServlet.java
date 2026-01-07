package org.example.web;

import org.example.service.core.InventoryService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/delete-ingredient")
public class DeleteIngredientServlet extends HttpServlet {

    @Inject
    private InventoryService inventoryService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");

        if (idParam == null || idParam.isEmpty()) {
            resp.sendRedirect("ingredients?error=ID manquant");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);

            // Vérifier si l'ingrédient est utilisé dans des stocks
            // (À implémenter plus tard - pour l'instant on supprime)

            inventoryService.deleteIngredient(id);
            resp.sendRedirect("ingredients?success=Ingrédient supprimé avec succès");

        } catch (NumberFormatException e) {
            resp.sendRedirect("ingredients?error=ID invalide");
        } catch (Exception e) {
            resp.sendRedirect("ingredients?error=" + e.getMessage());
        }
    }
}