<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Stocks | Restaurant Supply Chain Optimizer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .stock-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
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

        .stat-value {
            font-size: 32px;
            font-weight: bold;
            margin: 10px 0;
        }

        .stat-label {
            color: #666;
            font-size: 14px;
        }

        .stat-critical { color: #F44336; }
        .stat-warning { color: #FF9800; }
        .stat-info { color: #2196F3; }
        .stat-success { color: #4CAF50; }

        .stock-level {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .level-critical { background: #f8d7da; color: #721c24; }
        .level-low { background: #fff3cd; color: #856404; }
        .level-ok { background: #d4edda; color: #155724; }
        .level-high { background: #cce5ff; color: #004085; }

        .expiration-indicator {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
        }

        .expiration-soon { color: #F44336; }
        .expiration-warning { color: #FF9800; }
        .expiration-good { color: #4CAF50; }

        .quantity-editor {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .batch-badge {
            display: inline-block;
            padding: 2px 8px;
            background: #e9ecef;
            border-radius: 4px;
            font-size: 11px;
            font-family: monospace;
            letter-spacing: 1px;
        }

        .stock-actions {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .stock-value {
            font-weight: bold;
            color: #2196F3;
        }

        .report-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .chart-container {
            height: 300px;
            margin-top: 15px;
        }

        .report-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .report-actions {
            display: flex;
            gap: 10px;
        }

        .alert-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .alert-table th, .alert-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .alert-table th {
            background: #f5f5f5;
            font-weight: 500;
        }

        .alert-row:hover {
            background: #f9f9f9;
        }

        .no-data {
            text-align: center;
            padding: 30px;
            color: #999;
            font-style: italic;
        }

        /* Filter styles */
        .filter-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .filter-row {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }

        .filter-label {
            font-weight: 500;
            margin-bottom: 5px;
            display: block;
            color: #333;
        }

        .btn-outline-primary {
            background: white;
            border: 1px solid #2196F3;
            color: #2196F3;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
        }

        .btn-outline-primary:hover {
            background: #2196F3;
            color: white;
        }

        .btn-outline-primary.active {
            background: #2196F3;
            color: white;
        }

        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-menu {
            position: absolute;
            background: white;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            z-index: 1000;
            min-width: 200px;
            display: none;
            padding: 5px 0;
        }

        .dropdown:hover .dropdown-menu {
            display: block;
        }

        .dropdown-item {
            padding: 8px 12px;
            display: block;
            color: #333;
            text-decoration: none;
            white-space: nowrap;
        }

        .dropdown-item:hover {
            background: #f5f5f5;
        }

        .filter-summary {
            background: #e8f4fd;
            border-left: 4px solid #2196F3;
        }

        /* Add responsive design for filters */
        @media (max-width: 768px) {
            .filter-row {
                flex-direction: column;
                align-items: stretch;
            }

            #restaurantFilter {
                width: 100% !important;
            }

            .btn-outline-primary {
                padding: 4px 8px;
                font-size: 12px;
            }

            .stock-header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }

            .report-header {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
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
            <a href="restaurants"><i class="fas fa-store"></i> Restaurants</a>
            <a href="stock" class="active"><i class="fas fa-boxes"></i> Stocks</a>
            <a href="waste"><i class="fas fa-trash"></i> Pertes</a>
        </nav>
    </header>

    <!-- Page Header -->
    <div class="stock-header">
        <div>
            <h2><i class="fas fa-boxes"></i> Gestion des Stocks</h2>
            <p style="color: #666; margin-top: 5px;">Surveillez et gérez vos stocks en temps réel</p>
            <c:if test="${selectedRestaurantId != null}">
                <div style="display: flex; align-items: center; gap: 8px; margin-top: 10px; padding: 8px 12px; background: #e8f4fd; border-radius: 4px; display: inline-flex;">
                    <i class="fas fa-store" style="color: #2196F3;"></i>
                    <span>Filtre actif: <strong>${selectedRestaurantName}</strong></span>
                </div>
            </c:if>
        </div>
        <div>
            <button class="btn btn-success" onclick="openAddStockForm()">
                <i class="fas fa-plus-circle"></i> Ajouter du Stock
            </button>
            <button class="btn btn-info" onclick="refreshPage()" style="margin-left: 10px;">
                <i class="fas fa-sync-alt"></i> Actualiser
            </button>
        </div>
    </div>

    <!-- Restaurant Filter Section -->
    <div class="filter-section">
        <div class="report-header">
            <h3 style="margin: 0;"><i class="fas fa-filter"></i> Filtres</h3>
        </div>

        <form method="get" action="${pageContext.request.contextPath}/stock" id="filterForm">
            <div class="filter-row">
                <div>
                    <label for="restaurantFilter" class="filter-label">
                        <i class="fas fa-store"></i> Restaurant
                    </label>
                    <select id="restaurantFilter" name="restaurantId" class="form-control"
                            style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; width: 250px;"
                            onchange="document.getElementById('filterForm').submit()">
                        <option value="">Tous les restaurants</option>
                        <c:forEach var="restaurant" items="${restaurants}">
                            <option value="${restaurant.id}"
                                    <c:if test="${selectedRestaurantId == restaurant.id}">selected</c:if>>
                                    ${restaurant.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div>
                    <label class="filter-label">
                        <i class="fas fa-info-circle"></i> Statut
                    </label>
                    <div style="font-size: 14px; color: #666; padding: 8px 12px; background: #f8f9fa; border-radius: 4px; min-width: 200px;">
                        <c:choose>
                            <c:when test="${selectedRestaurantId != null}">
                                <i class="fas fa-check-circle" style="color: #4CAF50;"></i>
                                Filtre actif: <strong>${selectedRestaurantName}</strong>
                            </c:when>
                            <c:otherwise>
                                <i class="fas fa-list" style="color: #666;"></i>
                                Affiche tous les restaurants
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div style="margin-left: auto; display: flex; gap: 10px; align-items: flex-end;">
                    <button type="button" class="btn btn-secondary" onclick="clearFilter()"
                            <c:if test="${selectedRestaurantId == null}">disabled</c:if>>
                        <i class="fas fa-times"></i> Effacer le filtre
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> Appliquer
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Quick Restaurant Navigation -->
    <div style="margin-bottom: 20px;">
        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/stock"
               class="btn btn-sm ${selectedRestaurantId == null ? 'btn-primary' : 'btn-outline-primary'}">
                <i class="fas fa-globe"></i> Tous
            </a>
            <c:forEach var="restaurant" items="${restaurants}" end="4">
                <a href="${pageContext.request.contextPath}/stock?restaurantId=${restaurant.id}"
                   class="btn btn-sm ${selectedRestaurantId == restaurant.id ? 'btn-primary' : 'btn-outline-primary'}">
                    <i class="fas fa-store"></i> ${restaurant.name}
                </a>
            </c:forEach>
            <c:if test="${restaurants.size() > 5}">
                <div class="dropdown">
                    <button class="btn btn-sm btn-outline-primary dropdown-toggle" type="button">
                        <i class="fas fa-ellipsis-h"></i> Plus
                    </button>
                    <ul class="dropdown-menu">
                        <c:forEach var="restaurant" items="${restaurants}" begin="5">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/stock?restaurantId=${restaurant.id}">
                                    ${restaurant.name}
                            </a></li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Filter Summary -->
    <c:if test="${selectedRestaurantId != null}">
        <div class="report-section filter-summary">
            <div style="display: flex; align-items: center; gap: 15px;">
                <div style="background: #2196F3; color: white; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                    <i class="fas fa-store"></i>
                </div>
                <div>
                    <h4 style="margin: 0;">Filtre actif: ${selectedRestaurantName}</h4>
                    <p style="margin: 5px 0 0 0; color: #666; font-size: 14px;">
                        Affichage de ${stockList.size()} items de stock pour ce restaurant
                        <c:if test="${stockValue > 0}">
                            | Valeur totale: <fmt:formatNumber value="${stockValue}" type="currency" currencyCode="EUR"/>
                        </c:if>
                    </p>
                </div>
                <div style="margin-left: auto;">
                    <button class="btn btn-sm btn-outline-danger" onclick="clearFilter()">
                        <i class="fas fa-times"></i> Retirer le filtre
                    </button>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Statistics -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-value stat-info">${stockList.size()}</div>
            <div class="stat-label">Items en stock</div>
        </div>
        <div class="stat-card">
            <c:set var="expiringCount" value="0" />
            <c:forEach var="stock" items="${stockList}">
                <c:if test="${stock.expirationDate != null}">
                    <c:set var="now" value="<%= new java.util.Date() %>" />
                    <c:set var="daysDiff" value="${(stock.expirationDate.time - now.time) / (1000 * 60 * 60 * 24)}" />
                    <c:if test="${daysDiff <= 3 && daysDiff >= 0}">
                        <c:set var="expiringCount" value="${expiringCount + 1}" />
                    </c:if>
                </c:if>
            </c:forEach>
            <div class="stat-value stat-warning">${expiringCount}</div>
            <div class="stat-label">Expire dans 3 jours</div>
        </div>
        <div class="stat-card">
            <c:set var="lowStockCount" value="0" />
            <c:forEach var="stock" items="${stockList}">
                <c:if test="${stock.quantity < 5}">
                    <c:set var="lowStockCount" value="${lowStockCount + 1}" />
                </c:if>
            </c:forEach>
            <div class="stat-value stat-critical">${lowStockCount}</div>
            <div class="stat-label">Stocks bas</div>
        </div>
        <div class="stat-card">
            <div class="stat-value stat-success">
                <fmt:formatNumber value="${stockValue}" type="currency" currencyCode="EUR" maxFractionDigits="0"/>
            </div>
            <div class="stat-label">Valeur totale</div>
        </div>
    </div>

    <!-- Simple Alerts Section -->
    <div class="report-section">
        <div class="report-header">
            <h3 style="margin: 0;"><i class="fas fa-exclamation-triangle"></i> Alertes</h3>
            <div class="report-actions">
                <button class="btn btn-sm btn-warning" onclick="exportAlerts()">
                    <i class="fas fa-download"></i> Exporter
                </button>
            </div>
        </div>

        <!-- Expiring Soon -->
        <h4><i class="fas fa-clock"></i> Stocks qui expirent bientôt</h4>
        <table class="alert-table">
            <thead>
            <tr>
                <th>Ingrédient</th>
                <th>Restaurant</th>
                <th>Quantité</th>
                <th>Expiration</th>
                <th>Jours restants</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="stock" items="${stockList}">
                <c:if test="${stock.expirationDate != null}">
                    <c:set var="now" value="<%= new java.util.Date() %>" />
                    <c:set var="daysDiff" value="${(stock.expirationDate.time - now.time) / (1000 * 60 * 60 * 24)}" />
                    <c:if test="${daysDiff <= 7 && daysDiff >= 0}">
                        <tr class="alert-row">
                            <td>${stock.ingredient.name}</td>
                            <td>${stock.restaurant.name}</td>
                            <td><fmt:formatNumber value="${stock.quantity}" maxFractionDigits="2"/> ${stock.ingredient.unit}</td>
                            <td><fmt:formatDate value="${stock.expirationDate}" pattern="dd/MM/yyyy"/></td>
                            <td>
                                    <span class="${daysDiff <= 3 ? 'expiration-soon' : 'expiration-warning'}">
                                        ${Math.round(daysDiff)} jours
                                    </span>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-primary" onclick="editStock(${stock.id})">
                                    <i class="fas fa-edit"></i>
                                </button>
                            </td>
                        </tr>
                    </c:if>
                </c:if>
            </c:forEach>
            <c:if test="${expiringCount == 0}">
                <tr>
                    <td colspan="6" class="no-data">
                        Aucun stock n'expire dans les 7 prochains jours
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>

        <!-- Low Stock -->
        <h4 style="margin-top: 25px;"><i class="fas fa-exclamation-circle"></i> Stocks bas</h4>
        <table class="alert-table">
            <thead>
            <tr>
                <th>Ingrédient</th>
                <th>Restaurant</th>
                <th>Quantité</th>
                <th>Niveau</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="stock" items="${stockList}">
                <c:if test="${stock.quantity < 5}">
                    <tr class="alert-row">
                        <td>${stock.ingredient.name}</td>
                        <td>${stock.restaurant.name}</td>
                        <td><fmt:formatNumber value="${stock.quantity}" maxFractionDigits="2"/> ${stock.ingredient.unit}</td>
                        <td>
                                <span class="stock-level ${stock.quantity < 2 ? 'level-critical' : 'level-low'}">
                                    <c:choose>
                                        <c:when test="${stock.quantity < 2}">
                                            <i class="fas fa-exclamation-circle"></i> Critique
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-exclamation-triangle"></i> Bas
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                        </td>
                        <td>
                            <button class="btn btn-sm btn-primary" onclick="editStock(${stock.id})">
                                <i class="fas fa-edit"></i>
                            </button>
                        </td>
                    </tr>
                </c:if>
            </c:forEach>
            <c:if test="${lowStockCount == 0}">
                <tr>
                    <td colspan="5" class="no-data">
                        Aucun stock bas
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- Distribution Chart -->
    <div class="report-section">
        <div class="report-header">
            <h3 style="margin: 0;">
                <i class="fas fa-chart-pie"></i>
                <c:choose>
                    <c:when test="${selectedRestaurantId != null}">
                        Répartition par Ingrédient - ${selectedRestaurantName}
                    </c:when>
                    <c:otherwise>
                        Répartition par Restaurant
                    </c:otherwise>
                </c:choose>
            </h3>
            <div class="report-actions">
                <button class="btn btn-sm btn-info" onclick="loadDistributionChart()">
                    <i class="fas fa-sync-alt"></i> Actualiser
                </button>
            </div>
        </div>
        <div class="chart-container">
            <canvas id="distributionChart"></canvas>
        </div>
    </div>

    <!-- Stock Table -->
    <div class="report-section">
        <div class="report-header">
            <h3 style="margin: 0;">
                <i class="fas fa-list"></i>
                <c:choose>
                    <c:when test="${selectedRestaurantId != null}">
                        Stocks du restaurant - ${selectedRestaurantName}
                    </c:when>
                    <c:otherwise>
                        Tous les Stocks
                    </c:otherwise>
                </c:choose>
            </h3>
            <div class="report-actions">
                <button class="btn btn-sm btn-info" onclick="exportToCSV()">
                    <i class="fas fa-file-export"></i> Exporter CSV
                </button>
                <button class="btn btn-sm btn-secondary" onclick="printStockTable()">
                    <i class="fas fa-print"></i> Imprimer
                </button>
            </div>
        </div>

        <div style="overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse;" id="stockTable">
                <thead>
                <tr style="background: #f4f4f4;">
                    <th style="padding: 12px; text-align: left;">Ingrédient</th>
                    <c:if test="${selectedRestaurantId == null}">
                        <th style="padding: 12px; text-align: left;">Restaurant</th>
                    </c:if>
                    <th style="padding: 12px; text-align: left;">Quantité</th>
                    <th style="padding: 12px; text-align: left;">Niveau</th>
                    <th style="padding: 12px; text-align: left;">Expiration</th>
                    <th style="padding: 12px; text-align: left;">Lot</th>
                    <th style="padding: 12px; text-align: left;">Valeur</th>
                    <th style="padding: 12px; text-align: left;">Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="stock" items="${stockList}">
                    <c:if test="${stock.ingredient != null && stock.restaurant != null}">
                        <tr>
                            <td style="padding: 12px;">
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
                            <c:if test="${selectedRestaurantId == null}">
                                <td style="padding: 12px;">
                                    <div style="display: flex; align-items: center; gap: 8px;">
                                        <i class="fas fa-store" style="color: #2196F3;"></i>
                                        <span>${stock.restaurant.name}</span>
                                    </div>
                                </td>
                            </c:if>
                            <td style="padding: 12px;">
                                <div class="quantity-editor">
                                    <input type="number" class="quantity-input" value="<fmt:formatNumber value='${stock.quantity}' maxFractionDigits='2'/>"
                                           min="0" step="0.01" style="width: 80px; padding: 4px; border: 1px solid #ddd; border-radius: 4px;"
                                           onchange="updateStockQuantity(${stock.id}, this.value)">
                                    <span style="font-size: 12px; color: #666;">${stock.ingredient.unit}</span>
                                </div>
                            </td>
                            <td style="padding: 12px;">
                                <span class="stock-level
                                    <c:choose>
                                        <c:when test="${stock.quantity < 2}">level-critical</c:when>
                                        <c:when test="${stock.quantity < 5}">level-low</c:when>
                                        <c:when test="${stock.quantity > 20}">level-high</c:when>
                                        <c:otherwise>level-ok</c:otherwise>
                                    </c:choose>">
                                    <c:choose>
                                        <c:when test="${stock.quantity < 2}">
                                            <i class="fas fa-exclamation-circle"></i> Critique
                                        </c:when>
                                        <c:when test="${stock.quantity < 5}">
                                            <i class="fas fa-exclamation-triangle"></i> Bas
                                        </c:when>
                                        <c:when test="${stock.quantity > 20}">
                                            <i class="fas fa-check-circle"></i> Élevé
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-check-circle"></i> OK
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td style="padding: 12px;">
                                <c:choose>
                                    <c:when test="${stock.expirationDate != null}">
                                        <div class="expiration-indicator
                                            <c:set var="now" value="<%= new java.util.Date() %>" />
                                            <c:set var="daysDiff" value="${(stock.expirationDate.time - now.time) / (1000 * 60 * 60 * 24)}" />
                                            <c:choose>
                                                <c:when test="${daysDiff < 0}">expiration-soon</c:when>
                                                <c:when test="${daysDiff <= 3}">expiration-soon</c:when>
                                                <c:when test="${daysDiff <= 7}">expiration-warning</c:when>
                                                <c:otherwise>expiration-good</c:otherwise>
                                            </c:choose>">
                                            <i class="far fa-calendar"></i>
                                            <fmt:formatDate value="${stock.expirationDate}" pattern="dd/MM/yyyy"/>
                                            <c:if test="${daysDiff >= 0}">
                                                <span style="font-size: 11px;">(${Math.round(daysDiff)}j)</span>
                                            </c:if>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #666; font-size: 12px;">Non défini</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="padding: 12px;">
                                <c:if test="${not empty stock.batchNumber}">
                                    <span class="batch-badge">${stock.batchNumber}</span>
                                </c:if>
                            </td>
                            <td style="padding: 12px;">
                                <span class="stock-value">
                                    <fmt:formatNumber value="${stock.quantity * stock.ingredient.currentPrice}"
                                                      type="currency" currencyCode="EUR" maxFractionDigits="2"/>
                                </span>
                            </td>
                            <td style="padding: 12px;">
                                <div class="stock-actions">
                                    <button class="btn btn-sm btn-primary" onclick="editStock(${stock.id})" title="Modifier">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-danger" onclick="deleteStock(${stock.id})" title="Supprimer">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
                <c:if test="${empty stockList}">
                    <tr>
                        <td colspan="${selectedRestaurantId == null ? '8' : '7'}" style="text-align: center; padding: 40px; color: #999; font-style: italic;">
                            <c:choose>
                                <c:when test="${selectedRestaurantId != null}">
                                    Aucun stock enregistré pour ce restaurant
                                </c:when>
                                <c:otherwise>
                                    Aucun stock enregistré
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    let distributionChart = null;

    // Initialize chart on page load
    document.addEventListener('DOMContentLoaded', function() {
        loadDistributionChart();
        setupNumberInputs();
    });

    // Load distribution chart data with filter support
    async function loadDistributionChart() {
        try {
            const urlParams = new URLSearchParams(window.location.search);
            const restaurantId = urlParams.get('restaurantId');

            let endpoint = '${pageContext.request.contextPath}/api/stock/summary';
            if (restaurantId) {
                endpoint += '?restaurantId=' + restaurantId;
            }

            const response = await fetch(endpoint);
            if (response.ok) {
                const summary = await response.json();
                console.log('Summary data:', summary);

                if (restaurantId) {
                    // For single restaurant, show ingredient breakdown
                    createIngredientChart(summary);
                } else {
                    // For all restaurants, show restaurant breakdown
                    createRestaurantChart(summary.byRestaurant);
                }
            } else {
                console.error('Failed to load summary:', await response.text());
                showChartError('Erreur de chargement des données');
            }
        } catch (error) {
            console.error('Error loading chart data:', error);
            showChartError('Erreur de connexion au serveur');
        }
    }

    function showChartError(message) {
        const ctx = document.getElementById('distributionChart').getContext('2d');

        // Destroy existing chart if it exists
        if (distributionChart) {
            distributionChart.destroy();
        }

        ctx.fillStyle = '#f5f5f5';
        ctx.fillRect(0, 0, ctx.canvas.width, ctx.canvas.height);
        ctx.fillStyle = '#F44336';
        ctx.font = '16px Arial';
        ctx.textAlign = 'center';
        ctx.fillText(message, ctx.canvas.width / 2, ctx.canvas.height / 2);
    }

    // Chart for all restaurants (restaurant distribution)
    function createRestaurantChart(restaurantData) {
        const ctx = document.getElementById('distributionChart').getContext('2d');

        // Destroy existing chart if it exists
        if (distributionChart) {
            distributionChart.destroy();
        }

        if (!restaurantData || restaurantData.length === 0) {
            showNoDataMessage('Aucune donnée disponible pour le moment');
            return;
        }

        const labels = restaurantData.map(item => item[0] || 'Sans nom');
        const values = restaurantData.map(item => {
            const value = parseFloat(item[2]) || 0;
            console.log('Value for ' + (item[0] || 'Sans nom') + ': ' + value);
            return value;
        });

        // Check if all values are zero
        const totalValue = values.reduce((a, b) => a + b, 0);
        if (totalValue === 0) {
            showNoDataMessage('Aucune valeur de stock enregistrée');
            return;
        }

        const colors = generateColors(restaurantData.length);

        distributionChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Valeur des stocks par restaurant (€)',
                    data: values,
                    backgroundColor: colors,
                    borderColor: colors.map(c => darkenColor(c, 20)),
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return `${context.dataset.label}: ${context.parsed.y.toFixed(2)} €`;
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value.toFixed(0) + ' €';
                            }
                        }
                    }
                }
            }
        });
    }

    // Chart for single restaurant (ingredient distribution)
    function createIngredientChart(stockData) {
        const ctx = document.getElementById('distributionChart').getContext('2d');

        // Destroy existing chart if it exists
        if (distributionChart) {
            distributionChart.destroy();
        }

        if (!stockData || stockData.length === 0) {
            showNoDataMessage('Aucun stock pour ce restaurant');
            return;
        }

        // Extract ingredient data from stock list
        const ingredientMap = new Map();

        <c:forEach var="stock" items="${stockList}">
        if (${stock.ingredient != null}) {
            const ingredientName = '${stock.ingredient.name}';
            const value = ${stock.quantity} * ${stock.ingredient.currentPrice};

            if (ingredientMap.has(ingredientName)) {
                ingredientMap.set(ingredientName, ingredientMap.get(ingredientName) + value);
            } else {
                ingredientMap.set(ingredientName, value);
            }
        }
        </c:forEach>

        if (ingredientMap.size === 0) {
            showNoDataMessage('Aucun ingrédient avec valeur pour ce restaurant');
            return;
        }

        const labels = Array.from(ingredientMap.keys());
        const values = Array.from(ingredientMap.values());

        const colors = generateColors(labels.length);

        distributionChart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Valeur par ingrédient (€)',
                    data: values,
                    backgroundColor: colors,
                    borderColor: colors.map(c => darkenColor(c, 20)),
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            padding: 20,
                            usePointStyle: true,
                            pointStyle: 'circle'
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const value = context.parsed;
                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                const percentage = Math.round((value / total) * 100);
                                return `${context.label}: ${value.toFixed(2)} € (${percentage}%)`;
                            }
                        }
                    }
                }
            }
        });
    }

    function showNoDataMessage(message) {
        const ctx = document.getElementById('distributionChart').getContext('2d');
        ctx.fillStyle = '#f5f5f5';
        ctx.fillRect(0, 0, ctx.canvas.width, ctx.canvas.height);
        ctx.fillStyle = '#999';
        ctx.font = '16px Arial';
        ctx.textAlign = 'center';
        ctx.fillText(message, ctx.canvas.width / 2, ctx.canvas.height / 2);
    }

    // Helper function to generate colors
    function generateColors(count) {
        const colors = [];
        const baseColors = [
            '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0',
            '#9966FF', '#FF9F40', '#8AC926', '#1982C4',
            '#6A4C93', '#FF595E', '#8AC926', '#1982C4'
        ];

        for (let i = 0; i < count; i++) {
            colors.push(baseColors[i % baseColors.length]);
        }
        return colors;
    }

    // Helper function to darken color
    function darkenColor(color, percent) {
        const num = parseInt(color.slice(1), 16);
        const amt = Math.round(2.55 * percent);
        const R = (num >> 16) - amt;
        const G = (num >> 8 & 0x00FF) - amt;
        const B = (num & 0x0000FF) - amt;

        return '#' + (
            0x1000000 +
            (R < 255 ? R < 1 ? 0 : R : 255) * 0x10000 +
            (G < 255 ? G < 1 ? 0 : G : 255) * 0x100 +
            (B < 255 ? B < 1 ? 0 : B : 255)
        ).toString(16).slice(1);
    }

    // Filter functions
    function clearFilter() {
        window.location.href = '${pageContext.request.contextPath}/stock';
    }

    // Edit stock function
    function editStock(stockId) {
        const urlParams = new URLSearchParams(window.location.search);
        const restaurantId = urlParams.get('restaurantId');

        let url = '${pageContext.request.contextPath}/stock/edit?id=' + stockId;
        if (restaurantId) {
            url += '&restaurantId=' + restaurantId;
        }

        window.location.href = url;
    }

    // Update stock quantity with filter preservation
    async function updateStockQuantity(stockId, newQuantity) {
        const quantity = newQuantity.replace(',', '.').trim();

        if (!quantity || isNaN(quantity) || parseFloat(quantity) < 0) {
            alert('Quantité invalide');
            return;
        }

        if (confirm(`Mettre à jour la quantité à ${quantity} ?`)) {
            try {
                const response = await fetch('${pageContext.request.contextPath}/api/stock/' + stockId, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({
                        quantity: parseFloat(quantity)
                    })
                });

                if (response.ok) {
                    alert('Quantité mise à jour avec succès');
                    // Preserve filter when reloading
                    reloadWithFilter();
                } else {
                    const error = await response.text();
                    let errorMessage = 'Erreur lors de la mise à jour';
                    try {
                        const errorJson = JSON.parse(error);
                        errorMessage = errorJson.error || errorJson.message || errorMessage;
                    } catch (e) {
                        errorMessage = error;
                    }
                    alert(errorMessage);
                }
            } catch (error) {
                alert('Erreur de connexion: ' + error.message);
            }
        }
    }

    // Delete stock with filter preservation
    async function deleteStock(stockId) {
        if (confirm('Êtes-vous sûr de vouloir supprimer cet item de stock ? Cette action est irréversible.')) {
            try {
                const response = await fetch('${pageContext.request.contextPath}/api/stock/' + stockId, {
                    method: 'DELETE',
                    headers: {
                        'Accept': 'application/json'
                    }
                });

                if (response.ok) {
                    const result = await response.json();
                    alert(result.message || 'Stock supprimé avec succès');
                    // Preserve filter when reloading
                    reloadWithFilter();
                } else {
                    const error = await response.text();
                    let errorMessage = 'Erreur lors de la suppression';
                    try {
                        const errorJson = JSON.parse(error);
                        errorMessage = errorJson.error || errorJson.message || errorMessage;
                    } catch (e) {
                        errorMessage = error;
                    }
                    alert(errorMessage);
                }
            } catch (error) {
                console.error('Erreur réseau:', error);
                alert('Erreur de connexion au serveur: ' + error.message);
            }
        }
    }

    // Helper function to reload page with current filter
    function reloadWithFilter() {
        const urlParams = new URLSearchParams(window.location.search);
        const restaurantId = urlParams.get('restaurantId');

        if (restaurantId) {
            window.location.href = '${pageContext.request.contextPath}/stock?restaurantId=' + restaurantId;
        } else {
            location.reload();
        }
    }

    // Export functions with filter support
    function exportToCSV() {
        const rows = document.querySelectorAll('#stockTable tbody tr');

        if (rows.length === 0) {
            alert('Aucune donnée à exporter');
            return;
        }

        let csvContent = "";

        if (${selectedRestaurantId == null}) {
            csvContent = "Restaurant,Ingrédient,Catégorie,Quantité,Unité,Prix Unitaire,Valeur,Expiration,Lot,Statut\n";
        } else {
            csvContent = "Ingrédient,Catégorie,Quantité,Unité,Prix Unitaire,Valeur,Expiration,Lot,Statut\n";
        }

        rows.forEach(row => {
            const cells = row.querySelectorAll('td');
            const cellCount = ${selectedRestaurantId == null} ? 8 : 7;

            if (cells.length >= cellCount) {
                let restaurant = '';
                let ingredient = '';
                let category = '';
                let quantity = '';
                let unit = '';
                let value = '';
                let expiration = 'Non défini';
                let batch = '';
                let status = '';

                if (${selectedRestaurantId == null}) {
                    // All restaurants view
                    restaurant = cells[1].querySelector('span').textContent;
                    ingredient = cells[0].querySelector('strong').textContent;
                    category = cells[0].querySelector('div').textContent.trim();
                    quantity = cells[2].querySelector('.quantity-input').value;
                    unit = cells[2].querySelector('span').textContent;
                    value = cells[6].querySelector('.stock-value').textContent;

                    const expirationDiv = cells[4].querySelector('.expiration-indicator');
                    if (expirationDiv) {
                        expiration = expirationDiv.textContent.trim();
                    }

                    const batchBadge = cells[5].querySelector('.batch-badge');
                    if (batchBadge) {
                        batch = batchBadge.textContent;
                    }

                    status = cells[3].querySelector('.stock-level').textContent.trim();
                } else {
                    // Single restaurant view
                    ingredient = cells[0].querySelector('strong').textContent;
                    category = cells[0].querySelector('div').textContent.trim();
                    quantity = cells[1].querySelector('.quantity-input').value;
                    unit = cells[1].querySelector('span').textContent;
                    value = cells[5].querySelector('.stock-value').textContent;

                    const expirationDiv = cells[3].querySelector('.expiration-indicator');
                    if (expirationDiv) {
                        expiration = expirationDiv.textContent.trim();
                    }

                    const batchBadge = cells[4].querySelector('.batch-badge');
                    if (batchBadge) {
                        batch = batchBadge.textContent;
                    }

                    status = cells[2].querySelector('.stock-level').textContent.trim();
                }

                const escapeCSV = (str) => {
                    if (!str) return '';
                    return '"' + String(str).replace(/"/g, '""') + '"';
                };

                if (${selectedRestaurantId == null}) {
                    csvContent += escapeCSV(restaurant) + ',' +
                        escapeCSV(ingredient) + ',' +
                        escapeCSV(category) + ',' +
                        quantity + ',' +
                        escapeCSV(unit) + ',' +
                        escapeCSV(value) + ',' +
                        escapeCSV(expiration) + ',' +
                        escapeCSV(batch) + ',' +
                        escapeCSV(status) + '\n';
                } else {
                    csvContent += escapeCSV(ingredient) + ',' +
                        escapeCSV(category) + ',' +
                        quantity + ',' +
                        escapeCSV(unit) + ',' +
                        escapeCSV(value) + ',' +
                        escapeCSV(expiration) + ',' +
                        escapeCSV(batch) + ',' +
                        escapeCSV(status) + '\n';
                }
            }
        });

        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;

        let filename = 'stocks_';
        if (${selectedRestaurantId != null}) {
            filename += '${selectedRestaurantName.replaceAll(" ", "_")}_';
        }
        filename += new Date().toISOString().split('T')[0] + '.csv';

        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
    }

    function exportAlerts() {
        const alertRows = document.querySelectorAll('.alert-row');

        if (alertRows.length === 0) {
            alert('Aucune alerte à exporter');
            return;
        }

        let csvContent = "Type,Ingrédient,Restaurant,Quantité,Expiration,Jours Restants,Statut\n";

        // Expiring alerts
        const expiringRows = document.querySelectorAll('.alert-table:first-of-type .alert-row');
        expiringRows.forEach(row => {
            const cells = row.querySelectorAll('td');
            if (cells.length >= 5) {
                const ingredient = cells[0].textContent;
                const restaurant = cells[1].textContent;
                const quantity = cells[2].textContent;
                const expiration = cells[3].textContent;
                const days = cells[4].querySelector('span').textContent;

                const escapeCSV = (str) => {
                    if (!str) return '';
                    return '"' + String(str).replace(/"/g, '""') + '"';
                };

                csvContent += 'Expiration,' +
                    escapeCSV(ingredient) + ',' +
                    escapeCSV(restaurant) + ',' +
                    escapeCSV(quantity) + ',' +
                    escapeCSV(expiration) + ',' +
                    escapeCSV(days) + ',' +
                    'Attention\n';
            }
        });

        // Low stock alerts
        const lowStockRows = document.querySelectorAll('.alert-table:last-of-type .alert-row');
        lowStockRows.forEach(row => {
            const cells = row.querySelectorAll('td');
            if (cells.length >= 4) {
                const ingredient = cells[0].textContent;
                const restaurant = cells[1].textContent;
                const quantity = cells[2].textContent;
                const status = cells[3].querySelector('.stock-level').textContent;

                const escapeCSV = (str) => {
                    if (!str) return '';
                    return '"' + String(str).replace(/"/g, '""') + '"';
                };

                csvContent += 'Stock Bas,' +
                    escapeCSV(ingredient) + ',' +
                    escapeCSV(restaurant) + ',' +
                    escapeCSV(quantity) + ',' +
                    'N/A,N/A,' +
                    escapeCSV(status) + '\n';
            }
        });

        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;

        let filename = 'alertes_stock_';
        if (${selectedRestaurantId != null}) {
            filename += '${selectedRestaurantName.replaceAll(" ", "_")}_';
        }
        filename += new Date().toISOString().split('T')[0] + '.csv';

        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
    }

    function printStockTable() {
        const printContent = document.querySelector('.report-section:last-of-type').outerHTML;
        const originalContent = document.body.innerHTML;

        // Get the current date in French format
        const currentDate = new Date().toLocaleDateString('fr-FR');

        // Get the stats values
        const totalItems = document.querySelector('.stat-card:first-child .stat-value').textContent;
        const totalValue = document.querySelector('.stat-card:last-child .stat-value').textContent;

        // Get filter info
        let filterInfo = '';
        if (${selectedRestaurantId != null}) {
            filterInfo = '<p>Filtre: <strong>${selectedRestaurantName}</strong></p>';
        }

        // Build the print HTML using string concatenation to avoid EL conflicts
        const printHTML = '<!DOCTYPE html>' +
            '<html>' +
            '<head>' +
            '<title>Liste des Stocks - ' + currentDate + '</title>' +
            '<style>' +
            'body { font-family: Arial, sans-serif; padding: 20px; }' +
            'table { width: 100%; border-collapse: collapse; margin-top: 20px; }' +
            'th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }' +
            'th { background-color: #f5f5f5; font-weight: bold; }' +
            '.header { text-align: center; margin-bottom: 30px; }' +
            '.footer { margin-top: 30px; text-align: center; font-size: 12px; color: #666; }' +
            '@media print {' +
            '.no-print { display: none; }' +
            '}' +
            '</style>' +
            '</head>' +
            '<body>' +
            '<div class="header">' +
            '<h1>Liste des Stocks</h1>' +
            '<p>Date d\'impression: ' + currentDate + '</p>' +
            filterInfo +
            '<p>Total: ' + totalItems + ' items</p>' +
            '<p>Valeur totale: ' + totalValue + '</p>' +
            '</div>' +
            printContent +
            '<div class="footer">' +
            '<p>Généré par Restaurant Supply Chain Optimizer</p>' +
            '</div>' +
            '</body>' +
            '</html>';

        document.body.innerHTML = printHTML;
        window.print();
        document.body.innerHTML = originalContent;
        reloadWithFilter();
    }

    function openAddStockForm() {
        const urlParams = new URLSearchParams(window.location.search);
        const restaurantId = urlParams.get('restaurantId');

        let url = '${pageContext.request.contextPath}/stock/add';
        if (restaurantId) {
            url += '?restaurantId=' + restaurantId;
        }

        window.location.href = url;
    }

    function refreshPage() {
        reloadWithFilter();
    }

    // Setup number input validation
    function setupNumberInputs() {
        document.querySelectorAll('.quantity-input').forEach(input => {
            input.addEventListener('input', function(e) {
                let value = e.target.value;
                // Remove any non-numeric characters except dot and comma
                value = value.replace(/[^\d.,]/g, '');

                // Replace comma with dot
                if (value.includes(',')) {
                    value = value.replace(',', '.');
                }

                // Ensure only one decimal point
                const parts = value.split('.');
                if (parts.length > 2) {
                    value = parts[0] + '.' + parts.slice(1).join('');
                }

                e.target.value = value;
            });
        });
    }
</script>
</body>
</html>