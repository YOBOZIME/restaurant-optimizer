<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Pertes | Restaurant Supply Chain Optimizer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Apply the same base styles as the first page */
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

        /* Header Navigation - Same as first page */
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

        /* Page Header - Same style */
        .waste-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid rgba(255, 0, 0, 0.3);
        }

        .waste-header h2 {
            color: #ffffff;
            font-size: 28px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .waste-header h2 i {
            color: #ff3333;
        }

        .waste-header p {
            color: #aaaaaa;
            margin-top: 8px;
            font-size: 15px;
        }

        /* Buttons - Same styles */
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

        .btn-sm {
            padding: 8px 16px;
            font-size: 13px;
        }

        .btn-success {
            background: linear-gradient(135deg, #00c853 0%, #007e33 100%);
            color: white;
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #00e676 0%, #008f40 100%);
        }

        .btn-warning {
            background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
            color: white;
        }

        .btn-warning:hover {
            background: linear-gradient(135deg, #ffb74d 0%, #ff9800 100%);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ff5252 0%, #d32f2f 100%);
            color: white;
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #ff867f 0%, #ff5252 100%);
        }

        /* Card Styling - Same as other pages */
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

        /* Updated Waste Stats */
        .waste-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.03);
            border-radius: 10px;
            padding: 25px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            background: rgba(255, 0, 0, 0.05);
            border-color: rgba(255, 0, 0, 0.2);
            transform: translateY(-3px);
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            margin: 15px 0;
            background: linear-gradient(135deg, #ff0000 0%, #ff6666 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-label {
            color: #aaaaaa;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Updated Waste Analysis */
        .waste-analysis {
            background: linear-gradient(135deg, rgba(255, 82, 82, 0.2) 0%, rgba(156, 39, 176, 0.2) 100%);
            color: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid rgba(255, 82, 82, 0.3);
            backdrop-filter: blur(10px);
        }

        .waste-value {
            font-size: 28px;
            font-weight: bold;
            background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        /* Updated Waste Reasons Badges */
        .reason-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            border: 1px solid;
        }

        .reason-spoiled {
            background: rgba(255, 82, 82, 0.15);
            color: #ff5252;
            border-color: rgba(255, 82, 82, 0.3);
        }
        .reason-overprepared {
            background: rgba(255, 152, 0, 0.15);
            color: #ff9800;
            border-color: rgba(255, 152, 0, 0.3);
        }
        .reason-expired {
            background: rgba(33, 150, 243, 0.15);
            color: #2196F3;
            border-color: rgba(33, 150, 243, 0.3);
        }
        .reason-damaged {
            background: rgba(156, 39, 176, 0.15);
            color: #9C27B0;
            border-color: rgba(156, 39, 176, 0.3);
        }

        /* Updated Cost Display */
        .cost-display {
            font-weight: bold;
            font-size: 18px;
            color: #ff5252;
        }

        /* Updated Waste Trend */
        .waste-trend {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
            margin-left: 10px;
        }

        .trend-up { color: #ff5252; }
        .trend-down { color: #00c853; }

        /* Updated Chart Container */
        .chart-container {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        /* Updated Date Filter */
        .date-filter {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            align-items: center;
            flex-wrap: wrap;
        }

        .date-option {
            padding: 8px 15px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
            color: #cccccc;
        }

        .date-option:hover, .date-option.active {
            background: rgba(255, 0, 0, 0.15);
            color: #ffffff;
            border-color: rgba(255, 0, 0, 0.3);
        }

        /* Updated Insight Items */
        .insight-item {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 8px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.3s ease;
        }

        .insight-item:hover {
            background: rgba(255, 255, 255, 0.05);
            border-color: rgba(255, 255, 255, 0.1);
        }

        .insight-item i {
            color: #ff9800;
            font-size: 18px;
        }

        .insight-item span {
            flex: 1;
            color: #cccccc;
        }

        /* Updated Reduction Goal */
        .reduction-goal {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
        }

        .goal-bar {
            flex: 1;
            height: 8px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
            overflow: hidden;
        }

        .goal-fill {
            height: 100%;
            background: linear-gradient(135deg, #00c853 0%, #007e33 100%);
            border-radius: 4px;
        }

        /* Updated Waste Details */
        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        /* Updated Waste Icons */
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

        .icon-spoiled { background: linear-gradient(135deg, #ff5252 0%, #d32f2f 100%); }
        .icon-overprepared { background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%); }
        .icon-expired { background: linear-gradient(135deg, #2196F3 0%, #0d47a1 100%); }
        .icon-damaged { background: linear-gradient(135deg, #9C27B0 0%, #6a1b9a 100%); }

        /* Updated Table Styles */
        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead tr {
            background: rgba(255, 255, 255, 0.03);
        }

        th {
            padding: 12px;
            text-align: left;
            color: #cccccc;
            font-weight: 600;
            border-bottom: 2px solid rgba(255, 255, 255, 0.05);
        }

        td {
            padding: 12px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        tbody tr:hover {
            background: rgba(255, 255, 255, 0.02);
        }

        /* Headers */
        h3 {
            color: #ffffff;
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        h3 i {
            color: #ff3333;
        }

        h4 {
            color: #ffffff;
            font-size: 16px;
            margin-bottom: 15px;
        }

        /* Animation */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card, .stat-card, .waste-analysis, .chart-container {
            animation: fadeIn 0.5s ease-out;
        }

        /* Helper text */
        .helper-text {
            font-size: 12px;
            color: #888888;
            margin-top: 5px;
        }

        /* Text colors */
        .text-warning { color: #ff9800; }
        .text-success { color: #00c853; }
        .text-info { color: #2196F3; }
        .text-danger { color: #ff5252; }
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
            <p>Analysez et réduisez le gaspillage alimentaire</p>
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
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
            <div>
                <div class="waste-value">
                    <fmt:formatNumber value="${totalWasteCost}" type="currency" currencyCode="EUR"/>
                </div>
                <div style="font-size: 14px; color: rgba(255, 255, 255, 0.7);">Coût total (7 jours)</div>
                <div class="waste-trend trend-down">
                    <i class="fas fa-arrow-down"></i> 12% vs semaine dernière
                </div>
            </div>
            <div>
                <div class="waste-value">${wasteReduction}%</div>
                <div style="font-size: 14px; color: rgba(255, 255, 255, 0.7);">Réduction cible atteinte</div>
                <div class="reduction-goal">
                    <div class="goal-bar">
                        <div class="goal-fill" style="width: ${wasteReduction}%;"></div>
                    </div>
                    <span style="font-size: 12px; color: rgba(255, 255, 255, 0.7);">${wasteReduction}% / 100%</span>
                </div>
            </div>
            <div>
                <div class="waste-value">${predictionAccuracy}%</div>
                <div style="font-size: 14px; color: rgba(255, 255, 255, 0.7);">Précision prédictive</div>
                <div class="helper-text">
                    Basée sur l'historique des 30 derniers jours
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Stats -->
    <div class="waste-stats">
        <div class="stat-card">
            <div class="stat-value">${wasteLogs.size()}</div>
            <div class="stat-label">Pertes enregistrées</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <fmt:formatNumber value="${wasteLogs.stream().map(wl -> wl.quantity).sum()}" maxFractionDigits="2"/>
            </div>
            <div class="stat-label">Quantité totale (kg)</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <c:set var="avgPerDay" value="${wasteLogs.size() > 0 ? wasteLogs.stream().map(wl -> wl.quantity).sum() / 7 : 0}" />
                <fmt:formatNumber value="${avgPerDay}" maxFractionDigits="2"/>
            </div>
            <div class="stat-label">Moyenne par jour</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">${inventoryTurnover}</div>
            <div class="stat-label">Rotation/mois</div>
        </div>
    </div>

    <!-- Date Filter -->
    <div class="card">
        <h3><i class="fas fa-calendar-alt"></i> Période d'analyse</h3>
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
        <h3><i class="fas fa-chart-pie"></i> Répartition par cause</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
            <div>
                <h4>Top causes de gaspillage</h4>
                <div>
                    <c:forEach var="entry" items="${wasteByIngredient}">
                        <div class="detail-row">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <div style="width: 10px; height: 10px; border-radius: 50%; background: #2196F3;"></div>
                                <span>${entry.key}</span>
                            </div>
                            <span style="font-weight: 500; color: #ffffff;">${entry.value}%</span>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <div>
                <h4>Impact financier</h4>
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
            <table>
                <thead>
                <tr>
                    <th>Date</th>
                    <th>Ingrédient</th>
                    <th>Restaurant</th>
                    <th>Quantité</th>
                    <th>Cause</th>
                    <th>Coût</th>
                    <th>Notes</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="waste" items="${wasteLogs}">
                    <tr>
                        <td>
                            <fmt:formatDate value="${waste.date}" pattern="dd/MM/yyyy"/>
                        </td>
                        <td>
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
                                    <strong style="color: #ffffff;">${waste.ingredient.name}</strong>
                                    <div class="helper-text">${waste.ingredient.category}</div>
                                </div>
                            </div>
                        </td>
                        <td style="color: #cccccc;">${waste.restaurant.name}</td>
                        <td>
                            <strong style="color: #ffffff;">
                                <fmt:formatNumber value="${waste.quantity}" maxFractionDigits="2"/>
                            </strong>
                            <div class="helper-text">${waste.ingredient.unit}</div>
                        </td>
                        <td>
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
                        <td>
                            <span class="cost-display">
                                <fmt:formatNumber value="${waste.quantity * waste.ingredient.currentPrice}"
                                                  type="currency" currencyCode="EUR"/>
                            </span>
                        </td>
                        <td>
                            <c:if test="${not empty waste.notes}">
                                <div style="max-width: 200px;" class="helper-text">
                                        ${waste.notes}
                                </div>
                            </c:if>
                        </td>
                        <td>
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
        <h3><i class="fas fa-lightbulb"></i> Recommandations</h3>
        <div>
            <c:forEach var="recommendation" items="${recommendations}">
                <div class="insight-item">
                    <i class="fas
                        <c:choose>
                            <c:when test="${recommendation.contains('⚠️')}">fa-exclamation-triangle text-warning</c:when>
                            <c:when test="${recommendation.contains('📈')}">fa-chart-line text-success</c:when>
                            <c:when test="${recommendation.contains('📦')}">fa-box text-info</c:when>
                            <c:otherwise>fa-info-circle text-info</c:otherwise>
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