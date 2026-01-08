package org.example.web;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transactional;
import org.example.dto.*;
import org.example.service.dashboard.DashboardStatisticsService;
import org.example.repository.*;
import org.example.util.JsonConverter;
import java.io.IOException;
import java.util.*;

@WebServlet("/dashboard")
@Transactional
public class DashboardServlet extends HttpServlet {

    @Inject
    private IngredientRepository ingredientRepo;

    @Inject
    private RestaurantRepository restaurantRepo;

    @Inject
    private StockRepository stockRepo;

    @Inject
    private DashboardStatisticsService dashboardService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        try {
            // Get dashboard data from service
            DashboardDataDTO dashboardData = dashboardService.getDashboardData();

            // 1. Basic counts
            req.setAttribute("ingredientsCount", ingredientRepo.findAll().size());
            req.setAttribute("restaurantsCount", restaurantRepo.findAll().size());
            req.setAttribute("expiringSoonCount", stockRepo.findNearExpiration().size());

            // 2. Pass the complete DTO
            req.setAttribute("dashboardData", dashboardData);

            // 3. Pass individual data for easy access
            req.setAttribute("ingredientsByCategory", dashboardData.getIngredientsByCategory());
            req.setAttribute("restaurantStockLevels", dashboardData.getRestaurantStockLevels());
            req.setAttribute("expirationTimeline", dashboardData.getExpirationTimeline());
            req.setAttribute("criticalAlerts", dashboardData.getCriticalAlerts());
            req.setAttribute("warningAlerts", dashboardData.getWarningAlerts());
            req.setAttribute("infoAlerts", dashboardData.getInfoAlerts());
            req.setAttribute("performanceStats", dashboardData.getPerformanceStats());

            // 4. Convert data to JSON for JavaScript
            req.setAttribute("ingredientsByCategoryJson", JsonConverter.toJson(dashboardData.getIngredientsByCategory()));
            req.setAttribute("restaurantStockLevelsJson", JsonConverter.toJson(dashboardData.getRestaurantStockLevels()));
            req.setAttribute("expirationTimelineJson", JsonConverter.toJson(dashboardData.getExpirationTimeline()));

            // 5. Simple recommendations
            List<String> recommendations = new ArrayList<>();
            recommendations.add("⚠️ Vérifiez les stocks de viande");
            recommendations.add("📈 Optimisez les commandes pour le week-end");
            recommendations.add("📦 " + dashboardData.getCriticalAlerts().size() + " items expirent dans 24h");
            req.setAttribute("recommendations", recommendations);

            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }
}