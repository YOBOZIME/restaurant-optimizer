<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${ingredient.name} | Détails Ingrédient</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .ingredient-header {
            background: linear-gradient(135deg, #4CAF50 0%, #8BC34A 100%);
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .ingredient-header::before {
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

        .ingredient-icon {
            width: 80px;
            height: 80px;
            border-radius: 16px;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            margin-right: 20px;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
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

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .badge-primary { background: #cce5ff; color: #004085; }
        .badge-success { background: #d4edda; color: #155724; }
        .badge-warning { background: #fff3cd; color: #856404; }
        .badge-danger { background: #f8d7da; color: #721c24; }

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

        .shelf-life-meter {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-top: 10px;
        }

        .meter-bar {
            flex: 1;
            height: 10px;
            background: #eee;
            border-radius: 5px;
            overflow: hidden;
            position: relative;
        }

        .meter-fill {
            height: 100%;
            border-radius: 5px;
        }

        .meter-labels {
            display: flex;
            justify-content: space-between;
            margin-top: 5px;
            font-size: 11px;
            color: #666;
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }

        .stat-item {
            text-align: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #4CAF50;
        }

        .stat-label {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
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
            <a href="ingredients" class="active"><i class="fas fa-carrot"></i> Ingrédients</a>
            <a href="restaurants"><i class="fas fa-store"></i> Restaurants</a>
            <a href="stock"><i class="fas fa-boxes"></i> Stocks</a>
            <a href="waste"><i class="fas fa-trash"></i> Pertes</a>
        </nav>
    </header>

    <!-- Ingredient Header -->
    <div class="ingredient-header">
        <div class="header-content">
            <div style="display: flex; align-items: center;">
                <div class="ingredient-icon">
                    <i class="fas
                        <c:choose>
                            <c:when test="${ingredient.category eq 'Viandes'}">fa-drumstick-bite</c:when>
                            <c:when test="${ingredient.category eq 'Légumes'}">fa-leaf</c:when>
                            <c:when test="${ingredient.category eq 'Produits laitiers'}">fa-cheese</c:when>
                            <c:when test="${ingredient.category eq 'Épicerie'}">fa-wheat-awn</c:when>
                            <c:when test="${ingredient.category eq 'Boissons'}">fa-wine-bottle</c:when>
                            <c:otherwise>fa-carrot</c:otherwise>
                        </c:choose>">
                    </i>
                </div>
                <div>
                    <h2 style="margin: 0; font-size: 28px;">${ingredient.name}</h2>
                    <div style="display: flex; gap: 15px; margin-top: 10px;">
                        <span style="background: rgba(255,255,255,0.2); padding: 6px 15px; border-radius: 20px;">
                            <i class="fas fa-layer-group"></i> ${ingredient.category}
                        </span>
                        <span style="background: rgba(255,255,255,0.2); padding: 6px 15px; border-radius: 20px;">
                            <i class="fas fa-box"></i> ${ingredient.unit}
                        </span>
                    </div>
                </div>
            </div>
            <div>
                <div style="text-align: right; margin-bottom: 10px;">
                    <div style="font-size: 24px; font-weight: bold;">
                        <fmt:formatNumber value="${ingredient.currentPrice}" type="currency" currencyCode="EUR"/>
                    </div>
                    <div style="font-size: 14px; opacity: 0.9;">/ ${ingredient.unit}</div>
                </div>
            </div>
        </div>

        <div class="action-buttons">
            <a href="ingredients" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Retour à la liste
            </a>
            <a href="edit-ingredient?id=${ingredient.id}" class="btn btn-warning">
                <i class="fas fa-edit"></i> Modifier
            </a>
            <button class="btn btn-danger" onclick="deleteIngredient(${ingredient.id})">
                <i class="fas fa-trash"></i> Supprimer
            </button>
        </div>
    </div>

    <!-- Statistiques -->
    <div class="info-card">
        <h3><i class="fas fa-chart-bar"></i> Statistiques</h3>
        <div class="stats-grid">
            <div class="stat-item">
                <div class="stat-value">
                    <fmt:formatNumber value="${totalQuantity}" maxFractionDigits="2"/>
                </div>
                <div class="stat-label">Quantité totale</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">
                    <fmt:formatNumber value="${totalValue}" type="currency" currencyCode="EUR" maxFractionDigits="2"/>
                </div>
                <div class="stat-label">Valeur totale</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">
                    ${stocks.size()}
                </div>
                <div class="stat-label">Restaurants utilisateurs</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">
                    ${ingredient.shelfLifeDays}
                </div>
                <div class="stat-label">Jours conservation</div>
            </div>
        </div>
    </div>

    <!-- Information Grid -->
    <div class="info-grid">
        <!-- Détails de l'ingrédient -->
        <div class="info-card">
            <h3><i class="fas fa-info-circle"></i> Détails</h3>
            <div class="info-row">
                <span class="info-label">ID</span>
                <span class="info-value">#${ingredient.id}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Nom</span>
                <span class="info-value">${ingredient.name}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Catégorie</span>
                <span class="info-value">
                    <span class="badge badge-primary">
                        <i class="fas fa-layer-group"></i> ${ingredient.category}
                    </span>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Unité</span>
                <span class="info-value">${ingredient.unit}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Prix unitaire</span>
                <span class="info-value">
                    <strong><fmt:formatNumber value="${ingredient.currentPrice}" type="currency" currencyCode="EUR"/></strong>
                    <span style="font-size: 12px; color: #666;">/ ${ingredient.unit}</span>
                </span>
            </div>
        </div>

        <!-- Conservation -->
        <div class="info-card">
            <h3><i class="fas fa-clock"></i> Conservation</h3>
            <div class="info-row">
                <span class="info-label">Durée</span>
                <span class="info-value">${ingredient.shelfLifeDays} jours</span>
            </div>
            <div class="info-row">
                <span class="info-label">Type</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${ingredient.shelfLifeDays < 7}">
                            <span class="badge badge-danger">Très périssable</span>
                        </c:when>
                        <c:when test="${ingredient.shelfLifeDays < 14}">
                            <span class="badge badge-warning">Périssable</span>
                        </c:when>
                        <c:when test="${ingredient.shelfLifeDays < 30}">
                            <span class="badge badge-warning">Moyenne conservation</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-success">Longue conservation</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="shelf-life-meter">
                <div class="meter-bar">
                    <div class="meter-fill" style="
                            width: ${(ingredient.shelfLifeDays / 365) * 100}%;
                            background:
                    <c:choose>
                    <c:when test="${ingredient.shelfLifeDays < 7}">#F44336</c:when>
                    <c:when test="${ingredient.shelfLifeDays < 14}">#FF9800</c:when>
                    <c:when test="${ingredient.shelfLifeDays < 30}">#FFC107</c:when>
                    <c:otherwise>#4CAF50</c:otherwise>
                    </c:choose>;
                            "></div>
                </div>
                <span style="font-size: 12px; color: #666;">${ingredient.shelfLifeDays} jours</span>
            </div>
            <div class="meter-labels">
                <span>1 jour</span>
                <span>1 mois</span>
                <span>1 an</span>
            </div>
        </div>

        <!-- Informations de stock -->
        <div class="info-card">
            <h3><i class="fas fa-boxes"></i> Disponibilité</h3>
            <div class="info-row">
                <span class="info-label">Restaurants utilisateurs</span>
                <span class="info-value">${stocks.size()}</span>
            </div>
            <div class="info-row">
                <span class="info-label">Quantité totale</span>
                <span class="info-value">
                    <fmt:formatNumber value="${totalQuantity}" maxFractionDigits="2"/> ${ingredient.unit}
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Valeur totale</span>
                <span class="info-value">
                    <strong><fmt:formatNumber value="${totalValue}" type="currency" currencyCode="EUR"/></strong>
                </span>
            </div>
        </div>
    </div>

    <!-- Stock dans les restaurants -->
    <div class="info-card">
        <h3><i class="fas fa-store"></i> Stock par restaurant</h3>

        <c:choose>
            <c:when test="${not empty stocks && stocks.size() > 0}">
                <table class="stock-table">
                    <thead>
                    <tr>
                        <th>Restaurant</th>
                        <th>Ville</th>
                        <th>Quantité</th>
                        <th>Valeur</th>
                        <th>Expiration</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="stock" items="${stocks}">
                        <c:if test="${stock.restaurant != null}">
                            <tr>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 10px;">
                                        <div style="width: 32px; height: 32px; border-radius: 8px; background: #f0f0f0; display: flex; align-items: center; justify-content: center;">
                                            <i class="fas fa-store"></i>
                                        </div>
                                        <div>
                                            <strong>${stock.restaurant.name}</strong>
                                        </div>
                                    </div>
                                </td>
                                <td>${stock.restaurant.city}</td>
                                <td>
                                    <fmt:formatNumber value="${stock.quantity}" maxFractionDigits="2"/>
                                    <span style="font-size: 12px; color: #666;">${ingredient.unit}</span>
                                    <div class="progress-bar">
                                        <div class="progress-fill" style="
                                                width: <c:choose>
                                        <c:when test="${stock.quantity > 20}">100%</c:when>
                                        <c:otherwise>${stock.quantity * 5}%</c:otherwise>
                                        </c:choose>;
                                                background: <c:choose>
                                        <c:when test="${stock.quantity < 2}">#F44336</c:when>
                                        <c:when test="${stock.quantity < 5}">#FF9800</c:when>
                                        <c:otherwise>#4CAF50</c:otherwise>
                                        </c:choose>;
                                                "></div>
                                    </div>
                                </td>
                                <td>
                                    <strong>
                                        <fmt:formatNumber value="${stock.quantity * ingredient.currentPrice}"
                                                          type="currency" currencyCode="EUR" maxFractionDigits="2"/>
                                    </strong>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${stock.expirationDate != null}">
                                            <fmt:formatDate value="${stock.expirationDate}" pattern="dd/MM/yyyy"/>
                                            <c:set var="now" value="<%= new java.util.Date() %>" />
                                            <c:set var="daysDiff" value="${(stock.expirationDate.time - now.time) / (1000 * 60 * 60 * 24)}" />
                                            <c:if test="${daysDiff < 3}">
                                                    <span class="badge badge-danger" style="margin-left: 10px;">
                                                        <i class="fas fa-exclamation-circle"></i> ${Math.round(daysDiff)}j
                                                    </span>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-primary" onclick="viewStock(${stock.id})">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-store-slash"></i>
                    <h3>Aucun stock trouvé</h3>
                    <p style="color: #666; margin-top: 10px;">
                        Cet ingrédient n'est actuellement présent dans aucun restaurant.
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function deleteIngredient(id) {
        if (confirm('Êtes-vous sûr de vouloir supprimer cet ingrédient ? Cette action supprimera également toutes les références dans les stocks.')) {
            window.location.href = 'delete-ingredient?id=' + id;
        }
    }

    function viewStock(stockId) {
        alert('Visualisation du stock #' + stockId + ' - En construction');
        // À implémenter: redirection vers la page de détails du stock
    }
</script>
</body>
</html>