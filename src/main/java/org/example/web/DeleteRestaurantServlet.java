package org.example.web;

import org.example.service.core.RestaurantService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/delete-restaurant")
public class DeleteRestaurantServlet extends HttpServlet {

    @Inject
    private RestaurantService restaurantService;

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

            System.out.println("=== TENTATIVE DE SUPPRESSION ===");
            System.out.println("ID à supprimer: " + id);

            // Supprimer le restaurant
            restaurantService.deleteRestaurant(id);

            System.out.println("Suppression effectuée avec succès");

            // Rediriger avec message de succès
            resp.sendRedirect("restaurants?success=Restaurant supprimé avec succès");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            resp.sendRedirect("restaurants?error=ID invalide");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("restaurants?error=Erreur: " + e.getMessage());
        }
    }
}