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
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/restaurants")
public class RestaurantsServlet extends HttpServlet {

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

            // SEULEMENT POUR L'AJOUT
            if ("add".equals(action)) {
                req.setAttribute("isEdit", false);
                req.getRequestDispatcher("/restaurant-form.jsp").forward(req, resp);
                return;
            }

            // Pour la liste des restaurants
            List<Restaurant> restaurants = restaurantService.getAllRestaurants();
            System.out.println("Nombre de restaurants chargés: " + restaurants.size());
            req.setAttribute("restaurants", restaurants);

            // Récupérer les messages d'erreur/succès
            String error = req.getParameter("error");
            String success = req.getParameter("success");

            if (error != null) {
                req.setAttribute("error", error);
            }
            if (success != null) {
                req.setAttribute("success", success);
            }

            req.getRequestDispatcher("/restaurants.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("restaurants?error=" + e.getMessage());
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
            String city = req.getParameter("city");
            String address = req.getParameter("address");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            String capacityStr = req.getParameter("capacity");
            String openingTimeStr = req.getParameter("openingTime");
            String closingTimeStr = req.getParameter("closingTime");
            String isActiveStr = req.getParameter("isActive");

            System.out.println("=== DO POST RESTAURANT ===");
            System.out.println("ID: " + idParam);
            System.out.println("Nom: " + name);
            System.out.println("Ville: " + city);

            Restaurant restaurant;

            if (idParam != null && !idParam.isEmpty()) {
                // MISE À JOUR
                Long id = Long.parseLong(idParam);
                restaurant = restaurantService.getRestaurantById(id);
                if (restaurant == null) {
                    resp.sendRedirect("restaurants?error=Restaurant non trouvé");
                    return;
                }
                restaurant.setName(name);
                restaurant.setCity(city);
            } else {
                // AJOUT
                restaurant = new Restaurant(name, city);
            }

            // Remplir les nouveaux champs
            restaurant.setAddress(address);
            restaurant.setPhone(phone);
            restaurant.setEmail(email);

            if (capacityStr != null && !capacityStr.isEmpty()) {
                restaurant.setCapacity(Integer.parseInt(capacityStr));
            }

            if (openingTimeStr != null && !openingTimeStr.isEmpty()) {
                restaurant.setOpeningTime(LocalTime.parse(openingTimeStr));
            }

            if (closingTimeStr != null && !closingTimeStr.isEmpty()) {
                restaurant.setClosingTime(LocalTime.parse(closingTimeStr));
            }

            restaurant.setIsActive(isActiveStr != null && isActiveStr.equals("true"));

            if (idParam != null && !idParam.isEmpty()) {
                // MISE À JOUR
                Long id = Long.parseLong(idParam);
                restaurantService.updateRestaurant(id, restaurant);
                System.out.println("Restaurant mis à jour avec succès");
                resp.sendRedirect("restaurants?success=Restaurant mis à jour avec succès");
            } else {
                // AJOUT
                restaurantService.addRestaurant(restaurant);
                System.out.println("Restaurant ajouté avec succès, ID: " + restaurant.getId());
                resp.sendRedirect("restaurants?success=Restaurant ajouté avec succès");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("restaurants?error=" + e.getMessage());
        }
    }
}