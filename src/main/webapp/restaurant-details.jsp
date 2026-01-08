<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${restaurant.name} | Détails Restaurant</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

        /* Header Navigation */
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

        /* Restaurant Header */
        .restaurant-header {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(220, 0, 0, 0.15);
            border: 1px solid rgba(255, 0, 0, 0.2);
            position: relative;
            overflow: hidden;
        }

        .restaurant-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent 30%, rgba(255, 0, 0, 0.05) 50%, transparent 70%);
            transform: rotate(30deg);
            animation: shimmer 3s infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%) rotate(30deg); }
            100% { transform: translateX(100%) rotate(30deg); }
        }

        .header-content {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }

        .restaurant-title {
            font-size: 32px;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 15px;
        }

        .restaurant-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .restaurant-badge i {
            color: #ff3333;
        }

        .status-badge {
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .status-active {
            background: rgba(0, 200, 83, 0.15);
            color: #00c853;
            border: 1px solid rgba(0, 200, 83, 0.2);
        }

        .status-inactive {
            background: rgba(255, 82, 82, 0.15);
            color: #ff5252;
            border: 1px solid rgba(255, 82, 82, 0.2);
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
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

        .btn-secondary {
            background: rgba(255, 255, 255, 0.05);
            color: #cccccc;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
            border-color: rgba(255, 0, 0, 0.3);
        }

        .btn-warning {
            background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
            color: white;
        }

        .btn-warning:hover {
            background: linear-gradient(135deg, #ffb74d 0%, #ff9800 100%);
            box-shadow: 0 4px 15px rgba(255, 152, 0, 0.2);
        }

        .btn-primary {
            background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #ff3333 0%, #e60000 100%);
            box-shadow: 0 4px 15px rgba(255, 0, 0, 0.2);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ff5252 0%, #d32f2f 100%);
            color: white;
        }

        .btn-danger:hover {
            background: linear-gradient(135deg, #ff867f 0%, #ff5252 100%);
            box-shadow: 0 4px 15px rgba(255, 82, 82, 0.2);
        }

        /* Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        /* Card Styling */
        .card {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(220, 0, 0, 0.15);
            border-color: rgba(255, 0, 0, 0.2);
        }

        .card h3 {
            color: #ffffff;
            font-size: 20px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(255, 0, 0, 0.3);
        }

        .card h3 i {
            color: #ff3333;
        }

        /* Info Rows */
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            color: #888888;
            font-weight: 500;
            font-size: 14px;
        }

        .info-value {
            color: #ffffff;
            font-weight: 600;
            font-size: 16px;
        }

        /* Stock Container */
        .stock-container {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .stock-container h3 {
            color: #ffffff;
            font-size: 20px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(255, 0, 0, 0.3);
        }

        .stock-container h3 i {
            color: #ff3333;
        }

        /* Stock Table */
        .stock-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
        }

        .stock-table th {
            background: rgba(255, 0, 0, 0.1);
            padding: 16px;
            text-align: left;
            font-weight: 600;
            color: #ffffff;
            border-bottom: 2px solid rgba(255, 0, 0, 0.3);
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stock-table td {
            padding: 16px;
            color: #cccccc;
            font-size: 14px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .stock-table tr:hover {
            background: rgba(255, 0, 0, 0.05);
        }

        /* Alert Badges */
        .alert-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .alert-critical {
            background: rgba(255, 82, 82, 0.15);
            color: #ff5252;
            border: 1px solid rgba(255, 82, 82, 0.2);
        }

        .alert-warning {
            background: rgba(255, 152, 0, 0.15);
            color: #ff9800;
            border: 1px solid rgba(255, 152, 0, 0.2);
        }

        .alert-info {
            background: rgba(33, 150, 243, 0.15);
            color: #2196F3;
            border: 1px solid rgba(33, 150, 243, 0.2);
        }

        /* Ingredient Cell */
        .ingredient-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .ingredient-icon {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            background: rgba(255, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ff3333;
            font-size: 16px;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666666;
        }

        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            color: #333333;
        }

        .empty-state h3 {
            color: #ffffff;
            margin-bottom: 10px;
            font-size: 24px;
        }

        .empty-state p {
            color: #888888;
            margin-bottom: 30px;
            font-size: 16px;
        }

        /* Alerts Container */
        .alerts-container {
            background: rgba(20, 20, 20, 0.9);
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid rgba(255, 82, 82, 0.3);
        }

        .alerts-container h3 {
            color: #ffffff;
            font-size: 20px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(255, 82, 82, 0.5);
        }

        .alerts-container h3 i {
            color: #ff5252;
        }

        .alert-item {
            padding: 20px;
            background: rgba(255, 82, 82, 0.1);
            border-radius: 10px;
            border: 1px solid rgba(255, 82, 82, 0.2);
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }

        .alert-item:hover {
            background: rgba(255, 82, 82, 0.15);
            border-color: rgba(255, 82, 82, 0.3);
            transform: translateX(5px);
        }

        .alert-item:last-child {
            margin-bottom: 0;
        }

        .alert-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .alert-title {
            color: #ffffff;
            font-weight: 600;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .alert-title i {
            color: #ff5252;
        }

        .alert-date {
            color: #ff9999;
            font-size: 12px;
        }

        .alert-message {
            color: #cccccc;
            font-size: 14px;
            line-height: 1.5;
        }

        /* Animations */
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

        .card, .stock-container, .restaurant-header, .alerts-container {
            animation: fadeIn 0.5s ease-out;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                text-align: center;
            }

            .header nav {
                justify-content: center;
            }

            .header-content {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }

            .action-buttons {
                flex-direction: column;
            }

            .action-buttons .btn {
                width: 100%;
                justify-content: center;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .stock-table {
                display: block;
                overflow-x: auto;
            }

            .restaurant-badge {
                flex-wrap: wrap;
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .restaurant-title {
                font-size: 24px;
            }

            .restaurant-header {
                padding: 25px;
            }

            .card, .stock-container, .alerts-container {
                padding: 20px;
            }
        }
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
            <a href="restaurants" class="active"><i class="fas fa-store"></i> Restaurants</a>
            <a href="stock"><i class="fas fa-boxes"></i> Stocks</a>
        </nav>
    </header>

    <!-- Restaurant Header -->
    <div class="restaurant-header">
        <div class="header-content">
            <div>
                <h2 class="restaurant-title">${restaurant.name}</h2>
                <div style="display: flex; flex-wrap: wrap; gap: 10px; align-items: center;">
                    <span class="restaurant-badge">
                        <i class="fas fa-map-marker-alt"></i>
                        ${restaurant.city}
                    </span>
                    <c:if test="${not empty restaurant.address}">
                        <span class="restaurant-badge">
                            <i class="fas fa-location-dot"></i>
                            ${restaurant.address}
                        </span>
                    </c:if>
                </div>
            </div>
            <div class="status-badge ${restaurant.isActive ? 'status-active' : 'status-inactive'}">
                <i class="fas fa-${restaurant.isActive ? 'check-circle' : 'times-circle'}"></i>
                ${restaurant.isActive ? 'Actif' : 'Inactif'}
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="action-buttons">
        <a href="restaurants" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Retour à la liste
        </a>
        <a href="edit-restaurant?id=${restaurant.id}" class="btn btn-warning">
            <i class="fas fa-edit"></i> Modifier
        </a>
        <a href="restaurant-stock?restaurantId=${restaurant.id}" class="btn btn-primary">
            <i class="fas fa-boxes"></i> Gérer le stock
        </a>
        <button class="btn btn-danger" onclick="deleteRestaurant(${restaurant.id})">
            <i class="fas fa-trash"></i> Supprimer
        </button>
    </div>

    <!-- Information Grid -->
    <div class="info-grid">
        <!-- Informations de contact -->
        <div class="card">
            <h3><i class="fas fa-address-book"></i> Contact</h3>
            <div class="info-row">
                <span class="info-label">Téléphone</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty restaurant.phone}">${restaurant.phone}</c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Email</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty restaurant.email}">${restaurant.email}</c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>

        <!-- Horaires -->
        <div class="card">
            <h3><i class="fas fa-clock"></i> Horaires</h3>
            <div class="info-row">
                <span class="info-label">Ouverture</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty restaurant.openingTime}">${restaurant.openingTime}</c:when>
                        <c:otherwise>11:00</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Fermeture</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty restaurant.closingTime}">${restaurant.closingTime}</c:when>
                        <c:otherwise>22:00</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Capacité</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${not empty restaurant.capacity}">${restaurant.capacity} places</c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>

        <!-- Informations générales -->
        <div class="card">
            <h3><i class="fas fa-info-circle"></i> Informations</h3>
            <div class="info-row">
                <span class="info-label">ID Restaurant</span>
                <span class="info-value">#${restaurant.id}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Ville</span>
                <span class="info-value">${restaurant.city}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Statut</span>
                <span class="info-value">
                    <span class="alert-badge ${restaurant.isActive ? 'alert-info' : 'alert-warning'}">
                        <i class="fas fa-${restaurant.isActive ? 'check-circle' : 'times-circle'}"></i>
                        ${restaurant.isActive ? 'Actif' : 'Inactif'}
                    </span>
                </span>
            </div>
        </div>
    </div>

    <!-- Stock Overview -->
    <div class="stock-container">
        <h3><i class="fas fa-boxes"></i> Vue d'ensemble du stock</h3>

        <c:choose>
            <c:when test="${not empty stockList && stockList.size() > 0}">
                <table class="stock-table">
                    <thead>
                    <tr>
                        <th>Ingrédient</th>
                        <th>Quantité</th>
                        <th>Expiration</th>
                        <th>Statut</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="stock" items="${stockList}">
                        <c:if test="${stock.ingredient != null}">
                            <tr>
                                <td>
                                    <div class="ingredient-cell">
                                        <div class="ingredient-icon">
                                            <i class="fas
                                                <c:choose>
                                                    <c:when test="${stock.ingredient.category eq 'Viandes'}">fa-drumstick-bite</c:when>
                                                    <c:when test="${stock.ingredient.category eq 'Légumes'}">fa-leaf</c:when>
                                                    <c:when test="${stock.ingredient.category eq 'Produits laitiers'}">fa-cheese</c:when>
                                                    <c:when test="${stock.ingredient.category eq 'Épicerie'}">fa-wheat-awn</c:when>
                                                    <c:when test="${stock.ingredient.category eq 'Boissons'}">fa-wine-bottle</c:when>
                                                    <c:otherwise>fa-carrot</c:otherwise>
                                                </c:choose>">
                                            </i>
                                        </div>
                                        <div>
                                            <strong style="color: #ffffff;">${stock.ingredient.name}</strong>
                                            <div style="font-size: 12px; color: #888888;">${stock.ingredient.category}</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${stock.quantity}" maxFractionDigits="2"/>
                                    <span style="font-size: 12px; color: #888888;">${stock.ingredient.unit}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${stock.expirationDate != null}">
                                            <fmt:formatDate value="${stock.expirationDate}" pattern="dd/MM/yyyy"/>
                                            <c:set var="now" value="<%= new java.util.Date() %>" />
                                            <c:set var="daysDiff" value="${(stock.expirationDate.time - now.time) / (1000 * 60 * 60 * 24)}" />
                                            <c:if test="${daysDiff < 3}">
                                                    <span class="alert-badge alert-critical" style="margin-left: 10px; font-size: 11px;">
                                                        <i class="fas fa-exclamation-circle"></i> ${Math.round(daysDiff)}j
                                                    </span>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${stock.quantity < 2}">
                                            <span class="alert-badge alert-critical">Critique</span>
                                        </c:when>
                                        <c:when test="${stock.quantity < 5}">
                                            <span class="alert-badge alert-warning">Bas</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="alert-badge alert-info">OK</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-box-open"></i>
                    <h3>Aucun stock trouvé</h3>
                    <p>Ce restaurant n'a pas encore de stock associé.</p>
                    <a href="restaurant-stock?restaurantId=${restaurant.id}" class="btn btn-primary" style="margin-top: 20px;">
                        <i class="fas fa-plus-circle"></i> Ajouter du stock
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Alertes et notifications -->
    <c:if test="${not empty alerts && alerts.size() > 0}">
        <div class="alerts-container">
            <h3><i class="fas fa-exclamation-triangle"></i> Alertes (${alerts.size()})</h3>
            <div style="display: flex; flex-direction: column; gap: 15px;">
                <c:forEach var="alert" items="${alerts}">
                    <div class="alert-item">
                        <div class="alert-header">
                            <div class="alert-title">
                                <i class="fas fa-exclamation-circle"></i> ${alert.title}
                            </div>
                            <div class="alert-date">${alert.date}</div>
                        </div>
                        <div class="alert-message">${alert.message}</div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>

<script>
    function deleteRestaurant(id) {
        if (confirm('Êtes-vous sûr de vouloir supprimer ce restaurant ? Cette action supprimera également tout le stock associé.')) {
            window.location.href = 'delete-restaurant?id=' + id;
        }
    }

    // Add animation delays to table rows and alert items
    document.addEventListener('DOMContentLoaded', function() {
        const tableRows = document.querySelectorAll('.stock-table tbody tr');
        tableRows.forEach((row, index) => {
            row.style.animationDelay = `${index * 0.05}s`;
        });

        const alertItems = document.querySelectorAll('.alert-item');
        alertItems.forEach((item, index) => {
            item.style.animationDelay = `${index * 0.05}s`;
        });

        // Compter les stocks critiques
        const criticalStocks = document.querySelectorAll('.alert-critical');
        if (criticalStocks.length > 0) {
            console.log(`${criticalStocks.length} stocks critiques détectés`);
        }
    });
</script>
</body>
</html>