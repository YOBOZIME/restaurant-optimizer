package org.example.web;

import org.example.entity.waste.WasteLog;
import org.example.service.core.WasteService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/waste")
public class WasteServlet extends HttpServlet {

    @Inject
    private WasteService wasteService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        try {
            List<WasteLog> wasteLogs = wasteService.getAllWasteLogs();
            System.out.println("Nombre de pertes chargées: " + wasteLogs.size());
            req.setAttribute("wasteLogs", wasteLogs);

            // Calculer le coût total
            double totalCost = 0;
            for (WasteLog waste : wasteLogs) {
                if (waste.getIngredient() != null && waste.getIngredient().getCurrentPrice() != null) {
                    totalCost += waste.getQuantity() * waste.getIngredient().getCurrentPrice();
                }
            }
            req.setAttribute("totalWasteCost", totalCost);

            req.getRequestDispatcher("/waste.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur: " + e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }
}