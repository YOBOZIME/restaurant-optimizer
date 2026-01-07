<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Pertes | Restaurant Supply Chain Optimizer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .waste-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .waste-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center;
        }

        .reason-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            margin-right: 5px;
        }

        .reason-spoiled { background: #f8d7da; color: #721c24; }
        .reason-overprepared { background: #fff3cd; color: #856404; }
        .reason-expired { background: #d1ecf1; color: #0c5460; }
        .reason-damaged { background: #cce5ff; color: #004085; }

        .cost-display {
            font-weight: bold;
            font-size: 18px;
        }

        .waste-trend {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
            margin-left: 10px;
        }

        .trend-up { color: #F44336; }
        .trend-down { color: #4CAF50; }

        .chart-container {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .date-filter {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            align-items: center;
            flex-wrap: wrap;
        }

        .date-option {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
        }

        .date-option:hover, .date-option.active {
            background: #2196F3;
            color: white;
            border-color: #2196F3;
        }

        .waste-analysis {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .insight-item {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
            padding: 10px;
            background: rgba(255,255,255,0.1);
            border-radius: 5px;
        }

        .waste-value {
            font-size: 20px;
            font-weight: bold;
            color: #FFD700;
        }

        .reduction-goal {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
        }

        .goal-bar {
            flex: 1;
            height: 10px;
            background: rgba(255,255,255,0.2);
            border-radius: 5px;
            overflow: hidden;
        }

        .goal-fill {
            height: 100%;
            background: #4CAF50;
            border-radius: 5px;
        }

        .waste-details {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-top: 20px;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .waste-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: white;
        }

        .icon-spoiled { background: #F44336; }
        .icon-overprepared { background: #FF9800; }
        .icon-expired { background: #2196F3; }
        .icon-damaged { background: #9C27B0; }
    </style>
</head>
<body>
<div class="container">
    <!-- Header -->
    <header class="header">
        <h1><i class="fas fa-chart-network"></i> Restaurant Supply Chain Optimizer</h1>
        <nav>
            <a href="dashboard"><i class="fas fa-home"></i> Dashboard</a>
            <a href="ingredients"><i class="fas fa-carrot"></i> Ingrédients</a>
            <a href="restaurants"><i class="fas fa-store"></i> Restaurants</a>
            <a href="stock"><i class="fas fa-boxes"></i> Stocks</a>
            <a href="waste" class="active"><i class="fas fa-trash"></i> Pertes</a>
        </nav>
    </header>

    <!-- Page Header -->
    <div class="waste-header">
        <div>
            <h2><i class="fas fa-trash"></i> Gestion des Pertes</h2>
            <p style="color: #666; margin-top: 5px;">Analysez et réduisez le gaspillage alimentaire</p>
        </div>
        <button class="btn btn-success" onclick="openWasteLogForm()">
            <i class="fas fa-plus-circle"></i> Loguer une Perte
        </button>
    </div>

    <!-- Waste Overview -->
    <div class="waste-analysis">
        <h3 style="color: white; margin-bottom: 20px;">
            <i class="fas fa-chart-line"></i> Analyse du Gaspillage
        </h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
            <div>
                <div class="waste-value">
                    <fmt:formatNumber value="${totalWasteCost}" type="currency" currencyCode="EUR"/>
                </div>
                <div style="font-size: 14px; opacity: 0.9;">Coût total (7 jours)</div>
                <div class="waste-trend trend-down">
                    <i class="fas fa-arrow-down"></i> 12% vs semaine dernière
                </div>
            </div>
            <div>
                <div class="waste-value">${wasteReduction}%</div>
                <div style="font-size: 14px; opacity: 0.9;">Réduction cible atteinte</div>
                <div class="reduction-goal">
                    <div class="goal-bar">
                        <div class="goal-fill" style="width: ${wasteReduction}%;"></div>
                    </div>
                    <span>${wasteReduction}% / 100%</span>
                </div>
            </div>
            <div>
                <div class="waste-value">${predictionAccuracy}%</div>
                <div style="font-size: 14px; opacity: 0.9;">Précision prédictive</div>
                <div style="font-size: 12px; margin-top: 5px;">
                    Basée sur l'historique des 30 derniers jours
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Stats -->
    <div class="waste-stats">
        <div class="stat-card">
            <div style="font-size: 32px; font-weight: bold; color: #F44336;">
                ${wasteLogs.size()}
            </div>
            <div style="color: #666;">Pertes enregistrées</div>
        </div>
        <div class="stat-card">
            <div style="font-size: 32px; font-weight: bold; color: #FF9800;">
                <fmt:formatNumber value="${wasteLogs.stream().map(wl -> wl.quantity).sum()}" maxFractionDigits="2"/>
            </div>
            <div style="color: #666;">Quantité totale (kg)</div>
        </div>
        <div class="stat-card">
            <div style="font-size: 32px; font-weight: bold; color: #2196F3;">
                <c:set var="avgPerDay" value="${wasteLogs.size() > 0 ? wasteLogs.stream().map(wl -> wl.quantity).sum() / 7 : 0}" />
                <fmt:formatNumber value="${avgPerDay}" maxFractionDigits="2"/>
            </div>
            <div style="color: #666;">Moyenne par jour</div>
        </div>
        <div class="stat-card">
            <div style="font-size: 32px; font-weight: bold; color: #4CAF50;">
                ${inventoryTurnover}
            </div>
            <div style="color: #666;">Rotation/mois</div>
        </div>
    </div>

    <!-- Date Filter -->
    <div class="card">
        <h3 style="margin-bottom: 15px;"><i class="fas fa-calendar-alt"></i> Période d'analyse</h3>
        <div class="date-filter">
            <span class="date-option active" onclick="filterByDate('7days')">7 derniers jours</span>
            <span class="date-option" onclick="filterByDate('30days')">30 derniers jours</span>
            <span class="date-option" onclick="filterByDate('90days')">90 derniers jours</span>
            <span class="date-option" onclick="filterByDate('month')">Ce mois-ci</span>
            <span class="date-option" onclick="filterByDate('year')">Cette année</span>
        </div>
    </div>

    <!-- Waste Reasons Chart -->
    <div class="chart-container">
        <h3 style="margin-bottom: 15px;"><i class="fas fa-chart-pie"></i> Répartition par cause</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
            <div>
                <h4 style="margin-bottom: 10px;">Top causes de gaspillage</h4>
                <div>
                    <c:forEach var="entry" items="${wasteByIngredient}">
                        <div class="detail-row">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <div style="width: 10px; height: 10px; border-radius: 50%; background: #2196F3;"></div>
                                <span>${entry.key}</span>
                            </div>
                            <span style="font-weight: 500;">${entry.value}%</span>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <div>
                <h4 style="margin-bottom: 10px;">Impact financier</h4>
                <div>
                    <c:forEach var="entry" items="${wasteByIngredient}">
                        <div class="detail-row">
                            <span>${entry.key}</span>
                            <span class="cost-display">
                                <fmt:formatNumber value="${entry.value * totalWasteCost / 100}"
                                                  type="currency" currencyCode="EUR"/>
                            </span>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <!-- Waste Logs Table -->
    <div class="card">
        <div style="overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                <tr style="background: #f4f4f4;">
                    <th style="padding: 12px; text-align: left;">Date</th>
                    <th style="padding: 12px; text-align: left;">Ingrédient</th>
                    <th style="padding: 12px; text-align: left;">Restaurant</th>
                    <th style="padding: 12px; text-align: left;">Quantité</th>
                    <th style="padding: 12px; text-align: left;">Cause</th>
                    <th style="padding: 12px; text-align: left;">Coût</th>
                    <th style="padding: 12px; text-align: left;">Notes</th>
                    <th style="padding: 12px; text-align: left;">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="waste" items="${wasteLogs}">
                    <tr>
                        <td style="padding: 12px;">
                            <fmt:formatDate value="${waste.date}" pattern="dd/MM/yyyy"/>
                        </td>
                        <td style="padding: 12px;">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <div class="waste-icon
                                    <c:choose>
                                        <c:when test="${waste.reason eq 'SPOILED'}">icon-spoiled</c:when>
                                        <c:when test="${waste.reason eq 'OVERPREPARED'}">icon-overprepared</c:when>
                                        <c:when test="${waste.reason eq 'EXPIRED'}">icon-expired</c:when>
                                        <c:when test="${waste.reason eq 'DAMAGED'}">icon-damaged</c:when>
                                    </c:choose>">
                                    <i class="fas
                                        <c:choose>
                                            <c:when test="${waste.reason eq 'SPOILED'}">fa-skull-crossbones</c:when>
                                            <c:when test="${waste.reason eq 'OVERPREPARED'}">fa-utensils</c:when>
                                            <c:when test="${waste.reason eq 'EXPIRED'}">fa-calendar-times</c:when>
                                            <c:when test="${waste.reason eq 'DAMAGED'}">fa-truck-loading</c:when>
                                        </c:choose>">
                                    </i>
                                </div>
                                <div>
                                    <strong>${waste.ingredient.name}</strong>
                                    <div style="font-size: 12px; color: #666;">${waste.ingredient.category}</div>
                                </div>
                            </div>
                        </td>
                        <td style="padding: 12px;">${waste.restaurant.name}</td>
                        <td style="padding: 12px;">
                            <strong><fmt:formatNumber value="${waste.quantity}" maxFractionDigits="2"/></strong>
                            <div style="font-size: 12px; color: #666;">${waste.ingredient.unit}</div>
                        </td>
                        <td style="padding: 12px;">
                            <span class="reason-badge
                                <c:choose>
                                    <c:when test="${waste.reason eq 'SPOILED'}">reason-spoiled</c:when>
                                    <c:when test="${waste.reason eq 'OVERPREPARED'}">reason-overprepared</c:when>
                                    <c:when test="${waste.reason eq 'EXPIRED'}">reason-expired</c:when>
                                    <c:when test="${waste.reason eq 'DAMAGED'}">reason-damaged</c:when>
                                </c:choose>">
                                <c:choose>
                                    <c:when test="${waste.reason eq 'SPOILED'}">Détérioré</c:when>
                                    <c:when test="${waste.reason eq 'OVERPREPARED'}">Surproduction</c:when>
                                    <c:when test="${waste.reason eq 'EXPIRED'}">Expiré</c:when>
                                    <c:when test="${waste.reason eq 'DAMAGED'}">Endommagé</c:when>
                                </c:choose>
                            </span>
                        </td>
                        <td style="padding: 12px;">
                            <span class="cost-display" style="color: #F44336;">
                                <fmt:formatNumber value="${waste.quantity * waste.ingredient.currentPrice}"
                                                  type="currency" currencyCode="EUR"/>
                            </span>
                        </td>
                        <td style="padding: 12px;">
                            <c:if test="${not empty waste.notes}">
                                <div style="max-width: 200px; font-size: 12px; color: #666;">
                                        ${waste.notes}
                                </div>
                            </c:if>
                        </td>
                        <td style="padding: 12px;">
                            <div style="display: flex; gap: 8px;">
                                <button class="btn btn-sm btn-warning" onclick="editWasteLog(${waste.id})">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-sm btn-danger" onclick="deleteWasteLog(${waste.id})">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Insights -->
    <div class="card">
        <h3 style="margin-bottom: 15px;"><i class="fas fa-lightbulb"></i> Recommandations</h3>
        <div>
            <c:forEach var="recommendation" items="${recommendations}">
                <div class="insight-item">
                    <i class="fas
                        <c:choose>
                            <c:when test="${recommendation.contains('⚠️')}">fa-exclamation-triangle text-warning</c:when>
                            <c:when test="${recommendation.contains('📈')}">fa-chart-line text-success</c:when>
                            <c:when test="${recommendation.contains('📦')}">fa-box text-info</c:when>
                            <c:otherwise>fa-info-circle</c:otherwise>
                        </c:choose>">
                    </i>
                    <span>${recommendation}</span>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    // Filter functions
    function filterByDate(period) {
        // Update active filter
        document.querySelectorAll('.date-option').forEach(opt => {
            opt.classList.remove('active');
        });
        event.target.classList.add('active');

        // In real app, fetch data for selected period
        console.log('Filtering by period:', period);
    }

    // Action functions
    function openWasteLogForm() {
        alert('Formulaire de log de perte - En construction');
    }

    function editWasteLog(id) {
        alert(`Modification de la perte #${id} - En construction`);
    }

    function deleteWasteLog(id) {
        if (confirm('Êtes-vous sûr de vouloir supprimer cet enregistrement de perte ?')) {
            alert(`Suppression de la perte #${id} - En construction`);
        }
    }

    // Initialize charts (example with Chart.js)
    function initCharts() {
        // This is where you would initialize Chart.js charts
        // For now, it's a placeholder
        console.log('Initializing waste charts...');
    }

    document.addEventListener('DOMContentLoaded', initCharts);
</script>
</body>
</html>