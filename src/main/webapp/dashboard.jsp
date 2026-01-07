<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Restaurant Supply Chain Optimizer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="container">
    <!-- Header -->
    <header class="header">
        <h1><i class="fas fa-chart-network"></i> Restaurant Supply Chain Optimizer</h1>
        <nav>
            <a href="dashboard" class="active"><i class="fas fa-home"></i> Dashboard</a>
            <a href="ingredients"><i class="fas fa-carrot"></i> Ingrédients</a>
            <a href="restaurants"><i class="fas fa-store"></i> Restaurants</a>
            <a href="stock"><i class="fas fa-boxes"></i> Stocks</a>
            <a href="waste"><i class="fas fa-trash"></i> Pertes</a>
        </nav>
    </header>

    <!-- Dashboard Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
        <div>
            <h2><i class="fas fa-tachometer-alt"></i> Tableau de Bord</h2>
            <p style="color: #666; margin-top: 5px;">Données mises à jour en temps réel</p>
        </div>
        <div style="display: flex; gap: 10px; align-items: center;">
            <span><i class="far fa-calendar"></i>
                <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm" />
            </span>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="card">
        <h3 style="margin-bottom: 15px;"><i class="fas fa-bolt"></i> Actions Rapides</h3>
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="ingredients?action=add" class="btn btn-primary">
                <i class="fas fa-plus"></i> Nouvel Ingrédient
            </a>
            <a href="restaurants" class="btn btn-success">
                <i class="fas fa-plus"></i> Ajouter un restaurant
            </a>
            <a href="stock" class="btn btn-warning">
                <i class="fas fa-box-open"></i> Gérer le stock
            </a>
        </div>
    </div>

    <!-- Main Metrics -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin: 20px 0;">
        <div class="card" style="text-align: center;">
            <div style="font-size: 36px; color: #4CAF50;">
                <i class="fas fa-carrot"></i>
            </div>
            <div style="font-size: 32px; font-weight: bold; margin: 10px 0;">
                ${ingredientsCount}
            </div>
            <div style="color: #666;">Ingrédients Actifs</div>
        </div>

        <div class="card" style="text-align: center;">
            <div style="font-size: 36px; color: #2196F3;">
                <i class="fas fa-store"></i>
            </div>
            <div style="font-size: 32px; font-weight: bold; margin: 10px 0;">
                ${restaurantsCount}
            </div>
            <div style="color: #666;">Restaurants Gérés</div>
        </div>

        <div class="card" style="text-align: center;">
            <div style="font-size: 36px; color: #FF9800;">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <div style="font-size: 32px; font-weight: bold; margin: 10px 0;">
                ${expiringSoonCount}
            </div>
            <div style="color: #666;">Expirations Imminentes</div>
        </div>

        <div class="card" style="text-align: center;">
            <div style="font-size: 36px; color: #F44336;">
                <i class="fas fa-money-bill-wave"></i>
            </div>
            <div style="font-size: 32px; font-weight: bold; margin: 10px 0;">
                <fmt:formatNumber value="${totalWasteCost}" type="currency" currencyCode="EUR"/>
            </div>
            <div style="color: #666;">Coût des Pertes (7j)</div>
        </div>
    </div>

    <!-- Alerts Section -->
    <div class="card">
        <h3><i class="fas fa-bell" style="color: #FF9800;"></i> Alertes d'Expiration</h3>
        <div>
            <c:choose>
                <c:when test="${not empty expiringSoonDetails}">
                    <table style="width: 100%; border-collapse: collapse; margin-top: 20px;">
                        <thead>
                        <tr style="background: #f4f4f4;">
                            <th style="padding: 10px; text-align: left;">Ingrédient</th>
                            <th style="padding: 10px; text-align: left;">Restaurant</th>
                            <th style="padding: 10px; text-align: left;">Expiration</th>
                            <th style="padding: 10px; text-align: left;">Quantité</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="stock" items="${expiringSoonDetails}">
                            <tr style="border-bottom: 1px solid #eee;">
                                <td style="padding: 10px;">${stock.ingredient.name}</td>
                                <td style="padding: 10px;">${stock.restaurant.name}</td>
                                <td style="padding: 10px;">
                                    <fmt:formatDate value="${stock.expirationDate}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td style="padding: 10px;">${stock.quantity} ${stock.ingredient.unit}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p style="color: #666; padding: 20px; text-align: center;">
                        <i class="fas fa-check-circle" style="color: #4CAF50;"></i>
                        Aucune alerte d'expiration imminente
                    </p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Quick Stats -->
    <div class="card">
        <h3 style="margin-bottom: 20px;"><i class="fas fa-chart-line"></i> Statistiques Rapides</h3>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px;">
            <div style="text-align: center;">
                <div style="font-size: 24px; font-weight: bold; color: #4CAF50;">
                    <fmt:formatNumber value="${stockValue}" type="currency" currencyCode="EUR"/>
                </div>
                <div style="font-size: 14px; color: #666;">Valeur du stock total</div>
            </div>
            <div style="text-align: center;">
                <div style="font-size: 24px; font-weight: bold; color: #2196F3;">
                    ${wasteReduction}%
                </div>
                <div style="font-size: 14px; color: #666;">Réduction des pertes</div>
            </div>
            <div style="text-align: center;">
                <div style="font-size: 24px; font-weight: bold; color: #9C27B0;">
                    ${predictionAccuracy}%
                </div>
                <div style="font-size: 14px; color: #666;">Précision prédictive</div>
            </div>
            <div style="text-align: center;">
                <div style="font-size: 24px; font-weight: bold; color: #FF9800;">
                    ${inventoryTurnover}
                </div>
                <div style="font-size: 14px; color: #666;">Rotation stocks/mois</div>
            </div>
        </div>
    </div>
</div>
</body>
</html>