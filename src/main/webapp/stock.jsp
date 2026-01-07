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
    <style>
        .stock-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .stock-filters {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .filter-card {
            background: white;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            flex: 1;
            min-width: 200px;
        }

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

        .quantity-btn {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            border: 1px solid #ddd;
            background: white;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .quantity-display {
            min-width: 40px;
            text-align: center;
            font-weight: 500;
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

        .stock-charts {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }

        .chart-container {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .stock-actions {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .progress-bar {
            height: 6px;
            background: #eee;
            border-radius: 3px;
            overflow: hidden;
            margin-top: 5px;
        }

        .progress-fill {
            height: 100%;
            transition: width 0.3s;
        }

        .stock-value {
            font-weight: bold;
            color: #2196F3;
        }

        .restaurant-filter {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .restaurant-option {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
        }

        .restaurant-option:hover {
            background: #f5f5f5;
        }

        .restaurant-option.active {
            background: #2196F3;
            color: white;
            border-color: #2196F3;
        }

        /* New styles for enhanced filtering */
        .quantity-input {
            width: 80px;
            padding: 4px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-align: center;
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
            <a href="stock?action=summary"><i class="fas fa-chart-pie"></i> Rapport</a>
            <a href="waste"><i class="fas fa-trash"></i> Pertes</a>
        </nav>
    </header>

    <!-- Page Header -->
    <div class="stock-header">
        <div>
            <h2><i class="fas fa-boxes"></i> Gestion des Stocks</h2>
            <p style="color: #666; margin-top: 5px;">Surveillez et gérez vos stocks en temps réel</p>
        </div>
        <button class="btn btn-success" onclick="openAddStockForm()">
            <i class="fas fa-plus-circle"></i> Ajouter du Stock
        </button>
    </div>

    <!-- Quick Stats -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 30px;">
        <div class="filter-card">
            <div style="font-size: 32px; font-weight: bold; color: #2196F3;">
                ${stockList.size()}
            </div>
            <div style="color: #666;">Items en stock</div>
        </div>
        <div class="filter-card">
            <div style="font-size: 32px; font-weight: bold; color: #FF9800;">
                <c:set var="expiringCount" value="0" />
                <c:forEach var="stock" items="${stockList}">
                    <c:if test="${stock.expirationDate != null}">
                        <c:set var="now" value="<%= new java.util.Date() %>" />
                        <c:set var="daysDiff" value="${(stock.expirationDate.time - now.time) / (1000 * 60 * 60 * 24)}" />
                        <c:if test="${daysDiff <= 3}">
                            <c:set var="expiringCount" value="${expiringCount + 1}" />
                        </c:if>
                    </c:if>
                </c:forEach>
                ${expiringCount}
            </div>
            <div style="color: #666;">Expire dans 3 jours</div>
        </div>
        <div class="filter-card">
            <div style="font-size: 32px; font-weight: bold; color: #F44336;">
                <c:set var="lowStockCount" value="0" />
                <c:forEach var="stock" items="${stockList}">
                    <c:if test="${stock.quantity < 5}">
                        <c:set var="lowStockCount" value="${lowStockCount + 1}" />
                    </c:if>
                </c:forEach>
                ${lowStockCount}
            </div>
            <div style="color: #666;">Stocks bas</div>
        </div>
        <div class="filter-card">
            <div style="font-size: 32px; font-weight: bold; color: #4CAF50;">
                <fmt:formatNumber value="${stockValue}" type="currency" currencyCode="EUR" maxFractionDigits="0"/>
            </div>
            <div style="color: #666;">Valeur totale</div>
        </div>
    </div>

    <!-- Enhanced Filters -->
    <div class="card">
        <h3 style="margin-bottom: 15px;"><i class="fas fa-filter"></i> Filtres Avancés</h3>

        <div class="stock-filters">
            <!-- Restaurant Filter -->
            <div style="flex: 1;">
                <label style="display: block; margin-bottom: 8px; font-weight: 500;">Restaurant</label>
                <select id="restaurantFilter" class="form-control" onchange="applyFilters()">
                    <option value="all">Tous les restaurants</option>
                    <c:forEach var="restaurant" items="${restaurants}">
                        <option value="${restaurant.id}">${restaurant.name}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Category Filter -->
            <div style="flex: 1;">
                <label style="display: block; margin-bottom: 8px; font-weight: 500;">Catégorie</label>
                <select id="categoryFilter" class="form-control" onchange="applyFilters()">
                    <option value="all">Toutes les catégories</option>
                    <c:forEach var="category" items="${uniqueCategories}">
                        <option value="${category}">${category}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Quantity Range -->
            <div style="flex: 1;">
                <label style="display: block; margin-bottom: 8px; font-weight: 500;">Quantité</label>
                <div style="display: flex; gap: 10px;">
                    <input type="number" id="minQuantity" class="form-control" placeholder="Min"
                           step="0.01" min="0" onchange="applyFilters()">
                    <input type="number" id="maxQuantity" class="form-control" placeholder="Max"
                           step="0.01" min="0" onchange="applyFilters()">
                </div>
            </div>
        </div>

        <!-- Date Range Filter -->
        <div style="margin-top: 15px;">
            <label style="display: block; margin-bottom: 8px; font-weight: 500;">Date d'expiration</label>
            <div style="display: flex; gap: 10px;">
                <input type="date" id="expirationFrom" class="form-control" onchange="applyFilters()"
                       placeholder="De">
                <input type="date" id="expirationTo" class="form-control" onchange="applyFilters()"
                       placeholder="À">
            </div>
        </div>

        <!-- Quick Action Buttons -->
        <div style="margin-top: 20px; display: flex; gap: 10px; flex-wrap: wrap;">
            <button class="btn btn-info" onclick="exportToCSV()">
                <i class="fas fa-file-export"></i> Exporter CSV
            </button>
            <button class="btn btn-warning" onclick="showLowStockReport()">
                <i class="fas fa-exclamation-triangle"></i> Stocks Bas
            </button>
            <button class="btn btn-danger" onclick="showExpiringReport()">
                <i class="fas fa-clock"></i> Expirent Bientôt
            </button>
            <button class="btn btn-secondary" onclick="resetFilters()">
                <i class="fas fa-redo"></i> Réinitialiser
            </button>
        </div>
    </div>

    <!-- Stock Table -->
    <div class="card">
        <div style="overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse;" id="stockTable">
                <thead>
                <tr style="background: #f4f4f4;">
                    <th style="padding: 12px; text-align: left;">Ingrédient</th>
                    <th style="padding: 12px; text-align: left;">Restaurant</th>
                    <th style="padding: 12px; text-align: left;">Quantité</th>
                    <th style="padding: 12px; text-align: left;">Niveau</th>
                    <th style="padding: 12px; text-align: left;">Expiration</th>
                    <th style="padding: 12px; text-align: left;">Lot</th>
                    <th style="padding: 12px; text-align: left;">Valeur</th>
                    <th style="padding: 12px; text-align: left;">Actions</th>
                </tr>
                </thead>
                <tbody id="stockTableBody">
                <c:forEach var="stock" items="${stockList}">
                    <c:if test="${stock.ingredient != null && stock.restaurant != null}">
                        <tr data-restaurant="${stock.restaurant.id}"
                            data-status="<c:choose>
                                <c:when test="${stock.quantity < 2}">critical</c:when>
                                <c:when test="${stock.quantity < 5}">low</c:when>
                                <c:when test="${stock.quantity > 20}">high</c:when>
                                <c:otherwise>ok</c:otherwise>
                            </c:choose>"
                            data-expiration="<c:choose>
                                <c:when test="${stock.expirationDate == null}">none</c:when>
                                <c:otherwise>
                                    <c:set var="now" value="<%= new java.util.Date() %>" />
                                    <c:set var="daysDiff" value="${(stock.expirationDate.time - now.time) / (1000 * 60 * 60 * 24)}" />
                                    <c:choose>
                                        <c:when test="${daysDiff < 0}">expired</c:when>
                                        <c:when test="${daysDiff <= 1}">today</c:when>
                                        <c:when test="${daysDiff <= 3}">3days</c:when>
                                        <c:when test="${daysDiff <= 7}">7days</c:when>
                                        <c:otherwise>future</c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>">
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
                            <td style="padding: 12px;">
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <i class="fas fa-store" style="color: #2196F3;"></i>
                                    <span>${stock.restaurant.name}</span>
                                </div>
                            </td>
                            <td style="padding: 12px;">
                                <div class="quantity-editor">
                                    <input type="number" class="quantity-input" value="<fmt:formatNumber value='${stock.quantity}' maxFractionDigits='2'/>"
                                           min="0" step="0.01" style="width: 80px; padding: 4px;"
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
                                    <button class="btn btn-sm btn-primary" onclick="editStock(${stock.id})">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-danger" onclick="deleteStock(${stock.id})">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                    <button class="btn btn-sm btn-info" onclick="transferStock(${stock.id})" title="Transférer">
                                        <i class="fas fa-exchange-alt"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    // Enhanced Filter Functions
    let currentFilters = {
        restaurantId: 'all',
        category: 'all',
        minQuantity: null,
        maxQuantity: null,
        expirationFrom: null,
        expirationTo: null
    };

    async function applyFilters() {
        // Get filter values
        const restaurantId = document.getElementById('restaurantFilter').value;
        const category = document.getElementById('categoryFilter').value;
        const minQuantity = document.getElementById('minQuantity').value;
        const maxQuantity = document.getElementById('maxQuantity').value;
        const expirationFrom = document.getElementById('expirationFrom').value;
        const expirationTo = document.getElementById('expirationTo').value;

        // Build query parameters
        const params = new URLSearchParams();

        if (restaurantId !== 'all') {
            params.append('restaurantId', restaurantId);
        }

        if (category !== 'all') {
            params.append('category', category);
        }

        if (minQuantity) {
            // Ensure proper decimal format (replace comma with dot)
            params.append('minQuantity', minQuantity.replace(',', '.'));
        }

        if (maxQuantity) {
            // Ensure proper decimal format (replace comma with dot)
            params.append('maxQuantity', maxQuantity.replace(',', '.'));
        }

        if (expirationFrom) {
            params.append('expirationFrom', expirationFrom);
        }

        if (expirationTo) {
            params.append('expirationTo', expirationTo);
        }

        try {
            const response = await fetch('${pageContext.request.contextPath}/api/stock/search?' + params);

            if (response.ok) {
                const filteredStock = await response.json();
                updateStockTable(filteredStock);
            } else {
                const error = await response.text();
                console.error('Erreur lors du filtrage:', error);
                try {
                    const errorJson = JSON.parse(error);
                    alert('Erreur: ' + (errorJson.error || errorJson.message || 'Erreur inconnue'));
                } catch (e) {
                    alert('Erreur: ' + error);
                }
            }
        } catch (error) {
            console.error('Erreur réseau:', error);
            alert('Erreur de connexion au serveur: ' + error.message);
        }
    }

    // Also fix the updateStockQuantity function:

    async function updateStockQuantity(stockId, newQuantity) {
        // Fix number format before sending
        const quantity = newQuantity.replace(',', '.');

        if (confirm('Mettre à jour la quantité à ' + quantity + ' ?')) {
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
                    applyFilters(); // Refresh the filtered view
                } else {
                    const error = await response.text();
                    alert('Erreur: ' + error);
                }
            } catch (error) {
                alert('Erreur de connexion: ' + error.message);
            }
        }
    }

    function createStockRow(stock) {
        const row = document.createElement('tr');

        // Calculate days until expiration
        const now = new Date();
        const expirationDate = stock.expirationDate ? new Date(stock.expirationDate) : null;
        const daysDiff = expirationDate ?
            Math.floor((expirationDate - now) / (1000 * 60 * 60 * 24)) : null;

        // Determine stock level
        let stockLevel = 'ok';
        if (stock.quantity < 2) stockLevel = 'critical';
        else if (stock.quantity < 5) stockLevel = 'low';
        else if (stock.quantity > 20) stockLevel = 'high';

        // Determine expiration status
        let expirationStatus = 'future';
        if (expirationDate) {
            if (daysDiff < 0) expirationStatus = 'expired';
            else if (daysDiff <= 1) expirationStatus = 'today';
            else if (daysDiff <= 3) expirationStatus = '3days';
            else if (daysDiff <= 7) expirationStatus = '7days';
        } else {
            expirationStatus = 'none';
        }

        row.setAttribute('data-restaurant', stock.restaurant.id);
        row.setAttribute('data-status', stockLevel);
        row.setAttribute('data-expiration', expirationStatus);

        // Calculate value
        const value = stock.quantity * stock.ingredient.currentPrice;

        // Build row content using string concatenation (no template literals)
        let rowContent = '';
        rowContent += '<td style="padding: 12px;">';
        rowContent += '    <div style="display: flex; align-items: center; gap: 10px;">';
        rowContent += '        <div style="width: 32px; height: 32px; border-radius: 8px; background: #f0f0f0; display: flex; align-items: center; justify-content: center;">';
        rowContent += '            <i class="fas fa-carrot"></i>';
        rowContent += '        </div>';
        rowContent += '        <div>';
        rowContent += '            <strong>' + escapeHtml(stock.ingredient.name) + '</strong>';
        rowContent += '            <div style="font-size: 12px; color: #666;">' + escapeHtml(stock.ingredient.category || 'Non catégorisé') + '</div>';
        rowContent += '        </div>';
        rowContent += '    </div>';
        rowContent += '</td>';
        rowContent += '<td style="padding: 12px;">';
        rowContent += '    <div style="display: flex; align-items: center; gap: 8px;">';
        rowContent += '        <i class="fas fa-store" style="color: #2196F3;"></i>';
        rowContent += '        <span>' + escapeHtml(stock.restaurant.name) + '</span>';
        rowContent += '    </div>';
        rowContent += '</td>';
        rowContent += '<td style="padding: 12px;">';
        rowContent += '    <div class="quantity-editor">';
        rowContent += '        <input type="number" class="quantity-input" value="' + stock.quantity.toFixed(2) + '"';
        rowContent += '               min="0" step="0.01" style="width: 80px; padding: 4px;"';
        rowContent += '               onchange="updateStockQuantity(' + stock.id + ', this.value)">';
        rowContent += '        <span style="font-size: 12px; color: #666;">' + escapeHtml(stock.ingredient.unit) + '</span>';
        rowContent += '    </div>';
        rowContent += '</td>';
        rowContent += '<td style="padding: 12px;">';
        rowContent += '    <span class="stock-level level-' + stockLevel + '">';

        let iconClass = 'check-circle';
        let levelText = 'OK';
        if (stockLevel === 'critical') {
            iconClass = 'exclamation-circle';
            levelText = 'Critique';
        } else if (stockLevel === 'low') {
            iconClass = 'exclamation-triangle';
            levelText = 'Bas';
        } else if (stockLevel === 'high') {
            levelText = 'Élevé';
        }

        rowContent += '        <i class="fas fa-' + iconClass + '"></i> ' + levelText;
        rowContent += '    </span>';
        rowContent += '</td>';
        rowContent += '<td style="padding: 12px;">';

        if (expirationDate) {
            let expirationClass = 'expiration-good';
            if (daysDiff <= 3) expirationClass = 'expiration-soon';
            else if (daysDiff <= 7) expirationClass = 'expiration-warning';

            rowContent += '    <div class="expiration-indicator ' + expirationClass + '">';
            rowContent += '        <i class="far fa-calendar"></i>';
            rowContent += '        ' + expirationDate.toLocaleDateString('fr-FR');
            if (daysDiff >= 0) {
                rowContent += '        <span style="font-size: 11px;">(' + daysDiff + 'j)</span>';
            }
            rowContent += '    </div>';
        } else {
            rowContent += '    <span style="color: #666; font-size: 12px;">Non défini</span>';
        }

        rowContent += '</td>';
        rowContent += '<td style="padding: 12px;">';
        if (stock.batchNumber) {
            rowContent += '    <span class="batch-badge">' + escapeHtml(stock.batchNumber) + '</span>';
        }
        rowContent += '</td>';
        rowContent += '<td style="padding: 12px;">';
        rowContent += '    <span class="stock-value">' + value.toFixed(2) + ' €</span>';
        rowContent += '</td>';
        rowContent += '<td style="padding: 12px;">';
        rowContent += '    <div class="stock-actions">';
        rowContent += '        <button class="btn btn-sm btn-primary" onclick="editStock(' + stock.id + ')">';
        rowContent += '            <i class="fas fa-edit"></i>';
        rowContent += '        </button>';
        rowContent += '        <button class="btn btn-sm btn-danger" onclick="deleteStock(' + stock.id + ')">';
        rowContent += '            <i class="fas fa-trash"></i>';
        rowContent += '        </button>';
        rowContent += '        <button class="btn btn-sm btn-info" onclick="transferStock(' + stock.id + ')" title="Transférer">';
        rowContent += '            <i class="fas fa-exchange-alt"></i>';
        rowContent += '        </button>';
        rowContent += '    </div>';
        rowContent += '</td>';

        row.innerHTML = rowContent;
        return row;
    }

    // Enhanced Stock Actions
    async function updateStockQuantity(stockId, newQuantity) {
        if (confirm('Mettre à jour la quantité à ' + newQuantity + ' ?')) {
            try {
                const response = await fetch('${pageContext.request.contextPath}/api/stock/' + stockId, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({
                        quantity: parseFloat(newQuantity)
                    })
                });

                if (response.ok) {
                    alert('Quantité mise à jour avec succès');
                    applyFilters(); // Refresh the filtered view
                } else {
                    const error = await response.text();
                    alert('Erreur: ' + error);
                }
            } catch (error) {
                alert('Erreur de connexion: ' + error.message);
            }
        }
    }

    function editStock(stockId) {
        window.location.href = '${pageContext.request.contextPath}/stock/edit?id=' + stockId;
    }

    async function deleteStock(stockId) {
        if (confirm('Êtes-vous sûr de vouloir supprimer cet item de stock ?')) {
            try {
                const response = await fetch('${pageContext.request.contextPath}/api/stock/' + stockId, {
                    method: 'DELETE'
                });

                if (response.ok) {
                    alert('Stock supprimé avec succès');
                    applyFilters(); // Refresh the filtered view
                } else {
                    const error = await response.text();
                    alert('Erreur: ' + error);
                }
            } catch (error) {
                alert('Erreur de connexion: ' + error.message);
            }
        }
    }

    function transferStock(stockId) {
        alert('Fonction de transfert en développement - Stock ID: ' + stockId);
    }

    // Report Functions
    function showLowStockReport() {
        document.getElementById('minQuantity').value = '';
        document.getElementById('maxQuantity').value = '5';
        applyFilters();
    }

    function showExpiringReport() {
        const today = new Date();
        const nextWeek = new Date(today);
        nextWeek.setDate(today.getDate() + 7);

        document.getElementById('expirationFrom').value = today.toISOString().split('T')[0];
        document.getElementById('expirationTo').value = nextWeek.toISOString().split('T')[0];
        applyFilters();
    }

    function resetFilters() {
        document.getElementById('restaurantFilter').value = 'all';
        document.getElementById('categoryFilter').value = 'all';
        document.getElementById('minQuantity').value = '';
        document.getElementById('maxQuantity').value = '';
        document.getElementById('expirationFrom').value = '';
        document.getElementById('expirationTo').value = '';

        // Reload all stock by making a request to get all items
        applyFilters();
    }

    function exportToCSV() {
        // Get all visible rows
        const rows = document.querySelectorAll('#stockTableBody tr');

        // Create CSV content
        let csvContent = "Restaurant,Ingrédient,Quantité,Unité,Valeur,Expiration,Lot\\n";

        rows.forEach(row => {
            const cells = row.querySelectorAll('td');
            if (cells.length >= 7) {
                const restaurant = cells[1].querySelector('span').textContent;
                const ingredient = cells[0].querySelector('strong').textContent;
                const quantity = cells[2].querySelector('.quantity-input').value;
                const unit = cells[2].querySelector('span').textContent;
                const value = cells[6].querySelector('.stock-value').textContent;

                let expiration = 'Non défini';
                const expirationDiv = cells[4].querySelector('.expiration-indicator');
                if (expirationDiv) {
                    expiration = expirationDiv.textContent.trim();
                }

                let batch = '';
                const batchBadge = cells[5].querySelector('.batch-badge');
                if (batchBadge) {
                    batch = batchBadge.textContent;
                }

                // Escape quotes and commas
                const escapeCSV = (str) => {
                    if (str == null) return '';
                    return '"' + String(str).replace(/"/g, '""') + '"';
                };

                csvContent += escapeCSV(restaurant) + ',' +
                    escapeCSV(ingredient) + ',' +
                    quantity + ',' +
                    escapeCSV(unit) + ',' +
                    escapeCSV(value) + ',' +
                    escapeCSV(expiration) + ',' +
                    escapeCSV(batch) + '\\n';
            }
        });

        // Create download link
        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'stock_export_' + new Date().toISOString().split('T')[0] + '.csv';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
    }

    // Helper function to escape HTML
    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    // Initialize filters on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Set default date ranges
        const today = new Date();
        document.getElementById('expirationFrom').min = today.toISOString().split('T')[0];

        // Load unique categories if not already in page context
        loadUniqueCategories();
    });

    async function loadUniqueCategories() {
        try {
            const response = await fetch('${pageContext.request.contextPath}/api/stock/categories');
            if (response.ok) {
                const categories = await response.json();
                const categorySelect = document.getElementById('categoryFilter');
                categorySelect.innerHTML = '<option value="all">Toutes les catégories</option>';
                categories.forEach(category => {
                    const option = document.createElement('option');
                    option.value = category;
                    option.textContent = category;
                    categorySelect.appendChild(option);
                });
            }
        } catch (error) {
            console.error('Erreur chargement catégories:', error);
        }
    }

    function openAddStockForm() {
        window.location.href = '${pageContext.request.contextPath}/stock/add';
    }

    // Add to stock.jsp JavaScript:

    // Validate number inputs
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
</script>
</body>
</html>