<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails Restaurant | Restaurant Supply Chain Optimizer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .restaurant-header {
            background: linear-gradient(135deg, #2196F3 0%, #21CBF3 100%);
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .restaurant-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 200%;
            background: rgba(255,255,255,0.1);
            transform: rotate(30deg);
        }

        .header-content {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }

        .restaurant-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: rgba(255,255,255,0.2);
            border-radius: 20px;
            font-size: 14px;
            margin-top: 10px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .info-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .info-card h3 {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 10px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #f5f5f5;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            color: #666;
            font-weight: 500;
        }

        .info-value {
            color: #333;
            font-weight: 500;
        }

        .stock-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        .stock-table th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }

        .stock-table td {
            padding: 12px;
            border-bottom: 1px solid #dee2e6;
        }

        .stock-table tr:hover {
            background: #f8f9fa;
        }

        .alert-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .alert-critical { background: #f8d7da; color: #721c24; }
        .alert-warning { background: #fff3cd; color: #856404; }
        .alert-info { background: #d1ecf1; color: #0c5460; }

        .chart-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 48px;
            margin-bottom: 20px;
            color: #dee2e6;
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
            <a href="waste"><i class="fas fa-trash"></i> Pertes</a>
        </nav>
    </header>

    <!-- Restaurant Header -->
    <div class="restaurant-header">
        <div class="header-content">
            <div>
                <h2 style="margin: 0; font-size: 28px;">${restaurant.name}</h2>
                <div class="restaurant-badge">
                    <i class="fas fa-map-marker-alt"></i>
                    <span>${restaurant.city}</span>
                    <c:if test="${not empty restaurant.address}">
                        <span style="margin: 0 5px;">•</span>
                        <span>${restaurant.address}</span>
                    </c:if>
                </div>
            </div>
            <div>
                <span class="restaurant-badge">
                    <i class="fas fa-${restaurant.isActive ? 'check-circle' : 'times-circle'}"></i>
                    ${restaurant.isActive ? 'Actif' : 'Inactif'}
                </span>
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
        <div class="info-card">
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
        <div class="info-card">
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

        <!-- Statistiques -->
        <div class="info-card">
            <h3><i class="fas fa-chart-bar"></i> Statistiques</h3>
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
    <div class="chart-container">
        <h3 style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px;">
            <i class="fas fa-boxes"></i> Vue d'ensemble du stock
        </h3>

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
                                    <div style="display: flex; align-items: center; gap: 10px;">
                                        <div style="width: 32px; height: 32px; border-radius: 8px; background: #f0f0f0; display: flex; align-items: center; justify-content: center;">
                                            <i class="fas fa-carrot"></i>
                                        </div>
                                        <div>
                                            <strong>${stock.ingredient.name}</strong>
                                            <div style="font-size: 12px; color: #666;">${stock.ingredient.category}</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${stock.quantity}" maxFractionDigits="2"/>
                                    <span style="font-size: 12px; color: #666;">${stock.ingredient.unit}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${stock.expirationDate != null}">
                                            <fmt:formatDate value="${stock.expirationDate}" pattern="dd/MM/yyyy"/>
                                            <c:set var="now" value="<%= new java.util.Date() %>" />
                                            <c:set var="daysDiff" value="${(stock.expirationDate.time - now.time) / (1000 * 60 * 60 * 24)}" />
                                            <c:if test="${daysDiff < 3}">
                                                    <span class="alert-badge alert-critical" style="margin-left: 10px;">
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
        <div class="chart-container">
            <h3 style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px; color: #dc3545;">
                <i class="fas fa-exclamation-triangle"></i> Alertes (${alerts.size()})
            </h3>
            <div style="display: flex; flex-direction: column; gap: 10px;">
                <c:forEach var="alert" items="${alerts}">
                    <div style="padding: 15px; background: #f8d7da; border: 1px solid #f5c6cb; border-radius: 8px; color: #721c24;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <strong><i class="fas fa-exclamation-circle"></i> ${alert.title}</strong>
                                <div style="margin-top: 5px; font-size: 14px;">${alert.message}</div>
                            </div>
                            <span style="font-size: 12px; color: #721c24;">${alert.date}</span>
                        </div>
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

    // Simuler des alertes pour la démo
    document.addEventListener('DOMContentLoaded', function() {
        // Compter les stocks critiques
        const criticalStocks = document.querySelectorAll('.alert-critical');
        if (criticalStocks.length > 0) {
            console.log(`${criticalStocks.length} stocks critiques détectés`);
        }
    });
</script>
</body>
</html>