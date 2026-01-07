package org.example.web;

import org.example.entity.core.Restaurant;
import org.example.service.core.RestaurantService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/restaurant-action")
public class RestaurantActionServlet extends HttpServlet {

    @Inject
    private RestaurantService restaurantService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        try {
            String action = req.getParameter("action");
            String idParam = req.getParameter("id");

            if (idParam == null || idParam.isEmpty()) {
                resp.sendRedirect("restaurants");
                return;
            }

            Long id = Long.parseLong(idParam);

            if ("edit".equals(action)) {
                // Afficher le formulaire de modification
                Restaurant restaurant = restaurantService.getRestaurantById(id);
                if (restaurant != null) {
                    req.setAttribute("restaurant", restaurant);
                    req.setAttribute("isEdit", true);
                    req.getRequestDispatcher("/restaurant-form.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Restaurant non trouvé");
                    req.getRequestDispatcher("/error.jsp").forward(req, resp);
                }
            } else if ("delete".equals(action)) {
                // Supprimer le restaurant
                try {
                    restaurantService.deleteRestaurant(id);
                    // REDIRECTION après suppression
                    resp.sendRedirect("restaurants?deleted=true");
                } catch (Exception e) {
                    req.setAttribute("error", "Erreur de suppression: " + e.getMessage());
                    req.getRequestDispatcher("/error.jsp").forward(req, resp);
                }
            } else if ("view".equals(action)) {
                // Voir les détails (à implémenter si besoin)
                Restaurant restaurant = restaurantService.getRestaurantById(id);
                req.setAttribute("restaurant", restaurant);
                req.getRequestDispatcher("/restaurant-details.jsp").forward(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "ID invalide");
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur: " + e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }
}