<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Restaurant Supply Chain Optimizer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 100%);
            color: #ffffff;
            min-height: 100vh;
            line-height: 1.6;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }

        /* Header */
        .header {
            background: rgba(15, 15, 15, 0.95);
            border-radius: 12px;
            padding: 20px 30px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(220, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .header h1 {
            color: #ff0000;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
        }

        .header h1 i {
            color: #ff3333;
            font-size: 28px;
        }

        .header nav {
            display: flex;
            gap: 5px;
            flex-wrap: wrap;
        }

        .header nav a {
            color: #cccccc;
            text-decoration: none;
            padding: 12px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1px solid transparent;
        }

        .header nav a:hover {
            color: #ffffff;
            background: rgba(255, 0, 0, 0.1);
            border-color: rgba(255, 0, 0, 0.2);
            transform: translateY(-2px);
        }

        .header nav a.active {
            color: #ff0000;
            background: rgba(255, 0, 0, 0.15);
            border-color: rgba(255, 0, 0, 0.3);
            font-weight: 600;
        }

        /* Page Header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(255, 0, 0, 0.3);
        }

        .page-header h2 {
            color: #ffffff;
            font-size: 28px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .page-header h2 i {
            color: #ff3333;
        }

        .page-header p {
            color: #aaaaaa;
            margin-top: 8px;
            font-size: 15px;
        }

        /* Metrics Section */
        .metrics-section {
            margin-bottom: 30px;
        }

        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .metric-card {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 25px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .metric-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(220, 0, 0, 0.15);
            border-color: rgba(255, 0, 0, 0.2);
        }

        .metric-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .metric-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }

        .metric-card-primary .metric-icon {
            background: linear-gradient(135deg, rgba(255, 82, 82, 0.2) 0%, rgba(255, 82, 82, 0.1) 100%);
            color: #ff5252;
        }

        .metric-card-warning .metric-icon {
            background: linear-gradient(135deg, rgba(255, 152, 0, 0.2) 0%, rgba(255, 152, 0, 0.1) 100%);
            color: #ff9800;
        }

        .metric-card-secondary .metric-icon {
            background: linear-gradient(135deg, rgba(33, 150, 243, 0.2) 0%, rgba(33, 150, 243, 0.1) 100%);
            color: #2196F3;
        }

        .metric-card-danger .metric-icon {
            background: linear-gradient(135deg, rgba(0, 200, 83, 0.2) 0%, rgba(0, 200, 83, 0.1) 100%);
            color: #00c853;
        }

        .metric-trend {
            font-size: 12px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .metric-trend.positive {
            background: rgba(0, 200, 83, 0.15);
            color: #00c853;
        }

        .metric-trend.negative {
            background: rgba(255, 82, 82, 0.15);
            color: #ff5252;
        }

        .metric-body {
            text-align: center;
        }

        .metric-value {
            font-size: 48px;
            font-weight: 700;
            margin: 15px 0;
            line-height: 1;
        }

        .metric-card-primary .metric-value {
            color: #ff5252;
        }

        .metric-card-warning .metric-value {
            color: #ff9800;
        }

        .metric-card-secondary .metric-value {
            color: #2196F3;
        }

        .metric-card-danger .metric-value {
            color: #00c853;
        }

        .metric-label {
            color: #cccccc;
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 10px;
        }

        .metric-detail {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: #888888;
            padding-top: 10px;
            border-top: 1px solid rgba(255, 255, 255, 0.05);
        }

        /* Buttons */
        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
        }

        .btn-primary {
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #ff3333 0%, #e60000 100%);
        }

        .btn-refresh {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.05) 0%, rgba(255, 255, 255, 0.02) 100%);
            color: #cccccc;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .btn-refresh:hover {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.08) 0%, rgba(255, 255, 255, 0.04) 100%);
            color: #ffffff;
            border-color: rgba(255, 255, 255, 0.2);
        }

        .btn-refresh.refreshing i {
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* Card Styling */
        .card {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(220, 0, 0, 0.15);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .card-title {
            color: #ffffff;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            margin: 0;
        }

        .card-title i {
            color: #ff3333;
        }

        .card-subtitle {
            color: #888888;
            font-size: 13px;
        }

        /* Chart Containers */
        .chart-container {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: transform 0.3s ease;
        }

        .chart-container:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(220, 0, 0, 0.15);
        }

        .chart-wrapper {
            height: 300px;
            position: relative;
            margin-top: 15px;
        }

        .chart-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        /* Alert Level Badges */
        .alert-level-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            border: 1px solid;
        }

        .alert-critical {
            background: rgba(255, 82, 82, 0.15);
            color: #ff5252;
            border-color: rgba(255, 82, 82, 0.3);
        }

        .alert-warning {
            background: rgba(255, 152, 0, 0.15);
            color: #ff9800;
            border-color: rgba(255, 152, 0, 0.3);
        }

        .alert-safe {
            background: rgba(0, 200, 83, 0.15);
            color: #00c853;
            border-color: rgba(0, 200, 83, 0.3);
        }

        /* Restaurant Map */
        .restaurant-map {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .restaurant-card {
            background: rgba(255, 255, 255, 0.03);
            border-radius: 10px;
            padding: 20px;
            border: 2px solid;
            transition: all 0.3s ease;
            cursor: pointer;
            text-align: center;
        }

        .restaurant-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(220, 0, 0, 0.15);
        }

        .restaurant-card.critical {
            border-color: rgba(255, 82, 82, 0.4);
            background: rgba(255, 82, 82, 0.05);
        }

        .restaurant-card.warning {
            border-color: rgba(255, 152, 0, 0.4);
            background: rgba(255, 152, 0, 0.05);
        }

        .restaurant-card.safe {
            border-color: rgba(0, 200, 83, 0.4);
            background: rgba(0, 200, 83, 0.05);
        }

        .restaurant-card .alert-count {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .restaurant-card.critical .alert-count {
            color: #ff5252;
        }

        .restaurant-card.warning .alert-count {
            color: #ff9800;
        }

        .restaurant-card.safe .alert-count {
            color: #00c853;
        }

        /* Timeline */
        .timeline {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            height: 200px;
            padding: 20px 0;
            margin-top: 20px;
            position: relative;
        }

        .timeline::before {
            content: '';
            position: absolute;
            bottom: 50px;
            left: 0;
            right: 0;
            height: 2px;
            background: rgba(255, 255, 255, 0.1);
        }

        .timeline-day {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

        .timeline-bar {
            width: 30px;
            border-radius: 6px 6px 0 0;
            transition: height 0.3s ease;
            position: relative;
        }

        .timeline-bar.critical {
            background: linear-gradient(to top, #ff5252, #ff867f);
        }

        .timeline-bar.warning {
            background: linear-gradient(to top, #ff9800, #ffb74d);
        }

        .timeline-bar.info {
            background: linear-gradient(to top, #2196F3, #64b5f6);
        }

        .timeline-label {
            font-size: 12px;
            color: #888888;
            text-align: center;
        }

        .timeline-value {
            position: absolute;
            top: -25px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 11px;
            font-weight: 600;
            background: rgba(0, 0, 0, 0.8);
            padding: 2px 6px;
            border-radius: 4px;
            color: white;
        }

        /* Ensure canvas has dimensions */
        #categoryChart, #testChart1, #testChart2 {
            width: 100% !important;
            height: 100% !important;
            display: block;
        }

        canvas {
            background: rgba(255,255,255,0.02);
            border-radius: 8px;
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .chart-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                align-items: stretch;
            }

            .header nav {
                justify-content: center;
            }

            .page-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .metrics-grid {
                grid-template-columns: 1fr;
            }

            .timeline {
                height: 150px;
            }

            .timeline-bar {
                width: 20px;
            }
        }

        /* Brand styling */
        .brand {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .brand-logo {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }

        .brand-text {
            display: flex;
            flex-direction: column;
        }

        .brand-title {
            font-size: 20px;
            font-weight: 600;
            color: #ffffff;
            margin: 0;
        }

        .brand-subtitle {
            font-size: 13px;
            color: #888888;
            margin-top: 2px;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <header class="header">
        <div class="brand">
            <div class="brand-logo">
                <i class="fas fa-chart-network"></i>
            </div>
            <div class="brand-text">
                <h1 class="brand-title">Restaurant Supply Chain Optimizer</h1>
                <p class="brand-subtitle">Système de gestion optimisée</p>
            </div>
        </div>

        <nav class="main-nav">
            <a href="dashboard" class="active">
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
            <a href="ingredients">
                <i class="fas fa-carrot"></i>
                <span>Ingrédients</span>
            </a>
            <a href="restaurants">
                <i class="fas fa-store"></i>
                <span>Restaurants</span>
            </a>
            <a href="stock">
                <i class="fas fa-boxes"></i>
                <span>Stocks</span>
            </a>
        </nav>
    </header>

    <!-- Dashboard Content -->
    <main class="dashboard-content">
        <!-- Page Header -->
        <div class="page-header">
            <div class="page-title">
                <h2><i class="fas fa-tachometer-alt"></i> Tableau de Bord</h2>
                <p class="page-subtitle">Surveillance en temps réel de votre chaîne d'approvisionnement</p>
            </div>
            <div class="page-actions">
                <button class="btn btn-refresh" id="refreshBtn">
                    <i class="fas fa-sync-alt"></i>
                    Actualiser
                </button>
            </div>
        </div>

        <!-- Metrics Cards -->
        <div class="metrics-section">
            <div class="metrics-grid">
                <!-- Critical Alerts -->
                <div class="metric-card metric-card-primary">
                    <div class="metric-header">
                        <div class="metric-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <div class="metric-trend negative">
                            <i class="fas fa-arrow-up"></i> ${criticalAlerts != null ? criticalAlerts.size() : 0}
                        </div>
                    </div>
                    <div class="metric-body">
                        <div class="metric-value" id="criticalCount">${criticalAlerts != null ? criticalAlerts.size() : 0}</div>
                        <div class="metric-label">Alertes Critiques</div>
                        <div class="metric-detail">
                            <span class="detail-label">Expirent dans:</span>
                            <span class="detail-value">24h</span>
                        </div>
                    </div>
                </div>

                <!-- Warning Alerts -->
                <div class="metric-card metric-card-warning">
                    <div class="metric-header">
                        <div class="metric-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="metric-trend positive">
                            <i class="fas fa-arrow-down"></i> ${warningAlerts != null ? warningAlerts.size() : 0}
                        </div>
                    </div>
                    <div class="metric-body">
                        <div class="metric-value" id="warningCount">${warningAlerts != null ? warningAlerts.size() : 0}</div>
                        <div class="metric-label">Alertes Avertissement</div>
                        <div class="metric-detail">
                            <span class="detail-label">Expirent dans:</span>
                            <span class="detail-value">24-48h</span>
                        </div>
                    </div>
                </div>

                <!-- Info Alerts -->
                <div class="metric-card metric-card-secondary">
                    <div class="metric-header">
                        <div class="metric-icon">
                            <i class="fas fa-info-circle"></i>
                        </div>
                    </div>
                    <div class="metric-body">
                        <div class="metric-value" id="infoCount">${infoAlerts != null ? infoAlerts.size() : 0}</div>
                        <div class="metric-label">Alertes Information</div>
                        <div class="metric-detail">
                            <span class="detail-label">Expirent dans:</span>
                            <span class="detail-value">48h+</span>
                        </div>
                    </div>
                </div>

                <!-- Efficiency Score -->
                <div class="metric-card metric-card-danger">
                    <div class="metric-header">
                        <div class="metric-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                    </div>
                    <div class="metric-body">
                        <div class="metric-value" id="efficiencyScore">
                            <c:choose>
                                <c:when test="${performanceStats != null && performanceStats.efficiencyScore != null}">
                                    ${performanceStats.efficiencyScore}%
                                </c:when>
                                <c:otherwise>
                                    85%
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="metric-label">Score d'Efficacité</div>
                        <div class="metric-detail">
                            <span class="detail-label">Moyenne:</span>
                            <span class="detail-value">75%</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Section - SIMPLIFIED VERSION -->
        <div class="chart-grid">
            <!-- Chart 1: Ingredients by Category -->
            <div class="chart-container">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-chart-pie"></i>
                        Répartition par Catégorie
                    </h3>
                    <span class="card-subtitle">Ingrédients par type</span>
                </div>
                <div class="chart-wrapper">
                    <canvas id="categoryChart"></canvas>
                </div>
            </div>

            <!-- Chart 2: Expiration Timeline -->
            <div class="chart-container">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-calendar-alt"></i>
                        Timeline des Expirations
                    </h3>
                    <span class="card-subtitle">7 prochains jours</span>
                </div>
                <div class="timeline" id="expirationTimeline">
                    <!-- Will be filled by JavaScript -->
                </div>
            </div>

            <!-- Chart 3: Restaurant Alerts Map -->
            <div class="chart-container">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-map-marked-alt"></i>
                        Carte des Alertes
                    </h3>
                    <span class="card-subtitle">Alertes par restaurant</span>
                </div>
                <div class="restaurant-map" id="restaurantMap">
                    <!-- Will be filled by JavaScript -->
                </div>
            </div>
        </div>

    </main>
</div>

<script>
    // Real data from server - Using JSTL to pass data to JavaScript
    const dashboardData = {
        categories: ${ingredientsByCategoryJson != null ? ingredientsByCategoryJson : '{}'},
        timeline: ${expirationTimelineJson != null ? expirationTimelineJson : '{}'},
        restaurants: ${restaurantStockLevelsJson != null ? restaurantStockLevelsJson : '[]'},
        performanceStats: {
            avgStockAgeDays: ${performanceStats != null ? performanceStats.avgStockAgeDays : 10},
            stockTurnoverRate: ${performanceStats != null ? performanceStats.stockTurnoverRate : 12.5},
            alertResponseTime: ${performanceStats != null ? performanceStats.alertResponseTime : 24},
            efficiencyScore: ${performanceStats != null ? performanceStats.efficiencyScore : 85}
        }
    };

    console.log("Dashboard real data loaded:", dashboardData);

    // Refresh button
    document.getElementById('refreshBtn').addEventListener('click', function() {
        this.classList.add('refreshing');
        setTimeout(() => {
            location.reload();
        }, 1000);
    });

    // Initialize charts when DOM is loaded
    document.addEventListener('DOMContentLoaded', function() {
        console.log("Initializing charts with real data...");

        // 1. Category Chart (Pie Chart) - USING REAL DATA
        const categoryCtx = document.getElementById('categoryChart');
        if (categoryCtx) {
            try {
                // Convert categories object to arrays
                const categories = dashboardData.categories;
                const labels = [];
                const dataValues = [];
                const colors = [
                    '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0',
                    '#9966FF', '#FF9F40', '#8AC926', '#FF6B6B',
                    '#48CAE4', '#52B788', '#FFD166', '#EF476F'
                ];

                let colorIndex = 0;
                for (const category in categories) {
                    if (categories.hasOwnProperty(category)) {
                        labels.push(category);
                        dataValues.push(categories[category]);
                        colorIndex++;
                    }
                }

                // If no real data, show message
                if (labels.length === 0) {
                    categoryCtx.parentElement.innerHTML = '<div style="color: #888; text-align: center; padding: 50px;">Aucune donnée de catégorie disponible</div>';
                } else {
                    new Chart(categoryCtx.getContext('2d'), {
                        type: 'pie',
                        data: {
                            labels: labels,
                            datasets: [{
                                data: dataValues,
                                backgroundColor: colors.slice(0, labels.length),
                                borderWidth: 2,
                                borderColor: '#222222'
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    position: 'right',
                                    labels: {
                                        color: '#cccccc',
                                        font: {
                                            size: 11
                                        }
                                    }
                                },
                                title: {
                                    display: true,
                                    text: 'Ingrédients par Catégorie (' + dataValues.reduce((a, b) => a + b, 0) + ' total)',
                                    color: '#ffffff',
                                    font: {
                                        size: 14
                                    }
                                }
                            }
                        }
                    });
                    console.log("Real pie chart created with", labels.length, "categories");
                }
            } catch (error) {
                console.error("Error creating real pie chart:", error);
                categoryCtx.parentElement.innerHTML = '<div style="color: #ff5252; text-align: center; padding: 50px;">Erreur: ' + error.message + '</div>';
            }
        }

        // 2. Timeline Chart - USING REAL DATA
        const timelineContainer = document.getElementById('expirationTimeline');
        if (timelineContainer) {
            try {
                const timeline = dashboardData.timeline;
                timelineContainer.innerHTML = '';

                if (Object.keys(timeline).length === 0) {
                    timelineContainer.innerHTML = '<div style="color: #888; text-align: center; padding: 50px;">Aucune donnée de timeline</div>';
                } else {
                    // Convert timeline object to arrays
                    const days = [];
                    const values = [];

                    for (const day in timeline) {
                        if (timeline.hasOwnProperty(day)) {
                            days.push(day);
                            values.push(timeline[day]);
                        }
                    }

                    // Find max value for scaling
                    let maxValue = 0;
                    for (let i = 0; i < values.length; i++) {
                        if (values[i] > maxValue) {
                            maxValue = values[i];
                        }
                    }

                    // Create timeline bars
                    for (let i = 0; i < days.length; i++) {
                        const day = days[i];
                        const value = values[i];
                        const height = Math.max(30, (value / (maxValue || 1)) * 120);
                        let colorClass = 'info';

                        if (value > 15) {
                            colorClass = 'critical';
                        } else if (value > 8) {
                            colorClass = 'warning';
                        }

                        const dayDiv = document.createElement('div');
                        dayDiv.className = 'timeline-day';
                        dayDiv.innerHTML = '\
                        <div class="timeline-bar ' + colorClass + '" style="height: ' + height + 'px;">\
                            <span class="timeline-value">' + value + '</span>\
                        </div>\
                        <span class="timeline-label">' + day + '</span>\
                    ';

                        timelineContainer.appendChild(dayDiv);
                    }
                    console.log("Real timeline created with", days.length, "days");
                }
            } catch (error) {
                console.error("Error creating real timeline:", error);
                timelineContainer.innerHTML = '<div style="color: #ff5252; text-align: center; padding: 20px;">Erreur de timeline</div>';
            }
        }

        // 3. Restaurant Map - USING REAL DATA - FILTERED TO SHOW ONLY RESTAURANTS WITH ALERTS
        const restaurantMap = document.getElementById('restaurantMap');
        if (restaurantMap) {
            try {
                const restaurants = dashboardData.restaurants;
                restaurantMap.innerHTML = '';

                if (!restaurants || restaurants.length === 0) {
                    restaurantMap.innerHTML = '<div style="color: #888; text-align: center; padding: 30px; grid-column: 1 / -1;">Aucun restaurant avec alertes</div>';
                } else {
                    // Filter restaurants to show only those with alerts (critical or warning)
                    let hasRestaurantsWithAlerts = false;

                    for (let i = 0; i < restaurants.length; i++) {
                        const restaurant = restaurants[i];
                        const criticalCount = restaurant.criticalCount || 0;
                        const warningCount = restaurant.warningCount || 0;
                        const totalAlerts = criticalCount + warningCount;

                        // Only show restaurants with alerts (critical or warning)
                        if (totalAlerts > 0) {
                            hasRestaurantsWithAlerts = true;
                            const alertLevel = restaurant.alertLevel || 'warning'; // Default to warning if has alerts but no level

                            const card = document.createElement('div');
                            card.className = 'restaurant-card ' + alertLevel;
                            card.innerHTML = '\
                                <div class="alert-count">' + totalAlerts + '</div>\
                                <div style="font-size: 14px; font-weight: 500; margin-bottom: 5px;">' + restaurant.name + '</div>\
                                <div class="alert-level-badge alert-' + alertLevel + '">\
                                    <i class="fas ' + (alertLevel === 'critical' ? 'fa-fire' : 'fa-exclamation-triangle') + '"></i>\
                                    ' + (alertLevel === 'critical' ? 'CRITIQUE' : 'AVERTISSEMENT') + '\
                                </div>\
                                <div style="margin-top: 8px; font-size: 12px; color: #888888;">\
                                    <span style="color: #ff5252;">' + criticalCount + ' critique(s)</span><br>\
                                    <span style="color: #ff9800;">' + warningCount + ' avertissement(s)</span>\
                                </div>\
                            ';

                            restaurantMap.appendChild(card);
                        }
                    }

                    // If no restaurants have alerts, show a message
                    if (!hasRestaurantsWithAlerts) {
                        restaurantMap.innerHTML = '<div style="color: #00c853; text-align: center; padding: 50px; grid-column: 1 / -1;">\
                            <i class="fas fa-check-circle" style="font-size: 48px; margin-bottom: 15px;"></i>\
                            <h4 style="color: #00c853; margin-bottom: 10px;">Aucune alerte active</h4>\
                            <p style="color: #888888;">Tous les restaurants sont sous contrôle</p>\
                        </div>';
                        console.log("No restaurants with alerts found");
                    } else {
                        console.log("Restaurant map created with restaurants that have alerts");
                    }
                }
            } catch (error) {
                console.error("Error creating restaurant map:", error);
                restaurantMap.innerHTML = '<div style="color: #ff5252; text-align: center; padding: 30px; grid-column: 1 / -1;">Erreur de chargement des données restaurants</div>';
            }
        }

        // Update metrics with real data
        updateMetricsWithRealData();

        // Check if Chart.js loaded
        setTimeout(function() {
            if (typeof Chart === 'undefined') {
                console.error("Chart.js not loaded!");
                showErrorMessage("Chart.js n'a pas pu être chargé");
            } else {
                console.log("Chart.js loaded successfully");
            }
        }, 1000);
    });

    // Update metrics with real data
    function updateMetricsWithRealData() {
        try {
            // Update critical alerts count
            const criticalCount = ${criticalAlerts != null ? criticalAlerts.size() : 0};
            document.getElementById('criticalCount').textContent = criticalCount;

            // Update warning alerts count
            const warningCount = ${warningAlerts != null ? warningAlerts.size() : 0};
            document.getElementById('warningCount').textContent = warningCount;

            // Update info alerts count
            const infoCount = ${infoAlerts != null ? infoAlerts.size() : 0};
            document.getElementById('infoCount').textContent = infoCount;

            // Update efficiency score
            const efficiencyScore = ${performanceStats != null ? performanceStats.efficiencyScore : 85};
            document.getElementById('efficiencyScore').textContent = efficiencyScore + '%';

            console.log("Metrics updated:", { criticalCount, warningCount, infoCount, efficiencyScore });
        } catch (error) {
            console.error("Error updating metrics:", error);
        }
    }

    // Show error message
    function showErrorMessage(message) {
        const msg = document.createElement('div');
        msg.style.cssText = 'position: fixed; bottom: 20px; left: 20px; background: rgba(255,87,87,0.9); color: white; padding: 12px 20px; border-radius: 8px; z-index: 10000; max-width: 300px;';
        msg.innerHTML = '<strong>⚠️ ' + message + '</strong><br><small>Vérifiez la console pour plus de détails</small>' +
            '<button onclick="this.parentElement.remove()" style="position: absolute; top: 5px; right: 5px; background: none; border: none; color: white; cursor: pointer;">×</button>';
        document.body.appendChild(msg);
    }

    // Debug function to see what data is available
    function debugData() {
        console.log("=== DASHBOARD DEBUG ===");
        console.log("Categories data:", dashboardData.categories);
        console.log("Timeline data:", dashboardData.timeline);
        console.log("Restaurants data:", dashboardData.restaurants);
        console.log("Performance stats:", dashboardData.performanceStats);

        // Show debug info
        const debugDiv = document.createElement('div');
        debugDiv.style.cssText = 'position: fixed; top: 100px; right: 20px; background: rgba(0,0,0,0.9); color: white; padding: 15px; border-radius: 8px; z-index: 10000; max-width: 400px;';
        debugDiv.innerHTML = '<strong>💡 Données disponibles:</strong><br>' +
            'Catégories: ' + Object.keys(dashboardData.categories).length + '<br>' +
            'Jours timeline: ' + Object.keys(dashboardData.timeline).length + '<br>' +
            'Restaurants: ' + dashboardData.restaurants.length + '<br>' +
            'Score efficacité: ' + dashboardData.performanceStats.efficiencyScore + '%' +
            '<button onclick="this.parentElement.remove()" style="position: absolute; top: 5px; right: 5px; background: none; border: none; color: white; cursor: pointer;">×</button>';
        document.body.appendChild(debugDiv);
    }
</script>

</body>
</html>