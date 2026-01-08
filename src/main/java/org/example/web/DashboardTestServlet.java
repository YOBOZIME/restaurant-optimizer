package org.example.web;

import jakarta.inject.Inject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.dto.DashboardDataDTO;
import org.example.service.dashboard.DashboardStatisticsService;
import org.example.util.JsonConverter;
import java.io.IOException;

@WebServlet("/api/dashboard-test")
public class DashboardTestServlet extends HttpServlet {

    @Inject
    private DashboardStatisticsService dashboardService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            DashboardDataDTO data = dashboardService.getDashboardData();
            resp.getWriter().write(JsonConverter.toJson(data));
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}